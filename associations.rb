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
    t.string :name
    t.integer :room_count
    t.integer :booked_guests

    t.timestamps null: false
  end

  ActiveRecord::Migration.create_table :rooms do |t|
    t.belongs_to :hotel

    t.integer :rate
    t.string :location

    t.timestamps null: false
  end

  ActiveRecord::Migration.create_table :bookings do |t|
    t.belongs_to :guest
    t.belongs_to :room

    t.datetime :check_in

    t.timestamps null: false
  end

  ActiveRecord::Migration.create_table :users do |t|
    t.string :name

    t.timestamps null: false
  end
end


## Do Not Modify These Lines ##
setup()
generate_migrations()
migrate()
#####  ^^ Do Not Modify ^^ ####


class Hotel < ActiveRecord::Base
  has_many :rooms
  has_many :bookings, through: :rooms
  has_many :booked_guests, through: :bookings, source: "guest"
 
  def to_s
    "#{name} with #{rooms.count} rooms"
  end
end

class Booking < ActiveRecord::Base
  belongs_to :guest, class_name: 'User'
  belongs_to :room
end

class Room < ActiveRecord::Base
  belongs_to :hotel
  has_many :bookings
end

class User < ActiveRecord::Base
  has_many :bookings, foreign_key: "guest_id"
  has_many :booked_rooms, through: :bookings, source: "room"
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
b = Booking.create!(guest: user, room: room, check_in: Time.now)

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
