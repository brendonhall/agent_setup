# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Portable, version-controlled home for **all** of the user's Claude Code agent configuration — skills, slash commands, hooks, `settings.json`, status line scripts, output styles, agent definitions, and anything else that normally lives under `~/.claude/`. Replicated across machines by `make install`, which symlinks `claude/`'s contents into `~/.claude/`.

Scope expands over time. Today the repo contains skills and slash commands; expect hooks, settings, and other agent assets to land here as the user adds them. When adding a new asset type, mirror the directory name Claude Code expects under `~/.claude/` (e.g. `hooks/`, `agents/`, `output-styles/`) so installation stays a 1:1 mapping — no Makefile changes needed.

## Layout

Everything that gets installed lives under `claude/`. The repo root holds meta files (`Makefile`, `README.md`, `CLAUDE.md`, `LICENSE`).

- `claude/commands/<name>.md` — slash commands. Installed at `~/.claude/commands/<name>.md`. Invoked as `/<name>`; `$ARGUMENTS` is replaced with whatever follows the command.
- `claude/skills/<skill-name>/SKILL.md` — skills. Installed at `~/.claude/skills/<skill-name>/SKILL.md`. Each skill is a directory so it can carry supporting files alongside `SKILL.md`.
- *(future)* `claude/hooks/`, `claude/agents/`, `claude/settings.json`, etc. — add as the user introduces them, matching `~/.claude/` names.

## Install

`make install` symlinks each top-level entry under `claude/` into `~/.claude/`:

- Top-level files (e.g. `claude/settings.json`) → linked directly as `~/.claude/<file>`.
- Top-level directories (`commands/`, `skills/`, …) → descended one level so each child is linked individually. This lets `~/.claude/skills` mix repo skills with skills installed by other tools without clobbering either side.

Other targets: `make status` (show install state and conflicts), `make uninstall` (remove only symlinks pointing back into this repo), `make help`. Override the destination with `CLAUDE_DIR=...` for testing.

Conflicts (a real file or a symlink pointing elsewhere at the destination) are reported and skipped — `install` never overwrites existing content. Resolve conflicts by hand before re-running.

## Authoring conventions

**Skills** require YAML frontmatter with `name` and `description`. The `description` is the trigger contract — it must state both when to use the skill and (where relevant) when *not* to, because Claude reads only descriptions when deciding which skill to invoke. See `claude/skills/article_writer/SKILL.md` for the established pattern: imperative rules numbered as "Hard rules", an explicit Workflow section, and Output discipline. Skills should defer voice/prose conventions to `~/.claude/CLAUDE.md` rather than redefining them.

**Slash commands** are plain Markdown prompts with no frontmatter. They address Claude in second person ("You are…"), define defaults plus optional argument modes, and end with `$ARGUMENTS` so the user's input flows in. See `claude/commands/peer-review.md`.

## Cross-references

Both existing artifacts assume `~/.claude/CLAUDE.md` exists on the host machine and carries the user's stylistic/voice preferences. Treat that file as authoritative for voice; this repo's content layers process and structure on top.

## Working in this repo

When adding or editing a skill or command, the only validation is that the file parses as Markdown (and, for skills, that the frontmatter is valid YAML). There is no linter or test suite to run.
