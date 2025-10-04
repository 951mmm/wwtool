idea_bin=/opt/ww/idea-IC-251.27812.49/bin/idea
log_path=$HOME/Public/cgroup-wrapper/idea.log

start_up_cpu_core=6
runing_cpu_core=3.7
mem_max=4G
start_up_sec=10
unit_name=idea-cgrouped
scope_name="$unit_name.scope"

function cal_quota() {
  local core_num="$1"
  echo "$((core_num * 100))%"
}

(
  sleep $start_up_sec
  systemctl \
    --user \
    set-property "$scope_name" \
    CPUQuota="$(cal_quota $runing_cpu_core)"
) &

systemd-run \
  --user \
  --scope \
  --unit "$unit_name" \
  --property=CPUQuota="$(cal_quota $start_up_cpu_core)" \
  --property=MemoryMax="$mem_max" \
  $idea_bin >>$log_path 2>&1
