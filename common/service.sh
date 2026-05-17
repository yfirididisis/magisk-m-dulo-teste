#!/system/bin/sh
MODDIR=${0%/*}
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 2
done
# Executa o script de inicialização do Spectrum
sh $MODDIR/init.spectrum.sh &
