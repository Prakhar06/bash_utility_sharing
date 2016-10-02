count=0
port=2000
ip=localhost
data=
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
	echo "$data" | nc $ip $port
	while [ $? == 1 ]; do
	    echo "$data" | nc $ip $port
	done

}

while true; do
    list_client_files=`nc -l $port`
    list_server_files=`ls -1 server`
    non_sync_files=`echo -e "$list_client_files\n$list_server_files" | sort | uniq -u`
    
    to_be_sent=`echo -e "$list_server_files\n$non_sync_files" | sort| uniq -d`
    [ -z "$to_be_sent" ] && count=0 || count=`echo "$to_be_sent" | wc -l`
    data=$count
    send_data
    IFS=$'\n'
    for file in $to_be_sent; do
	data="server/$file"
	echo "${file}" | nc $ip $port
	send_file
    done
    
done
