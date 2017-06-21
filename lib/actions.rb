# frozen_string_literal: true

# Robotics namespace
module Robotics
  module Actions
    private

    def place(options)
      @position = Hash[POSITION_KEYS.zip(options)]
      loop do
        break if compass.next[0] == position[:facing]
      end
    end

    def left(_options)
      2.times { compass.next }
      position[:facing] = compass.next[0]
    end

    def right(_options)
      position[:facing] = compass.next[0]
    end

    def move(_options)
      position[:x] = target[:x]
      position[:y] = target[:y]
    end

    def report(_options)
      puts position
      position
    end
  end
end
