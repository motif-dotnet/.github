<h1>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/motif-dotnet/.github/main/brand/motif-net-dark.svg">
    <img alt="Motif.NET" src="https://raw.githubusercontent.com/motif-dotnet/.github/main/brand/motif-net.svg" height="48">
  </picture>
</h1>

**Opinionated, agent-assisted tooling for building .NET apps, from first sketch onwards.**

Motif.NET is a suite of tools and conventions for building .NET apps with a coding agent. Each one does one job well, and they work together through files in the app's repo, so a design you sketch can become a plan that a coding agent builds from.

The tools are opinionated about architecture, naming, code style and automated specs. Using them is optional: pick the ones you want, and none of them gets in your way by default. Where a good .NET tool already exists, Motif sets it up for you rather than replacing it.

### Why this exists

Motif.NET is how I'm finding my way in agent-assisted development. The tools are what I build along the way, so expect ideas, trials and changes of mind. If you find them useful, or want to come along for the ride, that's a bonus. Say hello or share ideas in [Discussions](https://github.com/motif-dotnet/.github/discussions).

## Tools

Open any of them from **[motif-dotnet.github.io](https://motif-dotnet.github.io/)**, or from the Motif menu at the top left of each tool.

| Tool | What it does | Status |
|---|---|---|
| [**Motif Sketch**](https://github.com/motif-dotnet/Motif.Sketch) | Sketch a system context diagram and a ports-and-adapters design, then export SVG pictures and a Markdown solution plan a coding agent can build stubs from. Runs in the browser, with no server and no accounts. [Try it](https://motif-dotnet.github.io/Motif.Sketch/). | Built |
| [**Motif Glossary**](https://github.com/motif-dotnet/Motif.Glossary) | The project's agreed terms, kept in `motif/glossary.md` ([format](https://github.com/motif-dotnet/.github/blob/main/design/glossary.md)) and read by people and agents at the start of every session, so names don't drift. A read-only viewer shows a whole glossary at a glance for review, from a file, pasted Markdown or a public repo. [Try it](https://motif-dotnet.github.io/Motif.Glossary/). An editor and checks may follow. | Trial |

**Built:** ready to use. **Trial:** in use on Motif's own repos, still changing. **Idea:** written up, nothing built yet.

Other ideas being explored are in [design/ideas.md](https://github.com/motif-dotnet/.github/blob/main/design/ideas.md).
