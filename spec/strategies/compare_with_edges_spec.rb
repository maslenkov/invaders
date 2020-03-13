# typed: false
# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/strategies/compare_with_edges'
require_relative '../../lib/radar'
require_relative '../../lib/invader'

RSpec.describe Strategies::Compare do
  subject(:strategy) do
    Strategies::CompareWithEdges.new(
      Radar.new(File.read('spec/fixtures/galaxy_top_left.txt')),
      Invader.new(File.read('spec/fixtures/invader_2.txt'))
    )
  end

  it 'finds invader pattern in radar shot' do
    expect(strategy.call).to eq([{ x: 18, y: -1 }])
  end
end
