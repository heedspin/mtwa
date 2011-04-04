require 'yaml'

def chef_cloud_attributes(instance_type)

  case instance_type
  when 'vagrant'
    @app[:url] = 'mtwa.local'
  end

  return {
    :ec2 => false,
    :lsb => { :code_name  => 'lucid' },
    :bootstrap => {:chef => {:client_version => '0.9.12'}},
    :fqdn => @app[:url],
    :hostname => @app[:name],
    :chef => { :roles => ['vagrant', 'app', 'database'], 
      :log_level => :debug 
    },
    :ubuntu => { :servers => [
                   {:ip => '127.0.0.1', :fqdn => @app[:url], :alias => @app[:name]},
                   {:ip => '127.0.1.1', :fqdn => 'vagrantup.com', :alias => 'vagrantup'},
                   {:ip => '127.0.0.1', :fqdn => "database.#{@app[:name]}.internal", :alias => 'database'},
                   {:ip => '127.0.0.1', :fqdn => "app.#{@app[:name]}.internal",      :alias => 'app'}
                 ],
                 :database => { :fqdn => "database.#{@app[:name]}.internal" },
                 :mysql => true,
                 :users => { :accounts => {} }
                 },
    :app => { :root_dir => "/var/www/apps/#{@app[:name]}", :app_name => @app[:name], :url => @app[:url] },
    :server => { :name => "#{@app[:name]}_#{@rails_env}" },
    :authorization => { :sudo => { :groups => ['admin'], :users => ['vagrant'] } },
    :ruby => { :version => 'ree' },
    :apache => {
      :vhost_port     => @app[:server_port],
      :vhosts         => [
        { :server_name    => @app[:url],
          :server_aliases => '',
          :docroot        => "/var/www/apps/#{@app[:name]}/public",
          :name           => @app[:url]
          }
      ],
      :server_name    => @app[:url],
      :web_dir        => '/var/www',
      :docroot        => "/var/www/apps/#{@app[:name]}/public",
      :name           => @app[:name],
      :enable_mods    => ["rewrite", "deflate", "expires"],
      :prefork => {
        :startservers        => 128,
        :minspareservers     => 32,
        :maxspareservers     => 128
      }
    },
    :rails => {
      :environment  => @rails_env,
      :db_adapter   => 'mysql',
      :version      => '3.0.4',
      :using_shared => false,
      :app_root_dir => "/var/www/apps/#{@app[:name]}",
      :db_directory => "/var/www/apps/#{@app[:name]}"
    },
    :mysql  => {
      :bind_address           => "database.#{@app[:name]}.internal",
      :database_name          => "#{@app[:name]}_#{@rails_env}",
      :server_root_password   => '',
      :server_repl_password   => '',
      :server_debian_password => '',
      :tunable => {
        :query_cache_size        => '40M',
        :tmp_table_size          => '100M',
        :max_heap_table_size     => '100M',
        :innodb_buffer_pool_size => '1GB'
      }
    },
    :passenger_enterprise => {
      :version => '3.0.2',
      :pool_idle_time => 100000,
      :max_requests   => 10000,
      :max_pool_size  => 10,
      :packages => %w(apache2-threaded-dev libapr1-dev libaprutil1-dev libcurl4-openssl-dev) # added libcurl4-openssl-dev
    },
    :ruby_enterprise => {
      :version => '1.8.7-2011.01',
      :url => 'http://rubyenterpriseedition.googlecode.com/files/ruby-enterprise-1.8.7-2011.01' # do not include extensions
    },
    :git => {
      :version => '1.7.4.1',
      :packages => %w(build-dep git-core tcllib), # added tcllib
      :install_from_source => false
    }
  }
end

Vagrant::Config.run do |config|
  @app = {}
  @app[:name] = 'mtwa'
  @app[:sever_port] = 80
  @rails_env = 'development'  
  
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "lucid64"

  # Assign this VM to a host only network IP, allowing you to access it
  # via the IP.
  config.vm.network "33.33.33.04"

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.forward_port "http", 80, 8080

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  config.vm.share_folder("app-data", "/var/www/apps/#{@app[:name]}", ".")
  config.vm.share_folder("home-dir", "/home/vagrant/home", "..")
  config.vm.share_folder("bundler-dir", "/home/vagrant/.bundler", "tmp/vagrant_bundler")

  # Enable provisioning with chef solo, specifying a cookbooks path (relative
  # to this Vagrantfile), and adding some recipes and/or roles.
  #
  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.cookbooks_path = "vendor/cookbooks"
    recipes = ["apt",
               "ubuntu",
               "openssl",
               "mysql::server",
               "apache2",
               "passenger_enterprise::apache2",
               'git',
               'rails'] # "rubygems"
    recipes.each do |recipe|
      chef.add_recipe(recipe)
    end

    # config.chef.add_role "web"

    # We need to pass our attributes for chef to set up properly
    chef.json.merge!( chef_cloud_attributes('vagrant') )
  end

end
