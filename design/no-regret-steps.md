# No-regret steps: design note

**Status:** a thought experiment, from a grilling on 2026-11-21. Nothing here is built, and none of it changes Motif's principles or rules yet.

## The idea

Some steps are so cheap and so plainly useful that it's hard to argue against them. Who wouldn't want a first draft of the context diagram, or fast specs for everything a user can do? These are **no-regret steps**, after the planning term for actions that pay off whatever the future turns out to be.

**Why.** Motif is opinionated, and its opinions mostly come as a set. But some of its steps stand on their own: useful to any team, whatever it thinks of the rest. Picking those out gives a way in that asks for no commitment: *"You don't have to agree with the ideas or the direction, but surely these are useful."* The rest of Motif's opinions can come later, or not at all.

## The test

A step is on the list only if it passes both tests.

1. **Cheap now, dearer later.** Doing it today costs little; skipping it costs more over time. It gets dearer for one of three reasons:
   - **Ratchets** are cheapest to fit while nothing breaks them.
   - **Knowledge fades.** The reasons for a decision, or what a word means, are free to write down while fresh and costly to piece together later.
   - **Other work builds on it.** Each Seam carries every spec, and each User Task gets a UI on top.
2. **It stands on its own merits.** A team can take it up without taking on anything else:
   - it pays back visibly within a week or two;
   - it takes hours, not days;
   - it stands alone, or needs only other steps on the list;
   - it can be dropped later at no cost;
   - it can be argued in plain terms, without Motif's philosophy.

The cost test stops the list being just "nice things". Standing on its own merits keeps the list short, and each step easy to take up.

**A rule that falls out: two users on day one.** An abstraction is earned on day one if it already has two implementations on day one. A Seam has a real Fitting and a fake one. The User port has the UI and the specs. A driven port with one deep adapter has only one, so it waits (see [Start without ports](ideas.md#the-list)).

## The list

One list for every kind of codebase. Each step has a new-app form and an existing-app form: done **now**, or **on touch**, meaning when you next change that area. The steps are described in plain words, each with Motif's term in brackets the first time it appears; the glossary and code keep Motif's terms.

### The core five

Described together, as one argument: a picture, the words, the things users do, and fast checks on all of them. Each makes the next cheaper.

| | In plain words | New app | Existing app |
|---|---|---|---|
| 1 | A picture of who and what the app deals with (the context diagram). | A first draft, on day one. | Now, recovered from the code. |
| 2 | The handful of words on that picture, each with one line saying what it means (the glossary). | Only the diagram's main terms: the system, actors, external systems and storage. Motif Sketch's Export glossary writes these. | Now. |
| 3 | One place listing what users can do and see, which the UI goes through (User Tasks and User Queries). | Day one. One interface or two is the team's choice. | On touch. |
| 4 | A thin wrapper around each outside thing, such as files, the network or the clock, so tests can fake it (a Seam, with a real and a fake Fitting). | Day one, including the clock, randomness and IDs. | On touch. |
| 5 | A fast check for everything users can do, run through that same place (specs). | Breadth first: one per User Task, on the happy path. Edge cases arrive with the work. | On touch, for the User Task being changed. |

- **Specs check through the User Queries,** the reads the UI uses, not through the fake Fittings. Checking at what got saved would tie every spec to how things are stored.
- **No driven ports in the first pass.** The User Tasks call Seams directly, so there are no port fakes, and the deep-adapter rule that removes them never needs explaining. Describing the steps never needs the word "port".
- **The glossary and the context diagram are nearly one step.** The User Task names are the other words the team will say every day, and may belong in the minimal glossary too.

### Then, one at a time, once the first five are in use

| | In plain words | New app | Existing app |
|---|---|---|---|
| 6 | A short note whenever something is decided on purpose (decision records). | From the first decision. | Now, from today. |
| 7 | CI runs the specs on every push, and keeps the build free of warnings. | CI fails on warnings. Local builds stay relaxed. | Now. Warnings as errors for new projects only: a shared `Directory.Build.props` turns it on, and each existing project opts out with one line. |
| 8 | A version in anything saved outside the repo, such as files and links. | When the app first saves something. | Now. A file with no version counts as version 0. |
| 9 | It works for real: the first User Task runs end to end in the real app, with a one-line manual check for each real Fitting. | Shipped however the team already ships. | Now: write down the checks the team already does in its head. |

- **Nullable** is already the default in new .NET project templates, so there's nothing to add.
- **Step 7 on an existing app** only bites when a team adds a project. Seams and specs added on touch usually go into existing projects, which still allow warnings, until someone clears a project's warnings and removes its opt-out.
- **Step 9 says nothing about how to deploy,** which keeps it clear of Motif's "hosting is out of scope". The core five already make most of a walking skeleton; only the real Fittings go unchecked by the specs, and this step covers them.

### For a library

The same list, filtered. Its public API is its User Tasks and Queries, and the specs go through it. It needs Seams only if it touches the outside world, which Motif.Is doesn't.

## Not on the list

Each of these fails one test or the other, which keeps the list sharp.

- **Don't stand on their own merits:**
  - **Architecture checks,** which only make sense once you believe in the layering.
  - **The `motif/` folder,** which commits a team to Motif. An agents file pointing at the diagram and glossary can come along with the glossary instead.
  - **Analyser rule sets, and `.editorconfig` beyond basic formatting,** which invite arguments about rules.
  - **Warnings as errors on every local build,** which gets in the way mid-change.
  - **Retrofitting User Tasks, Seams and specs across a whole existing app,** which is a rewrite. Hence "on touch".
- **Fail the cost test,** being either a guess about the future or a measure of work that doesn't exist yet: driven ports with one adapter, a rich domain model, simulated adapters, spec depth, generated plain-English specs, mutation testing, and glossary sections.

## Names

- **No-regret steps.** "Who wouldn't want…?" sums the steps up, but isn't the name. *Turned down:* essential (sounds required, and clashes with "optional to adopt"); easy yeses (loses "dearer later"); "who wouldn't want…?" as the name (awkward in a sentence); day-one kit (wrong for existing apps).
- **Step,** read as "a step, repeated each time you touch an area" for the on-touch ones. *Turned down:* move (sounds like a choice), practice (sounds like process, and so like a commitment).

## Open questions

- **Does it fit Motif?** Motif is opinionated by design, and this list is deliberately the part without the opinions. Maybe it's the way in to the rest, maybe something of its own.
- **It leans on Start without ports,** which hasn't been tried yet, while [adapters](adapters.md) rule 22 keeps ports from the start for now. The no-regret list could be the reason to try it on the next new app.
- **"Firm at the start, open after":** perhaps the firm part is simply this list. The principle stays as it is until the list has been tried with a real team.

## Terms

```markdown
## No-regret step

A step that is cheap now and dearer later, and that stands on its own merits,
without taking on anything else.

- **Kind:** domain concept
- **Avoid:** essential step (sounds required), best practice
```
