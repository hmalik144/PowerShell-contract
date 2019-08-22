echo "Connecting to remote "

$Server="dc1prdnet40"

$User="0hxmali"

$Password="*****"

cmdkey /generic:TERMSRV/$Server /user:$User /pass:$Password

mstsc /v:$Server
