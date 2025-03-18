#!/bin/bash

release_has_public_changes=false

url=$(git remote get-url origin | sed -r 's/(.*)\.git/\1/')
repo_owner=$(echo "$url" | sed -E 's|.*github.com/([^/]+)/.*|\1|')
repo_name=$(echo "$url" | sed -E 's|.*github.com/[^/]+/(.*)|\1|')

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
        github_username=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
            "https://api.github.com/repos/$repo_owner/$repo_name/commits?author=$author_email" | \
            jq -r '.[0].author.login' | grep -v null)

        author_to_github[$author_email]="$github_username"
    else
        github_username="${author_to_github[$author_email]}"
    fi

    # Exclude commits starting with "Meta"
    if [[ $summary != Meta* ]]; then
        echo "* [$summary]($url/commit/$rev) by [$github_username](https://github.com/$github_username)"

        # Append commit body indented (blank lines and signoff trailer removed)
        git log $rev~..$rev --format="%b" | sed '/^\s*$/d' | sed '/^Signed-off-by:/d' | \
        while read -r line; do
            # Escape markdown formatting symbols _ * `
            echo "  $line" | sed 's/_/\\_/g' | sed 's/`/\\`/g' | sed 's/\*/\\\*/g'
        done

        release_has_public_changes=true
    fi
done

# Generate collaborator mapping at the end of the changelog
echo "" 
echo "## Contributors"
echo ""

for email in "${!author_to_github[@]}"; do
    username="${author_to_github[$email]}"
    if [[ -n "$username" ]]; then
        echo "- [$username](https://github.com/$username) ($email)"
    else
        echo "- *(Unknown GitHub username)* ($email)"
    fi
done

if ! $release_has_public_changes; then
    echo "No public changes since $previous_tag." >&2
    exit 1
fi
