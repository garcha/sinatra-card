require 'sinatra'
require 'sinatra/activerecord'
require './environments'

class Card < ActiveRecord::Base
end

get "/" do
  @cards = Card.order("created_at DESC")
  @title = "Welcome"
  erb :"cards/index"
end

helpers do
  def title
    if @title
      "#@{title}"
    else
      "Welcome"
    end
  end
end
