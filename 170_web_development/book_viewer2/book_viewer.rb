require "sinatra"
require "sinatra/reloader"

get "/" do
  @contents = File.readlines("data/toc.txt")
  erb :home
end

get "/chapters/1" do
  @title = "Chapter 1"
  @contents = File.readlines("data/toc.txt")
  @chapter = File.read("data/chp1.txt")
  erb :chapter
end
