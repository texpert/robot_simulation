#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
Dir['./lib/*'].sort.each { |file| require file }

require 'scanf'

# Robotics namespace
module Robotics
  def self.read_commands(input)
    robot = Robot.new
    until input.eof?
      line = input.readline.chomp
      command = line.scanf('%s%d,%d,%s')
      next if command.empty?

      puts "Executing command: #{line}"
      result = robot.run(command)
      puts "Result: #{result}" if robot.errors.any?
    end
  end

  if ARGV[0]
    if File.file?(ARGV[0])
      File.open(ARGV[0], 'r') do |file|
        Robotics.read_commands(file)
      end
    else
      puts "File missing: #{ARGV[0]}"
    end
  else
    puts 'No simulation file specified.'
  end
end
