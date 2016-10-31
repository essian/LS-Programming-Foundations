require "sinatra"
require "sinatra/reloader"


helpers do
  def say_hello
    "hello"
  end
end
get "/" do
  params[:jess] = "one two three"
  erb :index
  puts "hello world"
end
