import csv
import io
import re
import subprocess
import sys
import os
from pathlib import Path
import shutil


# Keep this script in the same project folder as:
# ev_automation.cnf and EV_Analysis_Queries_Main.sql

PROJECT_DIR = Path(__file__).resolve().parent
MYSQL_SETTING = os.environ.get("MYSQL_EXE", "mysql")
OPTIONS_FILE = Path(os.environ.get(
    "MYSQL_OPTIONS_FILE", PROJECT_DIR / "ev_automation.cnf"
))
SQL_FILE = PROJECT_DIR / "EV_Analysis_Queries_Main.sql"
OUTPUT_DIR = PROJECT_DIR / "EV_Analysis_Results"

def resolve_mysql_executable():
    candidate = Path(MYSQL_SETTING).expanduser()

    if candidate.is_absolute() or candidate.parent != Path("."):
        return str(candidate) if candidate.is_file() else None

    return shutil.which(MYSQL_SETTING)

def main():
    mysql_exe = resolve_mysql_executable()

if not mysql_exe:
    print(
        "ERROR: MySQL command-line client was not found. "
        "Install it, add it to PATH, or set MYSQL_EXE to its full path."
    )
    return 2

missing = [
    str(path)
    for path in (OPTIONS_FILE, SQL_FILE)
    if not path.is_file()
]

if missing:
    print("ERROR: Required file(s) not found:")
    for item in missing:
        print(f"  {item}")
    return 2

    sql_text = SQL_FILE.read_text(encoding="utf-8-sig")
    
    # Remove whole-line SQL comments and split the file into statements.
    sql_text = re.sub(r"(?m)^\s*--.*$", "", sql_text)
    statements = [s.strip() for s in sql_text.split(";") if s.strip()]
    queries = [s for s in statements if re.match(r"(?is)^\s*SELECT\b", s)]

    if not queries:
        print("ERROR: No SELECT analysis queries were found.")
        return 3

    OUTPUT_DIR.mkdir(exist_ok=True)
    for old_csv in OUTPUT_DIR.glob("analysis_*.csv"):
        old_csv.unlink()

    for index, query in enumerate(queries, start=1):
        command = [
            mysql_exe,
            f"--defaults-extra-file={OPTIONS_FILE}",
            "--batch",
            "--raw",
            "--execute",
            query,
        ]
        result = subprocess.run(
            command,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            cwd=str(PROJECT_DIR),
            shell=False,
        )
        if result.returncode != 0:
            print(f"ERROR: Analysis query {index} failed.")
            if result.stderr.strip():
                print(result.stderr.strip())
            return result.returncode or 1

        rows = list(csv.reader(io.StringIO(result.stdout), delimiter="\t"))
        if not rows:
            print(f"ERROR: Analysis query {index} returned no output.")
            return 4

        output_file = OUTPUT_DIR / f"analysis_{index:02d}.csv"
        with output_file.open("w", newline="", encoding="utf-8-sig") as handle:
            csv.writer(handle).writerows(rows)
        print(f"Saved {output_file.name} ({max(len(rows) - 1, 0)} data rows)")

    print(f"SUCCESS: Exported {len(queries)} analysis result(s) to:")
    print(OUTPUT_DIR)
    return 0


if __name__ == "__main__":
    sys.exit(main())
