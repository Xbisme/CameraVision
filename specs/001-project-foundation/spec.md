# Feature Specification: Project Foundation

**Feature Branch**: `001-project-foundation`

**Created**: 2026-08-14

**Status**: Draft

**Input**: User description: "Spec #001 — Project Foundation for ProductCam. Stand up a running Flutter skeleton that matches the ratified architecture, so every later spec only has to fill in features. When this spec is done, the app must build and run on both iOS and Android with 7 empty screens wired to navigation. No real camera yet."

## Overview

ProductCam is a real-time background-removal camera for product photos, aimed at online sellers and small shop owners. It runs entirely on the device, has no backend, no accounts, and works offline.

This is the foundation spec. It ships **no user-visible product capability** — no camera, no cutouts, no export. What it delivers is a shell that behaves correctly for the two things a user always experiences regardless of features (the app opens in their language, and it asks for permissions honestly) plus the structural guarantees every later spec depends on (a place for each feature to live, one way to report failure, two installable builds).

Its real audience is therefore split: end users get a navigable, correctly-localized shell, and the development team gets the scaffolding that makes specs #002–#009 additive rather than reorganizing.

## Clarifications

### Session 2026-08-14

- Q: How should the four flow-only areas (review, background editor, batch, export) be opened in this spec, given there is no capture action yet? → A: A navigation index listing all seven areas, present only in the development build; production exposes only what real flows reach.
- Q: Is the app locked to portrait, and do tablets get their own layout? → A: Portrait locked on every device, tablets included; tablets share the phone layout, with no tablet-specific layout in v1.
- Q: Can the user pick a language inside the app, or does language always follow the operating system? → A: System only. No in-app language setting, and therefore no stored language preference in this spec.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The app opens and every area is reachable (Priority: P1)

A person installs ProductCam and opens it. The app starts on the camera area — the one thing the product exists to do — and from there they can reach every other area of the app: the result of a shot, background and shadow, the shooting session, export, history, and settings. Each area is currently empty, but nothing dead-ends and nothing crashes.

**Why this priority**: If the shell does not launch and navigate, no other story in this spec can be demonstrated at all. It is also the only story that proves the seven-feature structure actually holds together rather than existing only as folders.

**Independent Test**: Install the development build, launch it, and visit all seven areas and back via the navigation index. Delivers a demonstrable, walkable app.

**Acceptance Scenarios**:

1. **Given** the app is freshly installed, **When** the user opens it, **Then** the camera area is shown first, without any setup or onboarding step.
2. **Given** the development build, **When** the user opens the navigation index and picks any of the other six areas, **Then** that area opens and can be exited back to where they came from.
3. **Given** the production build, **When** the user looks for the navigation index, **Then** it is not present anywhere in the app.
4. **Given** the user is in any area, **When** they leave and return to it, **Then** the app does not crash and does not lose its place in navigation.

---

### User Story 2 - The app speaks the user's language (Priority: P1)

A Vietnamese seller opens the app on a phone set to Vietnamese and sees Vietnamese. Someone on a phone set to English — or to Japanese, or to anything else — sees English. No screen ever shows a mix of the two, and no screen ever shows a raw internal label.

**Why this priority**: The product ships two languages from day one, and the Vietnamese market is the primary one. Retrofitting language support after screens exist means revisiting every screen, so it must be structurally impossible to add an untranslated screen from the very first commit.

**Independent Test**: Switch the device language between Vietnamese, English, and a third unrelated language, relaunching each time, and confirm the displayed language and the fallback behaviour.

**Acceptance Scenarios**:

1. **Given** the device language is Vietnamese, **When** the app launches, **Then** all visible text is Vietnamese.
2. **Given** the device language is English, **When** the app launches, **Then** all visible text is English.
3. **Given** the device language is neither Vietnamese nor English, **When** the app launches, **Then** all visible text is English.
4. **Given** any supported language, **When** the user walks through all seven areas, **Then** no placeholder, key name, or untranslated fragment is visible anywhere.

---

### User Story 3 - Permission requests are honest and never dead-end (Priority: P2)

The app never asks for anything at launch. When the user first does something that genuinely needs the camera, it asks then, and explains why in plain language. If the user says no, the app keeps working and tells them what they will not be able to do. If the user has previously refused permanently, the app explains the situation and offers a way to the system settings rather than silently failing or asking again pointlessly.

**Why this priority**: Permission handling is the single most common place a camera app loses a user in the first minute, and denial paths are the most common source of crashes. It ranks below the shell and language only because it cannot be demonstrated until there is a shell to demonstrate it in.

**Independent Test**: Install fresh, verify no permission dialog appears at launch, then trigger the camera area and exercise grant, deny, and permanent-deny paths.

**Acceptance Scenarios**:

1. **Given** a fresh install, **When** the app launches, **Then** no permission dialog is shown.
2. **Given** the user opens the camera area for the first time, **When** the app needs the camera, **Then** it requests camera access with a reason describing what the app actually does with it.
3. **Given** the user denies camera access, **When** they remain in the app, **Then** the app stays usable, states plainly what is unavailable, and offers a way to try again.
4. **Given** the user has permanently denied camera access, **When** they open the camera area, **Then** the app explains the situation and offers a route to the system settings instead of re-prompting.
5. **Given** any permission outcome, **When** the user continues using the app, **Then** the app never crashes.

---

### User Story 4 - Two builds of the app coexist on one device (Priority: P2)

A developer measuring performance keeps the last known-good build installed on a real low-end Android phone and installs the build under test next to it, telling them apart by name. Both are installable at the same time; neither replaces the other.

**Why this priority**: Every later spec that touches the real-time pipeline must be measured on real hardware against a reference build. Without side-by-side installs, each measurement costs an uninstall/reinstall cycle and loses the comparison. It is P2 because it serves the team rather than the end user.

**Independent Test**: Install both builds on the same physical Android device and confirm two distinct entries appear and both launch.

**Acceptance Scenarios**:

1. **Given** a physical device, **When** both the development and production builds are installed, **Then** two separate apps appear with distinguishable names.
2. **Given** both builds are installed, **When** either is launched, **Then** it runs independently of the other.
3. **Given** the development build, **When** it is built in its optimized (non-debug) form, **Then** it still runs and still identifies itself as the development build.
4. **Given** the production build, **When** it is inspected, **Then** it contains no development-only diagnostics or measurement surfaces — the navigation index from User Story 1 being the concrete case this spec verifies.

---

### User Story 5 - Failures are explained, never dumped (Priority: P3)

When something goes wrong — a permission refused, storage full, an image that cannot be read — the user sees a short sentence in their own language explaining what happened and what they can do. They never see an internal error code, a stack trace, or English technical text on a Vietnamese phone.

**Why this priority**: The target users are not technical, and the product's voice rules are explicit that imperfect output is described plainly and never dramatized. This is P3 because in this spec there are few real failures to trigger yet; the value is that the mechanism exists before the specs that generate real failures land.

**Independent Test**: Trigger each representable failure condition (or its test double) and confirm a localized, human sentence is produced for every one.

**Acceptance Scenarios**:

1. **Given** any failure the app can represent, **When** it reaches the user, **Then** it is shown as a localized sentence, not as a code or raw platform message.
2. **Given** the full catalogue of known failure conditions, **When** each is mapped for display, **Then** every one has text in both supported languages.
3. **Given** an unrecognized failure, **When** it reaches the user, **Then** it is still shown as a localized sentence rather than raw text.

---

### Edge Cases

- **Device language changes while the app is running**: the app must reflect the new language without requiring reinstallation, and must not display a half-translated screen.
- **A translation key exists in one language but not the other**: the missing side falls back to English rather than showing the key name or an empty space — and this fallback is a safety net, not an accepted state.
- **Permission granted, then revoked in system settings while the app is backgrounded**: on return, the app must detect the loss and behave as if denied, not crash or assume access.
- **The user reaches an area that has no content yet**: the area must still open, be exitable, and be recognizable as intentionally empty rather than broken.
- **Both builds installed and launched in quick succession**: neither may read or overwrite the other's data.
- **An unknown or unexpected failure surfaces**: it must still be reportable to the user in their language, with no path that leaks raw text to the screen.
- **Text length differs sharply between the two languages**: neither language may cause labels to be cut off or overflow in a way that hides meaning.
- **Device is rotated to landscape**: the app stays in portrait and does not re-lay-out, on phones and tablets alike.
- **App runs on a tablet-sized portrait screen**: screens fill the larger viewport without clipping, stranding content at the top, or assuming phone dimensions.

## Requirements *(mandatory)*

### Functional Requirements

**Structure and extensibility**

- **FR-001**: The codebase MUST be organized so that each of the seven product areas (camera capture, review, background editor, batch, export, history, settings) owns a self-contained slice with a clear separation between its domain concepts, its data access, and its presentation.
- **FR-002**: Each of the seven areas MUST exist in this spec with a minimal working presence — an empty screen plus the minimum state handling needed to prove the slice is wired end to end — so later specs add behaviour rather than restructure.
- **FR-003**: One area MUST NOT reach into another area's internals; anything shared MUST live in a common layer.
- **FR-004**: Dependencies MUST be supplied to each area from a single composition point, so any dependency can be replaced with a test double without modifying the consuming code.
- **FR-005**: A single, named boundary MUST exist for all future communication with platform-native code, holding the channel and method names and the data shapes defined by the platform channel contract v0.2.0. No native behaviour is implemented in this spec.

**Failure handling**

- **FR-006**: The system MUST define one closed set of failure conditions covering every code in the platform channel contract's error catalogue, plus: permission denied, permission permanently denied, storage full, export failed, and an unknown case that carries its cause.
- **FR-007**: Every failure condition MUST map to display text in both supported languages.
- **FR-008**: Raw platform messages, error codes, stack traces, and internal type names MUST NOT be displayed to the user under any circumstance.
- **FR-009**: Operations that can fail MUST report failure as a value the caller must handle, rather than as an unhandled error that reaches the user interface.

**Language**

- **FR-010**: The app MUST support English and Vietnamese, with English as the default and as the fallback for any unsupported device language.
- **FR-011**: A device set to Vietnamese MUST display Vietnamese.
- **FR-012**: No user-visible text may be embedded in screen code, including on the empty placeholder screens and including accessibility labels.
- **FR-013**: Adding a further language MUST require only adding a translation resource, with no change to any screen.
- **FR-032**: The displayed language MUST follow the operating system setting only. The app MUST NOT offer an in-app language setting and MUST NOT store a language preference, so nothing in this spec depends on persistent storage.
- **FR-014**: Neither language may have missing entries; a missing entry is a defect, and the English fallback exists only as a safety net.

**Builds**

- **FR-015**: Exactly two build flavors MUST exist: development and production. No third flavor.
- **FR-016**: The two flavors MUST be installable **side by side on the same device**, neither replacing the other.
- **FR-017**: Flavor-dependent values MUST be read from a single configuration point, and the choice of flavor MUST be independent of whether the build is optimized — an optimized development build MUST be possible, because performance measurement requires it.
- **FR-018**: The production flavor MUST NOT include development-only diagnostics or measurement surfaces.

**Platform reach**

- **FR-019**: The app MUST run on iOS 17.0 and later and on Android API level 24 and later, and MUST NOT be installable below those floors.
- **FR-020**: The app MUST identify itself as `com.productcam.app` in production and `com.productcam.app.dev` in development, and MUST display the names "ProductCam" and "ProductCam Dev" respectively — these distinct identities are what make FR-016's side-by-side installation possible and what lets a person tell the two apart without opening either.
- **FR-031**: The app MUST be locked to portrait orientation on every device, phones and tablets alike, and MUST NOT rotate when the device is turned. Tablets run the phone layout; no tablet-specific layout exists in v1. Screens MUST therefore be built to stretch to larger portrait viewports rather than to fixed phone dimensions.

**Navigation and permissions**

- **FR-021**: The camera area MUST be the first area shown on launch, with no onboarding or gate before it.
- **FR-022**: All seven areas MUST be reachable and exitable. Because four of them (review, background editor, batch, export) are only entered through a capture flow that does not exist yet, the **development build MUST provide a navigation index listing all seven areas**; the production build MUST NOT contain that index (see FR-018) and exposes only the areas real flows reach. The index is a temporary scaffold: each area drops off it as the spec that gives it a real entry point lands.
- **FR-023**: Permission for the camera and for the photo library MUST be requested only at the moment the user does something that needs it, never at launch and never bundled together.
- **FR-024**: Each permission request MUST state a reason that matches what the app actually does with that permission.
- **FR-025**: A denied permission MUST leave the rest of the app usable and MUST offer a way to retry.
- **FR-026**: A permanently denied permission MUST be explained and MUST offer a route to the system settings instead of re-prompting.
- **FR-027**: No permission outcome may cause a crash.

**Verification and hygiene**

- **FR-028**: The project MUST carry an automated check that fails the build on formatting drift, on any static-analysis warning, and on any failing test.
- **FR-029**: The project MUST exclude generated and machine-local artifacts from version control.
- **FR-030**: Automated tests MUST cover, at minimum, the mapping from every failure condition to its display text, and at least one end-to-end check that the app launches and renders.

### Key Entities

- **Product area**: One of the seven slices of the app (camera capture, review, background editor, batch, export, history, settings). Each owns its own concepts, data access, and screens, and is independently extendable.
- **Failure condition**: A named, closed-set description of something that went wrong, carrying enough context to be explained to the user in their language. Includes every condition the native segmentation contract can report, plus permission, storage, and export conditions, plus an unknown case.
- **Build flavor**: Development or production. Determines the app's identity, displayed name, and whether development-only diagnostics are present. Independent of build optimization.
- **Translation resource**: The set of display texts for one language. English is the source and the fallback; Vietnamese is the second shipped language.
- **Native boundary**: The single named place describing how the app will later talk to platform-native segmentation code. Defined here, unimplemented here.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A person can install the development build, open it, and reach all seven areas and return via the navigation index, with zero crashes across the full walk; the same walk on the production build finds no navigation index at all.
- **SC-002**: 100% of visible text is correct for the device language across all seven areas, in both Vietnamese and English, with zero untranslated or key-name fragments.
- **SC-003**: A device set to any language other than Vietnamese shows a fully English interface, with zero mixed-language screens.
- **SC-004**: 100% of the failure conditions defined in this spec produce a human-readable sentence in both languages; zero produce a code, raw platform message, or English text on a Vietnamese device.
- **SC-005**: Both build flavors install and run simultaneously on one physical device, and are distinguishable by name without opening either.
- **SC-006**: No permission prompt appears before the user takes an action that needs it; every denial path — including permanent denial — ends in a usable screen with a stated next step, in 100% of attempts.
- **SC-007**: Adding an eighth product area, or a third language, requires no change to any existing area's screens — verifiable by walking through the change without editing existing screen files.
- **SC-008**: The automated check fails when formatting drifts, when a static-analysis warning is introduced, or when a test fails — verified by deliberately introducing each of the three and observing the failure.
- **SC-009**: The app cold-starts to a rendered camera area in under 2 seconds on a mid-range Android device. The **exact device model and OS version used for the measurement MUST be recorded**, since "mid-range" is not yet defined project-wide — without a named device the figure cannot be compared against the next measurement.

## Assumptions

- **This spec ships no product capability.** The camera is not opened, no frames are captured, no background is removed, nothing is exported. The camera area's only behaviour here is the permission conversation.
- **The navigation index is scaffolding, not a feature.** It exists so the seven-area structure is walkable before capture exists, and it is confined to the development build so it can never ship. It is not a menu the product is expected to keep, and entries leave it as later specs give each area a real entry point.
- **The visual design is deliberately absent.** All screens stay bare. Colours, typography, spacing, and the shared component set arrive in Spec #001b, and inventing any interim visual language here would be discarded work and would violate the ratified no-hardcoded-style rule. The only visual decision made here is that the app is dark, which is already ratified.
- **No native segmentation code is written.** iOS and Android engines arrive in Specs #002b and #002. This spec only fixes the shape of the boundary, based on platform channel contract v0.2.0, which is still a draft pending the #000 freeze. If #000 changes the contract, this boundary is updated with it — that is expected and cheap, because nothing implements it yet.
- **The English texts are newly authored, not translated.** The design bundle's copy is Vietnamese and is the source for the Vietnamese resource; the English resource is written to match the product's voice (short declarative statements, no marketing adjectives, no exclamation marks) rather than machine-translated from Vietnamese.
- **Placeholder screens still obey the text rule.** Even a screen showing only its own name gets that name from the translation resource, because the rule is only enforceable if it has no exceptions from the first commit.
- **Photo library permission has no trigger yet** in this spec, since nothing saves images until Spec #007. Its handling is built and testable, but the user-facing trigger arrives later.
- **No persistent storage is set up.** History and its database arrive in Spec #007. Nothing in this spec needs to survive a restart — which is precisely why language follows the system rather than an in-app choice (FR-032). The design bundle's settings screen has no language row, so this matches the intended product, not just the current constraints. Should an in-app choice be wanted later, Spec #008 is the natural home, by which point storage exists.
- **A placeholder screen shows only its own localized area name**, nothing else — **with one deliberate exception: the camera area also carries entry points to settings and history.** Those two are the only non-camera areas reachable in production without a capture flow, so without those entry points they would be unreachable in the production build, contradicting FR-022. Everything else stays bare, which keeps the no-hardcoded-text rule verifiable from the first commit (even a screen with one word gets that word from the translation resource) and avoids inventing interim visuals that Spec #001b would discard.
- **Portrait-only is a v1 product decision, not a temporary shortcut.** The design bundle has a single portrait frame, and the 132px bottom action band exists for one-handed portrait use — that layout has no meaning rotated. Locking it here also spares Spec #003 from rotating the camera preview and the contour coordinate space for every orientation, which is the most bug-prone and most performance-sensitive work in the product. Tablets are supported in the sense that they install and run the portrait layout; a tablet-specific layout is not in v1.
- **Android API 24 and iOS 17.0** are ratified floors, decided in `.claude/decisions/001-app-identity-and-min-sdk.md` and `000-min-ios-version.md`. Whether the Android model chosen in Spec #002 can actually run acceptably at API 24–26 is an open question for that spec, not this one.
- **The 2-second cold-start target** is a reasonable starting expectation for a shell with no camera and no model loading, not a measured figure. It exists to catch gross regressions early; the binding real-time performance budgets belong to Spec #003.
- **Repository name differs from product name.** The GitHub repository is `CameraVision` while the product is ProductCam. This is intentional and recorded; the app's identity follows the product name.
