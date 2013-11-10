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
  @images = []
  path = '/uploads/'
  Dir.foreach("public"+path) {|e| @images << path+e if e =~ /jpg|png|gif/}
  @images = @images.shuffle
  erb :index, {layout: :layout}
end

get '/upload' do
  protect!
  @page = :upload
  erb :upload, {layout: :layout}
end

post '/upload' do
  protect!
  file = params[:file][:tempfile]
  filename = params[:file][:filename]
  cp file.path, "public/uploads/#{filename}"
  "Successfully uploaded #{filename}"
end

get '/write' do
  @page = :write
  erb :write, {layout: :layout}
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
