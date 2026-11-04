---
name: visualize
description: "Add a correct, minimal visual to a lesson — a diagram or geometric picture — that renders inline in the Obsidian log. Use when an idea is genuinely clearer as a picture: a dependency graph, system/flow, sequence, state machine, tree, comparison, or a spatial/geometric thing (coordinate geometry, number line, vectors, a plot, a physical layout). Outsources authoring+rendering to a maker subagent that verifies the image by looking at it, then you embed the returned file."
---

# Visualize

A picture earns its place only when it shows something words can't — shape, structure, direction, relationship, geometry. This skill produces ONE such picture, guarantees it is **correct** (the maker renders it and looks at it before returning), and drops it into the lesson so it renders inline in the Obsidian `md-log` file.

You are the **creative director**. You decide the exact idea and distill it to its fewest carrying elements. A **maker subagent** does the authoring, rendering, visual verification, and saving, then returns a filename. You embed that filename in your reply.

## When to visualize (and when not to)

This teaching system builds a **dependency graph in the learner's head** — axioms at the root, derived facts hanging off them. A visual is powerful exactly when it makes that structure (or a geometry) visible. Reach for one when:

- The idea is a **structure or relationship**: dependencies, a system with parts and arrows, a flow/pipeline, a sequence of exchanges, a state machine, a tree/hierarchy, a comparison, a containment (what's inside vs outside).
- The idea is **spatial or geometric**: coordinate geometry, a number line, vectors, a function's shape, a physical arrangement.

Do NOT visualize when prose or a single equation already carries it. A decorative diagram that just restates the sentence next to it adds noise and a chance to be wrong. When in doubt, don't — a missing visual is cheaper than a false one.

## Choose the maker

Two makers, installed as subagents for your harness (pi: `.pi/agents/`; Claude Code: `.claude/agents/`; OpenCode: `.opencode/agents/`; Gemini CLI: `.gemini/agents/`):

- **`mermaid-maker`** — structural/relational visuals: dependency graphs, flowcharts, sequence/state/ER/class diagrams, trees, mindmaps, timelines. This is the default and fits the dependency-graph pedagogy directly.
- **`svg-maker`** — spatial/geometric visuals Mermaid can't lay out: exact coordinates, geometry figures, number lines, vectors, plots, custom shapes.

Rule of thumb: if it's *nodes-and-edges / relationships*, use mermaid-maker. If it's *positions-and-shapes / geometry*, use svg-maker.

## Brief the maker well: one idea, fewest elements

The most common failure is **cramming** — every extra label makes the picture harder to read AND harder to lay out correctly. Before briefing, prune to the fewest elements that carry the idea, and for each ask: *"if I delete this, is the idea still clear?"* If yes, delete it.

Give the maker the concept AND the concrete elements you want — not a vague topic, and not a long checklist.

- BAD: "make a diagram about how TCP works"
- GOOD: "graph TD: a node 'packet' at the top; arrows down to 'ordering' and 'retransmit on loss'; both arrows down into 'reliable stream'. No title. Show that reliability is built FROM packets, not alongside them."

Keep the idea intact but trust the maker to compose; if your brief lists more than ~5–7 elements, cut it first.

## Invoke

Dispatch the maker with your harness's subagent mechanism:

| Harness | Call |
|---|---|
| pi | `subagent(agent="mermaid-maker", task="<brief>")` |
| Claude Code | `Agent` tool, `subagent_type: "mermaid-maker"`, prompt = brief |
| OpenCode | `task` tool with the `mermaid-maker` subagent (or `@mermaid-maker <brief>`) |
| Gemini CLI | the `mermaid-maker` subagent (subagents must be enabled) |

Use `svg-maker` the same way.

**No subagent support** (e.g. Codex, Freebuff, or makers not installed)? Run the maker's workflow yourself. Read `agents/mermaid-maker.md` or `agents/svg-maker.md` in the `learn` folder and follow it exactly. Read `{{LEARN_DIR}}` there as the path of the `learn` folder. Render with this skill's script:

```bash
bash <this skill's dir>/render.sh mermaid <source.mmd>              # preview → prints PNG path
bash <this skill's dir>/render.sh svg     <source.svg>              # preview
bash <this skill's dir>/render.sh mermaid <source.mmd> <kebab-slug> # publish → viz/viz-<slug>-<ts>.png
```

Open the preview PNG with your image-capable read tool and actually look at it before you publish. If your harness cannot view images, embed the Mermaid source as a ```` ```mermaid ```` code block instead and keep it very small. A PNG you have not looked at is not verified.

The maker authors the source, renders it to a PNG, **looks at the PNG and iterates until it is correct and clean**, publishes it into the vault with a unique filename, and returns:

```
RESULT:
filename: viz-<slug>-<timestamp>.png
path: <cwd>/viz/viz-<slug>-<timestamp>.png
```

If it returns `RESULT: NONE`, it couldn't make a correct picture of the brief — simplify or rethink, or decide the visual isn't worth it. Never fake a diagram or skip the render-and-inspect loop. Correctness depends on it. Authoring it yourself is allowed only in the no-subagent fallback above, and only through that same loop.

## Embed it in the lesson

Put the embed directly in your teaching reply, using Obsidian's wikilink embed with the returned **filename** (not the full path) and a display width:

```
![[viz-<slug>-<timestamp>.png|500]]
```

That's all. The session log (pi's `md-log` extension, or the manual log described in `AGENTS.md`) mirrors your reply text verbatim into the linked `.md`, and Obsidian resolves the embed by filename anywhere in the vault (the maker saves into the project's `viz` folder, which is inside the vault) — so it renders inline in the lesson automatically. Width `|500` is a good default; use larger for dense diagrams. Introduce the visual in a sentence, then let it carry the idea — don't narrate every element back in prose.

## Why this is reliable

- The maker never returns a picture it hasn't **looked at**, so "renders fine but says something false" is caught before it reaches the learner.
- PNG embed means **what the maker verified is pixel-identical to what the learner sees** — no re-render drift.
- Unique filenames keep Obsidian's by-filename embed resolution unambiguous.

> In pi the makers render through the `visual-tools` extension. Everywhere else they use `render.sh` next to this file. Both use the same backends: Mermaid via `@mermaid-js/mermaid-cli`, SVG via `rsvg-convert` with ImageMagick as fallback. When a maker subagent exists, you don't render anything yourself. You brief it and embed the filename it returns.
