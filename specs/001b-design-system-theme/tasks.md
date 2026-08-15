# Tasks: Design System & Theme

**Input**: Design documents from `/specs/001b-design-system-theme/`

**Prerequisites**: [plan.md](./plan.md), [spec.md](./spec.md), [research.md](./research.md), [data-model.md](./data-model.md), [contracts/](./contracts/)

**Tests**: Included, and not optional here. The specification requires them by name — golden coverage for every component state (FR-029, SC-005), touch-area assertions (SC-007), and a token-catalogue audit (SC-001) — and Constitution Principle XII names golden tests for design-system components specifically.

**Organization**: Grouped by user story so each is independently testable. Read the dependency note under each phase before reordering.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependency on incomplete work)
- **[Story]**: Which user story the task serves (US1–US5)
- Every task names an exact path

## Path Conventions

Single Flutter codebase at repository root. Source in `lib/`, tests in `test/`, assets in `assets/`, guard scripts in `scripts/`. Full tree in [plan.md](./plan.md#source-code-repository-root).

---

## Phase 1: Setup

**Purpose**: Put the dependency, the directories and the guard rails in place before any value is ported, so the gate is watching from the first commit rather than the last.

- [X] T001 Add `flutter_svg: 2.3.0` to `dependencies` in `pubspec.yaml` (verified on pub.dev 2026-08-14: publisher `flutter.dev`, Flutter Favorite, Android + iOS supported — research R2), run `flutter pub get`, and commit the updated `pubspec.lock`
- [X] T002 [P] Create the source tree: `lib/core/theme/tokens/`, `lib/core/theme/extensions/`, and `lib/core/widgets/{core,camera,editor,batch,feedback,shell}/`, removing the `.gitkeep` files left by Spec #001
- [X] T003 Create `assets/fonts/` and `assets/icons/`, declare both under `flutter:` in `pubspec.yaml` (**after T001** — same file, so this cannot run in parallel with it), and add the Open Font License text for Manrope and IBM Plex Mono plus the ISC license text for the Lucide glyphs so attribution ships with the app
- [X] T004 Tighten `scripts/check_no_hardcode.sh`: change the colour and style exemption from `lib/core/theme/` to `lib/core/theme/tokens/`, and extend the style pattern to catch `EdgeInsets.all(`, `EdgeInsets.symmetric(`, `SizedBox(` and `BorderRadius.circular(` with numeric literals outside that prefix (research R14 — the current script is looser than Constitution VII permits). Confirm it still exits 0 on the untouched tree, and that a violation is reported with its file and line (FR-028)
- [X] T005 Update `.github/workflows/ci.yml`: keep `flutter test` running everything on `ubuntu-latest` as the golden authority, and add a separate `workflow_dispatch` job `update-goldens` that runs `flutter test --update-goldens --tags golden` and commits the result, so baselines are never generated on a developer machine (research R6)

**Checkpoint**: `./scripts/check_no_hardcode.sh` passes on a tree with no tokens yet, and CI is ready to be the single rendering target.

---

## Phase 2: Foundational — the token layer

**Purpose**: The 196 values from [contracts/token-catalogue.md](./contracts/token-catalogue.md). Every user story reads from these, so nothing else can start.

**⚠️ CRITICAL**: No user story work begins until this phase is complete.

**Rule for every task in this phase**: together these seven files are the single definition layer FR-001 requires, and they are the *only* place in the repository where a raw visual literal may appear (FR-002). Port values unchanged (FR-004); where a CSS construct has no Flutter equivalent, substitute and record the substitution inline (FR-005). Each file exposes one `abstract final class` of `static const` members — `const` is what keeps paint allocation-free (research R7).

- [X] T006 [P] Port the 28 spacing tokens to `lib/core/theme/tokens/pc_spacing.dart` — the 12-step 4px scale, gutters, the four touch minimums (44/56/80/104), the fixed bands (132 thumb, 56 bar, 64 tabbar), grid gap 6, and the three stroke widths. Mark `safeTop` and `safeBottom` with a comment stating they are the bundle's prototype constants and **must not be used for layout** — real insets come from `MediaQuery.viewPaddingOf` (catalogue §4)
- [X] T007 [P] Port the 9 radius tokens to `lib/core/theme/tokens/pc_radius.dart` as `BorderRadius` constants, with `--r-pill` becoming a `StadiumBorder` rather than a literal 999px radius — the CSS value is an idiom for "fully rounded", and copying it as a number would be a misreading (catalogue §5)
- [X] T008 [P] Port the 16 motion tokens to `lib/core/theme/tokens/pc_motion.dart` — 7 `Duration`s, 4 curves as `Cubic`, the 2 press scales, and the 3 `transition` shorthands decomposed into documented duration+curve pairs so the audit reads them as ported rather than dropped (catalogue §7)
- [X] T009 [P] Port the 77 colour tokens to `lib/core/theme/tokens/pc_colors.dart` — 39 base ramp entries then 38 semantic aliases. Aliases must reference ramp entries, never restate a hex. Preserve alpha percentages exactly rather than rounding to a convenient byte. Comment `--accent-hover` as ported-but-unused: hover exists only in the bundle's desktop preview and must not be wired to a Flutter hover callback (catalogue §1)
- [X] T010 Port the 33 typography tokens plus 2 family stacks to `lib/core/theme/tokens/pc_typography.dart` — 9 sizes, 4 line heights, 5 weights, 5 tracking values, and the 10 composed roles as `TextStyle`s. **Convert tracking from `em` to logical pixels per role** (`tracking × fontSize`, so `--type-readout` at 13px/.08em becomes `letterSpacing: 1.04`); copying `0.08` directly would yield roughly a thirteenth of the specified tracking. Reduce the CSS fallback stacks to the platform default, which is the only fallback that can resolve on mobile (catalogue §2, §3)
- [ ] T011 Calibrate the 9 blur and shadow radii by rendering the design bundle in a browser beside a Flutter harness and matching by eye — `--shadow-float`, `--shadow-sheet`, `--shadow-thumb`, `--glow-accent`, `--glow-accent-soft`, `--glow-caution`, `--contour-glow`, `--contour-glow-review`, `--blur-chrome`. Record each calibrated number together with its CSS origin. **Do not transcribe the CSS numbers**: `filter: blur()` takes a standard deviation, `box-shadow`/`drop-shadow` take a radius of roughly twice that, and Flutter's `BoxShadow` documents `blurRadius` as a deviation while also exposing a separate `blurSigma` — three conventions that cannot all be satisfied by one number (research R10)
- [X] T012 Port the 11 elevation tokens to `lib/core/theme/tokens/pc_elevation.dart` using T011's calibrated values — 2 rims as inset hairline borders, 3 `BoxShadow`s, 3 glows (`--glow-accent` stays **two** layered shadows: a 1px ring plus a 22px bloom), 2 scrim `LinearGradient`s, and the chrome blur as an `ImageFilter.blur` plus a separate colour matrix for the `saturate(1.1)` half (catalogue §6)
- [X] T013 Port the 20 contour tokens to `lib/core/theme/tokens/pc_contour.dart` using T011's calibrated glow values — the two stroke widths (halo 6, core 2.5, core-lock 3), 5 colours, the two dash/gap pairs, framing ticks, the two state fills, and the checkerboard trio. **Add no token for a single-stroke contour** and leave a comment saying why: one line vanishes against either a white sweep or black leather (FR-016, catalogue §8)
- [X] T014 Write `test/core/theme/token_catalogue_test.dart` asserting that all 196 catalogued tokens resolve and that the per-file counts match [contracts/token-catalogue.md](./contracts/token-catalogue.md) — 77/33+2/28/9/11/16/20. The test guards against silent drops (FR-003, SC-001); it deliberately cannot judge whether a value is *correct*, which is SC-006's job

**Checkpoint**: 196 values exist, `flutter analyze` is clean, and `./scripts/check_no_hardcode.sh` still passes — proving every literal landed inside `tokens/`.

---

## Phase 3: User Story 1 — The app wears its own appearance (P1)

**Goal**: The seven placeholder areas stop looking like a stock framework app and start looking like ProductCam, on every device regardless of the phone's light/dark setting.

**Independent test**: Install, walk all seven areas with the phone in light mode and then dark mode. The appearance is identical, dark, and matches the bundle's colour and type specimens. No stock framework colour is visible.

- [X] T015 [P] [US1] Create the `PcColors` `ThemeExtension` in `lib/core/theme/extensions/pc_colors.dart`, with `copyWith` and a real `lerp` over every field — a `lerp` returning `this` breaks `AnimatedTheme` silently and no value-reading test would catch it (research R8)
- [X] T016 [P] [US1] Create `PcSpacing` in `lib/core/theme/extensions/pc_spacing.dart` with `copyWith` and `lerp`
- [X] T017 [P] [US1] Create `PcRadius` in `lib/core/theme/extensions/pc_radius.dart` with `copyWith` and `lerp`
- [X] T018 [P] [US1] Create `PcMotion` in `lib/core/theme/extensions/pc_motion.dart` with `copyWith` and `lerp`
- [X] T019 [P] [US1] Create `PcElevation` in `lib/core/theme/extensions/pc_elevation.dart` with `copyWith` and `lerp`
- [X] T020 [P] [US1] Create `PcContour` in `lib/core/theme/extensions/pc_contour.dart` with `copyWith` and `lerp`
- [X] T021 [US1] Create `PcTypography` in `lib/core/theme/extensions/pc_typography.dart` exposing the 10 composed roles, with `copyWith` and `lerp`
- [X] T022 [US1] Write `lib/core/theme/pc_theme.dart` — `buildPcTheme()` returning one dark `ThemeData` with all seven extensions registered, mapping `--bg-app`/`--bg-surface`/`--bg-surface-raised` onto `ColorScheme.dark` and the type roles onto `TextTheme` per the bundle readme's Flutter mapping table
- [X] T023 [US1] Write `lib/core/theme/pc_context.dart` with `BuildContext` getters — `context.pcColors`, `.pcSpacing`, `.pcRadius`, `.pcTypography`, `.pcElevation`, `.pcMotion`, `.pcContour`
- [X] T024 [US1] Replace both `ThemeData.dark()` calls in `lib/app/app.dart` with `buildPcTheme()`, keeping `themeMode: ThemeMode.dark` so the app never follows the device appearance (FR-007)
- [X] T025 [US1] Wrap the app subtree in `MediaQuery.withClampedTextScaling(maxScaleFactor: …)` in `lib/app/app.dart`, reading the 1.3 cap from a named constant in the theme layer rather than inline (FR-015a, research R12)
- [X] T026 [US1] Update the seven placeholder pages under `lib/features/*/presentation/` to draw their surfaces and text from the theme instead of framework defaults — appearance only, **no layout, no capability, no content** (FR-008, SC-011)
- [X] T027 [P] [US1] Write `test/core/theme/extensions_test.dart` covering `copyWith` and `lerp` for all seven extensions, including that `lerp` at t=0.5 actually interpolates rather than returning an endpoint

**Checkpoint**: US1 is demonstrable on its own. The app is dark, ProductCam-coloured, and type-correct — though still in the platform font until US2.

---

## Phase 4: User Story 2 — Vietnamese and English read correctly, with no network (P1)

**Goal**: Both typefaces embedded and rendering correct Vietnamese diacritics offline, from first launch.

**Independent test**: Airplane mode before first launch, open in Vietnamese then English, display the diacritic reference string including the uppercase mono badges `XONG` and `CẦN XEM LẠI` and the đồng sign `₫`. Zero substituted or missing glyphs, zero network requests.

**Depends on**: Phase 3 (T021 declares the family names these binaries satisfy).

- [X] T028 [US2] Generate the six subset font binaries with `pyftsubset` — Manrope 400/500/600/700/800 and IBM Plex Mono 500 — restricted to **Latin + Vietnamese**. Latin-Extended is excluded deliberately: it serves European languages this product does not ship (research R4). Confirm the mono subset covers `U+1EA0-1EF9` and `U+20AB`, since uppercase Vietnamese badges and the đồng sign both go through the mono face
- [X] T029 [US2] Commit the six TTF files to `assets/fonts/` and declare both families with their weights under `flutter: fonts:` in `pubspec.yaml`. Static TTF, not variable and not WOFF2 — Flutter cannot load WOFF2 at all, and variable-axis weight resolution would put unexplained churn into the golden baselines this spec depends on (research R5)
- [X] T030 [US2] Delete any remaining reference to the font CDN, and confirm `grep -rn "fonts.googleapis\|@import\|http" lib/ pubspec.yaml` returns nothing outside comments. The bundle's `@import` is the one line in the design system that cannot be honoured (FR-012, Principle VI)
- [X] T031 [US2] Write `test/flutter_test_config.dart` loading the six embedded fonts through `FontLoader` before any test runs, so goldens render ProductCam's actual type rather than the placeholder font `flutter_test` uses by default — without this, every golden would verify layout while hiding typography (research R6)
- [X] T032 [P] [US2] Write `test/core/theme/typography_test.dart` asserting each of the 10 composed roles resolves to the expected family, weight and **pixel** letter spacing, so the `em` conversion in T010 cannot silently regress
- [X] T032a [P] [US2] Close the missing-glyph edge case with a **charset golden** at `test/core/theme/charset_test.dart`: render the complete Vietnamese diacritic set plus Latin and `₫` in both faces — prose in Manrope, uppercase badges in IBM Plex Mono — and commit it as a reference image. A missing glyph renders as a substitution or a tofu box, both of which differ visibly from the correct glyph, so the existing golden machinery catches it with no new tooling. Two layers, stated together: T010 defines the fallback (platform default for anything outside the shipped set), and this test guarantees normal Vietnamese and English copy never reaches it
- [X] T033 [US2] Measure and record the six per-file sizes in `assets/fonts/` and confirm the total sits inside the 1.5 MB ceiling. If correct Vietnamese coverage cannot fit, revisit the budget — not the coverage (FR-014, SC-008, spec Assumptions)

**Checkpoint**: US2 is demonstrable on its own. Type is ProductCam's, offline, with correct diacritics on both faces.

---

## Phase 5: User Story 3 — The signature contour survives any background (P1)

**Goal**: The two-stroke contour, its three states, and the guarantee that it stays readable against anything a camera can see.

**Independent test**: Render all three states over the four reference backgrounds — white studio paper, warm cardboard, black leather, backlit window — and confirm the line is visible in all twelve. Then name each state from a greyscale still, 3 out of 3, without seeing colour.

**Depends on**: Phase 2 (T013), Phase 3, and **T031** — the goldens in T039 need `flutter_test_config.dart` loading the real fonts, or they will bake baselines rendered in the placeholder font. This is the one place Phases 4 and 5 are not truly parallel.

- [X] T034 [US3] Implement the dash routine inside `lib/core/widgets/camera/contour_overlay.dart` by walking `Path.computeMetrics()` and extracting alternating segments, with the walk's start offset as the animatable phase. No package — this is a short routine on the app's most performance-sensitive widget (research R11)
- [X] T035 [US3] Implement `ContourOverlay` painting **two strokes, always**: halo 6px `--contour-halo` first, then the core 2.5px (3px when locked) on top. Accept `path` in normalized 0.0–1.0 coordinates scaled to the paint size, and `state`. Place it inside a `RepaintBoundary` and repaint only when inputs change (FR-016, contract component-api)
- [X] T036 [US3] Implement the three states — `scanning` (12/9 marching dashes, mint, inner sweep), `locked` (solid brighter core, glow, one 380ms pulse on entry), `review` (2/7 amber dots, no motion). State must be readable from dash pattern alone, so it survives greyscale and colour-blindness (FR-017, Principle XI)
- [X] T037 [US3] Honour reduced motion via `MediaQuery.disableAnimationsOf(context)`: stop the march and the lock pulse, hold each state's static shape, keep all three distinguishable. Nothing is lost because the states never depended on motion to differ (FR-027a, research R13)
- [X] T038 [US3] Handle the empty case — a null or degenerate `path` paints nothing and does not throw, rather than leaving a stray mark on the viewfinder (spec Edge Cases)
- [X] T039 [US3] Write `test/core/widgets/contour_overlay_test.dart` with the 12 goldens (3 states × 4 reference backgrounds), plus behaviour tests for the empty path and the reduced-motion path. Also assert FR-019 statically — no file under `lib/core/widgets/` imports the camera or any platform channel, so the contour cannot quietly grow a dependency that belongs to Spec #003
- [ ] T040 [US3] Produce the 3 greyscale stills from the `ContourOverlay` goldens in `test/core/widgets/goldens/` and confirm a reviewer can name each state without colour. Attach them to the PR — they are review artifacts, not golden files (SC-003)

**Checkpoint**: The product's signature element works and is proven against the exact conditions that break a single-stroke line.

---

## Phase 6: User Story 4 — Later screens assemble instead of inventing (P2)

**Goal**: The remaining 18 shared components — which together with `ContourOverlay` from Phase 5 complete the set of 19 FR-020 requires — so Specs #004–#008 compose screens rather than styling them.

**Independent test**: Build one scratch screen using only the kit and confirm no colour, text size, spacing value, radius or duration is authored anywhere in it.

**Depends on**: Phases 2–4. Public surface is fixed by [contracts/component-api.md](./contracts/component-api.md) — a change there after this phase is a change to six other specs.

**Applies to every task below**: text and `semanticsLabel` arrive as parameters and are never read from the ARB (FR-021); the component carries no content belonging to a later spec (FR-022); touch minimums are asserted against the **rendered hit area**, not the painted size (FR-023).

- [X] T041 [US4] Implement `PcIcon` in `lib/core/widgets/core/pc_icon.dart` as the single icon entry point, accepting a value of a closed `PcIconData` enumeration — an arbitrary asset path must not be an accepted input, so an un-vendored glyph is a compile error rather than a blank square at runtime (FR-025)
- [X] T042 [US4] Vendor the **26** working-vocabulary SVG glyphs listed in [data-model.md](./data-model.md#3-icon-inventory) into `assets/icons/` at stroke 1.75 with round caps and joins, and **only** those — the full source set would add weight for glyphs no screen will draw. Assert the asset count in the `PcIcon` test so an extra glyph cannot drift in unnoticed (FR-026a, research R3)
- [X] T043 [P] [US4] Implement `PcButton` in `lib/core/widgets/core/pc_button.dart` — 4 variants, 2 sizes, press/disabled/loading states. Assert in debug that a `danger` variant is never mounted inside `ThumbBand` (FR-024)
- [X] T044 [P] [US4] Implement `PcIconButton` in `lib/core/widgets/core/pc_icon_button.dart` with `semanticsLabel` as a **required** parameter — an unlabelled icon button must not be constructible (Principle XI)
- [X] T045 [P] [US4] Implement `PcChip` in `lib/core/widgets/core/pc_chip.dart`, where selection is a mint ring plus tick rather than a fill swap — the same lock mark the viewfinder uses
- [X] T046 [P] [US4] Implement `PcBadge` in `lib/core/widgets/core/pc_badge.dart` — mono, uppercase, readout tracking, with every non-neutral kind carrying a dot or glyph beside its colour
- [X] T047 [P] [US4] Implement `PcSheet` in `lib/core/widgets/core/pc_sheet.dart` — top corners only at radius 24, 20 padding, sheet shadow, and **opaque**: a sheet over a solid background is never glass (FR-011)
- [X] T048 [P] [US4] Implement `PcSlider` in `lib/core/widgets/core/pc_slider.dart` with an optional mono readout while dragging and a thumb hit area of at least 44 even though the painted thumb is smaller. `semanticsLabel` is **required** even though the visible `label` is optional — the design uses unlabelled sliders inside sheets, which is precisely why the accessible name cannot also be optional (Principle XI)
- [X] T049 [P] [US4] Implement `Readout` in `lib/core/widgets/camera/readout.dart` — mono, uppercase, readout tracking, taking pre-formatted text. Prose must never pass through it (FR-013)
- [X] T050 [US4] Implement `ShutterButton` in `lib/core/widgets/camera/shutter_button.dart` — 80px disc in a 104px hit target, nothing tappable within 12px, press scale .90, and the ring acting as a **status light** that turns mint the instant the contour locks, so confirmation happens under the user's thumb. `semanticsLabel` is a **required** parameter: the button renders no text, and Principle XI forbids an unnamed icon-only control — this is the most-pressed control in the product
- [X] T051 [P] [US4] Implement `ModeToggle` in `lib/core/widgets/camera/mode_toggle.dart` — 220ms slide on the snap curve, glass since it sits over the feed, each half at least 44
- [X] T052 [US4] Implement `CheckerSurface` in `lib/core/widgets/editor/checker_surface.dart` as a 16px tile of four 8px quadrants via `ImageShader` in `TileMode.repeated`, defaulting to the **light** variant and reserving **dark** for grid thumbnails. The values are the Photoshop/Figma figures and must not be adjusted (FR-022a)
- [X] T053 [P] [US4] Implement `BackgroundSwatchPicker` in `lib/core/widgets/editor/background_swatch_picker.dart` taking its swatch list as a parameter — the seven fixed backgrounds belong to Spec #005 and must not appear here (FR-022)
- [X] T054 [P] [US4] Implement `BatchThumb` in `lib/core/widgets/batch/batch_thumb.dart` with all 5 statuses, each pairing its colour with a mark — dimmed, trace ring, tick, scissors, retry. `review` is amber and must never read as failure (FR-018)
- [X] T055 [P] [US4] Implement `ProgressTrace` in `lib/core/widgets/batch/progress_trace.dart` as a traced ring — the contour line applied to time — holding a static arc under reduced motion
- [X] T056 [P] [US4] Implement `EdgeNotice` in `lib/core/widgets/feedback/edge_notice.dart` in amber with the **`scissors`** glyph and two exits. No red, no triangle, no exclamation mark — the target users are not technical and a warning would read as "your photo failed" when the photo is fine (FR-018)
- [X] T057 [P] [US4] Implement `PcToast` in `lib/core/widgets/feedback/pc_toast.dart` — one line, at most one action, glass, entering with the fade-up motion
- [X] T058 [P] [US4] Implement `ScreenHeader` in `lib/core/widgets/shell/screen_header.dart` fixed at 56px with a 16 gutter, not growing with text scale
- [X] T059 [US4] Implement `ThumbBand` in `lib/core/widgets/shell/thumb_band.dart` fixed at 132px, holding primary actions only and **refusing destructive ones** via a debug assertion rather than rendering them (FR-024)
- [X] T060 [US4] Write per-component tests under `test/core/widgets/` asserting rendered hit areas against the 44/56/80-in-104 minimums, plus the debug assertions (danger-in-band) and an accessible-name test covering all three text-free controls — `PcIconButton`, `ShutterButton`, `PcSlider` — confirming each exposes its `semanticsLabel` and none can be constructed without one (Principle XI)
- [X] T060a [US4] Prove SC-009: assemble one scratch screen at `lib/dev/kit_proof_page.dart` using only the shared kit, and confirm no colour, text size, spacing value, radius or duration is authored anywhere in it — `./scripts/check_no_hardcode.sh` must pass with the file present. Delete it once recorded in the PR; it is proof, not a deliverable, and `lib/dev/` is imported only by the development entry point
- [X] T061 [US4] Write the 55 remaining golden cases across the 18 components — the full breakdown is in [contracts/component-api.md](./contracts/component-api.md), totalling 67 with `ContourOverlay`'s 12 from T039

**Checkpoint**: A screen can be assembled from the kit alone. Specs #004–#008 are unblocked.

---

## Phase 7: User Story 5 — Drift is caught before it merges (P2)

**Goal**: Prove the guard rails put in place during Setup actually bite, rather than assuming they do.

**Independent test**: Deliberately introduce a hardcoded colour and a small spacing change; both are rejected automatically with the offending location named.

**Depends on**: all prior phases — there is nothing to protect until there is something to break.

- [X] T062 [US5] Verify the tightened gate rejects a hardcoded colour added to a feature file, and — the case that matters — **also** rejects one added to `lib/core/theme/pc_theme.dart`, which the pre-tightening script would have passed. Revert both afterwards (SC-010, research R14)
- [X] T063 [US5] Verify the golden gate bites: nudge the padding in `lib/core/widgets/core/pc_button.dart` by 2px, confirm `flutter test --tags golden` fails and shows what changed, then revert
- [ ] T064 [US5] Verify the refresh path: make an intended visual change, regenerate baselines through the `update-goldens` CI job, and confirm the diff reads as a reviewable before-and-after (FR-030)
- [X] T065 [US5] Verify FR-006 and SC-002 by changing one token of each kind in `lib/core/theme/tokens/` — `mint500` in `pc_colors.dart`, `sp6` in `pc_spacing.dart`, `durBase` in `pc_motion.dart` — then hot-restarting and confirming every affected surface moves together with nothing left behind. Anything that fails to move is a literal the gate did not catch

**Checkpoint**: The design system is enforced, not merely documented.

---

## Phase 8: Polish & Cross-Cutting

- [ ] T066 Run the full quickstart in [quickstart.md](./quickstart.md) and record results for SC-001 through SC-012, on a real device for SC-004, SC-008, SC-012 and the reduced-motion check
- [X] T067 Verify layout at 1.3× system text across the seven pages under `lib/features/*/presentation/` and a kit-built screen: text stops growing at the cap, no label clips or overlaps, and the header and thumb band still measure 56 and 132 (SC-012)
- [X] T067a Verify the fixed bands survive the extremes of the supported device range: a **320dp-wide phone** (the narrowest the Android API 24 floor admits) and a **tablet in portrait**. The 56 header plus the 132 thumb band claim 188dp of fixed height regardless of screen, and Spec #001 locked portrait with tablets sharing the phone layout — so confirm the content area stays usable at the small end and that components do not stretch into shapes the design never anticipated at the large end. Capture `ScreenHeader` and `ThumbBand` goldens at 320dp width (spec Edge Cases)
- [ ] T068 Measure the installed app-size delta against the Spec #001 baseline **per platform**, using release builds of the `development` flavor, and record it with the six per-file font sizes in the PR (FR-014). The Android half needs an Android SDK that is not installed yet — second spec in a row to need it, and it becomes blocking at Spec #002 (SC-008, research R15)
- [X] T069 [P] Walk [contracts/token-catalogue.md](./contracts/token-catalogue.md) by hand against the nine CSS files and confirm 196 properties accounted for with zero unexplained, then record the audit result in the PR (FR-003, SC-001)
- [ ] T070 [P] Confirm SC-011 by walking the seven pages under `lib/features/*/presentation/`: appearance changed, capability did not. Still no camera, no cutout, no export, no new screen
- [ ] T070a [P] On the same walkthrough of `lib/features/*/presentation/` plus the kit-proof screen from T060a, verify the three design laws that have no automated gate: at most **two** distinct background values per screen (FR-009); mint spent only on machine feedback and a single primary action, amber never signalling failure, coral only for genuine failure (FR-010); and no bounce, spring, parallax or decorative motion anywhere (FR-027). Record a pass/fail per law in the PR — these are the rules most likely to erode across Specs #004–#008, and review is the only thing watching them
- [X] T071 [P] Update `.claude/project-context.md` (Current Focus), `.claude/sdd-roadmap.md` (#001b status), and add a `.claude/changelog.md` entry per the Per-Spec Hygiene list in `.claude/dev-workflow.md`
- [X] T072 Fix the stale design-bundle path in `.claude/dev-workflow.md` — it directs implementers to `_ds/…/ui_kits/productcam-app/`, which does not exist on disk. Record the same defect against Constitution Principle VIII in `.claude/decisions/`, since correcting the constitution needs an amendment rather than an edit
- [X] T073 Record any UI divergence from the design bundle in `.claude/decisions/`, so design and code never drift apart silently (dev-workflow Design Fidelity Check)

---

## Dependencies

```
Phase 1 Setup (T001–T005)
        │
        ▼
Phase 2 Foundational — token layer (T006–T014)   ⚠️ blocks everything
        │
        ▼
Phase 3 US1 — appearance (T015–T027)   ← the load-bearing story
        │
        ├──────────────────────┐
        ▼                      ▼
Phase 4 US2 — fonts      Phase 5 US3 — contour
   (T028–T033)              (T034–T040)
        │                      │
        └───────────┬──────────┘
                    ▼
        Phase 6 US4 — the kit (T041–T061)
                    │
                    ▼
        Phase 7 US5 — enforcement (T062–T065)
                    │
                    ▼
        Phase 8 Polish (T066–T073)
```

**Note on story independence**: US1 is not independent of the others in the usual sense — it is what they are all built on. US2 and US3 are genuinely parallel with each other once US1 lands. US4 needs both. US5 needs everything, because a gate has nothing to catch until there is something to break. This is honest rather than ideal; a design-system spec is layered by nature.

## Parallel Opportunities

| Where | Tasks | Note |
|---|---|---|
| Phase 2 | T006, T007, T008, T009 | Four independent token files. T010 follows (needs the `em` conversion decided), T011 gates T012 and T013 |
| Phase 3 | T015–T020 | Six extensions, one file each. T021 is separate only because typography is the largest |
| Phases 4 & 5 | T028–T033 ∥ T034–T038 | Fonts and contour touch nothing in common — **except T039**, whose goldens need T031's font loading and must therefore follow it |
| Phase 6 | T043–T049, T051, T053–T058 | Fourteen components in parallel; T060a and T061 need all of them. T041/T042 come first (every component draws icons); T050, T052, T059 are called out separately because their rules are load-bearing |
| Phase 8 | T069, T070, T071 | Documentation and audit, independent of each other |

## Implementation Strategy

**MVP scope**: Phases 1–3 (T001–T027). That delivers the whole point of the spec — one definition layer, enforced, with the app visibly wearing ProductCam's appearance. Everything after is coverage and reach.

**Incremental delivery**:

1. **Phases 1–3** — the app is ProductCam-coloured and type-correct in the platform font. Demonstrable, reviewable, and already blocks the failure mode this spec exists to prevent.
2. **Phase 4** — real typefaces, offline. The identity is complete.
3. **Phase 5** — the signature element, proven against the four backgrounds that break a single-stroke line.
4. **Phase 6** — the kit. This is the phase that unblocks Specs #004–#008.
5. **Phases 7–8** — prove the gates bite, measure the size, update the project docs.

**Do not merge before Phase 6.** Merging earlier would let a UI spec start against a half-built kit, which is precisely the situation — every screen inventing its own styles — that made this spec a hard prerequisite in the first place.
