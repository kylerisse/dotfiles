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
    set aws_username (aws sts get-caller-identity | jq ".Arn" | sed -n 's!.*"arn:aws:iam::.*:user/\\(.*\\)".*!\\1!p')
    set mfa_device (aws iam list-mfa-devices --user-name $aws_username | jq -r '.MFADevices[].SerialNumber' | grep mfa)
    echo "You are $aws_username"
    echo "Your MFA device is $mfa_device"
    read -P "Enter code: " -s mfa_code

    set tokens (aws sts get-session-token --serial-number "$mfa_device" --token-code $mfa_code)
    set access_key (echo $tokens | jq -r '.Credentials.AccessKeyId')
    set secret_key (echo $tokens | jq -r '.Credentials.SecretAccessKey')
    set session_token (echo $tokens | jq -r '.Credentials.SessionToken')
    set expiration (echo $tokens | jq -r '.Credentials.Expiration')

    sed -i '' '/dev/,$d' ~/.aws/credentials

    echo "[dev]" >> ~/.aws/credentials
    echo "aws_access_key_id = $access_key" >> ~/.aws/credentials
    echo "aws_secret_access_key = $secret_key" >> ~/.aws/credentials
    echo "aws_session_token = $session_token" >> ~/.aws/credentials
    echo "Key valid until $expiration"
end
