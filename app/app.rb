require "sinatra/base"
require "sinatra/reloader"
require 'json'
require "snowball/sinatra"
require 'pebblebed/sinatra'

# A filter to put code in a slide
# :code in haml
# Use double brackets to mark sections as important:
#   this.is.[[importantCode]].youKonw
module Haml::Filters::Code
  include Haml::Filters::Base

  def render(text)
    result = "<pre>"
    text.split("\n").each do |line|
      line = CGI.escapeHTML(line)
      line.gsub!(/\[\[.*?\]\]/) do |fragment|
        "<mark class='important'>#{fragment[2..-3]}</mark>"
      end
      result << "<code>#{line}</code>"
    end
    result << "</pre>"
    result
  end
end

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)

  set :static, true
  set :public_folder, Proc.new { File.join(root, "../public") }

  set :haml, :layout => :'layouts/main'

  set :markdown, Redcarpet::Markdown.new(Redcarpet::Render::HTML,
        :autolink => true, :space_after_headers => true)

  register Sinatra::Pebblebed

  helpers Sprockets::Helpers

  register Sinatra::Snowball
  snowball do
    set_serve_path "/js"
    add_load_path "app/assets/js"
  end

  configure :development do
    register Sinatra::Reloader
  end

  helpers do
    def markdown(source, options = {})
      result = nil
      result = $memcached.get(options[:cache_key]) if options[:cache_key]
      unless result
        result = settings.markdown.render(source)
        $memcached.set(options[:cache_key], result)
      end
      result
    end
  end

  get "/" do
    redirect "/overview"
  end

  get '/overview' do
    haml :overview
  end

end
