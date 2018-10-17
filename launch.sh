while getopts hpc OPT
do
    case $OPT in
        "h" ) FLG_HELP="TRUE" ;;
        "p" ) FLG_PRECOMPILE="TRUE" ;;
        "c" ) FLG_CRON_UPDATE="TRUE" ;;
    esac
done

# ヘルプ表示
if [ "$FLG_HELP" = "TRUE" ]; then
    echo ''
    echo 'Usage:'
    echo 'launch.sh [-h] [-p] [-c] rails_master_key'
    echo '  -h: help'
    echo '  -p: with precompile(when .js or .css or figs updated)'
    echo '  -c: with crontab update'
    echo ''
    exit 0
fi

# 引数の数の確認
shift `expr $OPTIND - 1`
if [ $# -ne 1 ]; then
    echo "RAILS_MASTER_KEYを指定してください。"
    exit 1
fi

# rails起動の確認
if [ -e "/tmp/pids/server.pid" ]; then
    echo "既にサーバーが起動しています。サーバのプロセスIDは"
    cat "/tmp/pids/server.pid"
    echo "です。"
    exit 1
fi

# アセットの明示的プリコンパイル
if [ "$FLG_PRECOMPILE" = "TRUE" ]; then
    bundle exec rake assets:clobber RAILS_ENV=production RAILS_MASTER_KEY=$1
    bundle exec rake assets:precompile RAILS_ENV=production RAILS_MASTER_KEY=$1
fi

# crontab update
if [ "$FLG_CRON_UPDATE" = "TRUE" ]; then
    bundle exec whenever --update-crontab 
fi

# db:migrate
RAILS_ENV=production RAILS_MASTER_KEY=$1 rails db:migrate

# サーバ起動
RAILS_ENV=production RAILS_MASTER_KEY=$1 RAILS_SERVE_STATIC_FILES=true rails s &