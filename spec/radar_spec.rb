# typed: false
# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/radar'

RSpec.describe Radar do
  it 'saves galaxy snapshot' do
    expect(Radar.new(File.read('spec/fixtures/galaxy.txt')).shot).to be_a String
  end
end
