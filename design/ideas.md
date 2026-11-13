# Ideas

Possible tools and conventions for Motif.NET. Nothing here is built or promised. An idea moves to the profile's Tools table once it has a design note of its own in this folder.

Thoughts, or an idea of your own? Start a thread in [Discussions](https://github.com/motif-dotnet/.github/discussions/categories/ideas).

## Purpose

Typing is no longer the bottleneck; understanding and checking the work is. Motif keeps agent-assisted software understandable.

That's why the effort goes into the glossary, the sketch, specs and review rather than into writing code faster. Every principle and idea below is judged by it.

## Principles

These came out of discussing what the suite is for. Every idea should fit them.

- **Optional to adopt, gentle by default, opinionated in use.** No tool is required. Checks report rather than block, unless a team turns blocking on. When you do use a tool, it has firm views.
- **Small and simple.** Both the code a Motif plan produces and the Motif tools themselves stay small and easy to use. Fewer moving parts make agent-written code easier to understand and check.
- **Habitable.** A Motif solution screams its architecture (Robert C. Martin) and is comfortable to live in (Richard Gabriel's habitability). People and agents start at the top (sketch, glossary, `motif/`) and find detail only as they need it, and each layer reads at one level of abstraction.
- **Use what already works; Motif sets it up.** Where an existing tool solves the problem, use it. A Motif tool's job is then to set it up, configure it and take the friction out, often by producing files an agent implements from. The solution plan is the model: the app uses ordinary Visual Studio solutions and projects, but a Motif tool decides their shape and an agent builds them. Code style works the same way, through analysers and `.editorconfig` that the plan sets up. Motif builds something of its own only where nothing suitable exists.
- **Firm at the start, open after.** The opinions are firm for the solution stub: ports and adapters, the glossary, code style, spec-style checks and the `motif/` layout. How far, if at all, to enforce them during maintenance is still open.
- **Code may become the source of truth.** One lean is to start from the sketch, then let the code lead, with tools that regenerate pictures and documents from the code to show drift. Still feeling our way.

## Scope

Which kinds of .NET app the suite covers ([#9](https://github.com/motif-dotnet/.github/issues/9)).

- **Scope follows what gets built.** Any kind of .NET app is in scope in principle. Motif learns a kind (its project templates and adapters) the first time a real app needs it. With ports and adapters, the kind of app only changes the edges: the domain, use cases, fakes and specs look the same everywhere.
- **Motif is a reason to try new things.** Sketch is a web app partly to get away from the desktop, and because web apps are easy to share and demo. New kinds of app are welcome, but each one arrives with a tool that genuinely needs it.
- **The tool's fit wins.** Each tool gets the form that suits it. Exploring comes from choosing *which tool* to build next, and each tool's design note says why its app kind was chosen. For example, building agent review as an MCP server would be a reason to learn services and MCP.
- **Unproven kinds say so.** Proven so far: Blazor WebAssembly (Sketch itself). The planner also knows `wpf` and `console`, which no Motif solution has used yet. A plan that uses an unproven template says so and asks the agent to report what needed fixing.
- **Services are in scope.** A REST API (ASP.NET Core, `webapi`) is a driving adapter, like a UI. The planner doesn't know it yet; it gets added when a tool first needs it.
- **Hosting is out of scope for now.** Where an app runs (GitHub Pages, Azure, containers) is a label in the sketch, not something the plan sets up. Services will feel this first.
- **Apps that use AI models are in scope, with a firm opinion.** A model is an external system behind a driven port. The real adapter uses `Microsoft.Extensions.AI`, a fake adapter gives fixed answers so specs stay fast and deterministic, and the domain never references an AI package. This holds even when the app is mostly AI.

## The list

| Idea | One line | Notes |
|---|---|---|
| **Motif CLI** (`dotnet motif`) | `init` sets up the `motif/` folder and the `AGENTS.md` pointer; `check` runs the gentle checks below. | [#4](https://github.com/motif-dotnet/.github/issues/4) |
| **Glossary checks** | Flag **Avoid** words, terms still *proposed*, and sketch names with no entry. | Likely the CLI's first check. |
| **Glossary editor** | An app for browsing and editing `motif/glossary.md`. | Reads and writes the same file. Started as a read-only viewer, [Motif Glossary](https://github.com/motif-dotnet/Motif.Glossary) ([#10](https://github.com/motif-dotnet/.github/issues/10)). |
| **Glossary in context** | Glossary terms shown where you work: IDE hover text, and Sketch highlighting names that aren't in the glossary. | Stretch goal. |
| **Architecture checks** | Report when the domain references an adapter or framework, or when the ports in code don't match the sketch. | |
| **Sketch from code** | Regenerate the sketch from the solution and compare it with the committed one to show drift. | |
| **Code-style baseline** | The solution plan sets up analysers, `.editorconfig`, nullable and warnings as errors. | Part of Motif Sketch. [#8](https://github.com/motif-dotnet/.github/issues/8) |
| **Spec conventions** | How behaviour specs are named and laid out, in glossary terms, perhaps with a spec project the plan generates. | First step towards plain-English specs. One candidate: [spec names as propositions](#motifis-isly), tried in Motif.Is first. |
| **Agent review** | A review prompt or skill that checks a change against Motif's opinions (architecture, glossary, style) and gives advice only. | Could cover the spirit of the checks long before they're built. |
| **Decision records** | `motif/decisions/`: short notes on why the design is the way it is, so agents don't undo choices made on purpose. | |
| **Plain-English specs** | Readable, glossary-shaped specs generated from well-named automated specs, as a living document of what the app does. | Blue-sky. Code first: the specs are tests, and the English is generated from them. |
| **System explorer** | Walk the solution's graph in 3D (ports, adapters, projects and their links) rather than reading a flat diagram. | Blue-sky. Built on Sketch from code: the same graph, drawn to explore rather than to edit. |
| **Motif.Is** (Isly) | A proposition library for specs: `total.Is(12.50m)` states a fact, rather than saying what it *should* be. Each check keeps its subject, claim and expected value, so plain-English specs can be generated from them. | On trial in [Motif.Is](https://github.com/motif-dotnet/Motif.Is), specced in itself; AwesomeAssertions stays the default in solution plans meanwhile. See [Motif.Is](#motifis-isly) below. |

## Motif.Is (Isly)

It started as a half-joke: an assertion library written properly, not how it [should be](https://github.com/shouldly/shouldly), but how it is. Shouldly writes `result.ShouldBe(5)`; Isly writes `result.Is(5)`.

Under the joke there's a real point. An assertion isn't a wish; it's a proposition, a claim about the app that is either true or false, and a failing check reports that the claim is false. That's the testing-versus-checking distinction: a check is a machine-decidable proposition, and the specs Motif sets up are spec-style checks. The working name inside the suite is **Motif.Is**, with Isly kept as the origin story.

**Credits.** The checking vocabulary comes from James Bach and Michael Bolton, in [Testing and Checking Refined](https://www.satisfice.com/blog/archives/856) (2013). Kevlin Henney pointed out how weak "should" is: test names should "reflect outcome not aspiration" ([2013](https://twitter.com/KevlinHenney/status/350242801868484608)), and since all code is a hypothesis, "should" is a truism and noise ([2016](https://x.com/KevlinHenney/status/703233830337925120)). His talks on good unit tests treat tests as propositions. He was talking about test names; Motif.Is takes the same point to the claims inside them.

**Spec names as propositions.** Also from Henney ([Structure and Interpretation of Test Cases](https://www.slideshare.net/Kevlin/structure-and-interpretation-of-test-cases)): a good spec name is long, so use all of it. Namespace, class and method together read as one proposition, and specs that share a namespace or class are grouped by the start of the sentence they share. Test runners already show specs as that tree. Motif.Is tries this first; if it works, it could become one of Motif's spec conventions.

**Why build it, when Shouldly works.** On its own, preferring *is* to *should* doesn't meet the "use what already works" bar. Plain-English specs is the reason:

- **Better sentences.** "The order total is 12.50" reads as a fact; "the order total should be 12.50" reads as a hope. If the living document is generated from the specs, propositions make it read properly.
- **Structure that's kept.** Shouldly turns an assertion into a failure message and throws the structure away. Motif.Is would keep each check as a proposition (subject, claim, expected and actual values) that a generator can read without parsing C#.
- **Glossary terms.** Subjects can be glossary terms, which ties in with glossary checks and spec conventions.

**Self-hosting.** Once a minimal `Is` works, every further spec of Motif.Is is written in Motif.Is: it checks itself, as a compiler compiles itself. That keeps the core small and trustworthy.

**Until then.** Solution plans keep setting up AwesomeAssertions (the free fork of FluentAssertions). Motif.Is is tried on Motif's own specs first, and becomes the default only if it earns it.

## Open questions

- Is Motif for starting an app, or for its whole life? The current lean is above, under **Code may become the source of truth**.
- Should the Tools table list conventions as well as apps? The Glossary is listed as a format on trial, for now.
- **Is Motif a ladder of tools?** A feeling, not yet an idea. The lowest rung is the Motif tools themselves: simple, largely built by agents, and partly built with Motif. The next rung is bespoke simple tools for a project or team, which Motif helps you make quickly, with throwaway tools ([#31](https://github.com/motif-dotnet/.github/issues/31)) at the bottom of it. On the top rung, the rungs below together help a person or team build and maintain complex software, still with agents but with more human-scale engineering. Each rung makes the next cheaper. If it holds, it could become a principle, or part of the purpose.
