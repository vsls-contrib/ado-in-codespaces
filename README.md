# Azure DevOps Repos in Codespaces

[<img title="Run in Codespace in one click" src="https://cdn.jsdelivr.net/gh/bookish-potato/codespaces-in-codespaces@f097ccddfc401ab6b09d233dc47c3efa3f9513f6/images/badge.svg">](https://github.com/features/codespaces)

Script to create GitHub Codespace out of any Azure DevOps repo.

### Use

1. Create a repo from this template, change the environment variables in the `devcontainer.json`:
 - `$ADO_REPO_URL` - ADO repo URL to create the codespace with
 - `$ADO_REPO_DEFAULT_PATH` - the default workspace folder for the Codespace (analog of `workspaceFolder` from devcontainer spec)
 - feel free to define any other settings inside the file
2. Create a Codespace and run `./init` in the terminal.
3. Follow interactive script to specify your ADO `username` and `PAT`.
4. Apply the devcontainer configuration from your repository by opening the **Command Palette** (Shift + Command + P/ Ctrl + Shift + P) and selecting **Codespaces: Rebuild Container**.
 
### Issues/Feedback

- Feedback appreciated, create issues on this repo if anything 🤗
