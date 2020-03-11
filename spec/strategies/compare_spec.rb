# typed: false
# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/strategies/compare'

RSpec.describe Strategies::Compare do
  subject(:strategy) do
    Strategies::Compare.new(Radar.new(''), Invader.new(''))
  end

  it { is_expected.to respond_to(:call) }
end
