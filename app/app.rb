#encoding: utf-8

require "sinatra/base"
require "sinatra/reloader"
require 'json'
require "snowball/sinatra"
require 'pebblebed/sinatra'
require 'digest/md5'

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
    # Github Flavored Markdown
    def gfm(text)

      # Extract pre blocks
      extractions = {}
      text.gsub!(%r{<pre>.*?</pre>}m) do |match|
        md5 = Digest::MD5.hexdigest(match)
        extractions[md5] = match
        "{gfm-extraction-#{md5}}"
      end

      # prevent foo_bar_baz from ending up with an italic word in the middle
      text.gsub!(/(^(?! {4}|\t)\w+_\w+_\w[\w_]*)/) do |x|
        x.gsub('_', '\_') if x.split('').sort.to_s[0..1] == '__'
      end

      # in very clear cases, let newlines become <br /> tags
      text.gsub!(/(\A|^$\n)(^\w[^\n]*\n)(^\w[^\n]*$)+/m) do |x|
        x.gsub(/^(.+)$/, "\\1  ")
      end

      # Insert pre block extractions
      text.gsub!(/\{gfm-extraction-([0-9a-f]{32})\}/) do
        extractions[$1]
      end

      text
    end

    def markdown(source, options = {})
      result = nil
      result = $memcached.get(options[:cache_key]) if options[:cache_key]
      unless result
        result = settings.markdown.render(gfm(source))

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

  get "/presentation/:file" do |file|
    source = File.read(File.join(settings.root, "presentations/#{file}.md"))
    haml :slidedown, :locals => { :source => source }
  end

end
