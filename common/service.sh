MODDIR=${0%/*}

# CAF CPU boost
if [[ -d "/sys/module/cpu_boost" ]]
then
	write "/sys/module/cpu_boost/parameters/input_boost_freq" 0:1600000
  write "/sys/module/cpu_boost/parameters/input_boost_ms" 250
fi

# Alarm Blocker
su -c "pm disable com.google.android.apps.messaging/.shared.analytics.recurringmetrics..AnalyticsAlarmReceiver"
su -c "pm disable com.google.android.location.internal.UPLOAD_ANALYTICS"

# WakeLock Blocker
su -c "pm disable com.google.android.apps.wellbeing/.powerstate.impl.PowerStateJobService"
su -c "pm disable com.google.android.apps.wellbeing/androidx.work.impl.background.systemjob.SystemJobService"
su -c "pm disable com.facebook.katana/com.facebook.analytics.appstatelogger.AppStateIntentService"
su -c "pm disable com.facebook.orca/com.facebook.analytics.apptatelogger.AppStateIntentService"
su -c "pm disable com.facebook.orca/com.facebook.analytics2.Logger.LollipopUploadService"
write /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker "qcom_rx_wakelock;wlan;wlan_wow_wl;wlan_extscan_wl;netmgr_wl;NETLINK;IPA_WS;[timerfd];wlan_ipa;wlan_pno_wl;wcnss_filter_lock;IPCRTR_lpass_rx;hal_bluetooth_lock"

# Doze setup services;
su -c "dumpsys deviceidle whitelist -com.google.android.gms"
su -c "pm enable com.google.android.gms/.update.SystemUpdateActivity"
su -c "pm enable com.google.android.gms/.update.SystemUpdateService"
su -c "pm enable com.google.android.gms/.update.SystemUpdateService\$ActiveReceiver"
su -c "pm enable com.google.android.gms/.update.SystemUpdateService\$Receiver"
su -c "pm enable com.google.android.gms/.update.SystemUpdateService\$SecretCodeReceiver"
su -c "pm enable com.google.android.gsf/.update.SystemUpdateActivity"
su -c "pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity"
su -c "pm enable com.google.android.gsf/.update.SystemUpdateService"
su -c "pm enable com.google.android.gsf/.update.SystemUpdateService\$Receiver"
su -c "pm enable com.google.android.gsf/.update.SystemUpdateService\$SecretCodeReceiver"
su -c "pm disable --user 0 com.google.android.gms/.phenotype.service.sync.PhenotypeConfigurator;"
settings put secure location_providers_allowed ' ';
dumpsys deviceidle enable all;
dumpsys deviceidle enabled all;

# Entropy config
echo '64' > /proc/sys/kernel/random/read_wakeup_threshold
echo '64' > /proc/sys/kernel/random/write_wakeup_threshold

#  Kill all Android Process Media & Media Server
busybox killall -9 android.process.media
busybox killall -9 mediaserver

# Touch Switch Improve
if [ -e /sys/class/touch/switch/set_touchscreen ]; then
  echo 7035 > /sys/class/touch/switch/set_touchscreen
  echo 8002 > /sys/class/touch/switch/set_touchscreen
  echo 11000 > /sys/class/touch/switch/set_touchscreen
  echo 13060 > /sys/class/touch/switch/set_touchscreen
  echo 14005 > /sys/class/touch/switch/set_touchscreen
fi

# Disable Fsync
chmod 666 /sys/module/sync/parameters/fsync_enable
chown root /sys/module/sync/parameters/fsync_enable
write /sys/module/sync/parameters/fsync_enable "N"

chmod 666 /sys/kernel/dyn_fsync/Dyn_fsync_active
chown root /sys/kernel/dyn_fsync/Dyn_fsync_active
write /sys/kernel/dyn_fsync/Dyn_fsync_active "0"

chmod 666 /sys/class/misc/fsynccontrol/fsync_enabled
chown root /sys/class/misc/fsynccontrol/fsync_enabled
write /sys/class/misc/fsynccontrol/fsync_enabled "0"

chmod 666 /sys/module/sync/parameters/fsync
chown root /sys/module/sync/parameters/fsync
write /sys/module/sync/parameters/fsync "0"

# A customized CPUSet profile
echo "0-1" > /dev/cpuset/background/cpus
echo "1,3" > /dev/cpuset/camera-daemon/cpus
echo "0-3,6-7" > /dev/cpuset/foreground/cpus
echo "2" > /dev/cpuset/kernel/cpus
echo "0-5" > /dev/cpuset/restricted/cpus
echo "0-2" > /dev/cpuset/system-background/cpus
echo "0-7" > /dev/cpuset/top-app/cpus

# Multitasking OOM Groupings Tweak Set Config
ro.FOREGROUND_APP_MEM=6400
ro.VISIBLE_APP_MEM=8960
ro.SECONDARY_SERVER_MEM=14080
ro.BACKUP_APP_MEM=17920
ro.HOME_APP_MEM=3200
ro.HIDDEN_APP_MEM=17920
ro.EMPTY_APP_MEM=64000
ro.PERCEPTIBLE_APP_MEM=3200
ro.HEAVY_WEIGHT_APP_MEM=14080
ro.CONTENT_PROVIDER_MEM=38400
ro.FOREGROUND_APP_ADJ=25
ro.VISIBLE_APP_ADJ=35
ro.SECONDARY_SERVER_ADJ=55
ro.BACKUP_APP_ADJ=56
ro.HOME_APP_ADJ=26
ro.EMPTY_APP_ADJ=69
ro.HIDDEN_APP_MIN_ADJ=250
ro.PERCEPTIBLE_APP_ADJ=27
ro.HEAVY_WEIGHT_APP_ADJ=36
ro.CONTENT_PROVIDER_ADJ=70
ENFORCE_PROCESS_LIMIT=false
MAX_SERVICE_INACTIVITY=false
MIN_HIDDEN_APPS=false
MAX_HIDDEN_APPS=false
CONTENT_APP_IDLE_OFFSET=false
EMPTY_APP_IDLE_OFFSET=false
MAX_ACTIVITIES=false
ACTIVITY_INACTIVE_RESET_TIME=false
MAX_RECENT_TASKS=false
MIN_RECENT_TASKS=false
APP_SWITCH_DELAY_TIME=false
MAX_PROCESSES=false
PROC_START_TIMEOUT=false
CPU_MIN_CHECK_DURATION=false
GC_TIMEOUT=false
SERVICE_TIMEOUT=false
MIN_CRASH_INTERVAL=false

# Increase how much CPU bandwidth (CPU time) realtime scheduling processes are given for slightly improved system stability and minimized chance of system freezes & lockups;
echo "1000000" > /proc/sys/kernel/sched_rt_runtime_us

# FileSystem (FS) optimized tweaks & enhancements for a improved userspace experience;
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time
echo "0" > /proc/sys/kernel/hung_task_timeout_secs

# FSTrim
echo "Trimming data"
sleep 1
busybox fstrim -v /data
echo " "
echo "Trimming Cache"
sleep 1
busybox fstrim -v /cache
echo " "
echo "Trimming System"
sleep 1
busybox fstrim -v /system
echo "Trimmed Succefully"

# Kernel sound settings adjust
echo "10 10" > /sys/kernel/sound_control/headphone_gain
echo "2" > /sys/kernel/sound_control/mic_gain
echo "4" > /sys/kernel/sound_control/earpiece_gain

# Force Stop Some apps in Background
busybox sleep 3
am force-stop com.facebook.lite
am force-stop com.android.chrome
am force-stop com.google.android.apps.docs
am force-stop com.google.android.apps.photos
am force-stop com.facebook.katana
am force-stop com.instagram.android
am force-stop com.google.android.googlequicksearchbox
am force-stop com.google.android.inputmethod.latin

# Wireless Speed Tweaks
setprop net.tcp.buffersize.hsdpa 4096,32768,65536,4096,32768,65536;
setprop net.tcp.buffersize.hspa 4096,32768,65536,4096,32768,65536;
setprop net.tcp.buffersize.hspap 4096,32768,65536,4096,32768,65536;
setprop net.tcp.buffersize.hsupa 4096,32768,65536,4096,32768,65536;
setprop net.tcp.buffersize.umts 4095,87380,110208,4096,32768,110208;
setprop net.tcp.buffersize.default 4094,87380,1220608,4096,32768,1220608;
setprop net.tcp.buffersize.edge 4093,26280,35040,4096,16384,35040;
setprop net.tcp.buffersize.evdo 4093,26280,35040,4096,16384,35040;
setprop net.tcp.buffersize.gprs 4092,8760,11680,4096,8760,11680;
setprop net.tcp.buffersize.wifi 4094,87380,1220608,4096,32768,1220608;

# Gms Blocker 
su -c "pm disable com.google.android.gms/com.google.android.gms.lockbox.service.LockboxBrokerService"
su -c "pm disable com.google.android.gms/com.google.android.gms.ads.cache.CacheBrokerService"
su -c "pm disable com.google.android.gms/com.google.android.gms.ads.AdRequestBrokerService" 
su -c "pm disable com.google.android.gms/com.google.android.gms.icing.service.IndexService"
su -c "pm disable com.google.android.gms/com.google.android.gms.fitness.service.history.FitHistoryBroker"
su -c "pm disable com.google.android.gms/com.google.android.gms.tron.CollectionService"
su -c "pm disable com.google.android.gms/com.google.android.gms.auth.managed.admin.DeviceAdminReceiver"
su -c "pm disable com.google.android.gsf/.update.SystemUpdateActivity"
su -c "pm disable com.google.android.gsf/.update.SystemUpdatePanoActivity" 
su -c "pm disable com.google.android.gsf/.update.SystemUpdateService" 
su -c "pm disable com.google.android.gsf/.update.SystemUpdateService$Receiver"
su -c "pm disable com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver"
su -c "pm disable --user 0 com.google.android.gms/.phenotype.service.sync.PhenotypeConfigurator"
su -c "pm disable com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver"or Android 9 or later);
su -c "pm disable com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver"

# Doze battery life profile;
settings delete global device_idle_constants;
settings put global device_idle_constants inactive_to=60000,sensing_to=0,locating_to=0,location_accuracy=2000,motion_inactive_to=0,idle_after_inactive_to=0,idle_pending_to=60000,max_idle_pending_to=120000,idle_pending_factor=2.0,idle_to=900000,max_idle_to=21600000,idle_factor=2.0,max_temp_app_whitelist_duration=60000,mms_temp_app_whitelist_duration=30000,sms_temp_app_whitelist_duration=20000,light_after_inactive_to=10000,light_pre_idle_to=60000,light_idle_to=180000,light_idle_factor=2.0,light_max_idle_to=900000,light_idle_maintenance_min_budget=30000,light_idle_maintenance_max_budget=60000;

# Enable a tuned Boeffla wakelock blocker at boot for both better active & idle battery life;
#echo "enable_wlan_ws;enable_wlan_wow_wl_ws;enable_wlan_extscan_wl_ws;enable_timerfd_ws;enable_qcom_rx_wakelock_ws;enable_netmgr_wl_ws;enable_netlink_ws;enable_ipa_ws;tftp_server_wakelock;" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker
echo "wlan_pno_wl;wlan_ipa;wcnss_filter_lock;[timerfd];hal_bluetooth_lock;IPA_WS;sensor_ind;wlan;netmgr_wl;qcom_rx_wakelock;SensorService_wakelock;tftp_server_wakelock;wlan_wow_wl;wlan_extscan_wl;" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker
