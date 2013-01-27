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
		#sets up basic constant
		response = Rack::Response.new
		values = request.params
		file = File.open("top_100_albums.txt")
		sort= values["order"]
		selected = values["rank"]
		#function to create hash table of all albums
		albums = createAlbumHash(file)
		#write the beginning of the html file
		response.write("<html>
			<head>
			<title>Rolling Stone's Top 100 Albums of All Time</title>
			</head>
			<body>

			<h1> Rolling Stone's Top 100 Albums of All Time </h1>")

			#TODO: figure out how it is sorted and print it
			case sort
			when "name" then albums.sort_by! {|album| album["name"]}
			when "year" then albums.sort_by! {|album| album["name"]}
			else
				#do nothing because it is sorting by rank and that is default
			end

			#write what it is being sorted by
			response.write("<h3>Sorted by "+sort+"</h3>")

			#write beginning of table
			response.write("<table id=albumTable>")

			#write out each rank, line and year of album
			albums.each do |record|
				response.write("<tr>
									<td>#{record["rank"]}</td>
									<td>#{record["name"]}</td>
									<td>#{record["year"]}</td>
								</tr>")
			end
			response.write("</table>")
		#writes the end of the html file
		response.write("</body></html>")
		response['Content-Type'] = 'text/html'
		response.finish
	end

	def render_404
		[404, {"Content-Type" => "text/plain"}, ["Nothing here!"]]
	end

	def createAlbumHash (file)
		rank = 1
		albums = Array.new
		file.each do |line|
			album = Hash.new
			album["rank"]=rank
			album["name"]=line.split(",")[0]
			album["year"]=line.split(",")[1].strip
			albums << album
			rank+=1
		end
		#yes I know the return is not needed but it makes me sleep better at night
		return albums
	end
end


Rack::Handler::WEBrick.run AlbumApp.new, :Port => 8080