# 3-Layer Agent Architecture

This project uses a **3-layer architecture** that separates concerns to maximize reliability and consistency.

## Why This Architecture?

LLMs are probabilistic, but most business logic is deterministic and requires consistency. This architecture fixes that mismatch by:

- **90% accuracy per step** = **59% success over 5 steps** ❌
- **Push complexity into deterministic code** = **Near 100% reliability** ✅

## The 3 Layers

### Layer 1: Directives (`directives/`)

**What to do**

Standard Operating Procedures (SOPs) written in Markdown that define:

- Goals and objectives
- Required inputs
- Tools/scripts to use
- Expected outputs
- Edge cases and constraints

📁 See [`directives/README.md`](directives/README.md) for details.

### Layer 2: Orchestration (AI Agent)

**Decision making**

The AI agent's job is **intelligent routing**:

- Read directives
- Call execution tools in the right order
- Handle errors
- Ask for clarification
- Update directives with learnings

The agent is the **glue between intent and execution**.

### Layer 3: Execution (`execution/`)

**Doing the work**

Deterministic Python scripts that handle:

- API calls
- Data processing
- File operations
- Database interactions

These scripts are **reliable, testable, and fast**.

📁 See [`execution/README.md`](execution/README.md) for details.

## Operating Principles

### 1. Check for Tools First

Before writing a new script, check `execution/` directory. Only create new scripts if none exist.

### 2. Self-Anneal When Things Break

When errors occur:

1. Read error message and stack trace
2. Fix the script and test it again
3. Update the directive with what you learned
4. System is now stronger 💪

### 3. Update Directives as You Learn

Directives are **living documents**. When you discover:

- API constraints
- Better approaches
- Common errors
- Timing expectations

→ Update the directive!

## File Organization

### Deliverables vs Intermediates

- **Deliverables**: R Markdown files, rendered outputs (HTML, PDF)
- **Intermediates**: Temporary files needed during processing

### Directory Structure

```
praktikum-r-stp/
├── directives/          # Layer 1: SOPs in Markdown
├── execution/           # Layer 3: Python scripts
├── .tmp/                # Intermediate files (never commit)
├── .env                 # Environment variables (never commit)
├── .env.example         # Template for .env
├── credentials.json     # Google OAuth (never commit)
└── token.json           # Google OAuth (never commit)
```

### Key Principle

- **Local files** are only for processing
- **Deliverables** live in cloud services (Google Sheets, Slides, etc.)
- Everything in `.tmp/` can be deleted and regenerated

📁 See [`.tmp/README.md`](.tmp/README.md) for details.

## Self-Annealing Loop

Errors are learning opportunities! When something breaks:

1. ✅ Fix it
2. ✅ Update the tool
3. ✅ Test the tool
4. ✅ Update directive to include new flow
5. 🎉 System is now stronger!

## Getting Started

### 1. Set Up Environment

Copy the example environment file:

```bash
cp .env.example .env
```

Edit `.env` and add your credentials.

### 2. Create Your First Directive

Create a new file in `directives/` following this template:

```markdown
# Task Name

## Goal

What is the objective?

## Inputs

What data/files are needed?

## Tools

Which scripts in `execution/` should be used?

## Outputs

What deliverables are expected?

## Edge Cases

Known issues, API limits, timing considerations
```

### 3. Create Execution Scripts

Create deterministic Python scripts in `execution/` that:

- Handle errors gracefully
- Log important steps
- Use environment variables
- Return clear exit codes

### 4. Let the AI Orchestrate

The AI agent will:

- Read your directives
- Run your scripts in the right order
- Handle errors
- Update directives based on learnings

## Summary

**Be pragmatic. Be reliable. Self-anneal.** 🚀

The AI sits between human intent (directives) and deterministic execution (Python scripts), making decisions, calling tools, handling errors, and continuously improving the system.
