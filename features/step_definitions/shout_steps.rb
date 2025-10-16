# frozen_string_literal: true

require 'shouty'
require 'coordinate'

ARBITRARY_MESSAGE = 'Hello, world'

Before do
  @shouty = Shouty.new
  @people = {}
end

Given('Lucy is at {int}, {int}') do |x, y|
  person = 'Lucy'
  @people[person] = Coordinate.new(x, y)
  @shouty.set_location(person, @people[person])
end

Given('Sean is at {int}, {int}') do |x, y|
  person = 'Sean'
  @people[person] = Coordinate.new(x, y)
  @shouty.set_location(person, @people[person])
end

Given('{word} is at {int}, {int}') do |person, x, y|
  @people[person] = Coordinate.new(x, y)
  @shouty.set_location(person, @people[person])
end

When('Sean shouts') do
  @shouty.shout('Sean', ARBITRARY_MESSAGE)
end

When('{word} shouts') do |person|
  @shouty.shout(person, ARBITRARY_MESSAGE)
end

When('{word} shouts {string}') do |person, message|
  @shouty.shout(person, message)
end

Then('Lucy should hear Sean') do
  shouts = @shouty.shouts_heard_by('Lucy')
  expect(shouts.size).to eq(1)
  expect(shouts).to have_key('Sean')
end

Then('Lucy should hear nothing') do
  expect(@shouty.shouts_heard_by('Lucy').size).to eq(0)
end

Then('{word} should hear {word}') do |listener, shouter|
  shouts = @shouty.shouts_heard_by(listener)
  expect(shouts).to have_key(shouter),
                    "Expected #{listener} to hear #{shouter}, but heard: #{shouts.keys.join(', ')}"
end

Then('{word} should hear nothing') do |listener|
  shouts = @shouty.shouts_heard_by(listener)
  expect(shouts).to be_empty,
                    "Expected #{listener} to hear nothing, " \
                    "but heard from: #{shouts.keys.join(', ')}"
end

Then('{word} should hear {int} shout(s)') do |listener, count|
  shouts = @shouty.shouts_heard_by(listener)
  total_messages = shouts.values.flatten.size
  expect(total_messages).to eq(count),
                            "Expected #{listener} to hear #{count} shout(s), " \
                            "but heard #{total_messages}"
end
