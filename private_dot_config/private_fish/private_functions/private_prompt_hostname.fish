function prompt_hostname --description 'short hostname for the prompt'
    if set -q alt_hostname
	echo $alt_hostname
    else
    	string replace -r "\..*" "" $hostname
    end
end
