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


    t.timestamps null: false
  end

  ActiveRecord::Migration.create_table :rooms do |t|
    t.integer :hotel_id
    t.integer :rate
    t.string :location

    t.timestamps null: false
  end

  ActiveRecord::Migration.create_table :bookings do |t|
    t.datetime :check_in
    t.integer :guest
    t.integer :room

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

  def to_s
    "#{name} with #{rooms.count} rooms"
  end

  def bookings
    Booking.where(:room => rooms.map{|r| r.id})
    # rooms.collect_concat {|r| r.bookings.to_a}
  end

  def booked_guests
    bookings.map{|b| b.guest}.uniq
  end
end

class Booking < ActiveRecord::Base
  belongs_to :room, foreign_key: :room
  belongs_to :user, foreign_key: :guest

end

class Room < ActiveRecord::Base
  belongs_to :hotel
  has_many :bookings, foreign_key: :room

end

class User < ActiveRecord::Base
  has_many :bookings, foreign_key: :guest

  def bookings
    Booking.where(:guest => id)
  end

  def booked_rooms
    bookings.collect_concat {|b| b.room}
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

p hotel.rooms

user = User.create!(name: "John Smith")
room = hotel.rooms.first
b = Booking.create!(guest: user, room: room, check_in: Time.now)

p user
p hotel.rooms.first.bookings

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
