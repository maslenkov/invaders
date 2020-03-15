# frozen_string_literal: true

require_relative '../lib/radar'
require_relative '../lib/invader'
require_relative '../lib/printer'

::Printer.new(Radar.new(File.read('spec/fixtures/galaxy.txt')), Invader.new(File.read('spec/fixtures/invader_1.txt'))).call
puts
::Printer.new(Radar.new(File.read('spec/fixtures/galaxy.txt')), Invader.new(File.read('spec/fixtures/invader_2.txt'))).call
