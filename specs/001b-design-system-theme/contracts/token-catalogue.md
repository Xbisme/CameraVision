# Contract: Token Catalogue

**Spec**: [../spec.md](../spec.md) · **Plan**: [../plan.md](../plan.md) · **Date**: 2026-08-14

This is the audit list that makes FR-003 and SC-001 checkable rather than asserted. Every custom property in the nine source files appears below exactly once, with its destination or a written reason for absence. **Silent omission is not permitted** — a token missing from this table is a defect in the table, not a licence to skip it.

**Source**: `.claude/design/project/_ds/productcam-design-system-8d7e1599-0b3a-4f3a-87c8-a208bd5b0896/tokens/*.css`

**Total: 196 custom properties + 5 `@keyframes`.**

| File | Properties | Destination |
|---|---|---|
| `colors.css` | 77 | `tokens/pc_colors.dart` |
| `typography.css` | 33 | `tokens/pc_typography.dart` |
| `fonts.css` | 2 | `tokens/pc_typography.dart` |
| `spacing.css` | 28 | `tokens/pc_spacing.dart` |
| `radius.css` | 9 | `tokens/pc_radius.dart` |
| `elevation.css` | 11 | `tokens/pc_elevation.dart` |
| `motion.css` | 16 | `tokens/pc_motion.dart` |
| `contour.css` | 20 + 5 keyframes | `tokens/pc_contour.dart` |
| `base.css` | 0 | element defaults, not tokens — see §9 |

---

## 1. `colors.css` → `PcColorTokens` (77)

**Base ramps — 39.** Direct transcription, hex → `Color(0xFF…)`.

| Group | Count | Members |
|---|---|---|
| ink | 13 | `950 900 850 800 700 600 500 400 300 200 100 050` + `white` |
| mint | 7 | `050 200 400 500 600 700 900` |
| amber | 5 | `050 300 500 700 900` |
| coral | 3 | `050 500 700` |
| checkerboard | 4 | `a`, `b`, `a-dark`, `b-dark` |
| alpha utilities | 7 | `white-04 white-08 white-14 white-24`, `ink-40 ink-64 ink-88` |

Alpha utilities are `rgba()` in source and become `Color(0x0AFFFFFF)`-style ARGB constants. The percentage is preserved exactly; rounding a `.04` to a convenient hex byte is the kind of drift FR-004 forbids.

**Semantic aliases — 38.** These reference ramp entries; none introduces a new value.

| Group | Count | Notes |
|---|---|---|
| surfaces | 9 | `shell app surface surface-raised sheet input track scrim glass` |
| light surfaces | 2 | `light`, `light-surface` — used only in export preview (Spec #007). Ported now; FR-003 forbids dropping a token because its consumer has not been written yet |
| text | 8 | `primary secondary muted inverse on-accent accent caution danger` |
| accent / interactive | 9 | `accent accent-hover accent-press accent-quiet accent-quiet-strong caution caution-quiet danger danger-quiet` |
| borders | 5 | `hairline subtle strong accent focus` |
| batch status | 5 | `queued working done review error` — the vocabulary of `PcBatchItemStatus` |

⚠️ **`--accent-hover` has no touch equivalent.** The design's own note is that hover exists only for the desktop preview of the bundle and does nothing but lift a surface. Ported for completeness and **must not be wired to any Flutter hover callback** — a hover affordance on a touch product is a Principle XI violation dressed as thoroughness.

---

## 2. `typography.css` → `PcTypographyTokens` (33)

| Group | Count | Transcription |
|---|---|---|
| font sizes | 9 | `display 34 · h1 26 · h2 21 · h3 18 · body-lg 17 · body 16 · body-sm 14 · caption 13 · micro 11` → logical pixels |
| line heights | 4 | `tight 1.08 · snug 1.25 · body 1.45 · loose 1.6` → `TextStyle.height`, unitless in both systems |
| weights | 5 | 400/500/600/700/800 → `FontWeight.w400`…`w800` |
| tracking | 5 | `display −.02em · tight −.01em · normal 0 · readout .08em · label .06em` → **conversion required**, see below |
| composed roles | 10 | `display h1 h2 h3 body body-strong caption button readout readout-sm` → one `TextStyle` each |

**Tracking needs a unit conversion, not a copy.** CSS `em` tracking is relative to font size; Flutter's `letterSpacing` is in logical pixels. Each role's value is `tracking × fontSize` — so `--type-readout` at 13px with `.08em` becomes `letterSpacing: 1.04`. Transcribing `0.08` directly would produce tracking roughly a thirteenth of what the design specifies. The five `em` values are kept as named constants and the multiplication is done per role, so the origin stays visible.

**Composed roles** are the `font:` shorthand substitution from research R9 — each expands into family, weight, size, height and letter spacing. Uppercasing on readouts is a widget-level concern (`Readout`), not baked into the token.

---

## 3. `fonts.css` → `PcTypographyTokens` (2)

| Property | Destination |
|---|---|
| `--font-ui` | `fontFamily` `Manrope`, with a reduced `fontFamilyFallback` |
| `--font-mono` | `fontFamily` `IBM Plex Mono`, with a reduced `fontFamilyFallback` |

**The `@import` line is deliberately not ported.** It fetches both families from a font CDN, which FR-012 and Principle VI forbid outright. Its replacement is the six embedded binaries in `assets/fonts/` (research R4). This is the single largest divergence between the bundle and the app, and it is required rather than optional.

The CSS fallback stacks name web-and-desktop faces (`Be Vietnam Pro`, `Segoe UI`, `system-ui`, `SFMono-Regular`) that mean nothing on iOS and Android. They are reduced to the platform default, which is the only fallback that can actually resolve. Recorded here so the reduction is not read as an oversight.

---

## 4. `spacing.css` → `PcSpacingTokens` (28)

| Group | Count | Members |
|---|---|---|
| 4px scale | 12 | `sp-1 2 · sp-2 4 · sp-3 6 · sp-4 8 · sp-5 12 · sp-6 16 · sp-7 20 · sp-8 24 · sp-9 32 · sp-10 40 · sp-11 48 · sp-12 64` |
| gutters | 3 | `gutter 16 · gutter-wide 20 · sheet-pad 20` |
| touch | 4 | `min 44 · comfortable 56 · shutter 80 · shutter-hit 104` |
| bands | 3 | `thumb-band 132 · bar-height 56 · tabbar-height 64` |
| safe areas | 2 | `safe-top 44 · safe-bottom 34` |
| grid | 1 | `grid-gap 6` |
| strokes | 3 | `hairline 1 · medium 1.5 · icon 1.75` |

⚠️ **`--safe-top` and `--safe-bottom` are prototype constants, not runtime values.** The bundle hardcodes them because a browser cannot ask a phone about its notch. In the app they must come from `MediaQuery.viewPaddingOf`. They are ported as the design's reference figures and **must not be used for layout** — using them would break every device whose insets differ. This is the one token pair where copying the value into a layout would be a bug.

The touch tokens are hard minimums, not suggestions (Principle XI). The shutter's 12px exclusion radius is a component rule rather than a token; it lives in [component-api.md](./component-api.md).

---

## 5. `radius.css` → `PcRadiusTokens` (9)

`xs 6 · sm 10 · md 14 · lg 20 · xl 28 · sheet 24 · pill 999 · thumb 12 · frame 34`

All become `BorderRadius` constants except `--r-pill`, which becomes a `StadiumBorder` — the design's `999px` is the CSS idiom for "fully rounded", and transcribing it as a literal 999px radius would be a misreading rather than a faithful port. Sheets use `sheet` on their **top corners only**.

---

## 6. `elevation.css` → `PcElevationTokens` (11)

| Property | Flutter form | Note |
|---|---|---|
| `--rim`, `--rim-strong` | 1px inset border | CSS `inset` box-shadow has no Flutter equivalent; drawn as a hairline `Border` inside the shape |
| `--shadow-float`, `--shadow-sheet`, `--shadow-thumb` | `BoxShadow` | ⚠️ blur radius calibrated, not copied — research R10 |
| `--glow-accent`, `--glow-accent-soft`, `--glow-caution` | `List<BoxShadow>` | `--glow-accent` is two layered shadows (a 1px ring plus a 22px bloom) and must stay two |
| `--scrim-top`, `--scrim-bottom` | `LinearGradient` | Direct transcription |
| `--blur-chrome` | `ImageFilter.blur` + colour matrix | ⚠️ `blur(18px)` calibrated (R10); the `saturate(1.1)` half needs a separate colour matrix |

**Depth is rims and glow, not drop shadows.** The three real shadows exist only for layers floating over the camera feed or over content. Applying one to an ordinary surface contradicts the design even though the token exists.

---

## 7. `motion.css` → `PcMotionTokens` (16)

| Group | Count | Members |
|---|---|---|
| durations | 7 | `instant 90 · fast 140 · base 220 · slow 380 · trace 1100 · lock 180 · shutter 110` → `Duration` |
| curves | 4 | `snap (.2,.9,.2,1) · out (.16,1,.3,1) · in-out (.4,0,.2,1) · linear` → `Cubic` / `Curves.linear` |
| press scales | 2 | `press .955 · shutter .90` → `double` |
| transitions | 3 | `t-press · t-color · t-sheet` → **decomposed, see below** |

The three `transition` shorthands are the substitution from research R9. CSS bundles property, duration and easing into one declaration; Flutter has no such object. Each is ported as a documented duration + curve pair — `t-press` = `instant` + `snap`, `t-color` = `fast` + `out`, `t-sheet` = `base` + `out` — so the audit reads them as ported, not dropped. The properties they animate (`transform`, `background-color`, `opacity`) are chosen per widget.

**`--dur-trace` is the only loop in the product** and is a status indicator, not an animation (Principle XI). It stops under reduced motion (FR-027a).

---

## 8. `contour.css` → `PcContourTokens` (20 + 5 keyframes)

| Group | Count | Members |
|---|---|---|
| colours | 5 | `core`, `core-lock`, `halo`, `review`, `error` |
| stroke widths | 3 | `core 2.5 · halo 6 · core-lock 3` |
| dash patterns | 2 | `scan 12 9 · review 2 7` → dash/gap pairs for the `PathMetric` walk (research R11) |
| march | 1 | `--contour-march` aliases `--dur-trace` |
| framing ticks | 2 | `tick 20 · tick-w 3` |
| state fills | 2 | `fill-scan` (mint 6%), `fill-lock` (mint 12%) |
| glows | 2 | ⚠️ `drop-shadow` filters → `MaskFilter.blur` on the path, calibrated (R9, R10) |
| checkerboard | 3 | `checker-size 16`, `checker-light`, `checker-dark` |

**The two-stroke rule is a token-level invariant.** `--contour-w-halo` (6) is always painted first, `--contour-w-core` (2.5) always on top. There is no token for a single-stroke contour and none may be added — a single line disappears against either a white sweep or black leather, which is the whole range a product photographer works across (FR-016).

**The checkerboard gradients are the conic-gradient substitution** from research R9: `--checker-size: 16px` describes a 16px tile of four 8px quadrants, repeated with an `ImageShader`. The light values `#FFFFFF`/`#D8DEE3` are the Photoshop/Figma figures and must not be adjusted — the design explicitly forbids redesigning this convention.

**The five `@keyframes` are behaviour, not values**, so they have no token destination. Each maps to a widget-level animation and is listed so the audit does not read them as dropped:

| Keyframe | Realised in |
|---|---|
| `pc-march` | `ContourOverlay` — dash-offset walk |
| `pc-lock-pulse` | `ContourOverlay` — one 380ms pulse on `scanning → locked` |
| `pc-sweep` | `ContourOverlay` — inner sweep during `scanning` |
| `pc-trace-spin` | `ProgressTrace` |
| `pc-fade-up` | `PcToast` and `PcSheet` entrances |

---

## 9. `base.css` → nothing (0 properties)

Eight CSS rules, zero custom properties. Each is a browser element default with a Flutter counterpart that already exists, so there is nothing to port:

| Rule | Why nothing is ported |
|---|---|
| `box-sizing: border-box` | Flutter's box model has no content-box/border-box distinction |
| `body` background, colour, font | Set by `ThemeData` — `scaffoldBackgroundColor`, `colorScheme`, `textTheme` |
| `-webkit-font-smoothing`, `text-rendering` | Rasterization is the engine's; no equivalent knob and none wanted |
| `h1…p { margin: 0 }` | Flutter `Text` has no implicit margin |
| `button { font-family }` | `PcButton` sets its own type role |
| `a` link styling | The product has no hyperlinks — it is offline (Principle VI) |
| `::selection` | No selectable prose surface in v1 |

Recorded rule-by-rule because "the file contributed nothing" is exactly the kind of claim FR-003 exists to make someone check.

---

## 10. Audit summary

Every one of the 196 properties falls into exactly one of these four buckets, which sum to 196:

| Category | Count | Meaning |
|---|---|---|
| Direct transcription | 167 | Value copied unchanged |
| Unit conversion | 5 | `em` tracking → logical pixels (§2) |
| Documented substitution | 18 | Composed `font:` roles 10, `transition:` shorthands 3, checkerboard gradients 2, `drop-shadow` glows 2, chrome blur 1 (§2, §6, §7, §8) |
| Calibrated, not copied | 6 | The `box-shadow` shadows and glows — `--shadow-float/-sheet/-thumb`, `--glow-accent/-accent-soft/-caution` (research R10) |

Three further calibrated values — `--contour-glow`, `--contour-glow-review`, `--blur-chrome` — are already counted under *substitution*, since they need both a different Flutter primitive **and** visual calibration. Research R10's list of nine calibrated values is therefore these three plus the six above.

Two overlay notes that do not change any count, but change what an implementer may do with the token:

| Note | Count | Tokens |
|---|---|---|
| Ported, but must not be used as written | 3 | `--safe-top`, `--safe-bottom` (§4 — use `MediaQuery.viewPaddingOf`), `--accent-hover` (§1 — no hover on a touch product) |
| Ported, and the CSS `@import` beside them is not | 2 | `--font-ui`, `--font-mono` (§3). The `@import` is an at-rule, not a custom property, so it is outside the 196 — but it is the one line in the bundle that cannot be honoured (Principle VI) |

Outside the property count entirely:

| Category | Count | Meaning |
|---|---|---|
| Behaviour, no token | 5 `@keyframes` | Realised as widget animations (§8) |
| No equivalent needed | 8 CSS rules | `base.css` — zero custom properties (§9) |

**196 properties accounted for, zero unexplained.**

`test/core/theme/token_catalogue_test.dart` asserts the count and that every catalogued name resolves. It cannot verify a value is *correct* — that is what golden comparison against the bundle is for.
