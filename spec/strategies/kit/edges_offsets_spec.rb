# typed: false
# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/strategies/kit/edges_offsets'
require_relative '../../../lib/radar'
require_relative '../../../lib/invader'

RSpec.describe Strategies::Kit::EdgesOffsets do
  subject(:extender) do
    Strategies::Kit::EdgesOffsets.new(
      Radar.new(File.read('spec/fixtures/galaxy_top_left.txt')),
      Invader.new(File.read('spec/fixtures/invader_2.txt')),
      Strategies::Compare::NOISE_RATE
    )
  end

  describe '#extend_galaxy' do
    it 'adds "o" as borders around radar shot' do
      expect(extender.add_offset_to_galaxy_shot).to eq(
        <<~EXTRACTED_GALAXY
          oooooooooooooooooooooooooooooooooo
          oooooooooooooooooooooooooooooooooo
          oooooooooooooooooooooooooooooooooo
          ooo----o--oo----o--ooo--ooo--o-ooo
          ooo--o-o-----oooooooo-oooooo---ooo
          ooo--o--------oo-ooo-oo-oo-oo--ooo
          ooo-------o--oooooo--o-oo-o--o-ooo
          ooo------o---o-ooo-ooo----o----ooo
          ooo-o--o-----o-o---o-ooooo-o---ooo
          oooo-------------ooooo-o--o--o-ooo
          ooo--o-------------------------ooo
          oooooooooooooooooooooooooooooooooo
          oooooooooooooooooooooooooooooooooo
          oooooooooooooooooooooooooooooooooo
        EXTRACTED_GALAXY
      )
    end
  end

  describe '#correct_results' do
    it 'removes offset' do
      expect(subject.remove_offset_from_result([{ x: 4, y: 4 }])).to eq([{ x: 1, y: 1 }])
    end
  end
end
