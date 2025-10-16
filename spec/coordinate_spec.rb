# frozen_string_literal: true

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

    context 'with negative coordinates' do
      let(:negative_point) { described_class.new(-100, -100) }

      it 'calculates distance correctly using absolute values' do
        expect(negative_point.distance_from(origin)).to eq(141)
      end
    end

    context 'symmetry property' do
      let(:point_a) { described_class.new(50, 80) }
      let(:point_b) { described_class.new(200, 300) }

      it 'returns same distance regardless of direction' do
        expect(point_a.distance_from(point_b)).to eq(point_b.distance_from(point_a))
      end
    end

    context 'with large distances' do
      let(:far_point) { described_class.new(10_000, 10_000) }

      it 'handles large coordinate values' do
        expect(origin.distance_from(far_point)).to eq(14_142)
      end
    end

    context 'boundary cases' do
      it 'returns correct distance for minimal non-zero x separation' do
        nearby = described_class.new(1, 0)
        expect(origin.distance_from(nearby)).to eq(1)
      end

      it 'returns correct distance for minimal non-zero y separation' do
        nearby = described_class.new(0, 1)
        expect(origin.distance_from(nearby)).to eq(1)
      end
    end

    context 'error handling' do
      it 'raises ArgumentError when given nil' do
        expect { origin.distance_from(nil) }.to raise_error(
          ArgumentError, /nil coordinate/
        )
      end

      it 'raises ArgumentError when given non-Coordinate object' do
        expect { origin.distance_from('not a coordinate') }.to raise_error(
          ArgumentError, /must be a Coordinate instance/
        )
      end
    end
  end
end
