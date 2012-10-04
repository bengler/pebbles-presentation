namespace :snowball do
  target = './public/admin.js'
  entryfile = './app/assets/js/admin.coffee'

  desc "Roll a new javascript bundle"
  task :roll do
    require "uglifier"
    require "snowball/roller"
    puts "Rolling..."
    File.open(target, 'w') do |f|
      f.write(Uglifier.compile(Snowball::Roller.new(entryfile).roll))
    end
    puts "Done!"
  end
end

namespace :assets do
  desc "Create publilc folder"
  task :create_public_folder do
    FileUtils.mkdir_p("./public")
  end

  desc "Build static assets"
  task :compile => ["assets:create_public_folder", "snowball:roll"]
end