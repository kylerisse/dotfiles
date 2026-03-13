function claude --description 'run claude inside nix develop when a flake is present'
    if test -z "$IN_NIX_SHELL"
        if test -f flake.nix; or test -f shell.nix
            nix develop --command claude $argv
            return
        end
    end
    command claude $argv
end
