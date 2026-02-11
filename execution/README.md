# Execution (Layer 3)

This directory contains **deterministic Python or R scripts** that do the actual work.

## Purpose

Execution scripts handle **doing the work** - API calls, data processing, file operations, and database interactions. They are reliable, testable, and fast.

## Principles

1. **Deterministic**: Same input → same output
2. **Well-commented**: Explain the "why", not just the "what"
3. **Error handling**: Try-except blocks, clear error messages
4. **Logging**: Use `logging` module for debugging
5. **Environment**: Use `.env` for secrets and configuration

## Structure

Each script should:

1. Import required libraries
2. Load environment variables from `.env`
3. Define clear functions with docstrings
4. Include `if __name__ == "__main__":` block
5. Handle errors gracefully
6. Return or save outputs clearly

## Naming Convention

Use descriptive names with underscores:

- `scrape_single_site.py`
- `clean_dataset.py`
- `generate_pdf_report.py`

## Dependencies

- Use `requirements.txt` for Python packages
- Use `renv` for R packages (if needed)
- Document all dependencies

## Example Structure

```python
#!/usr/bin/env python3
"""
Script: clean_dataset.py
Purpose: Clean and standardize university student datasets
Author: AI Agent
Date: 2026-02-11
"""

import os
import pandas as pd
from dotenv import load_dotenv
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Load environment variables
load_dotenv()

def clean_dataset(input_file: str, output_file: str) -> bool:
    """
    Clean a dataset by handling missing values and standardizing formats.

    Args:
        input_file: Path to input CSV
        output_file: Path to output CSV

    Returns:
        True if successful, False otherwise
    """
    try:
        # Read data
        df = pd.read_csv(input_file)
        logger.info(f"Loaded {len(df)} rows from {input_file}")

        # Clean data
        df = df.dropna()  # Remove missing values

        # Save
        df.to_csv(output_file, index=False)
        logger.info(f"Saved cleaned data to {output_file}")

        return True

    except Exception as e:
        logger.error(f"Error cleaning dataset: {e}")
        return False

if __name__ == "__main__":
    import sys

    if len(sys.argv) != 3:
        print("Usage: python clean_dataset.py <input_file> <output_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    success = clean_dataset(input_file, output_file)
    sys.exit(0 if success else 1)
```

## Testing

- Test scripts in isolation before integration
- Use small test datasets first
- Verify outputs manually before automation

## Environment Variables

Store sensitive data in `.env`:

- API keys
- Database credentials
- File paths
- Configuration flags

Never commit `.env` to version control!

## Guidelines

- Write scripts that can be called from command line
- Use argparse or sys.argv for parameters
- Return clear exit codes (0 = success, 1 = failure)
- Log important steps and errors
- Keep functions focused and reusable
