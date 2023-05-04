function tf
    if test (count (find ./ -maxdepth 1 -name "*.tf")) -eq 0
        echo "tf: no .tf files, using terraform"
        terraform $argv
        return $status
    end

    set -l tf_ver (grep -A4 'terraform {' *.tf | grep 'required_version' | cut -d '"' -f 2)
    if test (count $tf_ver) -eq 1
        if not type -q terraform-$tf_ver
            echo "tf: can't find terraform-$tf_ver, using terraform"
            terraform $argv
            return $status
        else
            echo "tf: using terraform-$tf_ver"
            terraform-$tf_ver $argv
            return $status
        end
    else
        echo "tf: no required_version, using terraform"
        terraform $argv
        return $status
    end
end
