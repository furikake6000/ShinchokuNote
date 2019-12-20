namespace :deploy do
  desc "pull from github"
  task :git_pull do
    run_locally do
      execute "cd #{deploy_to}; git pull"
    end
  end

  # capistrano/railsにもうあった
  # desc "db migration"
  # task :db_migration do
  #   run_locally do
      
  #   end
  # end

  desc "restart puma server"
  task :restart_server do
    run_locally do
      execute 'bundle exec pumactl restart'
    end
  end
end