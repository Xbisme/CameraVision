# Phase 0 Research: Design System & Theme

**Spec**: [spec.md](./spec.md) · **Plan**: [plan.md](./plan.md) · **Date**: 2026-08-14

Every package version below was read from pub.dev on 2026-08-14, as Principle XIV requires. Nothing is carried over from another project or guessed.

---

## R1 — Toolchain stays pinned at Flutter 3.44.4 / Dart 3.12.2

**Decision**: No toolchain change. Spec #001's pin holds.

**Rationale**: In Spec #001 the pin was hygiene. Here it becomes load-bearing: golden baselines are bytes produced by a specific renderer, and a toolchain bump can change antialiasing or text layout enough to fail every golden at once. Bumping Flutter now would mean regenerating ~50 baselines in the same change that introduces them, making it impossible to tell an intended visual change from a renderer change.

**Alternatives considered**: Adopting a newer stable — rejected; the cost lands entirely on this spec's verification story and buys nothing it needs. A toolchain bump should be its own change, with a full golden regeneration as its visible diff.

---

## R2 — Icons ship as bundled SVG rendered by `flutter_svg 2.3.0`

**Decision**: Add exactly one runtime dependency, `flutter_svg`, pinned to `2.3.0`. Icons live in `assets/icons/` as SVG and are drawn through the single `PcIcon` widget.

**Verified on pub.dev (2026-08-14)**: version `2.3.0`, published by **flutter.dev** (verified publisher), carries the **Flutter Favorite** badge, supports Android · iOS · Linux · macOS · Web · Windows. No discontinuation or maintenance notice. No runtime network access.

**Rationale**: Clarification Q1 chose vector glyphs so the documented **1.75** stroke weight is reproduced exactly rather than approximated. An icon font bakes its stroke into the glyph outline and scales it with the type size, so it can never hold 1.75 across the four icon sizes the design uses (14 in badges, 16–18 inline, 22 in chrome, 26 in large icon buttons). Because the wrong choice would be frozen into every golden baseline as the standard, the fidelity argument outweighs the dependency cost here — and `flutter_svg` is about as safe as a Flutter dependency gets.

**Alternatives considered**:
- *An icon font* — smallest and dependency-free, rejected on stroke fidelity (Constitution VII names 1.75 explicitly).
- *Hand-porting ~30 icons to `Path` code* — zero dependencies, rejected under Principle XIII: thirty transcriptions is real, error-prone work, and swapping the icon set later means doing all of it again.
- *`vector_graphics` with precompiled `.vec` assets* — faster to parse and smaller, rejected for now because it adds a build step for a saving nobody has measured a need for. It remains the escape hatch if icon parsing ever shows up in a profile; `flutter_svg` already sits on top of `vector_graphics`, so the migration is local.

---

## R3 — Only the design's working vocabulary is vendored

**Decision**: Bundle roughly thirty glyphs — the working vocabulary the design bundle names — and no more. Source is Lucide at the version the design pins (`0.474.0`), ISC-licensed, attribution recorded in the repo.

**Rationale**: FR-026a. The full Lucide set is over a thousand icons; shipping it would add weight for glyphs no screen will ever draw, in a project where app size is a named top-three risk. Adding a glyph later is dropping in one file.

**Alternatives considered**: Vendoring the whole set for convenience — rejected on size and on YAGNI. Fetching icons at runtime — forbidden outright by Principle VI.

---

## R4 — Six font binaries, subset to Latin + Vietnamese

**Decision**: Embed six static font files in `assets/fonts/`:

| Family | Weights | Why |
|---|---|---|
| Manrope | 400, 500, 600, 700, 800 | All five are referenced by composed type roles |
| IBM Plex Mono | 500 | The only mono weight any role references |

Both are Open Font License, so embedding and redistribution are permitted; the licence file ships with the app. Each binary is subset to **Latin + Vietnamese** before it is committed, using `pyftsubset` from `fonttools`.

**Rationale**: Clarification Q2. An audit of the ten composed roles in `tokens/typography.css` found every Manrope weight in use but only `--fw-medium` on the mono face — `--type-readout` and `--type-readout-sm` are the only mono roles, and both are weight 500. Shipping mono 400 and 600 would put two files in every install that nothing can reference.

**Vietnamese coverage is not optional on the mono face.** It is tempting to assume readouts are digits and ASCII, but the design's own copy includes uppercase Vietnamese badges — `XONG`, `CẦN XEM LẠI` — which need `Ầ` and `Ạ`. IBM Plex Mono was confirmed on 2026-08-14 to carry a Vietnamese subset, covering `U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+1EA0-1EF9, U+20AB`. That last codepoint is the đồng sign `₫` — worth keeping deliberately in a Vietnamese selling app.

**Latin-Extended is excluded deliberately.** The product ships `en` and `vi` only (Principle IX); Latin-Ext exists for European languages this app does not serve. Excluding it is a size decision, recorded here so nobody re-adds it by reflex.

**Alternatives considered**: Shipping all eight weights — rejected, two would be dead payload. Keeping the CDN `@import` — forbidden by Principle VI and by FR-012. Not subsetting — rejected; unsubset faces would blow the 1.5 MB budget on their own.

---

## R5 — Static TTF, not variable, not WOFF2

**Decision**: Ship static TTF files, one per weight.

**Rationale**: Flutter's asset font loader does not consume WOFF2, so the format the design bundle's CDN serves is not an option regardless. Between static and variable, the deciding factor is that this spec makes golden baselines the enforcement mechanism: variable-font weight selection resolves through font-variation axes rather than a direct family match, and any per-platform disagreement in that resolution would surface as unexplained golden churn on the very tests meant to catch real regressions. Six static files remove that class of problem for a size difference measured in tens of kilobytes after subsetting.

**Alternatives considered**: A single Manrope variable file covering 400–800 — genuinely the smallest option and the reason it was considered at all; rejected because it trades a small, certain saving for an uncertain risk to the entire verification story.

---

## R6 — Golden tests use Flutter's built-in `matchesGoldenFile`; baselines are Linux-authoritative

**Decision**: No golden-testing package. Use `matchesGoldenFile` directly, with a `test/flutter_test_config.dart` that loads the six embedded fonts through `FontLoader` so goldens render ProductCam's actual type instead of the test placeholder font. Golden tests carry a `golden` tag. CI (Ubuntu) is the authority and runs everything; local runs exclude the tag by default. Baselines are regenerated through a `workflow_dispatch` CI job, not on a developer machine.

**Verified on pub.dev (2026-08-14)**: `golden_toolkit` is marked **discontinued**, last published `0.15.0` three years ago, with no successor named on its page.

**Rationale**: Two facts drive this. First, the obvious package is gone, and Principle XIV forbids substituting a look-alike. Second, `flutter_test` renders with the placeholder font unless real fonts are loaded — goldens taken without `FontLoader` would verify layout while hiding the typography, which is half of what this spec delivers.

The Linux-authoritative rule is the honest resolution of a real conflict: the dev machine is macOS, CI is `ubuntu-latest`, and text rasterization differs enough between them that one set of bytes cannot satisfy both. Picking CI as the single rendering target keeps one baseline per component instead of two.

**Cost, stated plainly**: a developer on macOS will not see golden failures locally — they surface on the PR. That is a real DX cost, mitigated only by CI running on every pull request. The alternative was worse.

**Alternatives considered**:
- *`golden_toolkit`* — rejected, discontinued.
- *A `macos-latest` CI job so dev and CI agree* — rejected: it doubles CI cost and still leaves two rendering targets the moment anyone runs Linux.
- *Regenerating baselines in Docker locally* — rejected as a hard prerequisite on a machine that does not yet have the Android SDK installed; the `workflow_dispatch` job achieves the same determinism with nothing to install.
- *Skipping goldens* — not available. Principle XII names golden tests for design-system components specifically.

---

## R7 — Tokens are `abstract final class` holders of `static const` values

**Decision**: Each token file exposes one `abstract final class` (for example `PcColorTokens`) whose members are `static const`. No maps, no enums, no generated code.

**Rationale**: `const` is the performance requirement in disguise — every colour, text style, shadow and duration is then allocated once at compile time and never rebuilt during paint, which is what lets `ContourOverlay` repaint over a live camera feed in Spec #003 without churning the heap. It also makes the CI gate trivially expressible: raw literals are legal under exactly one directory prefix. A map keyed by string would defeat both — no `const`, no compile-time check that a token exists.

**Alternatives considered**: A generated token file produced from the CSS by a script — attractive for guaranteeing no transcription slips, rejected under Principle XIII because it introduces a build step and a generator to maintain for a one-time port of 196 values that will change rarely. The audit test in [contracts/token-catalogue.md](./contracts/token-catalogue.md) covers the same risk without the machinery.

---

## R8 — Seven hand-written `ThemeExtension`s

**Decision**: Seven extensions — `PcColors`, `PcTypography`, `PcSpacing`, `PcRadius`, `PcElevation`, `PcMotion`, `PcContour` — each implementing `copyWith` and `lerp` by hand, registered on one `ThemeData`, reached through `context.pcColors`-style getters.

**Rationale**: The grouping is the constitution's, and it is a good one: it matches how the values are actually consumed, so a widget asks for "the colours" rather than importing seven unrelated things. `lerp` is implemented properly rather than returning `this`, because `AnimatedTheme` and any future cross-fade depend on it and a stub would fail silently, in a way no test that only reads values would catch.

**Alternatives considered**:
- *One giant extension* — rejected; every widget would depend on every token group, and `copyWith` would become unmanageable.
- *`theme_tailor` or similar codegen* — rejected under Principles XIII and XIV: a build-time dependency to avoid writing seven `copyWith` methods once.
- *Static access without `ThemeExtension`* — rejected; it would work today only because the theme is locked to one variant, and would have to be unwound the moment anything needs a second one.

---

## R9 — Five CSS constructs have no Flutter equivalent and are substituted, not copied

**Decision**: Reproduce each by equivalent means and record the substitution beside the token, as FR-005 requires.

| CSS construct | Where | Flutter equivalent |
|---|---|---|
| `repeating-conic-gradient` checkerboard | `--checker-light`, `--checker-dark` | A 16px tile painted as four 8px quadrants, repeated with an `ImageShader` in `TileMode.repeated` |
| `drop-shadow(...)` filter | `--contour-glow`, `--contour-glow-review` | `MaskFilter.blur` on the painted contour path — a `BoxShadow` cannot follow an arbitrary path |
| `backdrop-filter: blur() saturate()` | `--blur-chrome` | `BackdropFilter` with `ImageFilter.blur`; the `saturate(1.1)` half needs a colour matrix and is composed on top |
| `font:` shorthand | the 10 composed type roles | One `TextStyle` per role, assembled from the size/height/weight/tracking tokens |
| `transition:` shorthand | `--t-press`, `--t-color`, `--t-sheet` | Not tokens at all in Flutter — they decompose into a duration and a curve that already exist. Ported as documented duration+curve pairs, with the decomposition noted so the audit does not read them as dropped |

**Rationale**: FR-004 says port unchanged, FR-005 says substitute where impossible. Being explicit about which of the two applies is what stops a reviewer from reading a substitution as a mistake — or a mistake as a substitution.

---

## R10 — Blur and shadow radii must be calibrated visually, not transcribed

**Decision**: Do not copy CSS blur numbers into Flutter fields. Set each one by comparing against the design bundle rendered in a browser, then record the calibrated value and its CSS origin together in the token file.

**Rationale**: This is the one place where a faithful-looking transcription produces a wrong result. The three blur-bearing constructs do not even agree with each other about what their number means: for `filter: blur(18px)` the length is the Gaussian standard deviation, while for `box-shadow: 0 0 22px` and `drop-shadow(0 0 6px)` the length is a blur radius that conventionally works out to about twice the deviation. Flutter adds a third convention — `BoxShadow.blurRadius` is documented as a standard deviation, yet the class also exposes a separate `blurSigma`, so the field is not simply one or the other.

Rather than assert a conversion factor this plan cannot verify from the documentation, the values get set by eye against the bundle and the result written down. That is slower and it is the only way to be sure. Affected tokens: `--shadow-float`, `--shadow-sheet`, `--shadow-thumb`, `--glow-accent`, `--glow-accent-soft`, `--glow-caution`, `--contour-glow`, `--contour-glow-review`, `--blur-chrome`.

**Alternatives considered**: Copying the numbers verbatim — rejected, it is guaranteed wrong for at least one of the three conventions. Deriving a single conversion constant and applying it everywhere — rejected, the conventions differ per construct, so one constant cannot be right for all of them.

---

## R11 — Dashed contour strokes are built from `PathMetric`, with no package

**Decision**: Implement dashing inside `ContourOverlay` by walking `Path.computeMetrics()` and extracting alternating segments. Animate the marching effect by offsetting where the walk starts.

**Rationale**: Flutter's `Paint` has no dash property, and this is the one place the product genuinely needs one. The `PathMetric` walk is a short, well-understood routine, and owning it means the dash phase — which is what animates — is directly controllable rather than filtered through a package's API. Principle XIII prefers three lines of repetition to an early abstraction; it prefers them even more to a dependency.

**Alternatives considered**: `path_drawing` — rejected under Principle XIII/XIV for a single function on the app's most performance-sensitive widget.

---

## R12 — Text scaling is clamped with `MediaQuery.withClampedTextScaling`

**Decision**: Wrap the app in `MediaQuery.withClampedTextScaling(maxScaleFactor: 1.3)` in `lib/app/app.dart`. The `1.3` lives in the theme layer as a named constant, not inline.

**Verified**: `MediaQuery.withClampedTextScaling` exists as a named constructor taking `minScaleFactor` (default `0.0`), `maxScaleFactor` (default `double.infinity`) and a required `child`, and applies `TextScaler.clamp` to the subtree.

**Rationale**: FR-015a. One wrapper at the root beats every component defending itself, and it makes the cap a single reviewable decision. Clamping rather than ignoring is what keeps Principle XI satisfied — the setting is honoured up to the point where the fixed 56/132 bands would have to stretch.

**Alternatives considered**: Per-component clamping — rejected, thirty places to forget one. Ignoring the setting entirely — rejected, it is a Principle XI violation and the target users are more likely than average to use enlarged text.

---

## R13 — Reduced motion reads `MediaQuery.disableAnimationsOf`

**Decision**: Every animating component checks `MediaQuery.disableAnimationsOf(context)` and, when true, holds its static appearance instead of running. `ContourOverlay` stops its dash march and its lock pulse but keeps each state's dash pattern.

**Verified**: `MediaQuery.disableAnimationsOf(context)` exists and returns the nearest ancestor's `disableAnimations`, defaulting to `false`.

**Rationale**: FR-027a, and Principle XI names this API directly. The reason nothing is lost is structural: the three contour states were already designed to differ by dash pattern rather than motion, so removing motion removes redundancy, not information. That claim is what SC-003's greyscale-still check actually tests.

**Alternatives considered**: Substituting a text status indicator when motion is off — rejected; it puts words over the viewfinder, which is exactly what the design avoids.

---

## R14 — The existing hardcode gate is tightened to `tokens/`

**Decision**: Change `scripts/check_no_hardcode.sh` to exempt `lib/core/theme/tokens/` rather than all of `lib/core/theme/`, and extend it to catch `EdgeInsets`/`SizedBox`/`BorderRadius` literals outside that prefix.

**Rationale**: The script written in Spec #001 exempts the whole theme directory. That was harmless when the directory held a `.gitkeep`, and it is wrong now — Constitution VII permits literals in `tokens/` only, so as written the gate would let a stray `Color(0xFF...)` into an extension or into `pc_theme.dart` and call it a pass. Tightening the prefix costs one line and is the difference between the gate enforcing the principle and merely appearing to.

**Alternatives considered**: Leaving it — rejected, it would silently weaken the central guarantee of this spec.

---

## R15 — App-size delta is measured against a Spec #001 baseline, per platform

**Decision**: Record installed size before and after on both platforms, using release builds of the `development` flavor. Report the delta in the PR, alongside the per-file font sizes.

**Rationale**: SC-008 sets a 1.5 MB ceiling, and a ceiling without a measurement is a wish. Per-platform matters because the two do not compress assets identically. Release-build measurement matters because debug builds carry payload that has nothing to do with fonts. The Android half of this needs a real device toolchain, which is the same dependency Spec #001 left outstanding.

**Known constraint carried over from Spec #001**: the dev machine has no Android SDK installed, so the Android figure cannot be produced until that is resolved. It is a measurement, not a design decision, so it does not block the rest of the work — but it is the second spec in a row to need it, and it should be sorted before Spec #002 makes it unavoidable.

**Alternatives considered**: Measuring only iOS — rejected, Android is the platform where the size budget is actually tight, since the segmentation model will claim most of it. Skipping measurement and trusting the subset — rejected; SC-008 is a numeric criterion.
