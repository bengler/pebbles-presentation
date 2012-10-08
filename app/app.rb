#encoding: utf-8

require "sinatra/base"
require "sinatra/reloader"
require 'json'
require "snowball/sinatra"
require 'pebblebed/sinatra'
require 'digest/md5'
require 'sinatra/content_for'
require 'albino'

# A filter to put code in a slide
# :code in haml
# Use double brackets to mark sections as important:
#   this.is.[[importantCode]].youKonw
class HTMLWithAlbino < Redcarpet::Render::HTML
  def block_code(code, language)
    Albino.colorize(code, language || 'text')
  end
end

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)

  set :static, true
  set :public_folder, Proc.new { File.join(root, "../public") }

  set :haml, :layout => :'layouts/main'

  set :markdown, Redcarpet::Markdown.new(HTMLWithAlbino,
       :fenced_code_blocks => true,
        :autolink => true, :space_after_headers => true)

  register Sinatra::Pebblebed

  helpers Sprockets::Helpers

  helpers Sinatra::ContentFor

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

        $memcached.set(options[:cache_key], result) if options[:cache_key]
      end
      result
    end

    # Converts markdown to shower-style slides
    def slidedown(markdown)
      slides = []
      begin
        slide = nil
        markdown.split("\n").each do |line|
          case line
          when /^\#\s+/
            # New slide
            slides << slide if slide
            title = line[1..-1].strip
            if title =~ /^\!\[.*\]\(.*\)/
              # Image slide
              /^\!\[.*\]\((?<image_url>.*)\)/ =~ title
              slide = {:image => image_url, :code => []}
            else
              # Normal slide
              slide = {:code => [], :title => title}
            end
          else
            slide[:code] << line
          end
        end
        slides << slide if slide
      end

      slides.each do |item|
        item[:code] = item[:code].join("\n")
      end

      result = ""
      slides.each_with_index do |slide, i|
        html = "<header><h2>#{slide[:title]}</h2></header>"
        cover = false
        if slide[:code].strip == ''
          # Cover slide
          cover = true
        else
          # Normal slide
          html << markdown(slide[:code])
        end

        if slide[:image]
          # Pure image slide
          html = "<div class='slide cover' id='slide_#{i}'><div><section><img src='#{slide[:image]}'/></section></div></div>"
        else
          # Normal slide
          classes = ['slide']
          classes << 'cover' if cover
          html = "<div class=\"#{classes.join(' ')}\" id=\"slide_#{i}\"><div><section>#{html}</section></div></div>"
        end
        result << html
      end
      result
    end
  end


  get "/" do
    redirect "/presentation/overview"
  end

  get "/presentation/overview" do
    haml :overview, :locals => {source: source(:overview)}
  end

  get "/presentation/frontend" do
    haml :frontend, :locals => {source: source(:frontend)}
  end

  private
  def source(file)
    File.read(File.join(settings.root, "presentations/#{file}.md"))
  end
end
