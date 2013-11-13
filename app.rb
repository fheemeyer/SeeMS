require "sinatra"
require "sinatra/contrib"
require "sass"
include FileUtils

# Styles
get '/*.css' do
  scss "#{params[:splat].first}".to_sym
end

# Pages
get '/' do
  @page = :index
  erb :index, {layout: :layout}
end

get '/about' do
  @page = :about
  erb :about, {layout: :layout}
end

get '/practice' do
  @page = :practice
  erb :practice, {layout: :layout}
end

get '/philosophy' do
  @page = :philosophy
  erb :philosophy, {layout: :layout}
end

get '/concept' do
  @page = :concept
  erb :concept, {layout: :layout}
end

get '/costs' do
  @page = :costs
  erb :costs, {layout: :layout}
end

get '/contact' do
  @page = :contact
  erb :about, {layout: :layout}
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
