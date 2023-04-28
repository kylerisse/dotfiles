function awsutc_to_local
    set -l unix_timestamp (awsutc_to_epoch $argv[1])
    set -l local_offset (date +%z)
    set -l operand (echo $local_offset | string sub -l 1)
    set -l hour_offset (echo $local_offset | string sub -s 2 -l 2)
    set -l local_time (date -r (math $unix_timestamp $operand (math $hour_offset x 60 x 60)))
    echo $local_time
end
