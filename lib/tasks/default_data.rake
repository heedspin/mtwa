namespace :default_data do
  desc "Load all default data"
  task :all => %w(users content_modules).map{ |task| "default_data:#{task}" }

  desc "Load default users"
  task :users => :environment do
    users = [
      ['Robo', 'Mailer', AppConfig.email_address],
      ['Tim', 'Harrison', 'heedspin@gmail.com', 'password123'],
    ]

    users.each do |user|
      next if User.find_by_email(user[2])
      u = User.new
      u.first_name = user[0]
      u.last_name = user[1]
      u.email = user[2]
      u.user_role_id = UserRole.admin.id
      u.user_status_id = UserStatus.active.id
      if (password = user[3]) and u.crypted_password.nil?
        u.password = u.password_confirmation = password
      end
      u.save(false)
    end
  end

  desc 'Create all the content modules'
  task :content_modules => [ :environment ] do
    [ { :key => 'home', :description => "The home page"},
      { :key => 'quote_request', :description => 'The Quote Request page', :title => 'Contact Us / Request A Quote',
        :content => <<-HTML
        <p>You can contact us directly or use the form below to request a quote.</p>
        HTML
        },
      { :key => 'home1', :description => 'Home Page Column 1', :title => '',
        :has_meta_title => true, :has_meta_description => true,
        :content => <<-HTML
        <p>Hi</p>
        HTML
        },
      { :key => 'home2', :description => 'Home Page Column 2', :has_meta_description => false,
        :title => 'Our Services & Expertise',
        :content => <<-HTML
        <ul>
        <li>hi 2</li>
        </ul>
        HTML
        }
    ].each do |config|
      ContentModule.make! config
    end
  end
end
