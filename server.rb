require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/cross_origin'
require "sinatra/namespace"
require './models/db'
require 'net/http'
require 'json'

url = 'http://www.omdbapi.com/?apikey=c51d871e&t=';

before do
  headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
end

options '*' do
  response.headers['Allow'] = 'HEAD,GET,PUT,DELETE,OPTIONS,POST'
  response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
end

namespace '/api/v1' do
 
  before do
    content_type 'application/json'
  end

  get '/movie-search/:title' do  
    #DB query to find movie by title
    #count the response, if the count is 1, means the movie is exist, if count is 0, means it does not exist
    movies = Movie.where(Title: params[:title]) 
    #these makes sure it is always lowecase
    if movies.count  > 0
      #return the response from the database
      movies.first.to_json
      #content_type :json
      #Movie_by_Title(params[:Title]).to_json
    else
      uri = URI(url + params[:title])
      response = Net::HTTP.get(uri)
      response
    end
  end

  get '/movies' do
    Movie.all.to_json
  end

  post '/movies' do
    params = JSON.parse request.body.read
    if params['id']
      movie = Movie.where(Title: params['Title']).first
      movie.update(comment: params['comment'], rating: params['rating'])
      movie.to_json
    else
      Movie.create(params)
    end
  end

  delete '/movies' do
    params = JSON.parse request.body.read
    movie = Movie.where(Title: params['Title'])
    movie.destroy
  end
end