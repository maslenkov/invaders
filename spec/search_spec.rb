# typed: false
# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/search'
require_relative '../lib/radar'
require_relative '../lib/invader'

RSpec.describe Search do
  subject(:search) do
    Search.new(
      Radar.new('spec/fixtures/galaxy.txt'),
      Invader.new('spec/fixtures/invader_1.txt')
    )
  end

  it 'saves pattern' do
    expect(search.call).to eq([{ x: 60, y: 13 }, { x: 74, y: 1 }, { x: 85, y: 12 }])
  end
end
