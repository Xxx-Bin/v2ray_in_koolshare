#!/bin/sh
# load path environment in dbus databse
eval `dbus export v2ray`
source /koolshare/scripts/base.sh
CONFIG_FILE=/jffs/configs/v2ray.config
FIREWALL_START=/jffs/scripts/firewall-start


run_v2ray(){
    dbus set v2ray_version=$(v2ray -version|cut -c7-13|head -n 1)
    v2ray_count=`ps w |grep '/koolshare/bin/v2ray'|grep -v grep|grep -v watchdog|wc -l`
    if [ "$v2ray_count" -gt 0 ];then
        log "已经在启动"
    else
        echo ${v2ray_config//\\n/} > $CONFIG_FILE
        /koolshare/bin/v2ray --config=$CONFIG_FILE &
        dbus set v2ray_status=$(ps | grep "v2ray"| grep -v "grep")
	    log "启动成功"
    fi
}

start_v2ray(){
   log "---启动进程---"
   run_v2ray
   log "---添加守护进程---"
   if [ $(grep -c 'v2ray_watchdog.sh' /var/spool/cron/crontabs/*) -gt 0 ]; then
   log "守护进程已添加过;"
   else
        cru a v2ray_watchdog "*/2 * * * * /bin/sh /koolshare/scripts/v2ray_watchdog.sh";
   fi
   log "---启动结束---"
}

stop_v2ray(){
   log "---解除守护进程和开机启动---"
   sed -i '/v2ray_watchdog/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
   v2ray=$(ps | grep "v2ray"| grep -v "grep")
   if [ ! -z "$v2ray" ];then
        log "关闭v2ray进程..."
        killall v2ray
        dbus set v2ray_status=""
   fi
   if [ -e "/koolshare/init.d/S165V2ray.sh" ];then
      rm -rf /koolshare/init.d/S165V2ray.sh
   fi
   log "关闭完毕"
}

log(){
    logger -c ${1//-/}
    echo $1
}

case $ACTION in
start)
	start_v2ray
	;;
stop)
	stop_v2ray
	;;
*)
	if [ "$v2ray_enable" == "1" ]; then
		stop_v2ray
		start_v2ray
	else
		stop_v2ray
	fi
	;;

esac
