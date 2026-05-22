{ config, ... }:

{
  sops = {
    secrets.default_email = { };
    secrets.work_email = { };

    templates."git-personal" = {
      content = ''
        [user]
          name = b0nz
          email = ${config.sops.placeholder.default_email}

        [core]
          sshCommand = "ssh -i ~/.ssh/id_default"
      '';
    };

    templates."git-work" = {
      content = ''
        [user]
          name = b0nz
          email = ${config.sops.placeholder.work_email}

        [core]
          sshCommand = "ssh -i ~/.ssh/id_work"
      '';
    };
  };

  programs.git = {
    enable = true;

    # Global Configuration
    settings = {
      init.defaultBranch = "main";

      alias = {
        # --- The Daily Basics ---
        s = "status -s"; # Short, concise status
        a = "add"; # git a .
        aa = "add --all"; # Stage everything
        c = "commit"; # git c
        cm = "commit -m"; # git cm "message"
        cam = "commit -am"; # Stage tracked files and commit with message
        p = "push";
        pl = "pull";
        d = "diff"; # Quick diff for unstaged changes
        dc = "diff --cached"; # Show staged changes

        # --- Branching & Navigation ---
        co = "checkout";
        cob = "checkout -b"; # Create and switch to a new branch
        sw = "switch"; # Newer alternative to checkout
        swc = "switch -c"; # Create and switch using switch
        br = "branch";
        bd = "branch -d"; # Delete local branch
        bD = "branch -D"; # Force delete local branch
        ri = "rebase --interactive"; # Interactive rebase
        cp = "cherry-pick"; # Cherry pick commit

        # --- Beautiful Logs & History ---
        # Creates a colorful, easy-to-read commit tree
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        lga = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all";
        recent = "branch --sort=-committerdate --format=\"%(committerdate:relative)%09%(refname:short)\""; # See recently worked on branches
        last = "log -1 HEAD --stat"; # Show details and file stat of last commit

        # --- Undoing & Fixing Mistakes ---
        amend = "commit --amend --no-edit"; # Add staged changes to the last commit without changing the message
        undo = "reset --soft HEAD~1"; # Uncommit the last commit, keep changes staged
        unstage = "reset HEAD --"; # Unstage a file (git unstage <file>)
        discard = "checkout --"; # Throw away local uncommitted changes to a file
        nuke = "!git reset --hard HEAD && git clean -fd"; # DANGEROUS: Wipe all local changes and untracked files

        # --- Stashing ---
        st = "stash";
        stp = "stash pop";
        stl = "stash list";

        # --- Remote Synchronization ---
        out = "log @{u}.. --oneline"; # Local commits not yet pushed
        "in" = "!git fetch && git log ..@{u} --oneline"; # Remote commits not yet pulled
      };
    };
    includes = [
      {
        inherit (config.sops.templates."git-personal") path;
      }
      {
        condition = "gitdir:~/work/";
        inherit (config.sops.templates."git-work") path;
      }
    ];
  };
}
