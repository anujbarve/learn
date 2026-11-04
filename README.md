# learn

[![video](assets/thumbnail.png)](https://www.youtube.com/watch?v=kzcI5F4tGiU)

My AI learning system from this video: [How I Use AI to Learn Things](https://www.youtube.com/watch?v=kzcI5F4tGiU).

This is a personal system, shared as-is. It started as a pi configuration and now works with any coding-agent CLI: **pi, Claude Code, Gemini CLI, OpenCode, Codex, Freebuff/Codebuff, Antigravity**. The teaching philosophy lives in harness-neutral skills, with small adapters per CLI.

## What's in it

- `AGENTS.md`: entry point every CLI reads. It maps abstract capabilities (`quiz`, `ask_user_question`, `researcher`, makers, session log) to each harness, with plain-chat fallbacks.
- `skills/teach/`: the philosophy and the process.
- `skills/visualize/`: adds a correct, minimal diagram to a lesson. `render.sh` renders Mermaid or SVG to PNG from any shell.
- `agents/`: `researcher`, `svg-maker`, `mermaid-maker`. These are the canonical subagent prompts, in pi format. `install.sh` generates the other formats from them.
- `extensions/`: pi-only extensions (`ask-user-question`, `quiz`, `md-log`, `visual-tools`).
- `install.sh`: wires everything into a project for the CLIs you name.

## Install

Clone anywhere inside or next to your learning project, then run the installer from the project root:

```bash
git clone https://github.com/anujbarve/learn
./learn/install.sh claude            # one CLI
./learn/install.sh claude gemini     # several
./learn/install.sh all               # claude gemini opencode codex freebuff agy
./learn/install.sh pi                # links .pi -> learn (the original setup)
```

What it creates:

| CLI | Instructions | Skills | Subagents |
|---|---|---|---|
| Claude Code | `CLAUDE.md` (`@AGENTS.md`) | `.claude/skills/` | `.claude/agents/` |
| Gemini CLI | `GEMINI.md` (`@AGENTS.md`) | `.agents/skills/` | `.gemini/agents/` (may need enabling in settings) |
| OpenCode | `AGENTS.md` | `.agents/skills/` | `.opencode/agents/` |
| Codex | `AGENTS.md` | `.agents/skills/` | none, workflows run inline |
| Freebuff / Codebuff | `AGENTS.md` | `.agents/skills/` | none, workflows run inline |
| Antigravity (`agy`) | `AGENTS.md` | `.agents/skills/` | none, workflows run inline |
| pi | `.pi/` | `.pi/skills/` | `.pi/agents/` + extensions |

Skills and `AGENTS.md` are symlinks, so `git pull` in `learn/` updates them. Subagent files are generated, so re-run `install.sh` after pulling. If an `AGENTS.md`, `CLAUDE.md`, or `GEMINI.md` already exists, the installer appends a pointer to it and does not replace it.

The original pi install still works: `git clone https://github.com/anujbarve/learn .pi`.

## Requirements

- One of the CLIs above.
- For visuals: Node (`npx` fetches `@mermaid-js/mermaid-cli`) plus Chrome or Chromium for Mermaid, and `rsvg-convert` (`brew install librsvg`) or ImageMagick for SVG. The agent must be able to view images to verify renders.
- **pi only:** a subagent implementation. Recommended: [pi-interactive-subagents](https://github.com/amosblomqvist/pi-interactive-subagents) (tmux only). `agents/researcher.md` lists `safe_bash`, which is specific to that extension. Use the bundled `ask-user-question`, because popups serialize through a shared UI lock that only works with the same implementation. Run `npm install` in `extensions/visual-tools/`.

## Notes

You can run the system without subagents. The main session does the teaching, and it runs the researcher and maker workflows inline, as `AGENTS.md` describes.

The teaching skill is written for one learner (me). Edit the skill to fit how you learn best.
