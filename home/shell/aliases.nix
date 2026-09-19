{
  ls = "eza --icons";
  ll = "eza -l -a --icons --git";
  lt = "eza --tree --level=2 --icons";
  cat = "bat";
  nv = "nvim";

  # --- Git: Daily Basics ---
  gs = "git status -s";
  ga = "git add";
  gaa = "git add --all";
  gc = "git commit";
  gcm = "git commit -m";
  gcam = "git commit -am";
  gp = "git push";
  gpl = "git pull";
  gd = "git diff";
  gdc = "git diff --cached";

  # --- Git: Branching & Navigation ---
  gco = "git checkout";
  gcob = "git checkout -b";
  gsw = "git switch";
  gswc = "git switch -c";
  gbr = "git branch";
  gbd = "git branch -d";
  gbD = "git branch -D";
  gri = "git rebase --interactive";
  gcp = "git cherry-pick";

  # --- Git: Logs & History ---
  glg = "git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
  glga = "git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all";
  grecent = "git branch --sort=-committerdate --format='%(committerdate:relative)%09%(refname:short)'";
  glast = "git log -1 HEAD --stat";

  # --- Git: Undoing & Fixing ---
  gamend = "git commit --amend --no-edit";
  gundo = "git reset --soft HEAD~1";
  gunstage = "git reset HEAD --";
  gdiscard = "git checkout --";
  gnuke = "git reset --hard HEAD && git clean -fd";

  # --- Git: Stashing ---
  gst = "git stash";
  gstp = "git stash pop";
  gstl = "git stash list";

  # --- Git: Remote Sync ---
  gout = "git log @{u}.. --oneline";
  gin = "git fetch && git log ..@{u} --oneline";
}
