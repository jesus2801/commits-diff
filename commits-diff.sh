#!/bin/bash

if [[ ! -d ./lib/ ]]; then
  mkdir "lib"
fi

if [[ ! -f ./lib/selector.sh ]]; then
  echo "Installing dependencies..."

  source .env
  if [[ -z $SELECTOR_URL ]]; then
    echo "ERROR: .env variable 'SELECTOR_URL' not found"
    exit 1
  fi

  wget -O "./lib/selector.sh" "$SELECTOR_URL"
fi

source ./lib/selector.sh

commits=($(git log | sed -n 's/^commit \(.*\)/\1/p')) # or git log --format='%H'
mapfile -t names < <(git log --oneline --pretty=format:"%s")

echo "Please, select the two commits you want to compare"
read -p "Press any key to start selecting..."

select_choice "${names[@]}"
first_commit=$?
select_choice "${names[@]}"
second_commit=$?

git diff "${commits[$first_commit]}" "${commits[$second_commit]}"
