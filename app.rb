require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'stripe'
require 'carrierwave'
require 'mini_magick'
require 'fog'
require 'carrierwave_direct'
require 'haml'
require 'carrierwave/orm/activerecord'
#require 'aws/s3'

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key

enable :sessions

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
    :region                 => "us-east-1"
  }
  config.fog_directory  = 'medicalidus'
end

class MyUploader < CarrierWave::Uploader::Base
  storage :fog

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end

# class Upload < ActiveRecord::Base
#   mount_uploader :filepath, MyUploader
#   belongs_to :card
# end

class Card < ActiveRecord::Base
  mount_uploader :picture, MyUploader
  # validates :name, presence: true
  # validates :phone, presence: true

end

class Address < ActiveRecord::Base
  belongs_to :card
end

class Purchase < ActiveRecord::Base
	belongs_to :address
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


#get all the cards
get "/" do
  @cards = Card.order("created_at DESC")
  @title = "Welcome"
  erb :"cards/index"

end

# post '/upload' do
#    upload = Upload.new
#    upload.filepath = params[:image]
#    upload.save
#   #  upload(params[:content]['file'][:filename], params[:content]['file'][:tempfile])
#    redirect to('/')
# end


#create a card
get "/cards/create" do
 @title = "Create card"
 @card = Card.new
 erb :"cards/create"
end

post "/cards" do
  # upload = Upload.new
  # upload.filepath = params[:image]
  # upload.save
  @card = Card.new(params[:card])
  @card.picture = params[:image]
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

#Address create
get "/address/create" do
  @title = "Shipping address"
  @address = Address.new
  erb :"addresses/create"
end

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
