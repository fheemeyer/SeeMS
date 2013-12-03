ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'App functionality' do
  def app
    Sinatra::Application
  end

  it "displayes admin" do
    get '/admin'
    expect(last_response).to be_ok
  end
end
