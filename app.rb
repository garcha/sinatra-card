require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'stripe'
require 'carrierwave'
require 'rmagick'
require 'fog'
require 'carrierwave_direct'
require 'haml'
require 'carrierwave/orm/activerecord'
#require 'aws/s3'

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key

# helpers do
#   def upload(filename, file)
#     bucket = 'medicalidus'
#     AWS::S3::Base.establish_connection!(
#       :access_key_id     => ENV['ACCESS_KEY_ID'],
#       :secret_access_key => ENV['SECRET_ACCESS_KEY']
#     )
#     AWS::S3::S3Object.store(
#       filename,
#       open(file.path),
#       bucket
#     )
#     return file.key
#   end
# end

enable :sessions

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AWS_ACCESS_KEY_ID',
    :aws_secret_access_key  => 'AWS_SECRET_ACCESS_KEY',
    :region                 => "us-east-1"
  }
  config.fog_directory  = 'medicalidus'
end

class MyUploader < CarrierWave::Uploader::Base
  storage :fog
end

class Upload < ActiveRecord::Base
  mount_uploader :filepath, MyUploader
end

class Card < ActiveRecord::Base

  # validates :name, presence: true
  # validates :phone, presence: true
  # has_attached_file :photo,
    # :storage => :s3,
    # :bucket => 'medicalidus',
    # :s3_credentials => {
    #   :access_key_id => 'AWS_ACCESS_KEY_ID',
    #   :secret_access_key => 'AWS_SECRET_ACCESS_KEY'
    # }
end

# class ImageUploader < CarrierWave::Uploader::Base
#   storage CarrierWaveDirect::Uploader
# end



class Address < ActiveRecord::Base
  belongs_to :card
end

class Purchase < ActiveRecord::Base
	belongs_to :address
end



#class MyUploader < CarrierWave::Uploader::Base
#  include CarrierWave::RMagick
#  version :thumb do
#    process :resize_to_fill => [200,200]
#  end
#  storage :fog
#end


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
get "/upload" do
  #  @cards = Card.order("created_at DESC")
  #  @title = "Welcome"
  @uploads = Upload.all
  erb :"cards/index"

end

post '/upload' do
   upload = Upload.new
   upload.filepath = params[:image]
   upload.save
  #  upload(params[:content]['file'][:filename], params[:content]['file'][:tempfile])
   redirect to('/upload')
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
