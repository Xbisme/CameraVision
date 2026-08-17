# Contract: Shared Component API

**Spec**: [../spec.md](../spec.md) · **Plan**: [../plan.md](../plan.md) · **Date**: 2026-08-14

The public surface of the nineteen shared widgets in `lib/core/widgets/`. This is a contract because Specs #004–#008 build against it — a change here after those specs start is a change to six other specs.

## Laws that apply to every component

1. **No literals.** Every visual value comes from a `ThemeExtension`. A component that reads a token group it does not use should not read it at all.
2. **Text comes in, never out of the ARB** (FR-021). Components take display strings and `semanticsLabel` as parameters, so they are reusable across screens and testable without a localization context.
3. **No content of its own** (FR-022). A component renders what it is handed. The seven background swatches belong to Spec #005, the batch queue to Spec #006.
4. **Touch minimums are hard** (FR-023): 44 minimum, 56 comfortable, 80 shutter inside a 104 hit target. A test asserts the rendered hit area, not the painted size.
5. **State is never carried by colour alone** (Principle XI). Every state pairs its colour with a shape, dash pattern, or glyph.
6. **Any control without visible text requires a `semanticsLabel`.** It is a required parameter, not an optional one — such a control must not be constructible without a name. That covers `PcIconButton`, `ShutterButton` and `PcSlider`. Controls that already carry a visible label (`PcButton`, `PcChip`, `ModeToggle`) take theirs from that text.
7. **Motion honours reduced motion** (FR-027a) and duration/curve come from `PcMotion`.

---

## `core/` — 7 components

### `PcButton`
Inputs: `label` · `onPressed` · `variant` (`primary`/`secondary`/`quiet`/`danger`, default `secondary`) · `size` (`comfortable` 56 / `standard` 44) · optional leading `PcIconData` · `isLoading`.
States: default · pressed (`scale .955` + `--accent-press`) · disabled · loading.
Rules: at most one `primary` per screen (FR-010). `danger` is forbidden inside `ThumbBand` (FR-024) — asserted in debug.
Goldens: 4 variants × (default, pressed) = 8.

### `PcIconButton`
Inputs: `icon` · `onPressed` · **required** `semanticsLabel` · `size` (`md` 44 icon 22 / `lg` 56 icon 26) · `variant` (`glass`/`solid`/`quiet`).
`glass` is permitted only over the camera feed or a photo (FR-011); on an opaque surface it must be `solid` or `quiet`.
Goldens: 3 variants × 2 sizes = 6.

### `PcChip`
Inputs: `label` · `selected` · `onTap` · optional `count`.
Selection is a **mint ring plus a tick**, never a fill-colour swap — the same lock mark the viewfinder uses. Minimum height 44.
Goldens: unselected · selected · with count = 3.

### `PcBadge`
Inputs: `text` · `kind` (`neutral`/`accent`/`caution`/`danger`) · optional `icon`.
Text is mono, uppercase, `--tracking-readout`. Every non-neutral kind carries a dot or glyph alongside its colour.
Goldens: 4 kinds = 4.

### `PcSheet`
Inputs: `title` · `child` · `onClose` · `actions`.
Top corners `--r-sheet` (24) only. Padding `--sheet-pad` (20). `--shadow-sheet`. **Opaque** — a sheet over a solid background is solid, never glass (FR-011). Entrance `--dur-base` + `--ease-out`.
Goldens: default · with actions = 2.

### `PcIcon`
Inputs: `icon` (a value of the closed `PcIconData` enumeration — an arbitrary asset path is not accepted) · `size` · optional `color` (defaults to inherited).
The single icon entry point (FR-025). Stroke fixed at `--stroke-icon` 1.75, round caps and joins, monochrome.
Goldens: one sheet showing the full vocabulary at all four sizes = 1.

### `PcSlider`
Inputs: `value` · `min` · `max` · `onChanged` · **required** `semanticsLabel` · optional `label` · optional `readout` (mono, shown while dragging).
The visible `label` stays optional because the design uses unlabelled sliders inside sheets, which is exactly why the accessible name cannot also be optional.
Track `--bg-track`, active fill mint, thumb hit area ≥ 44 even though the painted thumb is smaller.
Goldens: idle · dragging = 2.

---

## `camera/` — 4 components

### `ContourOverlay` ★
Inputs: `path` (a `Path` in normalized 0.0–1.0 coordinates, scaled to the paint size) · `state` (`scanning`/`locked`/`review`) · optional `showFramingTicks`.
**Draws two strokes, always**: halo 6px `--contour-halo` first, then core 2.5px (3px locked) on top (FR-016). Dash patterns from `PcContour`; the marching walk is `PathMetric`-based (research R11). Lives inside a `RepaintBoundary` and repaints only when inputs change.
Empty or degenerate `path` → paints nothing, does not throw.
Reduced motion → march and pulse stop, dash patterns stay (FR-027a).
**Does not touch the camera.** Spec #003 supplies the path.
Goldens: 3 states × 4 reference backgrounds = 12, plus 3 greyscale stills for SC-003.

### `ShutterButton` ★
Inputs: `onPressed` · `mode` (`single`/`batch`) · `contourLocked` · **required** `semanticsLabel` · optional `shotCount` (batch only).
It renders a bare disc with no text, so it is an icon-only control in every sense that matters — Principle XI requires a label and forbids constructing one without it. This is the most-pressed control in the product; a screen reader must not meet it as an unnamed button.
80px visible disc inside a 104px hit target, nothing tappable within 12px. Press scale `.90`. The ring **is a status light**: white while scanning, mint plus glow the instant the contour locks — confirmation happens under the user's thumb. Batch mode shows a mono shot count.
Goldens: single unlocked · single locked · batch with count · pressed = 4.

### `ModeToggle`
Inputs: `mode` · `onChanged` · `labels`.
220ms slide, `--ease-snap`. Glass, since it sits over the feed. Each half ≥ 44.
Goldens: single · batch = 2.

### `Readout`
Inputs: `text` (already formatted by the caller) · optional `icon` · `emphasis`.
Mono, **uppercase**, `--tracking-readout`. Prose must never be passed to it and it must never be used for prose (FR-013). The middot separator and `×` in dimensions are the only permitted non-icon marks.
Goldens: plain · with icon · emphasised = 3.

---

## `editor/` — 2 components

### `CheckerSurface` ★
Inputs: `child` · `variant` (`light` default / `dark`).
16px tile of four 8px quadrants via `ImageShader` in `TileMode.repeated`. `light` wherever a cutout is previewed at size; `dark` for grid thumbnails only (FR-022a). Values are the Photoshop/Figma figures and must not be adjusted.
Goldens: light · dark = 2.

### `BackgroundSwatchPicker` ★
Inputs: `swatches` (supplied by the caller) · `selectedIndex` · `onSelected`.
**Carries no swatch list of its own** — the seven fixed backgrounds are Spec #005's (FR-022). Selection is the mint ring plus tick. Each swatch ≥ 44.
Goldens: none selected · one selected, using a fixture list = 2.

---

## `batch/` — 2 components

### `BatchThumb` ★
Inputs: `image` · `status` (`queued`/`working`/`done`/`review`/`error`) · `onTap` · optional `progress`.
Radius `--r-thumb` (12), `--shadow-thumb`. Every status pairs its colour with a mark: dimmed, trace ring, tick, scissors, retry. `review` is amber and must never read as failure (FR-018).
Goldens: 5 statuses = 5.

### `ProgressTrace`
Inputs: `progress` (`null` = indeterminate) · `size`.
A traced ring — the same line the viewfinder draws, applied to time. Reduced motion stops the indeterminate spin and holds a static arc.
Goldens: indeterminate · 40% · complete = 3.

---

## `feedback/` — 2 components

### `EdgeNotice`
Inputs: `title` · `body` · `onRefine` · `onAccept`.
Amber, icon **`scissors`** — never `alert-triangle`, no red, no exclamation mark (FR-018). Two exits, matching the design's copy: refine, or use as-is.
Goldens: 1.

### `PcToast`
Inputs: `message` · `kind` (`neutral`/`caution`/`error`) · optional single `action` · `onDismiss`.
One line, at most one action. Glass, since it floats over content. Entrance is `pc-fade-up`.
Goldens: 3 kinds = 3.

---

## `shell/` — 2 components

### `ScreenHeader`
Inputs: `title` · optional `leading` · optional `actions` · optional `readout`.
Fixed **56px** (`--bar-height`), gutter 16. Does not grow with text scale (FR-015a).
Goldens: title only · with leading and actions = 2.

### `ThumbBand`
Inputs: `primary` (the one primary action) · optional `secondary` · optional `child` band content.
Fixed **132px** (`--thumb-band`) at the bottom, holding every primary action so the app stays one-handed. **Refuses destructive actions** (FR-024) — a `PcButton` with `variant: danger` triggers an assertion in debug rather than rendering.
Goldens: primary only · primary with secondary = 2.

---

## Coverage total

8 + 6 + 3 + 4 + 2 + 1 + 2 + 12 + 4 + 2 + 3 + 2 + 2 + 5 + 3 + 1 + 3 + 2 + 2 = **67 golden cases** across 19 components.

`ContourOverlay` alone accounts for twelve of them, because SC-003 requires all three states against all four reference backgrounds. That is a large share for one widget and it is the right share — it is the only component in the set with a documented failure mode.

The three greyscale stills used to verify SC-003 by eye are review artifacts, not golden files, and are not counted above.
