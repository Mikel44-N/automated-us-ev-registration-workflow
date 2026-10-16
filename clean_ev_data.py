import csv
import os
import sys

# --------------------------------------------------
# Get input and output paths from Power Automate
# --------------------------------------------------

if len(sys.argv) != 3:
    raise ValueError(
        "Expected two arguments: input file and output folder"
    )

input_file = sys.argv[1]
output_folder = sys.argv[2]

output_file = os.path.join(
    output_folder,
    "Vehicle Data - Cleaned.csv"
)


# --------------------------------------------------
# Read the incoming CSV
# --------------------------------------------------

with open(input_file, "r", newline="", encoding="utf-8-sig") as file:
    reader = csv.reader(file)
    rows = list(reader)


# --------------------------------------------------
# Clean the data
# --------------------------------------------------

headers = rows[0]
cleaned_rows = [headers]

for row in rows[1:]:
    cleaned_row = [row[0]]

    for value in row[1:]:
        cleaned_value = value.replace(",", "")

        if cleaned_value == "":
            cleaned_row.append("")
        else:
            cleaned_row.append(int(cleaned_value))

    cleaned_rows.append(cleaned_row)


# --------------------------------------------------
# Validate the cleaned data
# --------------------------------------------------

data_rows = cleaned_rows[1:]

states = [row[0] for row in data_rows]

if len(data_rows) != 51:
    raise ValueError(
        f"Expected 51 data rows, found {len(data_rows)}"
    )

if len(states) != len(set(states)):
    raise ValueError("Duplicate states found")


blank_ev_values = sum(
    1 for row in data_rows
    if row[1] == ""
)

if blank_ev_values > 0:
    raise ValueError("Blank EV values found")


numeric_values_are_valid = all(
    isinstance(value, int)
    for row in data_rows
    for value in row[1:]
)

if not numeric_values_are_valid:
    raise ValueError("One or more fuel values are not integers")


# --------------------------------------------------
# Save the cleaned CSV
# --------------------------------------------------

with open(output_file, "w", newline="", encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerows(cleaned_rows)


# --------------------------------------------------
# Report result back to Power Automate
# --------------------------------------------------

print("SUCCESS")
print(f"Rows processed: {len(data_rows)}")
print(f"Output file: {output_file}")