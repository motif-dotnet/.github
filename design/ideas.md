# Ideas

Possible tools and conventions for Motif.NET. Nothing here is built or promised. An idea moves to the profile's Tools table once it has a design note of its own in this folder.

## Principles

These came out of discussing what the suite is for. Every idea should fit them.

- **Optional to adopt, gentle by default, opinionated in use.** No tool is required. Checks report rather than block, unless a team turns blocking on. When you do use a tool, it has firm views.
- **Use what already works; Motif sets it up.** Where an existing tool solves the problem, use it. A Motif tool's job is then to set it up, configure it and take the friction out, often by producing files an agent implements from. The solution plan is the model: the app uses ordinary Visual Studio solutions and projects, but a Motif tool decides their shape and an agent builds them. Code style works the same way, through analysers and `.editorconfig` that the plan sets up. Motif builds something of its own only where nothing suitable exists.
- **Firm at the start, open after.** The opinions are firm for the solution stub: ports and adapters, the glossary, code style, spec-style checks and the `motif/` layout. How far, if at all, to enforce them during maintenance is still open.
- **Code may become the source of truth.** One lean is to start from the sketch, then let the code lead, with tools that regenerate pictures and documents from the code to show drift. Still feeling our way.

## The list

| Idea | One line | Notes |
|---|---|---|
| **Motif CLI** (`dotnet motif`) | `init` sets up the `motif/` folder and the `AGENTS.md` pointer; `check` runs the gentle checks below. | [#4](https://github.com/motif-dotnet/.github/issues/4) |
| **Glossary checks** | Flag **Avoid** words, terms still *proposed*, and sketch names with no entry. | Likely the CLI's first check. |
| **Glossary editor** | An app for browsing and editing `motif/glossary.md`. | Reads and writes the same file. |
| **Glossary in context** | Glossary terms shown where you work: IDE hover text, and Sketch highlighting names that aren't in the glossary. | Stretch goal. |
| **Architecture checks** | Report when the domain references an adapter or framework, or when the ports in code don't match the sketch. | |
| **Sketch from code** | Regenerate the sketch from the solution and compare it with the committed one to show drift. | |
| **Code-style baseline** | The solution plan sets up analysers, `.editorconfig`, nullable and warnings as errors. | Part of Motif Sketch. [#8](https://github.com/motif-dotnet/.github/issues/8) |
| **Spec conventions** | How behaviour specs are named and laid out, in glossary terms, perhaps with a spec project the plan generates. | First step towards plain-English specs. |
| **Agent review** | A review prompt or skill that checks a change against Motif's opinions (architecture, glossary, style) and gives advice only. | Could cover the spirit of the checks long before they're built. |
| **Decision records** | `motif/decisions/`: short notes on why the design is the way it is, so agents don't undo choices made on purpose. | |
| **Plain-English specs** | Readable, glossary-shaped specs generated from well-named automated specs, as a living document of what the app does. | Blue-sky. Code first: the specs are tests, and the English is generated from them. |

## Open questions

- Which kinds of .NET app are in scope? [#9](https://github.com/motif-dotnet/.github/issues/9)
- Is Motif for starting an app, or for its whole life? The current lean is above, under **Code may become the source of truth**.
- Should the Tools table list conventions as well as apps? The Glossary is listed as a format on trial, for now.
