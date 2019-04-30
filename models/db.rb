require 'mongoid'
require 'sinatra'

# DB Setup
Mongoid.load! "mongoid.config"

# Models
class Movie
  include Mongoid::Document
  field :Title, :type => String
  field :Year, :type => String
  field :Poster, :type => String
  field :Plot, :type => String
  field :rating, :type => String
  field :comment, :type => String
end
