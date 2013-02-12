require 'sinatra'
require 'data_mapper'
require_relative 'Album.rb'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/albums.sqlite3.db")

set :port, 8080

get "/" do
	"Sinartra is working"
end