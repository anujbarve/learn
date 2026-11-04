#!/usr/bin/env bash
# render.sh — harness-neutral renderer for the visualize skill.
#
# Same backends as pi's visual-tools extension, callable from any agent with a shell:
#   Mermaid -> PNG via @mermaid-js/mermaid-cli (mmdc), scale 2, white background
#   SVG     -> PNG via rsvg-convert -z 2, fallback ImageMagick -density 192
#
# Usage:
#   render.sh mermaid <source.mmd> [save_as_slug]
#   render.sh svg     <source.svg> [save_as_slug]
#
# Without a slug: renders a preview into a temp dir and prints its path.
# With a slug:    also publishes to ./viz/viz-<slug>-<epoch_ms>.png and prints
#                 a RESULT block (filename + absolute path).
set -euo pipefail

usage() { echo "usage: $0 mermaid|svg <source> [save_as_slug]" >&2; exit 2; }
[ $# -ge 2 ] || usage
kind="$1"; src="$2"; slug="${3:-}"
[ -f "$src" ] || { echo "error: source not found: $src" >&2; exit 1; }

export PATH="/opt/local/bin:/usr/local/bin:/opt/homebrew/bin:$PATH"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
stage="${TMPDIR:-/tmp}/learn-visual-tools"
mkdir -p "$stage"
out="$stage/preview-$kind-$$.png"

case "$kind" in
  mermaid)
    # Prefer the mmdc bundled with pi's visual-tools extension if installed; else npx.
    bundled="$here/../../extensions/visual-tools/node_modules/.bin/mmdc"
    cfg="$stage/puppeteer-$$.json"
    chrome=""
    for c in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
             "/Applications/Chromium.app/Contents/MacOS/Chromium" \
             "$(command -v google-chrome 2>/dev/null || true)" \
             "$(command -v chromium 2>/dev/null || true)"; do
      [ -n "$c" ] && [ -x "$c" ] && { chrome="$c"; break; }
    done
    if [ -n "$chrome" ]; then
      printf '{"executablePath":"%s","args":["--no-sandbox"]}\n' "$chrome" > "$cfg"
    else
      printf '{"args":["--no-sandbox"]}\n' > "$cfg"
    fi
    if [ -x "$bundled" ]; then mmdc=("$bundled"); else mmdc=(npx -y -p @mermaid-js/mermaid-cli@11 mmdc); fi
    "${mmdc[@]}" -i "$src" -o "$out" -p "$cfg" -s 2 -b white >&2
    rm -f "$cfg"
    ;;
  svg)
    if command -v rsvg-convert >/dev/null 2>&1 && rsvg-convert -z 2 "$src" -o "$out" 2>/dev/null; then :
    elif command -v magick >/dev/null 2>&1; then magick -density 192 -background white "$src" "$out"
    else echo "error: need rsvg-convert (brew install librsvg) or ImageMagick (brew install imagemagick)" >&2; exit 1
    fi
    ;;
  *) usage ;;
esac

[ -f "$out" ] || { echo "error: render produced no image" >&2; exit 1; }

if [ -z "$slug" ]; then
  echo "preview: $out"
  exit 0
fi

clean="$(printf '%s' "$slug" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"
[ -n "$clean" ] || clean="viz"
ms="$(($(date +%s) * 1000))"
mkdir -p "$PWD/viz"
filename="viz-$clean-$ms.png"
cp "$out" "$PWD/viz/$filename"
printf 'RESULT:\nfilename: %s\npath: %s\n' "$filename" "$PWD/viz/$filename"
