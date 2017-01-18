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
  #Users & Hotel belong to no one => they can claim belongs_to rels

  ActiveRecord::Migration.create_table :hotels do |t|
    t.string :name, null: false
    t.integer :room_count, default: 0
    t.timestamps null: false
  end

  ActiveRecord::Migration.create_table :rooms do |t|
    t.belongs_to :hotel, index: true
    t.integer :rate, null: false
    t.string :location, null: false
    t.timestamps null: false
  end

#owns belongs to room, user; bridge of user to room
  ActiveRecord::Migration.create_table :bookings do |t|
    t.belongs_to :room, index: true
    t.belongs_to :user, index: true
    t.belongs_to :hotel, index: true
    t.datetime :check_in
    t.timestamps null: false
  end

  ActiveRecord::Migration.create_table :users do |t|
    t.string :name, null: false
    t.timestamps null: false
  end
end


## Do Not Modify These Lines ##
setup()
generate_migrations()
migrate()
#####  ^^ Do Not Modify ^^ ####


#user owns rooms and bookings, and users through bookings
class Hotel < ActiveRecord::Base
  has_many :rooms, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings
  def to_s
    "#{name} with #{rooms.count} rooms"
  end
  def booked_guests
    self.users
  end
end

#establishes connection between room and user
class Booking < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
  belongs_to :hotel
end

#room is owned by hotel
class Room < ActiveRecord::Base
  belongs_to :hotel
  has_many :bookings
  has_many :users, through: :bookings
end

#user has many bookings, has rooms through those bookings
class User < ActiveRecord::Base
  has_many :bookings, dependent: :destroy
  has_many :rooms, through: :bookings, dependent: :nullify
  def booked_rooms
    self.rooms
  end
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
#changed attribute 'guest' to 'user'
b = Booking.create!(user: user, room: room, check_in: Time.now)

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
