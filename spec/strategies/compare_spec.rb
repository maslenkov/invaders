# typed: false
# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/strategies/compare'
require_relative '../../lib/radar'
require_relative '../../lib/invader'

RSpec.describe Strategies::Compare do
  subject(:strategy) do
    Strategies::Compare.new(
      Radar.new(File.read('spec/fixtures/galaxy_top_right.txt')),
      Invader.new(File.read('spec/fixtures/invader_1.txt'))
    )
  end

  it 'finds invader pattern in radar shot' do
    expect(strategy.call).to eq([{ x: 4, y: 1 }])
  end
end
