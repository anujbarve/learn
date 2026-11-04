# learn — AI learning system

This project is a **learning workspace**. Whenever you explain or teach anything — even a one-line explanation — load and follow the `teach` skill. When an idea is clearer as a picture, follow the `visualize` skill.

These instructions are harness-neutral. They work in pi, Claude Code, Gemini CLI, OpenCode, Codex, Freebuff/Codebuff, Antigravity, and any agent that reads `AGENTS.md` and `SKILL.md` skills.

## Skills

- `teach` — the teaching philosophy and the probe → plan → teach process.
- `visualize` — add one correct, minimal diagram to a lesson.

If your harness did not auto-load skills, read them directly: `skills/teach/SKILL.md` and `skills/visualize/SKILL.md` in the `learn` folder.

## Capabilities — map them to your harness

The skills name four abstract capabilities. Use the best match your harness has. When a capability is missing, use the fallback. Never skip the step itself.

### `quiz` — a graded question (has a right answer)

| Harness | Use |
|---|---|
| pi | the `quiz` tool (bundled extension) |
| Claude Code | `AskUserQuestion` with the options. You grade the answer yourself afterwards. |
| Others | plain-text fallback below |

Plain-text fallback:

1. Ask the question. List options as `1.` `2.` `3.` … plus a final `0. I don't know`. Shuffle the correct option's position.
2. Stop and wait for the learner's reply. Do not reveal the answer in the same message.
3. Reply with `✓` or `✗`, the correct answer, and a short explanation.
4. Treat `0` (I don't know) as an honest gap, not a wrong guess.

### `ask_user_question` — a question with no right answer (goals, preferences, direction)

| Harness | Use |
|---|---|
| pi | the `ask_user_question` tool (bundled extension) |
| Claude Code | `AskUserQuestion` |
| Others | ask in chat with numbered options plus "something else", then wait |

### `researcher` — verify facts before teaching them

| Harness | Use |
|---|---|
| pi | `subagent(agent="researcher", task=...)` |
| Claude Code | the `Agent` tool with `subagent_type: "researcher"` |
| OpenCode | the `task` tool with the `researcher` subagent, or `@researcher` |
| Gemini CLI | the `researcher` subagent, if subagents are enabled |
| Others / no subagents | do the research yourself with your web search and fetch tools, then continue |

### `mermaid-maker` / `svg-maker` — render-and-verify a diagram

Dispatch them the same way as `researcher`. With no subagent support, follow the maker workflow yourself, as described in the `visualize` skill.

## Session log (replaces pi's `md-log` extension)

In pi, `/md-log <file>` mirrors the session into a markdown file. In other harnesses, do it by hand when the learner asks you to log to a file:

- After each teaching reply, append that reply's lesson prose to the file.
- Append each quiz as: question and options first, then the learner's answer, the grade, and the explanation.
- Never write the correct answer into the log before the learner has answered.
- Skip tool chatter: bash output, file reads, edits.
- Keep the file append-only.

## Formatting

Lessons are read rendered as markdown (for example in Obsidian). Write math as LaTeX: `$x^2$` inline, `$$ … $$` for display. Mermaid code blocks and `![[file.png|500]]` embeds render natively there.
