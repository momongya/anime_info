require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'date'
require 'net/http'
require 'uri'

def call_api
    base_url = 'https://api.moemoe.tokyo/anime/v1/master/' + Date.today.year.to_s + '/' + Date.today.month.div(3).to_s
    url = URI.parse(base_url)
    returned_json = Net::HTTP.get(url).force_encoding("utf-8")
    hash_data = JSON.parse(returned_json)
    return hash_data
end

get '/' do
    @result = []
    api_data = call_api
    if params[:keyword]
        api_data.each do |res|
            if res["title"].include?(params[:keyword])
                @result.push(res)
            end
        end
    end
    erb :index
end

get '/info/:id' do
    api_data = call_api
    api_data.each do |res|
        if res["id"] == params[:id].to_i
            @info = res
        end
    end
    erb :info
end