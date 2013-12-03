require "sinatra"
require "sinatra/contrib"
require "sinatra/reloader" if development?
require "sass"
require "mongoid"
require "pry"
require_relative "models/init"
include FileUtils

Mongoid.load!  File.join(File.dirname(__FILE__), 'config', 'mongoid.yml')

set :bind, '0.0.0.0'
set :env, :development

before do
  unless Application.first
    Application.new(:title => "Foo").save!
  end

  @app = Application.first
  @pages = @app.children_sorted
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
      @app.update_children(params[:application][:child_ids])
    end
    @app.save!
  end

  get '/pages/:page_id/edit' do
    @page = Page.find(params[:page_id])
    erb :edit_page, {layout: :layout}
  end

  post '/pages/:page_id/update' do
    @page = Page.find(params[:page_id])
    if params[:page][:child_ids]
      @page.update_children(params[:application][:child_ids])
    end
    @page.save!
  end

  get '/pages' do
    @pages.to_json(include: :children)
  end

  post '/pages/create' do
    if(params["page"]["type"] == "content")
      ContentPage.new(params["page"]).save!
    else
      params["page"]["parent"] = @app.id
      NavigationPage.new(params["page"]).save!
    end

    Page.find(params["page"]["parent"]).children << Page.last

    "true"
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
