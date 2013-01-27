#!/usr/bin/env/ ruby
require 'rack'

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
		File.open("form.html", "rb"){ |form| response.write(form.read)}
		response.finish
	end

	def render_list(request)
		response = Rack::Response.new
		values = request.params
		file = File.open("top_100_albums.txt")
		albums = Array.new
		sort= values["order"]
		selected = values["rank"]
		response.write("<html>
			<head>
			<title>Rolling Stone's Top 100 Albums of All Time</title>
			</head>
			<body>")
			file.each do |line|
				response.write("<p>"+line+"</p>")
			end






		response.write("</body></html>")
		response['Content-Type'] = 'text/html'
		response.finish
	end

	def render_404
		[404, {"Content-Type" => "text/plain"}, ["Nothing here!"]]
	end
end


Rack::Handler::WEBrick.run AlbumApp.new, :Port => 8080