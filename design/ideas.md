# Ideas

Possible tools and conventions for Motif.NET. Nothing here is built or promised. An idea moves to the profile's Tools table once it has a design note of its own in this folder.

Thoughts, or an idea of your own? Start a thread in [Discussions](https://github.com/motif-dotnet/.github/discussions/categories/ideas).

## Principles

These came out of discussing what the suite is for. Every idea should fit them.

- **Optional to adopt, gentle by default, opinionated in use.** No tool is required. Checks report rather than block, unless a team turns blocking on. When you do use a tool, it has firm views.
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
| **Spec conventions** | How behaviour specs are named and laid out, in glossary terms, perhaps with a spec project the plan generates. | First step towards plain-English specs. |
| **Agent review** | A review prompt or skill that checks a change against Motif's opinions (architecture, glossary, style) and gives advice only. | Could cover the spirit of the checks long before they're built. |
| **Decision records** | `motif/decisions/`: short notes on why the design is the way it is, so agents don't undo choices made on purpose. | |
| **Plain-English specs** | Readable, glossary-shaped specs generated from well-named automated specs, as a living document of what the app does. | Blue-sky. Code first: the specs are tests, and the English is generated from them. |

## Open questions

- Is Motif for starting an app, or for its whole life? The current lean is above, under **Code may become the source of truth**.
- Should the Tools table list conventions as well as apps? The Glossary is listed as a format on trial, for now.
