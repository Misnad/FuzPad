#!/bin/bash

release_has_public_changes=false

url=$(git remote get-url origin | sed -r 's/(.*)\.git/\1/')
repo_owner=$(echo "$url" | sed -E 's|.*github.com/([^/]+)/.*|\1|')
repo_name=$(echo "$url" | sed -E 's|.*github.com/[^/]+/(.*)|\1|')

previous_tag=$(git describe --tags --abbrev=0 HEAD~)

echo "## Changes since $previous_tag"
echo ""

declare -A author_to_github  # Store email-to-GitHub username mapping
declare -A github_avatar_urls  # Store username-to-avatar mapping

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
        github_avatar=$(echo "$response" | jq -r '.[0].author.avatar_url' | grep -v null)

        author_to_github[$author_email]="$github_username"
        github_avatar_urls[$github_username]="$github_avatar"
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

# Generate contributor section with profile pictures
echo "" 
echo "## Contributors"
echo ""

for username in "${!github_avatar_urls[@]}"; do
    avatar_url="${github_avatar_urls[$username]}"
    if [[ -n "$username" && -n "$avatar_url" ]]; then
        echo "- <img src=\"$avatar_url\" width=\"40\" height=\"40\" style=\"border-radius:50%; vertical-align:middle;\"> [**$username**](https://github.com/$username)"
    else
        echo "- *(Unknown Contributor)*"
    fi
done

if ! $release_has_public_changes; then
    echo "No public changes since $previous_tag." >&2
    exit 1
fi
