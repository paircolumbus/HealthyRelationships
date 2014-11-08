require 'active_record'

def setup
  ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
end

def migrate
  ActiveRecord::Migrator.up "db/migrate"
end


def generate_migrations
  ActiveRecord::Migration.create_table :hotels do |t|
    #insert our columns here

    t.timestamps
  end

  ActiveRecord::Migration.create_table :rooms do |t|
    #insert our columns here

    t.timestamps
  end

  ActiveRecord::Migration.create_table :bookings do |t|
    #insert our columns here

    t.timestamps
  end

  ActiveRecord::Migration.create_table :users do |t|
    #insert our columns here

    t.timestamps
  end
end


## Do Not Modify These Lines ##
setup()
generate_migrations()
migrate()
#####  ^^ Do Not Modify ^^ ####


class Hotel < ActiveRecord::Base
  #insert our associations here
 
  def to_s
    "#{name} with #{rooms.count} rooms"
  end
end

class Booking < ActiveRecord::Base
  #insert our associations here

end

class Room < ActiveRecord::Base
  #insert our associations here

end

class User < ActiveRecord::Base
  #insert our associations here

end

#DO NOT CHANGE ANYTHING BELOW THIS LINE.
#<< Attempting to insert into database
hotel = Hotel.create!(name: "Westin", room_count: 200)
hotel.rooms << Room.create!(rate: 200)
hotel.rooms << Room.create!(rate: 50)
puts Room.first.hotel
user = User.create!(name: "John Smith")
room = hotel.rooms.first
b = Booking.create!(guest: user, room: room)
p user.bookings
p user.booked_rooms
p hotel.rooms
p hotel.bookings
p hotel.guests
