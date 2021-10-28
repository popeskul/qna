lock "~> 3.16.0"

set :application, "qna"
set :repo_url, "git@github.com:popeskul/qna.git"

set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'

append :linked_files, "config/database.yml", 'config/master.key'

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", 'storage'

set :pty, false

set :rvm_ruby_version, "2.7.3@#{fetch(:application)}"

after 'deploy:publishing', 'unicorn:restart'
