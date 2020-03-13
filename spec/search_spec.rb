# typed: false
# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/search'
require_relative '../lib/radar'
require_relative '../lib/invader'
require_relative '../lib/strategies/compare_with_edges'

RSpec.describe Search do
  context 'with Strategies::Compare' do
    subject(:search) do
      Search.new(
        Radar.new(File.read('spec/fixtures/galaxy.txt')),
        Invader.new(File.read('spec/fixtures/invader_2.txt')),
        Strategies::Compare
      )
    end

    it 'finds non edge-cased patterns' do
      expect(search.call).to eq(
        [
          { x: 16, y: 28 },
          { x: 82, y: 41 },
          { x: 35, y: 15 },
          { x: 42, y: 0 }
        ]
      )
    end
  end

  context 'with Strategies::CompareWithEdges' do
    subject(:search_with_edges) do
      Search.new(
        Radar.new(File.read('spec/fixtures/galaxy.txt')),
        Invader.new(File.read('spec/fixtures/invader_2.txt')),
        Strategies::CompareWithEdges
      )
    end

    it 'finds even if invader is not fully visible' do
      expect(search_with_edges.call).to eq(
        [
          { x: 16, y: 28 },
          { x: 82, y: 41 },
          { x: 18, y: -1 },
          { x: 35, y: 15 },
          { x: 42, y: 0 }
        ]
      )
    end
  end
end
