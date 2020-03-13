# typed: false
# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/invader'

RSpec.describe Invader do
  subject(:invader) { Invader.new(File.read('spec/fixtures/invader_1.txt')) }

  it 'saves pattern' do
    expect(invader.pattern).to eq(
      <<~INVADER
        --o-----o--
        ---o---o---
        --ooooooo--
        -oo-ooo-oo-
        ooooooooooo
        o-ooooooo-o
        o-o-----o-o
        ---oo-oo---
      INVADER
    )
  end

  it 'provides sizes' do
    expect(invader.sizes).to eq({ width: 11, height: 8 })
  end
end
