# Feature Specification: Design System & Theme

**Feature Branch**: `001b-design-system-theme`

**Created**: 2026-08-14

**Status**: Draft

**Input**: User description: "Specify Spec 001b — Design System & Theme. Port the ProductCam design system into the Flutter codebase so that every later UI spec (004 onward) consumes tokens and shared widgets instead of authoring its own styles. This spec must merge before any UI spec. It ships no product feature and no new screen — the 7 placeholder pages from Spec 001 stay placeholders."

## Overview

ProductCam's competitive advantage is not the background-removal engine — anyone can license one. It is that the app looks and behaves like a **measuring instrument**: a dark viewfinder shell that recedes so the product dominates, a mint contour traced over the live subject before the shutter is pressed, and machine facts set in uppercase mono like a readout on a device. The design bundle in `.claude/design/` already solved that problem. Nothing of it exists in the codebase yet.

This spec moves the design system from a bundle of stylesheets into the product. Like Spec #001, it ships **no product capability** — no camera, no cutouts, no export, no new screen. The seven placeholder areas stay placeholders. What changes is that they stop wearing Flutter's stock appearance and start wearing ProductCam's.

Its audience is split, and both halves matter:

- **End users** get the visual identity itself: a shell whose surfaces, type, contrast, and touch sizes are the ones the design was tested against, with Vietnamese and English text rendered in the product's own typefaces, entirely offline.
- **The development team** gets the enabling condition for every screen spec from #004 onward. Once one definition layer exists and is enforced, a later screen cannot invent its own blue, its own 13px padding, or its own single-stroke contour. Without this spec, each of the six remaining UI specs would author its own styles and the visual system would be gone by the time the app is feature-complete — recoverable only by rewriting all of them.

That is why this spec is a hard prerequisite: it must land before Spec #004, and it is cheap now and expensive later.

## Clarifications

### Session 2026-08-14

- Q: Should the shared components read display text themselves, or receive it? → A: Receive it. Components take display strings as parameters and never reach into the translation catalogue, so they stay reusable across screens and testable without a localization context.
- Q: Does this spec build the contour against the live camera? → A: No. It builds the contour renderer and its three states against a fixed, supplied outline. Connecting it to the camera stream belongs to Spec #003.
- Q: Do components that later screens will fill with fixed content (background swatches, batch tiles) carry that content now? → A: No. They render whatever they are handed. The seven fixed backgrounds belong to Spec #005 and the batch states to Spec #006; building those lists here would be implementing two unwritten specs.
- Q: How are icons delivered — a pre-rendered icon set, or the original vector glyphs bundled with the app? → A: Original vector glyphs, bundled. A pre-rendered set bakes in a stroke weight that cannot match the documented one, and every reference image would then lock that mismatch in as the standard. Only the icons named in the design's working vocabulary are bundled, not the full source set.
- Q: Which typeface weights are embedded — all eight the design names, or only those a type role actually references? → A: Only those referenced — six in total. An audit of the ten composed type roles found all five prose weights in use but only one of the three mono weights; the other two mono weights would be dead payload in every install, and adding a weight back later is trivial.
- Q: How far can the user enlarge system text before the product stops guaranteeing the layout holds? → A: Up to 1.3×. Below that, every label must stay readable, uncut, and unoverlapped; above it, text stops growing and holds at 1.3×. Honouring the operating system's full range would require the fixed header and bottom action bands to stretch, which is precisely what keeps the shutter reachable one-handed.
- Q: When does the transparency checkerboard use its light variant and when its dark one? → A: Light is the default wherever a cutout is previewed at size; dark is reserved for thumbnails in a grid, where a small white patch against the ink shell glares. The light values are the ones sellers already know from other tools, and the design explicitly forbids redesigning this convention.
- Q: With the device set to reduce motion, does the contour stop its running dash loop? → A: Yes — all looping and pulsing stops, and each state holds its static shape. Nothing is lost, because the three states are already told apart by dash pattern alone; this both respects the accessibility setting and saves battery for someone shooting forty items in a row.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The app wears its own appearance (Priority: P1)

Someone opens ProductCam and the app no longer looks like a default framework app. Every surface is the cool ink-navy of the viewfinder shell, headings and body text are set in the product's own typeface, controls are the documented sizes, and nothing is the stock purple-blue of an unstyled build. The app is dark on every screen and on every device, and never flips to a light appearance because the phone is set to light mode.

**Why this priority**: This is the deliverable. Every other story in this spec either supplies it (fonts, definitions) or protects it (components, gates). It is also the only story a non-technical reviewer can assess by opening the app.

**Independent Test**: Install the build, walk all seven areas with the phone set to light mode and then to dark mode, and confirm the appearance is identical, dark, and matches the design bundle's colour and type specimens.

**Acceptance Scenarios**:

1. **Given** a freshly installed build, **When** the user opens any of the seven areas, **Then** every surface, text colour, and control uses the ProductCam palette, and no stock framework colour is visible anywhere.
2. **Given** the device is set to light appearance, **When** the app launches, **Then** the app is still dark, with no light surface anywhere except the transparency checkerboard.
3. **Given** any screen, **When** a reviewer counts the distinct background values on it, **Then** there are at most two.
4. **Given** any screen, **When** a reviewer looks for the mint signal colour, **Then** it appears only on machine feedback or on that screen's single primary action — never as decoration and never on two competing actions.

---

### User Story 2 - Vietnamese and English read correctly, with no network (Priority: P1)

A seller in Vietnam opens the app on a phone in airplane mode, on the day they install it. Every Vietnamese character renders correctly — every diacritic, every stacked mark — in the product's typeface, not in a substituted system font. Someone on an English phone gets the same treatment. The app never waits on, and never makes, a network request to display text.

**Why this priority**: Vietnamese is the primary market and the language with the most demanding diacritics; a font that silently falls back mangles the product's identity on its most important audience. It is also a constitutional hard line — the product is offline-only, so a typeface fetched over the network is not an option, and the design bundle currently loads its fonts from a public web service.

**Independent Test**: Put the device in airplane mode before first launch, open the app in Vietnamese and then in English, and confirm correct rendering of a diacritic-heavy reference string plus zero network activity.

**Acceptance Scenarios**:

1. **Given** the device has never had network access, **When** the app launches for the first time, **Then** all text renders in the product's typefaces with no substitution and no delay.
2. **Given** the Vietnamese locale, **When** a reference string covering the full Vietnamese diacritic set is displayed, **Then** every character renders correctly with no missing-glyph marks.
3. **Given** any screen, **When** a machine fact is displayed (a count, a dimension, a file size, a duration), **Then** it is set in the mono typeface, uppercase, with the documented letter spacing.
4. **Given** any screen, **When** prose is displayed, **Then** it is never set in the mono typeface, and no readout is set in the prose typeface.

---

### User Story 3 - The signature contour survives any background (Priority: P1)

The contour is the thing that proves the product works. It is drawn over whatever the camera happens to see — white studio paper, warm cardboard, black leather, a backlit window — and it stays readable against all of them, because it is always drawn as a dark halo with a bright core on top, never as a single line. Its state is legible without relying on colour: still searching, locked and ready, or flagged as a complex edge.

**Why this priority**: It is the product's signature element and the one component with a documented failure mode — a single-stroke contour disappears against either a white or a dark scene, which is exactly the range a product photographer works across. Getting it wrong makes the app's core promise invisible in real use.

**Independent Test**: Render the contour over each of the four reference backgrounds in each of its three states and confirm both that the line is visible in all twelve combinations and that a reviewer can name the state from a still, greyscale image.

**Acceptance Scenarios**:

1. **Given** any of the four reference backgrounds, **When** the contour is drawn in any state, **Then** both the dark halo and the bright core are visible and the line does not disappear into the background.
2. **Given** a greyscale or colour-blind-simulated rendering, **When** a reviewer is shown the three states, **Then** they can tell them apart from the line's dash pattern alone, without needing the hue.
3. **Given** the searching state, **When** the contour is displayed, **Then** it shows the documented marching dash pattern; **Given** the locked state, **Then** it is solid, brighter, and glows; **Given** the complex-edge state, **Then** it is dotted and amber.
4. **Given** the complex-edge state, **When** a reviewer inspects it, **Then** nothing about it reads as failure — no red, no warning triangle, no exclamation mark.

---

### User Story 4 - Later screens assemble instead of inventing (Priority: P2)

A developer starting any screen spec from #004 onward finds every repeated element of the product already built: buttons, the shutter, the mode toggle, readouts, sheets, chips, badges, the checkerboard surface, thumbnails, progress, the complex-edge notice, toasts, the header, and the bottom action band. They compose a screen out of these instead of styling one from scratch, and the pieces already carry the documented sizes and states.

**Why this priority**: This is what makes the design system durable rather than a one-time paint job. It is P2 rather than P1 because the visual identity is already delivered by Stories 1–3; this story determines whether it survives six more specs.

**Independent Test**: Assemble a scratch screen using only the shared kit and confirm it can be built without writing a single visual value, and that it matches the corresponding design bundle screen.

**Acceptance Scenarios**:

1. **Given** the shared kit, **When** a developer builds a screen from it, **Then** they never need to author a colour, a text size, a spacing value, a corner radius, or an animation duration.
2. **Given** any interactive component, **When** its touch area is measured, **Then** it is at least the documented minimum, and the shutter is the documented visible size inside its larger hit area.
3. **Given** the bottom action band, **When** a reviewer inspects what it contains, **Then** it holds primary actions only and never a destructive one.
4. **Given** any component that shows an icon, **When** its source is traced, **Then** it goes through the single icon entry point, and no emoji or substitute character appears anywhere in the product.
5. **Given** a component that later specs will fill with content, **When** it is used here, **Then** it renders content supplied to it and carries no screen-specific data of its own.

---

### User Story 5 - Drift is caught before it merges (Priority: P2)

A change that quietly alters the product's appearance — a one-off colour typed into a screen, a padding nudged by three pixels, a component whose spacing shifted — fails automatically before it can reach the main line. Nobody has to notice it by eye in review.

**Why this priority**: Enforcement is what separates a design system from a style guide nobody follows. It is P2 because the system works on day one without it; it is what keeps it working on day ninety.

**Independent Test**: Deliberately introduce a hardcoded colour in a screen and a small spacing change in a component, and confirm both are rejected automatically.

**Acceptance Scenarios**:

1. **Given** a change that hardcodes a colour or a display string outside the permitted definition layer, **When** the pre-merge checks run, **Then** they fail and name the offending location.
2. **Given** an unintended visual change to any shared component, **When** the pre-merge checks run, **Then** they fail and show what changed.
3. **Given** an intended visual change to a component, **When** the reference images are refreshed as part of the same change, **Then** the checks pass and the change is visible in review as a before-and-after.
4. **Given** the definition layer, **When** a reviewer changes one value in it, **Then** every place in the app that used that value moves together, and no place is left behind.

---

### Edge Cases

- **The user has enlarged system text.** Fixed bands (the 56px header, the 132px bottom action band) do not grow with text. Up to 1.3× enlargement every label must stay readable, uncut, and unoverlapped; beyond 1.3× text stops growing and holds there, so the bands stay fixed and the shutter stays where the thumb expects it.
- **The device is unusually small or unusually large.** On the narrowest supported phone, the fixed bands plus the gutter must still leave a usable content area. On a tablet in portrait, the same layout is used (Spec #001 locked portrait and ruled out tablet-specific layouts) — components must not stretch into shapes the design never anticipated.
- **The system asks for reduced motion.** All looping and pulsing stops, including the contour's marching loop, and each state holds its static shape. The three states stay distinguishable because dash pattern alone already separates them; no state may collapse into another.
- **The contour has nothing to draw.** When no outline is supplied, or the supplied outline is degenerate, the renderer must draw nothing rather than a stray mark, and must not fail.
- **A character has no glyph in the product typeface.** The fallback behaviour must be defined and must never show a missing-glyph box in normal Vietnamese or English text.
- **The transparency checkerboard sits on a dark screen.** The light variant is used wherever a cutout is previewed at size, keeping the convention sellers already recognise from other tools. The dark variant is used only for thumbnails in a grid, where a small white patch surrounded by the ink shell glares. No context may leave the choice unstated.
- **A value in the design bundle has no direct equivalent in the product's rendering layer.** Several do — the checkerboard pattern, the glow filters, the background blur, and the composed type shorthands. Each must be reproduced by equivalent means, and the substitution recorded, not silently dropped.

## Requirements *(mandatory)*

### Functional Requirements

**Definition layer**

- **FR-001**: The product MUST carry exactly one definition layer for visual values, covering colour, typography, spacing, corner radius, elevation and glow, motion, and the contour and checkerboard treatment.
- **FR-002**: The definition layer MUST be the only place in the entire product where a raw visual value is written. Every other location MUST reference a definition by name.
- **FR-003**: Every value present in the nine design-system source files MUST either appear in the definition layer, or be listed with a written reason for its absence. Silent omission is not permitted.
- **FR-004**: Values MUST be ported unchanged — not rounded, re-derived, or adjusted to taste.
- **FR-005**: Where a source value has no direct equivalent in the product's rendering layer, the product MUST reproduce it by equivalent means and record the substitution alongside the definition.
- **FR-006**: Changing a single definition MUST change every place in the product that uses it, with no location left behind.

**Appearance**

- **FR-007**: The app MUST present one dark appearance on every screen and every device, regardless of the device's light or dark setting. A light appearance and a runtime appearance switch are out of scope.
- **FR-008**: The seven placeholder areas MUST adopt the appearance without gaining any product capability, layout, or content.
- **FR-009**: No screen MUST show more than two distinct background values.
- **FR-010**: The mint signal colour MUST appear only on machine feedback and on a single primary action per screen. Amber MUST mean "worth a look" and MUST NEVER indicate failure. Coral MUST be reserved for genuine failure.
- **FR-011**: Depth MUST come from rims and glow; real shadows MUST appear only on layers floating over the camera feed or over content. Translucency and blur MUST be used only on controls sitting over the camera feed or a photo, never on an opaque screen.

**Typography**

- **FR-012**: The product's two typefaces MUST be embedded in the app and MUST cover the Vietnamese and Latin character sets. The product MUST NOT fetch a typeface over the network under any circumstance.
- **FR-013**: Machine facts MUST be set in the mono typeface, uppercase, at the documented letter spacing. Prose MUST NEVER be set in the mono typeface, and readouts MUST NEVER be set in the prose typeface.
- **FR-014**: The embedded typefaces MUST NOT increase the installed app size beyond the budget in SC-008, and the actual increase MUST be measured and recorded.
- **FR-015**: The product MUST embed exactly six weights — five of the prose typeface (regular, medium, semibold, bold, black) and one of the mono typeface (medium) — because those are the weights the composed type roles reference. Weights nothing references MUST NOT be embedded, and any weight added later MUST be justified by a type role that needs it.

- **FR-015a**: Text MUST honour the device's enlarged-text setting up to 1.3×, and MUST NOT grow beyond 1.3× however far the device setting goes. Within that range no label may clip, truncate unintentionally, or overlap another element, and the fixed bands MUST NOT grow.

**Contour**

- **FR-016**: The contour MUST always be drawn as two strokes — a dark halo beneath a brighter core. A single-stroke contour is forbidden.
- **FR-017**: The contour MUST support three states — searching, locked, and complex-edge — and MUST distinguish them by dash pattern and motion, not by colour alone.
- **FR-018**: The complex-edge state MUST read as a hint, never as an error: no red, no warning triangle, no exclamation mark.
- **FR-019**: The contour MUST be drawn against a supplied outline. It MUST NOT connect to the camera in this spec.

**Shared components**

- **FR-020**: The product MUST provide a shared set of components covering every repeated element of the design: the buttons and icon buttons, chips, badges, sheets, the icon entry point, sliders, toasts, the complex-edge notice, readouts, the shutter, the mode toggle, the contour renderer, the checkerboard surface, the background swatch picker, the batch thumbnail, the progress trace, the screen header, and the bottom action band.
- **FR-021**: Components MUST receive display text as input and MUST NOT read the translation catalogue themselves.
- **FR-022**: Components MUST NOT carry screen-specific content that belongs to a later spec; they render what they are handed.
- **FR-022a**: The transparency surface MUST default to the light checkerboard wherever a cutout is previewed at size, and MUST use the dark checkerboard only for thumbnails in a grid. Both variants MUST come from the definition layer, and neither may be redesigned.
- **FR-023**: Every interactive component MUST meet the documented touch minimum, and the shutter MUST present its documented visible size inside its larger hit area with the documented clearance around it.
- **FR-024**: The bottom action band MUST hold primary actions only and MUST NEVER hold a destructive action.
- **FR-025**: All icons MUST pass through a single entry point so the icon set can later be replaced by changing one location. Emoji and substitute characters standing in for icons are forbidden anywhere in the product.
- **FR-026**: Icons MUST be delivered as original vector glyphs bundled with the app, reproducing the documented stroke weight exactly rather than approximating it. Icons MUST be monochrome and MUST inherit the surrounding colour.
- **FR-026a**: Only the icons named in the design's working vocabulary MUST be bundled. The full source icon set MUST NOT be included, and an icon MUST NOT be added to the bundle until a screen needs it.
- **FR-027**: Motion MUST be feedback only, at the documented durations and easings. Bounce, spring, parallax, and decorative animation are forbidden. The only loop in the product is the contour's status trace.
- **FR-027a**: When the device requests reduced motion, all looping and pulsing MUST stop, including the contour's trace, and each affected state MUST hold its static appearance. The three contour states MUST remain distinguishable from dash pattern alone with motion suppressed.

**Enforcement**

- **FR-028**: Pre-merge checks MUST reject any hardcoded visual value or display string introduced outside the permitted layers, and MUST name the offending location.
- **FR-029**: Every shared component MUST have reference images covering each of its documented states, and an unintended change to any of them MUST fail pre-merge checks.
- **FR-030**: An intended visual change MUST be accepted when its reference images are refreshed in the same change, and MUST be reviewable as a before-and-after.

### Key Entities

- **Definition**: One named visual value — a colour, a text role, a spacing step, a radius, an elevation or glow, a duration or easing, or a contour treatment. Has a name, a value, and a traceable origin in the design bundle. Definitions are the only carriers of raw visual values in the product.
- **Definition group**: A named set of definitions of one kind, made available to every screen at once, so a screen asks for "the colours" rather than importing values individually.
- **Shared component**: A reusable piece of interface with documented states, documented touch behaviour, and no content of its own. Reads only from definition groups; receives text and data from whoever uses it.
- **Component state**: One documented appearance of a shared component — for example the contour's searching, locked, and complex-edge, or a batch thumbnail's queued, working, done, review, and error. Each state is what a reference image captures.
- **Reference image**: The approved appearance of one component in one state, used to detect unintended visual change.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of the values in the nine design-system source files are either present in the product or accompanied by a written reason for absence — zero silent drops, verified by a value-by-value audit.
- **SC-002**: Changing any one definition and rebuilding moves every affected surface in the app together; a reviewer testing three definitions of different kinds finds zero locations left behind.
- **SC-003**: The contour is visible in all twelve combinations of its three states against the four reference backgrounds, and a reviewer shown greyscale stills identifies the state correctly in 3 out of 3 cases without seeing the colour.
- **SC-004**: With the device in airplane mode from first launch, a reference string covering the complete Vietnamese diacritic set renders with zero substituted or missing glyphs, and the app issues zero network requests for text rendering.
- **SC-005**: All shared components render at 100% of their documented states, each captured as a reference image, and any unintended change to any of them fails pre-merge checks.
- **SC-006**: A reviewer can place each component's reference image beside its counterpart in the design bundle and confirm agreement on the fixed layout bands, touch sizes, corner radii, and stroke weights.
- **SC-007**: 100% of interactive components meet the documented touch minimum, and the shutter meets its documented visible size, hit area, and surrounding clearance.
- **SC-008**: Embedded typefaces increase the installed app size by no more than 1.5 MB against the Spec #001 baseline, with the actual figure measured and recorded.
- **SC-009**: A screen can be assembled entirely from the shared kit without authoring a single visual value, demonstrated once as proof.
- **SC-010**: A deliberately introduced hardcoded colour and a deliberately introduced spacing change are both rejected automatically, with the offending location named.
- **SC-011**: The seven placeholder areas gain appearance and gain no capability — the app still offers no camera, no cutout, no export, and no new screen.
- **SC-012**: At 1.3× enlarged system text, 100% of labels across the shared kit remain readable with zero unintended clipping, truncation, or overlap, and the fixed bands measure the same as at default text size.

## Assumptions

- **The design bundle is authoritative and complete for this spec.** The nine token source files on disk are the input. The bundle's own index refers to component, guideline, and screen-kit folders that are not present as readable sources — they are compiled into a single bundle file — so the readable visual references are the bundle's written rationale plus the two click-through prototype files. Planning must not send implementers to paths that do not exist.
- **The design bundle's copy is Vietnamese; the product ships two languages.** Component text arrives as input, so this spec neither adds nor translates copy. Vietnamese copy in the bundle is the source for the Vietnamese catalogue in later screen specs.
- **Reference images are generated on the pinned toolchain and committed.** The toolchain is already pinned exactly (Spec #001), and the typefaces are embedded rather than fetched, which is what makes rendering reproducible. Reference-image checks are expected to run only on that pinned toolchain; any environment that renders differently is out of scope rather than something to compensate for.
- **The seven placeholder areas are the proving ground.** They already exist and navigate correctly, so appearance can be demonstrated end-to-end without building any real screen.
- **Component states come from the design's documented states, not from later specs' needs.** Where a later spec will supply fixed content — the seven backgrounds in Spec #005, the batch states in Spec #006 — this spec builds the presentation and leaves the content to that spec.
- **The 1.5 MB type budget in SC-008 is a chosen ceiling, not a measurement.** It is set to catch a careless full-character-set embed. If the correct character coverage cannot fit within it, the budget is the thing to revisit, not the coverage.
- **The contour's four reference backgrounds are the ones the design names**: white studio paper, warm cardboard, black leather, and a backlit window. They are the test set because they are the range that breaks a single-stroke line.
- **This spec depends only on Spec #001**, which has merged. It does not depend on the platform channel contract, on either segmentation engine, or on the camera, and it can proceed in parallel with Specs #002, #002b, and #003.
- **Nothing here is user-configurable.** No appearance setting, no theme switch, no colour picker. Adding one later is a change to the ratified principles, not a follow-up task.
