#!/bin/bash

url=$(git remote get-url origin | sed -r 's/(.*)\.git/\1/')
repo_owner=$(echo "$url" | sed -E 's|.*github.com/([^/]+)/.*|\1|')
repo_name=$(echo "$url" | sed -E 's|.*github.com/[^/]+/(.*)|\1|')

latest_tag=$(git describe --tags --abbrev=0)
previous_tag=$(git describe --tags --abbrev=0 HEAD~)

echo "## Changes since $previous_tag"
echo ""

declare -A author_to_github  # Store email-to-GitHub username mapping

# Loop through all commits since previous tag
for rev in $(git log $previous_tag..HEAD --format="%H" --reverse --no-merges)
do
    summary=$(git log $rev~..$rev --format="%s")
    author_email=$(git log $rev~..$rev --format="%aE")

    # Get GitHub username if not cached
    if [[ -z "${author_to_github[$author_email]}" ]]; then
        response=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
            "https://api.github.com/repos/$repo_owner/$repo_name/commits?author=$author_email")

        github_username=$(echo "$response" | jq -r '.[0].author.login' | grep -v null)

        author_to_github[$author_email]="$github_username"
    else
        github_username="${author_to_github[$author_email]}"
    fi

    # Exclude commits starting with "Meta"
    if [[ $summary != Meta* ]]; then
        echo "* $summary by @$github_username in [$rev]($url/commit/$rev)"

        # Append commit body indented (blank lines and signoff trailer removed)
        git log $rev~..$rev --format="%b" | sed '/^\s*$/d' | sed '/^Signed-off-by:/d' | \
        while read -r line; do
            # Escape markdown formatting symbols _ * `
            echo "  $line" | sed 's/_/\\_/g' | sed 's/`/\\`/g' | sed 's/\*/\\\*/g'
        done

        release_has_public_changes=true
    fi
done

echo ""
echo "[Full Changelog]($url/compare/$previous_tag...$latest_tag)"

# Generate contributor section
echo "" 
echo "## New Contributors"
echo ""

new_contributors=()
for github_username in "${author_to_github[@]}"; do
    if [[ -n "$github_username" && ! " ${new_contributors[*]} " =~ " $github_username " ]]; then
        new_contributors+=("$github_username")
        echo "@$github_username"
    fi
done

if [[ ${#new_contributors[@]} -eq 0 ]]; then
    echo "No new contributors in this release."
fi

if ! $release_has_public_changes; then
    echo "No public changes since $previous_tag." >&2
    exit 1
fi
