# Contract: Route Table

**Feature**: 001-project-foundation
**Mechanism**: `go_router` 17.5.0, declarative table built in the composition root

## Routes

| Path | Area | Registered in | Reachable by the user in production |
|---|---|---|---|
| `/` | Camera capture | both flavors | **Yes — launch screen** |
| `/settings` | Settings | both flavors | Yes, from camera |
| `/history` | History | both flavors | Yes, from camera |
| `/review` | Review | both flavors | No — needs capture (Spec #004) |
| `/editor` | Background editor | both flavors | No — needs Spec #005 |
| `/batch` | Batch session | both flavors | No — needs Spec #006 |
| `/export` | Export | both flavors | No — needs Spec #007 |
| `/dev` | **Navigation index** | **development only** | **Never — absent from production** |

## Rules

1. **`/` is the launch route.** No onboarding, no permission gate, no splash decision precedes it (FR-021).
2. **`/dev` is registered by the development entry point only.** Production does not conditionally hide it — production never references it. Absence is structural, not a runtime check (FR-018, FR-022).
3. **All seven area routes exist in both flavors.** What differs is only whether a manual path to them exists. This keeps production's route table honest: as Specs #004–#007 land, each area gains a real entry point and drops off `/dev`.
4. **Every route is exitable.** Back from any area returns to where it was entered from, with no dead ends (FR-022).
5. **Deep links are not configured.** Nothing outside the app addresses these routes in v1; adding that later is additive.
6. **No route-level permission guard.** Permission is requested when the user does the thing that needs it, not when a route opens (FR-023, Principle VI). Entering `/` must never trigger a prompt by itself.

## Development navigation index (`/dev`)

Lists all seven areas by their **localized** display names (FR-012 applies to it as well) and navigates to each.

It is scaffolding with a defined end: an area leaves the list once the spec that gives it a real entry point lands. When the list is empty, `/dev` and `lib/dev/` are deleted.

## Verification

- Development build: `/dev` reaches all seven areas, and each returns cleanly.
- Production build: `/dev` does not exist; only `/`, `/settings`, `/history` are reachable by hand.
- Widget test asserts the production route table contains **no** `/dev` entry.
