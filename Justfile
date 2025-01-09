default: ssh


ssh:
  gh workflow run .github/workflows/ssh.yml

workflow-cancel:
  gh run list --status in_progress --limit 100 | awk '/in_progress/ {print $1}' | xargs -n 1 gh run cancel

workflow-rm:
  # gh run list --status completed --limit 10 | awk '/ID/ {print $1}' | xargs -n 1 gh run delete
  gh run list --status completed --limit 10 --json databaseId | jq -r '.[].databaseId' | xargs -n 1 gh run delete  

