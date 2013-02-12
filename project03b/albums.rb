require 'sinatra'
require 'data_mapper'
require_relative 'Album.rb'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/albums.sqlite3.db")

set :port, 8080

get "/" do
	"Sinartra is working"
end

get "/form" do
	erb :form
end

post "/list" do
	@order = params[:order]
	@highlight = params[:rank]
	@albums = Album.all(:order => params[:order].intern.asc)
	erb :list
end