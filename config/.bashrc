#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ssh
## source ~/.bashrc.ssh

cd() {
        if [[ -z "$@" ]] && [[ "${PWD}" == *"/GitHub"* ]]; then
                builtin cd ~/GitHub
        elif [[ -z "$@" ]] && [[ "${PWD}" == *"/AUR-packages"* ]]; then
		builtin cd ~/AUR-packages
        elif [[ -z "$@" ]]; then
                builtin cd ~
        else
                builtin cd "$@"
        fi
}

url_test() {
        if [[ -z "$@" ]];then
                echo -e "ERROR: \$@ is empty"
		return 1
        fi
        for arg in "$@";do
                curl --max-time 1 -w '%{time_total}' -s $arg -o /dev/null | awk '{printf "Result: %.0f ms\n", $1*1000}'
	done
        if ! [[ -z $2 ]];then
        	echo "------------------"
        fi
        sleep 0.5
        url_test "$@"
}

dns_test(){
        if [[ -z $@ ]];then
                local TEST_SERVER="example.com 192.168.1.10"
        else
                local TEST_SERVER="$@"
        fi
        start=$(date +%s%N||return)
        $(nslookup $TEST_SERVER > /dev/null || return)
        end=$(date +%s%N||return)
	elapsed=$((($end - $start)/1000000))||return
        echo "Time taken: $elapsed milliseconds" || return
        sleep 0.5 || return
        dns_test $@
}

stunclient() {
	if [[ -z "$@" ]];then
		/usr/bin/stunclient --mode full stun.syncthing.net
	else
		/usr/bin/stunclient --mode full "$@"
	fi
}

m3u8() {
	local parts=( )
	if [[ -z "$@" ]];then
		echo 'No URL and NAME'
		return
	fi
	local IFS=' '
	read -a parts <<< "$@"
	local IFS=
	for arg in ${parts[@]};do
		if [[ $arg == 'http'* ]]; then
        		local M3U8_URL=$arg
		else
		        local NAME=$arg
		fi
	done
	# echo "NAME=$NAME URL=$URL"
	if [[ -z $M3U8_URL ]];then
		echo 'No URL'
		return
	fi
	if [[ -z ${parts[1]} ]];then
		echo 'No NAME'
		return
	fi
	local DOMAIN=$(echo "$M3U8_URL" | sed -n 's/.*\/\/\([^\/]*\).*/\1/p')
	local URL=$(echo "$M3U8_URL" | sed '\#index.m3u8#s###')
	curl -L "$M3U8_URL" | sed -e '\#^\(http\|\#\|\/\)#!s#.*#'"$URL"'&#' |\
		sed -e '\#^\(http\|\#\)#!s#.*#https://'"$DOMAIN"'&#' >| ~/Downloads/$NAME.m3u8 
	ffmpeg  -protocol_whitelist file,http,https,tcp,tls,crypto \
        -i ~/Downloads/$NAME.m3u8 -headers "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0" ~/Downloads/$NAME.mp4
	rm ~/Downloads/$NAME.m3u8 -f
}

trash() {
	for arg in "$@";do
: '		if [[ $arg == *'-rf'* ]];then
			rm -rf $arg
		fi'
		cat <<EOF > ~/.local/share/Trash/info/"$arg.trashinfo"
[Trash Info]
Path=$(realpath $arg)
DeletionDate=$(date +'%Y-%m-%dT%H:%M:%S')
EOF
		mv "$arg" ~/.local/share/Trash/files/
	done
}

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR"/ssh-agent.socket
export SSH_ASKPASS="/usr/bin/ksshaskpass"
export SSH_ASKPASS_REQUIRE=prefer
export GPG_TTY=$(tty)
