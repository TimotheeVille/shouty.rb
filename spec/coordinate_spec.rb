require 'coordinate'

describe Coordinate do
  subject(:origin) { described_class.new(0, 0) }

  describe '#distance_from' do
    it 'returns zero for identical coordinates' do
      expect(origin.distance_from(origin)).to eq(0)
    end

    context 'with horizontal separation only' do
      let(:other) { described_class.new(600, 0) }

      it 'returns the absolute x distance' do
        expect(origin.distance_from(other)).to eq(600)
      end
    end

    context 'with vertical separation only' do
      let(:other) { described_class.new(0, 450) }

      it 'returns the absolute y distance' do
        expect(origin.distance_from(other)).to eq(450)
      end
    end

    context 'with diagonal separation' do
      let(:other) { described_class.new(300, 400) }

      it 'returns the Euclidean distance rounded down to integer' do
        expect(origin.distance_from(other)).to eq(500)
      end
    end
  end
end
