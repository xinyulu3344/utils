#!/usr/bin/env bash

# 统计TCP重传率

# nstat初始值
nstat_all_init="`nstat -az`"

# 获取初始TcpRetransSegs、TcpOutSegs值
tcp_retrans_segs_temp=`echo "$nstat_all_init" | grep TcpRetransSegs | awk '{print $2}'`
tcp_out_segs_temp=`echo "$nstat_all_init" | grep TcpOutSegs | awk '{print $2}'`

echo ""
echo 初始时间: `date "+%Y-%m-%d %H:%M:%S"`
echo "TcpRetransSegs 初始值: $tcp_retrans_segs_temp"
echo "TcpOutSegs 初始值: $tcp_out_segs_temp"

echo ""

printf "%s\t\t%s\t%s\t%s\t%s\t%s\n" "时间" "当前TCP重传数" "TCP总出包数" "TCP重传差值" "TCP出包差值" "TCP重传率"

while :
do
    sleep 1
    nstat_time=`date "+%Y-%m-%d %H:%M:%S"`
    nstat_all="`nstat -az`"

    tcp_retrans_segs=`echo "$nstat_all" | grep TcpRetransSegs | awk '{print $2}'`
    tcp_out_segs=`echo "$nstat_all" | grep TcpOutSegs | awk '{print $2}'`

    # 获取当前重传数和上一次重传数的差值
    tcp_retrans_segs_sub=$[ tcp_retrans_segs - tcp_retrans_segs_temp ]
    # 获取当前总TCP出包数和上一次出包数的差值
    tcp_out_segs_sub=$[ tcp_out_segs - tcp_out_segs_temp ]

    # 计算TCP重传率
    tcp_retrans_segs_rate=`echo "scale=2;$tcp_retrans_segs_sub/$tcp_out_segs_sub" | bc`

    printf "%s %s\t%d\t%d\t%d\t%d\t%.2f\n" $nstat_time $tcp_retrans_segs $tcp_out_segs $tcp_retrans_segs_sub $tcp_out_segs_sub $tcp_retrans_segs_rate

    tcp_retrans_segs_temp=$tcp_retrans_segs
    tcp_out_segs_temp=$tcp_out_segs

done
