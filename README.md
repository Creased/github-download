# GitHub mass repo downloader

Want to backup all your projects on GitHub?

1. Open a terminal and instantiate the function:

  ```bash
source github-dl.sh
  ```

2. Create your new [token](https://github.com/settings/tokens/new) to access the GitHub API;

3. Gather entity information such as its name (e.g. `Yubico`) and its type (i.e. `users`, `orgs`);

4. Call the function according to this template:

  ```bash
github-dl <email|username> <token|password> <orgs|users> <entity>
  ```

It's that simple.
