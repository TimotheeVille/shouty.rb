# frozen_string_literal: true

require_relative './coordinate'

class Shouty
  MESSAGE_RANGE = 1000

  def initialize
    @locations = {}
    @shouts = {}
  end

  def set_location(person, location)
    @locations[person] = location
  end

  def shout(person, shout)
    @shouts[person] = [] unless @shouts.key?(person)

    @shouts[person].push(shout)
  end

  def shouts_heard_by(listener)
    shouts_heard = {}

    @shouts.each do |shouter, shouts|
      distance = @locations[listener].distance_from(@locations[shouter])
      shouts_heard[shouter] = shouts if distance < MESSAGE_RANGE
    end

    shouts_heard
  end
end
