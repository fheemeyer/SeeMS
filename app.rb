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
set :env, :development

before do
  unless Application.first
    Application.new(:title => "Foo").save!
  end

  @app = Application.first
  @pages = @app.children
end

get '/favicon.ico' do
end

# Styles
get '/*.css' do
  scss "#{params[:splat].first}".to_sym
end

# Pages
get '/p/:page' do
  @page = Page.where(url: params[:page]).first
  @page_title = @page.url

  erb :page, {layout: :layout}
end

# Admin Corner
namespace '/admin' do
  get '' do
    @page_title = "admin"
    erb :admin, {layout: :layout}
  end

  post '/app/update' do
    if params[:application][:child_ids]
      @app.child_ids = params[:application][:child_ids].map!{|id| Moped::BSON::ObjectId.from_string(id)}
    end
    @app.save!
  end

  get '/pages' do
    @pages.to_json
  end

  post '/pages/create' do
    if(params["page"]["type"] == "content")
      @new_page = ContentPage.new(params["page"]).save!
    else
      @new_page = NavigationPage.new(params["page"]).save!
    end

    "true"
  end

  get '/:page/children' do
    Page.find(params[:page]).children.to_json
  end
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
