function fish_greeting
    set -l repo ~/go/src/github.com/kylerisse/dotfiles
    set -l cache_file ~/.cache/dotfiles-remote-master-sha
    set -l cache_ttl_minutes 60
    set -l local_dotfiles_master (git -C $repo rev-parse refs/heads/master 2>/dev/null)
    if test -z "$local_dotfiles_master"
        set_color red
        echo "couldn't read local dotfiles sha"
        set_color normal
        return
    end
    set -l remote_dotfiles_master
    if test -f $cache_file; and test (find $cache_file -mmin -$cache_ttl_minutes | count) -gt 0
        set remote_dotfiles_master (cat $cache_file)
    end
    # fetch when the cache is stale or empty, and also when it disagrees with
    # local — we may have just pushed, so don't warn off a stale sha
    if test -z "$remote_dotfiles_master"; or test "$remote_dotfiles_master" != "$local_dotfiles_master"
        set remote_dotfiles_master (curl --silent --max-time 5 https://api.github.com/repos/kylerisse/dotfiles/git/refs/heads | jq -r '.[] | select (.ref=="refs/heads/master") | .object.sha')
        if test -z "$remote_dotfiles_master"
            set_color red
            echo "couldn't read remote dotfiles sha"
            set_color normal
            return
        end
        mkdir -p (dirname $cache_file)
        echo $remote_dotfiles_master >$cache_file
    end
    if test "$remote_dotfiles_master" != "$local_dotfiles_master"
        set_color red
        echo "local dotfiles behind master, has sha $local_dotfiles_master expected $remote_dotfiles_master"
        set_color normal
    end
end
