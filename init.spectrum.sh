#!/system/bin/sh

# Wait for the system to fully boot
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 2
done

# Set the default profile (0 = Balance)
setprop persist.spectrum.profile 0
