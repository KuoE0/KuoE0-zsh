#=============================================================================
#     FileName: function.zsh
#         Desc: function definition
#       Author: KuoE0
#        Email: kuoe0.tw@gmail.com
#     HomePage: http://kuoe0.ch/
#=============================================================================


cpu_load() {
	echo $@ $(uptime | awk -F'load average:' '{ print $2 }' | sed "s/ //g" | cut -d"," -f1)
}

user_numbers() {
	echo $@ $(who | cut -d" " -f1 | sort | uniq | wc -l)
}

mac_memory() {

	FREE_MEM=`vm_stat| grep free | awk '{ print $3 }' | sed 's/\.//'`
	SPECULATIVE_MEM=`vm_stat| grep speculative | awk '{ print $3 }' | sed 's/\.//'`
	WIRED_MEM=`vm_stat| grep wired | awk '{ print $4 }' | sed 's/\.//'`
	ACTIVE_MEM=`vm_stat| grep -v inactive | grep active | awk '{ print $3 }' | sed 's/\.//'`
	INACITVE_MEM=`vm_stat| grep inactive | awk '{ print $3 }' | sed 's/\.//'`

	# page size of 4096 bytes
	# for gigabyte (GB)
	FREE=$((($FREE_MEM + $SPECULATIVE_MEM) * 4.0 / (1024 * 1024)))
	WIRED=$(($WIRED_MEM * 4.0 / (1024 * 1024)))
	ACTIVE=$(($ACTIVE_MEM * 4.0 / (1024 * 1024)))
	INACITVE=$(($INACITVE_MEM * 4.0 / (1024 * 1024)))

	# format output
	if [ "$1" = "-f" ]; then
		printf "\x1b[0;32mFree:      %.2lf GB\x1b[m\n" $FREE
		printf "\x1b[0;31mWired:     %.2lf GB\x1b[m\n" $WIRED
		printf "\x1b[0;33mActive:    %.2lf GB\x1b[m\n" $ACTIVE
		printf "\x1b[0;34mInactive:  %.2lf GB\x1b[m\n" $INACITVE
	else
		printf "%.2lf,%.2lf,%.2lf,%.2lf" $FREE $WIRED $ACTIVE $INACITVE
	fi
}

linux_memory() {
	FREE_MEM=`vmstat -s | grep "free memory" | awk '{ print $1 }'`
	BUFFER_MEM=`vmstat -s | grep "buffer memory" | awk '{ print $1 }'`
	ACTIVE_MEM=`vmstat -s | grep -v "inactive" | grep "active memory" | awk '{ print $1 }'`
	INACITVE_MEM=`vmstat -s | grep "inactive memory" | awk '{ print $1 }'`

	FREE=$(($FREE_MEM.0 / (1024 * 1024)))
	BUFFER=$(($BUFFER_MEM.0 / (1024 * 1024)))
	ACTIVE=$(($ACTIVE_MEM.0 / (1024 * 1024)))
	INACITVE=$(($INACITVE_MEM.0 / (1024 * 1024)))

	if [ "$1" = "-f" ]; then
		printf "\x1b[0;32mFree:      %.2lf GB\x1b[m\n" $FREE
		printf "\x1b[0;31mBuffer:    %.2lf GB\x1b[m\n" $BUFFER
		printf "\x1b[0;33mActive:    %.2lf GB\x1b[m\n" $ACTIVE
		printf "\x1b[0;34mInactive:  %.2lf GB\x1b[m\n" $INACITVE
	else
		printf "%.2lf,%.2lf,%.2lf,%.2lf" $FREE $BUFFER $ACTIVE $INACITVE
	fi
}

memory_usage() {

	if [ "$OS" = "Darwin" ]; then
		MEM_STAT=$(mac_memory)
	elif [ "$OS" = "Linux" ]; then
		MEM_STAT=$(linux_memory)
	fi

	TOTAL=$(echo $MEM_STAT | awk -F',' '{ for (i=1; i <= NF; ++i) sum+=$i; print sum }')
	USED=$(($TOTAL - $(echo $MEM_STAT | cut -d',' -f1)))
	RET=$(printf "%.0f" $(echo $(($USED / $TOTAL * 100))))
	if [ "$1" = "-f" ]; then
		if [ "$OS" = "Darwin" ]; then
			mac_memory -f
		elif [ "$OS" = "Linux" ]; then
			linux_memory -f
		fi

		echo "Memory Usage: $RET %"
	else
		echo -n $RET
	fi

}

################################################################################
# utilities
################################################################################

# colourifide cat
ccat() {
	if which source-highlight-esc.sh &> /dev/null; then
		source-highlight-esc.sh $1
	else
		echo "\x1b[31mcommand not found: source-highlight\x1b[0m" 1>&2
		cat $1
	fi
}

# colourifide less
cless() {
	ccat $1 | less
}

get_syslog() {
	if [ "$OS" = "Darwin" ]; then
		SYSLOGFILE=/var/log/system.log
	elif [ "$OS" = "Linux" ]; then
		SYSLOGFILE=/var/log/syslog
	fi
		
	CCZE=`which ccze`
	if [ -n "$CCZE" ]; then
		tail $SYSLOGFILE | ccze -m ansi
	else
		tail $SYSLOGFILE
	fi
}

passwd_gen() {
	len=${2:-16}
	echo -n $(echo "$1" | sha1sum | cut -c1-"$len" | tr -d ' \n\t')
}

