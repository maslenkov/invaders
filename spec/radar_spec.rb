# typed: false
# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/radar'

RSpec.describe Radar do
  it 'saves galaxy snapshot' do
    expect(Radar.new(File.read('spec/fixtures/galaxy_top_left.txt')).shot).to eq(
      <<~PART_OF_GALAXY
        ----o--oo----o--ooo--ooo--o-
        --o-o-----oooooooo-oooooo---
        --o--------oo-ooo-oo-oo-oo--
        -------o--oooooo--o-oo-o--o-
        ------o---o-ooo-ooo----o----
        -o--o-----o-o---o-ooooo-o---
        o-------------ooooo-o--o--o-
        --o-------------------------
      PART_OF_GALAXY
    )
  end
end
