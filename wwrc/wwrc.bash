## NOTE extern ww_host=""
alias l='ls -CF'

{
  ## ANCHOR mod log
  ss=/data/rizhiyi/logs/splserver/splserver.log

  ftp=/data/rizhiyi/logs/flink_taskmanager
  ft=$ftp/flink_taskmanager.log
  fty=$ftp/yottabyte.log

  fj=/data/rizhiyi/logs/flink_jobmanager/flink_jobmanager.log

  begin=$(date -d "1 hour ago" +'%Y-%m-%d %H')
  today=$(date +'%Y-%m-%d')

  function tdl() {
    local log_path=$1
    [ -z "$log_path" ] && return $?
    sed -n "/^$begin/,\$p" $log_path
  }

  alias stdl="tdl $ss | less"
  ## ANCHOR mod end
}

{
  ## ANCHOR mod dict
  case "$ww_host" in
  rzy_179)
    dict_csv_path=/data/rizhiyi/5.0/data/rizhiyi/spldata/dictionary/1/files
    ;;
  *)
    dict_csv_path=/data/rizhiyi/spldata/dictionary/1/files
    ;;
  esac

  function dict() {
    cd $dict_csv_path
  }
  ## ANCHOR mod end

  {
    ## ANCHOR mod lrv
    lrv=/data/rizhiyi/logs/logriver/logriver.log
    lrvr=/data/rizhiyi/logs/logriver/request.log
    ops_path=/data/rizhiyi/logparser/plugin/ops
    function ops() {
      cd $ops_path
    }

    ops_path=
    if [ "$ww_host" = "root_179" ]; then
      ops_path=/data/rizhiyi/4.8/data/rizhiyi/logparser/plugin/ops
    fi
    function untar_and_privileges() {
      local dst=$1
      if [ -z "$dst" ]; then
        return 1
      fi
      tar -xzvf "$dst.tar.gz"
      (
        chown rizhiyi:root -R "$dst"
      )
    }
    ## ANCHOR end
  }
  {
    ## ANCHOR mod java bin
    function jb() {
      local jc=$1
      local args="$@"
      local java_bin_path=/opt/rizhiyi/java/bin
      $java_bin_path/$jc "${args[@]}"
    }
    ## ANCHOR end
  }
}
