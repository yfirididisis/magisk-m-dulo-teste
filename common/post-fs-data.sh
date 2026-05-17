MODDIR=${0%/*}

if [ -e /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors ]; then
 gov=/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
fi

if grep 'schedutil' $gov; then
	cp -f $MODDIR/config/eas $MODDIR/service.sh
else
    if grep 'blu_schedutil' $gov; then
	    cp -f $MODDIR/config/eas $MODDIR/service.sh
	else
	    cp -f $MODDIR/config/hmp $MODDIR/service.sh
	fi
fi
