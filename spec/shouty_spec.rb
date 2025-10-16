# frozen_string_literal: true

require 'shouty'
require 'coordinate'

describe Shouty do
  subject(:network) { described_class.new }

  let(:lucy) { 'Lucy' }
  let(:sean) { 'Sean' }
  let(:larry) { 'Larry' }

  describe '#set_location' do
    let(:location) { Coordinate.new(100, 200) }

    it 'stores person location' do
      network.set_location(lucy, location)
      expect(network.shouts_heard_by(lucy)).to eq({})
    end
  end

  describe '#shout' do
    let(:message) { 'Hello, world!' }

    context 'when person has no prior shouts' do
      it 'records the shout' do
        network.set_location(lucy, Coordinate.new(0, 0))
        network.set_location(sean, Coordinate.new(0, 0))
        network.shout(sean, message)

        heard = network.shouts_heard_by(lucy)
        expect(heard[sean]).to contain_exactly(message)
      end
    end

    context 'when person has existing shouts' do
      it 'appends to shout history' do
        network.set_location(lucy, Coordinate.new(0, 0))
        network.set_location(sean, Coordinate.new(0, 0))
        network.shout(sean, 'First')
        network.shout(sean, 'Second')

        heard = network.shouts_heard_by(lucy)
        expect(heard[sean]).to eq(%w[First Second])
      end
    end
  end

  describe '#shouts_heard_by' do
    let(:origin) { Coordinate.new(0, 0) }

    before do
      network.set_location(lucy, origin)
    end

    context 'when no shouts exist' do
      it 'returns empty hash' do
        expect(network.shouts_heard_by(lucy)).to eq({})
      end
    end

    context 'with in-range shouter' do
      let(:nearby) { Coordinate.new(0, 500) }

      before do
        network.set_location(sean, nearby)
      end

      it 'includes shouts from nearby person' do
        network.shout(sean, 'Hello')
        heard = network.shouts_heard_by(lucy)

        expect(heard).to have_key(sean)
        expect(heard[sean]).to contain_exactly('Hello')
      end

      it 'includes multiple shouts from same person' do
        network.shout(sean, 'Hello')
        network.shout(sean, 'How are you?')

        heard = network.shouts_heard_by(lucy)
        expect(heard[sean]).to eq(['Hello', 'How are you?'])
      end
    end

    context 'with out-of-range shouter' do
      let(:far_away) { Coordinate.new(800, 800) }

      before do
        network.set_location(sean, far_away)
      end

      it 'excludes shouts from distant person' do
        network.shout(sean, 'Can you hear me?')
        heard = network.shouts_heard_by(lucy)

        expect(heard).not_to have_key(sean)
      end
    end

    context 'with boundary distance exactly at range' do
      let(:boundary) { Coordinate.new(1_000, 0) }

      before do
        network.set_location(sean, boundary)
      end

      it 'excludes shouts at exact range limit' do
        network.shout(sean, 'Boundary test')
        heard = network.shouts_heard_by(lucy)

        expect(heard).not_to have_key(sean)
      end
    end

    context 'with multiple shouters at varying distances' do
      let(:near) { Coordinate.new(0, 100) }
      let(:far) { Coordinate.new(2_000, 0) }

      before do
        network.set_location(sean, near)
        network.set_location(larry, far)
      end

      it 'includes only in-range shouts' do
        network.shout(sean, 'Near message')
        network.shout(larry, 'Far message')

        heard = network.shouts_heard_by(lucy)

        expect(heard).to have_key(sean)
        expect(heard).not_to have_key(larry)
      end
    end

    context 'when listener has not shouted' do
      before do
        network.set_location(sean, Coordinate.new(0, 100))
      end

      it 'still receives shouts from others' do
        network.shout(sean, 'Hello Lucy')
        heard = network.shouts_heard_by(lucy)

        expect(heard[sean]).to contain_exactly('Hello Lucy')
      end
    end

    context 'when listener hears their own shout' do
      it 'includes own shout at zero distance' do
        network.shout(lucy, 'Talking to myself')
        heard = network.shouts_heard_by(lucy)

        expect(heard[lucy]).to contain_exactly('Talking to myself')
      end
    end
  end

  describe 'MESSAGE_RANGE constant' do
    it 'is set to 1000' do
      expect(Shouty::MESSAGE_RANGE).to eq(1_000)
    end
  end
end
