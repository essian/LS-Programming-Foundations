require "sinatra"
require "sinatra/reloader"
require "yaml"

before do
  @users = YAML.load_file("users.yaml")
end

helpers do
  def count_interests(users)
    users.reduce(0) do |sum, (name, user)|
      sum + user[:interests].size
    end
  end
end

get "/" do
  @users = @users.keys.map(&:to_s)
  erb :users
end

get "/user/:name" do
  name = params[:name].to_sym
  @email = @users[name][:email]
  @interests = @users[name][:interests].join(', ')
  @other_users = @users.keys.map(&:to_s)
  erb :user
end
