require "sinatra"
require "sinatra/contrib"
require "sinatra/reloader" if development?
require "sass"
require "mongoid"
require "pry"
require_relative "models/init"
include FileUtils

Mongoid.load!('config/mongoid.yml')

set :bind, '0.0.0.0'

before do
  unless Application.first
    Application.new(:title => "Foo").save!
  end

  @app = Application.first
  @pages = @app.pages
end

# Styles
get '/*.css' do
  scss "#{params[:splat].first}".to_sym
end

# Pages
get '/p/:page' do

end

# Admin Corner
get '/admin' do
  @page = :admin
  erb :admin, {layout: :layout}
end

post '/admin/app/update' do
  @app.update_attributes(params[:application])
end

post '/admin/pages/create' do
  if(params["page"]["type"] == "content")
    @new_page = ContentPage.new(params["page"])
  else
    @new_page = NavigationPage.new(params["page"])
  end

  @new_page.save
  @app.pages << @new_page
end

get '/admin/pages' do
  @pages.to_json
end

# Additional
get '/' do
  @page = :index
  erb :index, {layout: :layout}
end

get '/imprint' do
  @page = :imprint
  erb :imprint, {layout: :layout}
end

get '/test' do
  @page = :test
  erb :test, {layout: :layout}
end

# Helpers
helpers do
  def protect!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['fzumk', 'ephk1']
  end
end
