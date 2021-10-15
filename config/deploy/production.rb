server "159.65.198.28", user: "deployer", roles: %w{app db web}, primary: true
set :rail_env, :production
set :branch, 'main'

set :ssh_options, {
  keys: %w(/Users/ppopeskul/.ssh/personal.pub),
  forward_agent: true,
  auth_methods: %w(publickey password),
  port: 2222
}
