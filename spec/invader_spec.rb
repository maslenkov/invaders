# typed: false
# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/invader'

RSpec.describe Invader do
  subject(:invader) { Invader.new(File.read('spec/fixtures/invader_1.txt')) }

  it 'saves pattern' do
    expect(invader.pattern).to be_a String
  end

  it 'provides sizes' do
    expect(invader.sizes).to be_a Hash
    expect(invader.sizes).to eq({ width: 11, height: 8 })
  end
end
