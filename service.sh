#!/system/bin/sh
MODDIR=${0%/*}
cd "$MODDIR"
exec 2>>"$MODDIR/LOG.log"

path="/data/data/me.piebridge.brevent"

# Start Time
echo "<$(date)> ReStart" > "$MODDIR/LOG.log"

# Print log
RunError="AutoBrevent Server Error: Service Run error. "
PackageError="AutoBrevent Server Error: Brevent not find. Please Cat the Log"
RunOk="AutoBrevent Server: Brevent is Run"

# Wait boot=1
while [ ! -d "/storage/emulated/0/Android/data" ]; do
    sleep 5
done

# Off SELinux
[ "$(getenforce)" = "Enforcing" ] && setenforce 0 && OffSelinux=1

# Server
if pm list package -3 | grep me.piebridge.brevent >/dev/null 2>&1; then
    # Run Brevent
    if [ -f "$path/brevent.sh" ]; then
        if sh "$path/brevent.sh" >/dev/null 2>&1; then
            echo "$RunOk" > "$MODDIR/LOG.log"
        else
            echo "$RunError" > "$MODDIR/LOG.log"
        fi
    else
        echo "$RunError" > "$MODDIR/LOG.log"
    fi
else
    # No Install Brevent
    echo "$PackageError" > "$MODDIR/LOG.log"
fi

# Reset SELinux
[ "$OffSelinux" = 1 ] && setenforce 1
