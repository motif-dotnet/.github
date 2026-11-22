# Motif Bubbles: design note

**Status:** next up, from a grilling on 2026-11-22. Nothing is built yet. A mockup with Motif Glossary's real numbers was agreed as the shape of the first version.

## The idea

A Motif app's architecture as a graph of bubbles, with its numbers drawn on it. Each bubble is an architectural object: the Domain, the User Tasks and User Queries, the Application, each driven port with its real adapter and its fake, and the specs. The links show which uses, implements or checks through which. A bubble's size, outline and ring show how big it is and how well its specs catch mistakes in it.

**Why it suits Motif.** Typing isn't the bottleneck any more; understanding and checking the work is. A Motif solution should scream its architecture, and this draws the architecture as built, with the evidence of checking on top. It's also the first, flat step towards the [System explorer](ideas.md#the-list), and its scanner is the start of [Sketch from code](ideas.md#the-list) and Architecture checks.

## Decisions so far

1. **The first version shows as much as the visuals can carry without noise.** Whether it should lead with risk (big, much-used, weakly checked bubbles) or general stats is decided after it has been used.
   - *Why:* you can only judge noise against real numbers. Each visual layer can be turned on and off, so you can see the trade-off for yourself.
2. **A bubble is an architectural object, not a project.** Domain, User Tasks (`ForDoing`), User Queries (`ForSeeing`), Application, each driven port, each real adapter, each fake, and one bubble each for Specs and BrowserSpecs. Specs links to the User Tasks and User Queries it checks through; BrowserSpecs links to the Web App.
   - *Turned down:* one bubble per project (the bubbles would just be the folder list); a bubble per spec class (most links would repeat "spec → User Task"). Seams and Fittings get no bubbles of their own yet.
3. **What it draws:**
   - **Columns** follow ports and adapters, left to right: browser checks, driving, User port, Application, driven ports, real adapters, fakes. **Each driven port has a row of its own**, ports sorted by name, so the same repo always looks the same. It pans and zooms when it gets tall.
   - **Area** is lines of code, not counting blank lines and comments.
   - **The mutation ring** around a bubble shows its Stryker mutants: caught, survived, or not reached by any spec. The score is printed inside. Code Stryker doesn't mutate is hatched.
   - **The outline** shows the kind of object: solid for real code, dashed for a fake, a plain outline for a port, and the accent colour for specs.
   - **Links** check through, use, implement, or wire up (the composition root, off by default).
   - **Hovering** a bubble picks out its neighbours and shows all its numbers.
   - *Turned down:* a force layout (bubbles move between loads, so two repos can't be compared). Taking the row order from the sketch file could come later.
4. **The app scans the code itself,** by Motif's conventions (`For…` interfaces, `Ports/`, adapter and fake projects), from a dropped folder or a public GitHub repo. The scanner lives in a Domain project with no package references, so the `dotnet motif` CLI ([#4](https://github.com/motif-dotnet/.github/issues/4)) can reuse it.
   - *Costs:* a repo that strays from the conventions is mapped badly, and the conventions are still moving.
   - *Turned down:* a generator that writes a stats file (an extra step, and the file goes stale); Roslyn (exact, but heavy in the browser).
5. **The mutation rings come from Stryker's JSON report, which CI publishes to the repo's GitHub Pages site. The report is never committed.** For now, the Pages workflow runs Stryker after the specs on every push. Later it moves to a nightly run.
   - *Why Pages:* a browser app can fetch from it. Actions artifacts need a token even for public repos, and release-asset downloads are blocked in the browser.
   - *Costs:* every push is about two minutes slower until the nightly run. The full report (about 1.2 MB for Glossary) is published, keeping which specs reach which mutant for later.
   - **Stale rings:** the report holds a copy of each file it mutated, so a bubble whose code has changed since the run shows a faded ring.
   - Libraries with no Pages site or Stryker (Motif.Is, Motif.Is.Core) show no rings in the first version. A dropped folder shows them once they have Stryker.
   - *Turned down:* committing the report (a large file in history, changing noisily); no rings for GitHub repos at all.
6. **One snapshot:** the code now and the latest report. Comparing two points ("what did the agent change?") is the strongest candidate for the next version. It needs a report kept for each commit.
7. **It's a Motif tool** in its own repo, `Motif.Bubbles`: Blazor WebAssembly on GitHub Pages, with the web kit, the tool switcher, specs, browser specs and Stryker, like Motif Glossary. Pointed at its own repo, it draws itself.
   - *Turned down:* a throwaway tool (the scanner is meant to be reused); a view in Motif Sketch (Sketch edits the design; this shows the code).
8. **Name:** *Motif Bubbles* (`Motif.Bubbles`), for now. **Motif Atlas** is kept for if it grows beyond bubbles, towards the System explorer or architecture checks.
   - *Turned down:* Motif Stats (generic); Motif Explorer (promises the 3D walk-through).

## Terms

- **Bubble:** one architectural object in the graph.
- **Mutation ring:** the ring around a bubble showing its Stryker mutants: caught, survived, or not reached by any spec.
- **Stale ring:** a mutation ring older than the bubble's code.
- **Check link:** a link from Specs or BrowserSpecs to what they check through.
