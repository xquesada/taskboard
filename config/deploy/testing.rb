namespace :deploy do
    set :application, "taskboard"
    set :repository,  "http://dev.agilar.org/svn/#{application}/"

    # If you aren't deploying to /u/apps/#{application} on the target
    # servers (which is the default), you can specify the actual location
    # via the :deploy_to variable:
    set :deploy_to, "/var/www/rails/#{application}/testing"

    # If you aren't using Subversion to manage your source code, specify
    # your SCM below:
    set :scm, :subversion
    set :scm_username, "deploy"
    set :scm_password, "dpl.925"
    set :use_sudo, false
    
    begin 
      url = URI.parse('http://hudson.dev.agilar.org:8080')
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.get('/job/Agilar%20Taskboard%20-%20Continuous%20Integration/lastStableBuild/api/xml')
      }
      res.body.match(/<revision>[0-9]*<\/revision>/)
      
      revision = $~.to_s.gsub("<revision>",'').gsub("</revision>", '').to_i
      
      set :revision, revision
    rescue
      raise ProblemAccessingHudson
    end
    
    server "dev.agilar.org", :app, :web, :db, :primary => true

    set :user, "deploy"


   desc "Restarting mod_rails with restart.txt"
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "touch #{current_path}/tmp/restart.txt"
   end

  task :create_member_pictures_symlink do
   run "ln -s #{deploy_to}/shared/images/members #{deploy_to}/current/public/images/"
  end

  task :rake_db_migrate do
    run "cd #{current_path}/ && rake RAILS_ENV=\"testing\" db:migrate"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  after "deploy:update", "deploy:rake_db_migrate", "deploy:create_member_pictures_symlink"
end