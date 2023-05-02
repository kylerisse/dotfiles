function gitlab_clone_from_root
    set -l root_group
    if test (count $argv) -gt 0
        set root_group $argv[1]
    else if set -q GITLAB_SYNC_GROUP
        set root_group $GITLAB_SYNC_GROUP
    else
        echo "gitlab_clone_from_root needs an argument or GITLAB_SYNC_GROUP set"
        return 1
    end
    if not set -q GITLAB_RO_API_TOKEN
        echo "gitlab_clone_from_root needs GITLAB_RO_API_TOKEN"
        return 1
    else if not set -q GITLAB_BASE_PATH
        echo "gitlab_clone_from_root needs GITLAB_BASE_PATH"
        return 1
    end
    for group in (_gitlab_get_group_tree $root_group)
        for repo in (_gitlab_get_child_repos $group)
            set -l details (curl --silent --request GET --header "PRIVATE-TOKEN: $GITLAB_RO_API_TOKEN" "https://gitlab.com/api/v4/projects/$repo")
            set -l path (echo $details | jq -r '.path_with_namespace')
            set -l ssh_source (echo $details | jq -r '.ssh_url_to_repo')
            if not test -d $GITLAB_BASE_PATH/$path
                echo "$path doesn't exist, cloning:"
                git clone $ssh_source $GITLAB_BASE_PATH/$path
            else
                echo $path exists
            end
        end
    end
end
