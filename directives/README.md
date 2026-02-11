# Directives (Layer 1)

This directory contains **Standard Operating Procedures (SOPs)** written in Markdown.

## Purpose

Directives define **what to do** - the goals, inputs, tools to use, outputs, and edge cases for each task. They are natural language instructions, like you'd give a mid-level employee.

## Structure

Each directive should include:

1. **Goal**: What is the objective?
2. **Inputs**: What data/files are needed?
3. **Tools**: Which scripts in `execution/` should be used?
4. **Outputs**: What deliverables are expected?
5. **Edge Cases**: Known issues, API limits, timing considerations

## Naming Convention

Use descriptive names with underscores:

- `scrape_website.md`
- `process_student_data.md`
- `generate_report.md`

## Living Documents

Directives are **living documents** that should be updated as you learn:

- API constraints discovered
- Better approaches found
- Common errors encountered
- Timing expectations adjusted

## Example Structure

```markdown
# Process Student Data

## Goal

Clean and standardize student datasets from multiple universities.

## Inputs

- CSV files in `datasets/` directory
- Must contain columns: nama, npm, fakultas, prodi

## Tools

- `execution/clean_data.py` - Main cleaning script
- `execution/validate_data.py` - Validation script

## Outputs

- Cleaned CSV files (replace original)
- Summary report in `cleaning_summary.txt`

## Edge Cases

- Missing values: Impute with mean (numeric) or mode (categorical)
- Encoding issues: Force UTF-8
- Duplicate rows: Keep first occurrence
```

## Guidelines

- Never create or overwrite directives without asking first
- Update directives when you discover new information
- Keep instructions clear and specific
- Document all learned edge cases
