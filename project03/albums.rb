#!/usr/bin/env ruby
require 'rack'
require 'sqlite3'
require_relative 'album'

class AlbumApp
  def call(env)
    request = Rack::Request.new(env)
    case request.path
    when "/form" then render_form(request)
    when "/list" then render_list(request)
    else render_404
    end
  end

  def render_form(request)
    response = Rack::Response.new
    file = File.open("form.erb.html", "rb")
    code = file.read
    file.close
    code = ERB.new(code).result(binding)
	[200, {"Content-Type"=>"text/html"}, [code]]


  end

  def render_list(request)
    sort_order = request.params['order']
    rank_to_highlight = request.params['rank'].to_i

    file = File.open("list.erb.html", "rb")
    code = file.read
    file.close


    #albums = File.readlines("top_100_albums.txt").each_with_index.map { |record, i| Album.new(i + 1, record) }
    db = SQLite3::Database.new( "albums.sqlite3.db" )
    db.results_as_hash = true
    sorted_list = Array.new()


	case sort_order 
	when 'title' 
    result_set = db.execute("SELECT * FROM albums ORDER BY title") 
    sorted_list = result_set.map { |record| Album.new(record['rank'], record['title'], record['year'])}
	when 'rank'
    result_set = db.execute("SELECT * FROM albums ORDER BY rank") 
    sorted_list = result_set.map { |record| Album.new(record['rank'], record['title'], record['year'])}
  else
    result_set = db.execute("SELECT * FROM albums ORDER BY year") 
    sorted_list = result_set.map { |record| Album.new(record['rank'], record['title'], record['year'])}
	end
   
   code = ERB.new(code).result(binding)
   [200, {"Content-Type"=>"text/html"}, [code]]
    
  end

  def render_404
    [404, {"Content-Type" => "text/plain"}, ["Nothing here!"]]
  end



  def row_tag_for(album, rank_to_highlight)
    album.rank == rank_to_highlight ? "\t<tr class=\"highlighted\">\n" : "\t<tr>\n"
  end

end

Signal.trap('INT') { Rack::Handler::WEBrick.shutdown } # Ctrl-C to quit
Rack::Handler::WEBrick.run AlbumApp.new, :Port => 8080