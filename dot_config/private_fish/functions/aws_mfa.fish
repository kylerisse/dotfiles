# sample ~/.aws/config
# ====================
# [default]
# region = us-east-2
#
# [profile dev]
# region = us-east-2
#
# [profile prod]
# region = us-east-2
# role_arn = arn:aws:iam::123456789012:role/ROLE-TO-ASSUME
# source_profile = dev
# ====================
#
# sample ~/.aws/credentials
# ====================
# [default]
# aws_access_key_id = AAAAAAAAAAAAAAAAAAAAAA
# aws_secert_access_key = abcdefghijklmnopqrstuvzxyz
# ====================
#
function aws_mfa --description 'authenticate to AWS using an MFA device'
    # check if user if force bypassing time comparison
    if test (count $argv) -lt 2 -a "$argv[1]" != "force"
        set -l existing_expiration (cat ~/.aws/credentials | grep -A5 '\[dev\]' | grep expiration | awk '{print $3}')
        if test $existing_expiration != ""
            set -l existing_epoch (awsutc_to_epoch $existing_expiration)
            set -l current_epoch (date +%s)
            if test $current_epoch -lt $existing_epoch
                set -l valid_until (awsutc_to_local $existing_expiration)
                echo "Existing session still valid until $valid_until, use 'force' to force reauth"
                return 0
            end
        end
    end
    set -l aws_username (aws sts get-caller-identity | jq ".Arn" | sed -n 's!.*"arn:aws:iam::.*:user/\\(.*\\)".*!\\1!p')
    set -l mfa_device (aws iam list-mfa-devices --user-name $aws_username | jq -r '.MFADevices[].SerialNumber' | grep mfa)
    echo "You are $aws_username"
    echo "Your MFA device is $mfa_device"
    read -P "Enter code: " -s mfa_code

    set -l tokens (aws sts get-session-token --serial-number "$mfa_device" --token-code $mfa_code)
    set -l access_key (echo $tokens | jq -r '.Credentials.AccessKeyId')
    set -l secret_key (echo $tokens | jq -r '.Credentials.SecretAccessKey')
    set -l session_token (echo $tokens | jq -r '.Credentials.SessionToken')
    set -l session_expiration (echo $tokens | jq -r '.Credentials.Expiration')

    sed -i '' '/dev/,$d' ~/.aws/credentials

    echo "[dev]" >>~/.aws/credentials
    echo "aws_access_key_id = $access_key" >>~/.aws/credentials
    echo "aws_secret_access_key = $secret_key" >>~/.aws/credentials
    echo "aws_session_token = $session_token" >>~/.aws/credentials
    echo "expiration = $session_expiration" >>~/.aws/credentials

    set -l new_session_local_time (awsutc_to_local $session_expiration)
    echo "Key valid until $new_session_local_time"
    return 0
end
