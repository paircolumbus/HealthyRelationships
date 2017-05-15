require 'active_record'
require 'table_print'
require 'awesome_print'

def setup
  ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
end

def migrate
  ActiveRecord::Migrator.up "db/migrate"
end


def generate_migrations
  ActiveRecord::Migration.create_table :hotels do |t|
    #insert our columns here
    t.string :name, null: false
    t.integer :room_count, null: false
    t.timestamps null: false
  end

  ActiveRecord::Migration.create_table :rooms do |t|
    #insert our columns here
    t.integer :rate, null: false
    t.string :location, null: false
    t.references :hotel, index: true, foreign_key: true
    t.timestamps null: false
  end

  ActiveRecord::Migration.create_table :users do |t|
    #insert our columns here
    t.string :name, null: false
    t.timestamps null: false
  end

  ActiveRecord::Migration.create_table :bookings do |t|
    #insert our columns here
    t.datetime :check_in, null: false
    t.integer :guest, index: true
    t.integer :room, index: true
    t.references :hotel, index: true, foreign_key: true
    t.timestamps null: false
  end

end


## Do Not Modify These Lines ##
setup()
generate_migrations()
migrate()
#####  ^^ Do Not Modify ^^ ####


class Hotel < ActiveRecord::Base
  #insert our associations 
  has_many :rooms
  has_many :bookings
  has_many :booked_guests, class_name: 'Booking', foreign_key: 'guest'
  def to_s
    "#{name} with #{rooms.count} rooms"
  end
end

class Booking < ActiveRecord::Base
  #insert our associations
  belongs_to :user
  belongs_to :hotel
end

class Room < ActiveRecord::Base
  #insert our associations here
  belongs_to :hotel
  belongs_to :user
end

class User < ActiveRecord::Base
  #insert our associations here
  has_many :bookings, foreign_key: 'guest'
  has_many :booked_rooms, class_name: 'Booking', foreign_key: 'room'
end

#DO NOT CHANGE ANYTHING BELOW THIS LINE.
def line_sep(title=nil); print "\n#{title} ----\n\n"; end
def random_loc; (('a'..'e').to_a.sample) + rand(1..5).to_s; end

hotel = Hotel.create!(name: "Westin", room_count: 5)

5.times do 
  hotel.rooms << Room.create!(
    rate: [125,200,175].sample,
    location: random_loc
  ) 
end

user = User.create!(name: "John Smith")
room = hotel.rooms.first
b = Booking.create!(guest: user.id, room: room.id, check_in: Time.now, hotel: hotel)

line_sep("#{user.name} bookings")
tp user.bookings
line_sep
tp user.booked_rooms
line_sep("#{hotel.name} Hotel")
tp hotel.rooms
line_sep
tp hotel.bookings
line_sep
tp hotel.booked_guests
