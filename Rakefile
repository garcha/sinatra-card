require './app'
require 'sinatra/activerecord/rake'
require 'csv'

task :daily_report do
  #attachment "myfilename.csv"
  @card = Card.last
  @address = Address.last
  csv_string = CSV.generate do |csv|
     csv << ["ID", "Name", "Picture", "Address", "City", "State", "Zip"]
     csv << [@card.id, @card.name, @card.picture, @card.address1, @card.city, @card.state, @card.zip]
   end
end

# @users = User.find(:all)
#     csv_string = CSV.generate do |csv|
#          csv << ["Id", "Name", "Email","Role"]
#          @users.each do |user|
#            csv << [user.id, user.name, user.name, user.role]
#          end
#     end
#
#    send_data csv_string,
#    :type => 'text/csv; charset=iso-8859-1; header=present',
#    :disposition => "attachment; filename=users.csv"
# end
#
# "<p>Picture: <img src=#{@card.picture.url} /> #{@card.picture.url}</p>
# <p>Name: #{@card.name} </p>
# <p>Address: #{@card.address1} </p>
# <p>City: #{@card.city} </p>
# <p>State: #{@card.state} </p>
# <p>Zip: #{@card.zip} </p>
# <p>Phone Number: #{@card.phone1} </p>
# <p>Date of Birth: #{@card.dob} </p>
# <p>Emergency Contact: #{@card.em_contact} </p>
# <p>Emergency Phone Number: #{@card.phone_em} </p>
# <p>Doctor: #{@card.doctor} </p>
# <p>Doctors Phone number: #{@card.phone_doc} </p>
# <p>Insurance Provider: #{@card.insurance}</p>
# <p>Insurance Information: #{@card.insur_numner} </p>
# <p>Blood Type: #{@card.bloodtype} </p>
# <p>Medical History: #{@card.medical_history1} </p>
# <p>Medical History: #{@card.medical_history2} </p>
# <p>Medical History: #{@card.medical_history3} </p>
# <p>Medical History: #{@card.medical_history4} </p>
# <p>Medical History: #{@card.medical_history5} </p>
# <p>Medication: #{@card.medication1} </p>
# <p>Medication: #{@card.medication2} </p>
# <p>Medication: #{@card.medication3} </p>
# <p>Medication: #{@card.medication4} </p>
# <p>Medication: #{@card.medication5} </p>
# <p>Name: #{@address.name}</p>
# <p>Address: #{@address.address}</p>
# <p>City: #{@address.city}</p>
# <p>State: #{@address.state}</p>
# <p>Zip: #{@address.zip}</p>
# <p>Email Address: #{@address.email}</p>
# <p>Phone Number: #{@address.phone1}</p>",
