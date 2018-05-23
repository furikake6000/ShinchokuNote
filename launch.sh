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
bundle exec rake assets:clobber RAILS_ENV=production RAILS_MASTER_KEY=$1
bundle exec rake assets:precompile RAILS_ENV=production RAILS_MASTER_KEY=$1
# サーバ起動
rails s RAILS_ENV=production RAILS_MASTER_KEY=$1 RAILS_SERVE_STATIC_FILES=true &