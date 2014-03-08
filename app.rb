require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

enable :sessions

class Card < ActiveRecord::Base
  validates :name, presence: true
  validates :phone, presence: true
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

get "/cards/create" do
 @title = "Create card"
 @card = Card.new
 erb :"cards/create"
end

post "/cards" do
 @card = Card.new(params[:card])
 if @card.save
   redirect "cards/#{@card.id}", :notice => 'Congrats! Love the new post. (This message will disapear in 4 seconds.)'
 else
   redirect "cards/create", :error => 'Something went wrong. Try again. (This message will disapear in 4 seconds.)'
 end
end

get "/cards/:id" do
 @card = Card.find(params[:id])
 @name = @card.name
 erb :"cards/view"
end
