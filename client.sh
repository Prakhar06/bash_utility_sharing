ip=localhost
port=2000
name=
data=
count=0
function recieve_file () {
   name=`nc -l 2000`
   nc -l 2000 > client/"$name"
   echo "$name recieved"
}
function send_file (){

    if [ -z "$data" ]; then
	:
    else
	nc $ip $port < ${data}
	while [ $? == 1 ]; do
	    nc $ip $port < ${data}
	done


    fi

}

function send_data (){

	echo "${data}" | nc $ip $port
	while [ $? == 1 ]; do
	    echo "${data}" | nc $ip $port
	done

}

while true; do
    data=`ls -1 client`
    send_data
    count=`nc -l $port`
    while [ "$count" != 0 ]; do
	recieve_file
	count=$((count-1))
    done
done
