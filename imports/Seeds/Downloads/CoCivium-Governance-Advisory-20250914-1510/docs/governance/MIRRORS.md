# Mirrors & Replication
Targets (suggested):
- GitHub (primary)  
- GitLab and/or Codeberg (mirrors)
- Periodic git bundle archives with signed SHA256 fingerprints

**Push-mirror playbook (fill remotes then run):**
git remote add mirror-gitlab  <gitlab-ssh-or-https>
git remote add mirror-codeberg <codeberg-ssh-or-https>
git push --all mirror-gitlab
git push --tags mirror-gitlab
git push --all mirror-codeberg
git push --tags mirror-codeberg
