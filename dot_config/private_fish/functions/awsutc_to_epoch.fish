function awsutc_to_epoch
    set -l unix_timestamp (date -j -f "%Y-%m-%dT%H:%M:%S+00:00" $argv[1] "+%s")
    echo $unix_timestamp
end
