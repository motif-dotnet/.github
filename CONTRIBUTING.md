# Contributing to Motif.NET

Motif.NET is one person's way of finding their feet in agent-assisted development, so it moves when there's time and changes its mind often. Help is welcome all the same, and this page says which kind fits where.

## Ways to help

- **Found a bug?** Open an issue in that tool's repo with **Report a bug**. The steps to make it happen matter most.
- **Want a tool to do something different?** Open an issue in that tool's repo with **Suggest a change**.
- **Got an idea for a new tool or convention, or something not settled yet?** Start a thread in [Ideas](https://github.com/motif-dotnet/.github/discussions/categories/ideas). Ideas that take shape end up in [design/ideas.md](design/ideas.md).
- **Have a question?** Ask in [Q&A](https://github.com/motif-dotnet/.github/discussions/categories/q-a).

Wherever you take part, the [code of conduct](CODE_OF_CONDUCT.md) applies: be excellent to each other.

## Pull requests

Small fixes (typos, broken links, an obvious bug) can go straight to a pull request.

For anything bigger, open an issue first and say you'd like to do it. The tools are opinionated about architecture, naming and style, so a quick conversation saves you building something that won't be merged.

When you do send one:

- Follow the repo's `README.md` to build and run it, and make sure `dotnet test` passes.
- Read the repo's `AGENTS.md` and `decisions.md`. They hold the conventions and the reasons behind them, and they're what a coding agent works from too.
- Add or change specs for the behaviour you change. The specs drive the tool through its ports with fakes, so follow the ones already there.
- Use the terms in the repo's `motif/glossary.md`. If you need a new one, say so in the pull request.
- Keep it to one change, and say what it does and why in plain words.

Using a coding agent is fine, and expected here. You're still the author, so read and understand what you send.

## Licence

Each repo is MIT licensed. By contributing, you agree your work is released under the same licence.
