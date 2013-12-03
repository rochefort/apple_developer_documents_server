require 'sinatra/base'
require 'dalli'
require 'json'
require './apple_developer_documents'

class App < Sinatra::Base
  configure do
    options = { :namespace => 'apple_developer_documents', :compress => true }
    set :cache, Dalli::Client.new('localhost:11211', options)
  end

  # /api/apple_developer_documents.json
  get '/api/apple_developer_documents.json' do
    content_type :json
    p request.user_agent
    not_found unless request.user_agent.match(/iPad|iPhone|iPod/)
    { apple_developer_documents: get_documents }.to_json
  end

  post '/api/apple_developer_documents' do
    crawl
  end

  not_found do
    "Whoops! #{request.path} is not available."
  end

  private
    def get_documents
      settings.cache.get('data') || crawl
      rescue
        # when memcached stop
        # todo: logging
        puts '-- warning memcached stopped'
        AppleDeveloperDocuments.crawl
    end

    def crawl
      data = AppleDeveloperDocuments.crawl
      settings.cache.set('data', data)
      rescue Dalli::RingError => e
        puts '-- warning memcached stopped'
      rescue => e
        puts '-- warning crawl is failed'
    end
end
