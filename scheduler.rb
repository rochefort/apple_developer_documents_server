require './apple_developer_documents'
require 'dalli'

def crawl
  options = { :namespace => 'apple_developer_documents', :compress => true }
  cache = Dalli::Client.new('localhost:11211', options)

  data = AppleDeveloperDocuments.crawl
  cache.set('data', data)
  rescue Dalli::RingError => e
    puts '-- warning memcached stopped'
  rescue => e
    puts '-- warning crawl is failed'
    p e
end

crawl
