DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

alert_unclean_work_tree() {
  # Update the index
  git update-index -q --ignore-submodules --refresh

  # Disallow unstaged changes in the working tree
  if ! git diff-files --quiet --ignore-submodules --
  then
      echo >&2 ""
      echo >&2 "$1: has unstaged changes."
      git status --ignore-submodules -s -- >&2
  fi

  # Disallow uncommitted changes in the index
  if ! git diff-index --cached --quiet HEAD --ignore-submodules --
  then
      echo >&2 ""
      echo >&2 "$1: has index with uncommitted changes."
      git status --ignore-submodules -s -- >&2
  fi
}

declare -a arr=(
  "ah-collector"
  "ah-deep-clone"
  "ah-fs.readfile"
  "ah-fs"
  "ah-prune"
  "ah-stack-capturer"
)

for d in "${arr[@]}"
do
  (cd $d && alert_unclean_work_tree $d)
done
