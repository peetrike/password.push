# Contributing to telia.remote.automation project

## Contributing to documentation

- all documentation is in [docs](docs) folder and in markdown format.
- The markdown help files are preferred source of truth, when possible, make
  documentation changes in markdown files.
- Module functions help is processed using [PlatyPS](https://github.com/powershell/platyps)
  module, currently using the older (v0.14.2) release.  The platyPS module
  imports comment-based help and changes in code to markdown help files.
- Follow the style guides from [PowerShell Docs style guide](https://learn.microsoft.com/powershell/scripting/community/contributing/powershell-style-guide)
  when writing markdown.

## Pull Requests

- Always use pull requests to submit changes
- When You make changes in this repository, create a new branch from
  _develop_ branch.
- Target pull request to _develop_ branch.  Main branch is for clean releases.
- To avoid conflicts during submitting pull request, first sync your branch with
  _develop_ branch and resolve all conflicts.
- Limit pull request to related changes.  Submit unrelated changes as
  separate pull requests.
- When you're not ready with development, you can mark Pull Request as [draft](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests#draft-pull-requests).
  You can still ask for comments/review, but draft pull requests are not merged.
- Review your own pull request before you [mark it as ready](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/changing-the-stage-of-a-pull-request).

## Style guide

Use the style rules in this repository.  When You use [VS Code](https://code.visualstudio.com)
to make changes, the editor follows automatically style rules in [PSScriptAnalyzerSettings.](PSScriptAnalyzerSettings.psd1)
file.  When you use another editor, run following in the repository root folder
to check style guides:

```powershell
Invoke-ScriptRunner -Path ./folder/myscript.ps1 -Settings ./PSScriptAnalyzerSettings.psd1
```

When specified path is folder, all PowerShell script files are checked
within the folder and subfolders.

### Indenting and encoding

Indenting and encoding guidelines are in [editorconfig](.editorconfig) file.
_VS Code_ recommends installing plugin when this repository is cloned and opened.
Check the [EditorConfig home page](https://editorconfig.org/) for the list of
editors who have _editorconfig_ supported automatically or have plugin available.
