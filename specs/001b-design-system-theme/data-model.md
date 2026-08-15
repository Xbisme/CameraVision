# Phase 1 Data Model: Design System & Theme

**Spec**: [spec.md](./spec.md) · **Plan**: [plan.md](./plan.md) · **Date**: 2026-08-14

This spec has no persisted data, no domain entities and no DTOs — it stores nothing and talks to nothing. What it does have is a structure worth writing down: the token groups, the component states those tokens dress, and the enumerations that later specs will hand to these components. Getting the state enumerations right here is what stops Specs #004–#007 from each inventing their own.

Full value-by-value mapping lives in [contracts/token-catalogue.md](./contracts/token-catalogue.md); this file describes shape, not contents.

---

## 1. Token groups

Seven groups, each a `ThemeExtension` fed by one token file. Counts are the number of definitions ported from the corresponding CSS source.

| Group | Extension | Source file | Definitions | Carries |
|---|---|---|---|---|
| Colour | `PcColors` | `colors.css` | 77 | 4 base ramps (ink, mint, amber, coral), checkerboard pairs, alpha utilities, then semantic aliases for surfaces, text, accent/interactive, borders, batch status |
| Typography | `PcTypography` | `typography.css` + `fonts.css` | 33 + 2 | 9 sizes, 4 line heights, 5 weights, 5 tracking values, 10 composed roles, 2 family stacks |
| Spacing | `PcSpacing` | `spacing.css` | 28 | 12-step 4px scale, gutters, sheet padding, 4 touch minimums, the fixed bands, grid gap, 3 stroke widths |
| Radius | `PcRadius` | `radius.css` | 9 | `xs` → `frame`, plus the pill and thumbnail radii |
| Elevation | `PcElevation` | `elevation.css` | 11 | 2 rims, 3 shadows, 3 glows, 2 scrim gradients, chrome blur |
| Motion | `PcMotion` | `motion.css` | 16 | 7 durations, 4 curves, 2 press scales, 3 decomposed transitions |
| Contour | `PcContour` | `contour.css` | 20 | Two-stroke widths and colours, 2 dash patterns, tick marks, state fills, glows, checkerboard sizing |

**Invariants across all groups**

- Every member is `const`. Nothing in a token group is constructed at paint time (Principle V, research R7).
- Raw literals appear only in `lib/core/theme/tokens/`. The extension classes reference tokens by name and hold no literal of their own.
- Each extension implements `copyWith` and `lerp` over every field. A `lerp` that returns `this` is a defect, not a shortcut — `AnimatedTheme` would silently stop working and no value-reading test would notice.
- Semantic aliases point at ramp entries, never at fresh values. `--accent` *is* `--mint-500`; it is not a second copy of the same hex.

**Relationships**

```
tokens/pc_colors.dart ──feeds──> PcColors ─┐
tokens/pc_typography.dart ─────> PcTypography ─┤
tokens/pc_spacing.dart ────────> PcSpacing ────┤
tokens/pc_radius.dart ─────────> PcRadius ─────┼──registered on──> one dark ThemeData
tokens/pc_elevation.dart ──────> PcElevation ──┤                        │
tokens/pc_motion.dart ─────────> PcMotion ─────┤                        │
tokens/pc_contour.dart ────────> PcContour ────┘                        │
                                                                        ▼
                                          context.pcColors / .pcSpacing / … ──> the 19 widgets
```

---

## 2. Component state enumerations

These are the vocabularies later specs will speak. Each value is a golden case (FR-029).

### `PcContourState` — 3 values

The signature element. State is carried by dash pattern first and colour second, so it survives greyscale and colour-blindness (SC-003).

| Value | Dash | Core | Motion | Meaning |
|---|---|---|---|---|
| `scanning` | `12 9` marching | mint | 1.1s loop + inner sweep | Edge found, not yet stable — hold still |
| `locked` | solid, thicker core | brighter, with glow | one 380ms pulse | Edge stable — shoot now |
| `review` | `2 7` dotted | amber | none | Complex edge (fur, hair, glass) — usable, may want a pass |

**Transitions**: `scanning → locked` is the only animated transition and it fires the lock pulse. `review` is entered from either and is terminal within a single frame's evaluation. This spec drives the state from a parameter; Spec #003 drives it from the segmentation engine.

**Reduced motion**: all three keep their dash pattern; the march and the pulse stop (FR-027a). No two states may become identical — that is the property the greyscale check verifies.

### `PcBatchItemStatus` — 5 values

Dressed here, populated in Spec #006. Each pairs a colour with a non-colour mark, per Principle XI.

| Value | Colour token | Non-colour mark |
|---|---|---|
| `queued` | `--status-queued` | dimmed thumbnail, no badge |
| `working` | `--status-working` | progress trace ring |
| `done` | `--status-done` | tick |
| `review` | `--status-review` | scissors glyph |
| `error` | `--status-error` | retry glyph |

`error` is the only status permitted the coral ramp. `review` is amber and must never read as failure (FR-018).

### `PcButtonVariant` / `PcButtonSize`

Variant carries the semantic-colour law of FR-010: at most one `primary` per screen, because mint is the single signal colour.

| Variant | Fill | Permitted use |
|---|---|---|
| `primary` | mint | The one primary action on a screen |
| `secondary` | raised surface + rim | Everything else |
| `quiet` | transparent + hairline | Tertiary, in-sheet |
| `danger` | coral | Destructive only — and never inside the thumb band (FR-024) |

Sizes map to the touch tokens: `comfortable` = 56, `standard` = 44. Nothing smaller exists.

### `PcCheckerVariant` — 2 values

| Value | Pair | Where |
|---|---|---|
| `light` | `--checker-a` / `--checker-b` | Default — any cutout previewed at size |
| `dark` | `--checker-a-dark` / `--checker-b-dark` | Grid thumbnails only |

Resolved by clarification (FR-022a) so Specs #004, #005 and #007 do not each guess. Neither pair may be redesigned — these are the values sellers already recognise from other tools.

### `PcToastKind` — 3 values

`neutral` (confirmation, e.g. "Đã lưu 6 ảnh vào máy"), `caution` (amber, worth a look), `error` (coral, a genuine failure that can be retried). One line, at most one action.

---

## 3. Icon inventory

A closed set, not an open door. `PcIcon` accepts a value from a single enumeration; an arbitrary asset path is not an accepted input, so an un-vendored glyph is a compile error rather than a blank square at runtime.

Working vocabulary from the design bundle — **26 glyphs**, the complete list: `camera`, `images`, `layers`, `image`, `zap`, `zapOff`, `refreshCw`, `rotateCcw`, `rotateCw`, `grid3x3`, `settings2`, `check`, `x`, `scissors`, `download`, `share2`, `clock`, `search`, `chevronLeft`, `moreHorizontal`, `loader`, `plus`, `undo2`, `signalHigh`, `wifi`, `batteryFull`.

**Rules**
- Monochrome, inheriting the surrounding colour. An icon is never coloured for decoration; colour follows state only.
- Stroke fixed at `--stroke-icon` (1.75), round caps and joins.
- Sizes: 14 in badges and readouts, 16–18 inline, 22 in chrome, 26 in the large icon button.
- `scissors` — never a warning triangle — marks a complex edge (FR-018).
- No emoji and no unicode character standing in for a glyph, anywhere (FR-025). The only permitted non-icon marks are typographic: the middot in readouts (`PNG · 1200×1200`) and `×` in dimensions.

---

## 4. Reference images

The unit of visual regression detection. Not persisted app data — build artifacts committed to the repo.

| Attribute | Value |
|---|---|
| Identity | one component + one state |
| Location | `test/core/widgets/goldens/` |
| Produced by | `matchesGoldenFile` with the real embedded fonts loaded (research R6) |
| Authority | Linux CI. Baselines are regenerated by a `workflow_dispatch` job, never on a dev machine |
| Lifecycle | An intended visual change refreshes the image in the same commit, so review sees a before-and-after (FR-030) |

Coverage is every documented state of every component: 3 contour states, 5 batch statuses, 4 button variants × 2 press states, 2 checkerboard variants, 3 toast kinds, and one per remaining component — roughly 50 cases.

---

## 5. What this spec deliberately does not model

- **No product entities.** No photo, no mask, no session, no export job. Those belong to Specs #004–#007.
- **No fixed content lists.** The seven background swatches (Spec #005) and the batch queue (Spec #006) are supplied to components, not owned by them (FR-022).
- **No persistence of any kind** — no preference, no cache, no stored appearance choice. There is nothing to choose: the theme is locked dark (FR-007).
- **No localization keys.** Components receive display text (FR-021), so this spec adds no ARB entries and cannot leak a literal.
