require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'stripe'

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key

enable :sessions

class Card < ActiveRecord::Base
  validates :name, presence: true
  validates :phone, presence: true
end

class Address < ActiveRecord::Base
  belongs_to :card
end

class Purchase < ActiveRecord::Base
	belongs_to :address
end


# get all the cards
get "/" do
  @cards = Card.order("created_at DESC")
  @title = "Welcome"
  erb :"cards/index"
end

helpers do
  def title
    if @title
      "#{@title}"
    else
      "Welcome"
    end
  end
end

#create a card
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

#view post
get "/cards/:id" do
 @card = Card.find(params[:id])
 @title = "Shipping address"
 @address = Address.new
 erb :"cards/view"
end

#edit post
get "/cards/:id/edit" do
  @card = Card.find(params[:id])
  @title = "Edit Card"
  erb :"cards/edit"
end
put "/cards/:id" do
  @card = Card.find(params[:id])
  @card.update(params[:card])
  redirect "/cards/#{@card.id}"
end

# #Address create
# get "/address/create" do
#   @title = "Shipping address"
#   @address = Address.new
#   erb :"addresses/create"
# end

post "/addresses" do
  @address = Address.new(params[:address])
  if @address.save
    redirect "addresses/#{@address.id}", :notice => 'Congrats! Love the new post. (This message will disapear in 4 seconds.)'
  else
    erb :"addresses/create", :error => 'Something went wrong. Try again. (This message will disapear in 4 seconds.)'
  end
end



get "/addresses/:id" do
  @@address = Address.find(params[:id])
  @address = Address.find(params[:id])
  @title = @address.name
  erb :"addresses/view"
end

post '/addresses/charge' do
  # Amount in cents
  @amount = 500

  customer = Stripe::Customer.create(
    :email => @@address.email,
    :card  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'MedicalIDOne Card',
    :currency    => 'usd',
    :customer    => @@address.id
  )

  erb :'addresses/charge'

end


