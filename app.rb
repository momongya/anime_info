require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'date'
require 'net/http'
require 'uri'

get '/' do
    base_url = 'http://api.moemoe.tokyo/anime/v1/master/' + Date.today.year.to_s + '/' + Date.today.month.div(3).to_s
    puts base_url
    url = URI.parse(base_url)
    returned_json = Net::HTTP.get(url).force_encoding("utf-8")
    hash_data = JSON.parse(returned_json)  # RubyのHashに変換している
    @result = []
    hash_data.each do |res|
        if res["title"].include?(params[:keyword])
            @result.push(res["title"])
        end
    end
    erb :index
end