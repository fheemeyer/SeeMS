ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'App functionality' do
  def app
    Sinatra::Application
  end

  before :each do
    @app = Application.new(title: "foo", owner: "foobert")
    @app.save!
  end

  it "displayes admin" do
    get '/admin'
    expect(last_response).to be_ok
  end

  it "displays page" do
    @app.children << ContentPage.new(title: "Testpage", url: "test")
    get "/p/#{Page.last.url}"
    expect(last_response).to be_ok
  end
end
