# config valid for current version and patch releases of Capistrano
lock "~> 3.11.2"

set :application, 'ShinchokuNote'
set :repo_url, 'https://github.com/furikake6000/ShinchokuNote'
set :deploy_to, '/ShinchokuNote'
set :use_sudo, false  # docker内部の実行のためsudoは不要

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle'
set :bundle_path, -> { shared_path.join('bundle') }
