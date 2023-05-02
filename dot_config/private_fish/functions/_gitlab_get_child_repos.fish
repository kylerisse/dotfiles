function _gitlab_get_child_repos
    set -l group $argv[1]
    set -e child_repos
    for repo in (curl --silent --request GET --header "PRIVATE-TOKEN: $GITLAB_RO_API_TOKEN" "https://gitlab.com/api/v4/groups/$group/projects" | jq -r '.[].id')
        if set -q child_repos
            set child_repos "$child_repos $repo"
        else
            set child_repos "$repo"
        end
    end
    if set -q child_repos
        echo $child_repos | string split " "
    end
end
