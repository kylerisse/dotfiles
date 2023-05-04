function _gitlab_get_group_tree
    set -l root_group $argv[1]
    set -e child_groups
    # for the purposes of this function, the root group is a child of itself
    set -l child_groups "$root_group"
    for group in (curl --silent --request GET --header "PRIVATE-TOKEN: $GITLAB_RO_API_TOKEN" "https://gitlab.com/api/v4/groups/$root_group/subgroups" | jq -r '.[].id')
        set -l children (_gitlab_get_group_tree $group)
        set child_groups "$child_groups $children"
    end
    echo $child_groups | string split " "
end
