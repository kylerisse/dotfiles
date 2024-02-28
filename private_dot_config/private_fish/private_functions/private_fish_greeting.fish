function fish_greeting
    set -l remote_dotfiles_master (curl --silent https://api.github.com/repos/kylerisse/dotfiles/git/refs/heads | jq -r '.[] | select (.ref=="refs/heads/master") | .object.sha')
    if test $status -ne 0
        set_color red
        echo "can't connect to github api"
        set_color normal
        return
    end
    set -l local_dotfiles_master (cat ~/go/src/github.com/kylerisse/dotfiles/.git/refs/heads/master)
    if test $remote_dotfiles_master != $local_dotfiles_master
        set_color red
        echo "local dotfiles behind master, has sha $local_dotfiles_master expected $remote_dotfiles_master"
        set_color normal
    end
end
