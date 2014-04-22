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
require 'pony'


set :public, File.dirname( __FILE__ ) + '/public'

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
  include CarrierWave::MiniMagick

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  process :resize_to_fit => [190, 140]

  storage :fog
end

message = Hash.new

class Card < ActiveRecord::Base

  #validates_presence_of :name, :message => "%{value} cannot be Empty."
  #:phone1, :picture, :address1, :city, :state, :zip, :em_contact, :phone_em,

  mount_uploader :picture, MyUploader
end

class Address < ActiveRecord::Base
  belongs_to :card

  #validates_presence_of :name, :email, :address, :city, :state, :zip, :phone1
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


#create a card
get "/" do
  @title = "Welcome, Create your Medical ID Card"
  @card = Card.new
  erb :"cards/create"
end

post "/cards" do

  @card = Card.new(params[:card])
  @card.picture = params[:picture]
  if @card.save
    redirect "cards/#{@card.id}", :notice => 'Congrats! Love the new post. (This message will disapear in 4 seconds.)'
  else
    message.each do |attr,msg|
    redirect "/", :error =>  msg
    end
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
    redirect "addresses/#{@address.id}", :notice => 'Congrats! You Just created your card. (This message will disapear in 4 seconds.)'
  else
    erb :"addresses/create", :error => 'Something went wrong. Try again. (This message will disapear in 4 seconds.)'
  end
end

get "/addresses/thankyou" do
  erb :"addresses/thankyou"
end

get "/addresses/:id" do
  @address = Address.find(params[:id])
  @title = @address.name
  erb :"addresses/view"
end


post "/addresses/charge" do
  # Amount in cents
  @amount = 500

   charge = Stripe::Charge.create(
    :email       => params[:email],
    :amount      => @amount,
    :description => 'MedicalIDOne Card',
    :currency    => 'usd',
    :card        => params[:stripeToken]
  )

   @card = Card.last
   @address = Address.last


   Pony.mail(
     :from => 'MedicalIDOne@heroku.com',
     :to => 'Jaspreet@garcha.com',
     :subject => "New Medical ID Card Sold",
     :headers => { 'Content-Type' => 'text/html' },
     :body =>
     "<p>Picture: <img src=#{@card.picture.url} /> #{@card.picture.url}</p>
     <p>Name: #{@card.name} </p>
     <p>Address: #{@card.address1} </p>
     <p>City: #{@card.city} </p>
     <p>State: #{@card.state} </p>
     <p>Zip: #{@card.zip} </p>
     <p>Phone Number: #{@card.phone1} </p>
     <p>Date of Birth: #{@card.dob} </p>
     <p>Emergency Contact: #{@card.em_contact} </p>
     <p>Emergency Phone Number: #{@card.phone_em} </p>
     <p>Doctor: #{@card.doctor} </p>
     <p>Doctors Phone number: #{@card.phone_doc} </p>
     <p>Insurance Provider: #{@card.insurance}</p>
     <p>Insurance Information: #{@card.insur_numner} </p>
     <p>Blood Type: #{@card.bloodtype} </p>
     <p>Medical History: #{@card.medical_history1} </p>
     <p>Medical History: #{@card.medical_history2} </p>
     <p>Medical History: #{@card.medical_history3} </p>
     <p>Medical History: #{@card.medical_history4} </p>
     <p>Medical History: #{@card.medical_history5} </p>
     <p>Medication: #{@card.medication1} </p>
     <p>Medication: #{@card.medication2} </p>
     <p>Medication: #{@card.medication3} </p>
     <p>Medication: #{@card.medication4} </p>
     <p>Medication: #{@card.medication5} </p>
     <p>Name: #{@address.name}</p>
     <p>Address: #{@address.address}</p>
     <p>City: #{@address.city}</p>
     <p>State: #{@address.state}</p>
     <p>Zip: #{@address.zip}</p>
     <p>Email Address: #{@address.email}</p>
     <p>Phone Number: #{@address.phone1}</p>",
     :via => :smtp,
     :via_options => {
        :address          => 'smtp.sendgrid.net',
        :port             => '587',
        :enable_starttls_auto => true,
        :user_name            => ENV['SENDGRID_USERNAME'],
        :password             => ENV['SENDGRID_PASSWORD'],
        :authentication       => :plain,
        :domain               => ENV['SENDGRID_DOMAIN'] || 'localhost.localdomain'
        })

    redirect '/addresses/thankyou'

end

error Stripe::CardError do
  env['sinatra.error'].message
end
