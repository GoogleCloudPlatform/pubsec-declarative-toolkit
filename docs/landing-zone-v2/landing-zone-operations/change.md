
# Implementing a change on the landing zone

1. ## Repo cloning
    - Clone locally the repository requiring code change
        ```
        git clone <REPO URL>
        ```
1. ## Create branch
    - Create a branch with a name representing the issue/work item
        ```
        git checkout -b <BRANCH NAME>
        ```
1. ## Make code changes 
    - Edit any file as required

    &nbsp;
1. ## Generate hydrated files
    - Execute hydration script ***from the root of the repository***
      ```
      bash tools/scripts/kpt/hydrate.sh
      ```
1. ## Add changes to repository
    1. Review changes using a git tool or just by running `git diff`
    1. Prepare your commit by staging the files by running `git add .`
    1. Commit your changes by running `git commit -m '<MEANINGFULL MESSAGE GOES HERE>`
    1. Push your changes to origin by running `git push --upstream origin <branch name>`
    1. Open a pull request process to merge this `<branch name>` into `main`
    1. Wait for branch policies requirements (approvals, tests, etc.) to be met
    1. Complete the pull request