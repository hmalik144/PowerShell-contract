echo "Connecting to remote "

$Server="dc1****net40"

$User="0hx****"

$Password="*****"

cmdkey /generic:TERMSRV/$Server /user:$User /pass:$Password

mstsc /v:$Server
