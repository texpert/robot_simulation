# frozen_string_literal: true

require_relative 'validations'

# Robotics namespace
module Robotics
  STEP = 1
  DIRECTIONS = { 'NORTH' => { y: STEP }, 'EAST' => { x: STEP }, 'SOUTH' => { y: -STEP }, 'WEST' => { x: -STEP } }.freeze
  POSITION_KEYS = %i[x y facing].freeze
  BOARD = { x_start: 0, y_start: 0, x_end: 5, y_end: 5 }.freeze

  # Toy Robot Simulator
  class Robot
    include Robotics::Validations

    attr_reader :errors

    def initialize
      @position = nil
      @errors = []
      @compass = DIRECTIONS.cycle.each
    end

    def run(command)
      action = command[0].downcase.to_sym
      options = command.drop(1)
      reset_errors

      return errors unless action_exist?(action)
      return errors unless __send__("#{action}_valid?", options)
      __send__(action, options)
    end

    def reset_errors
      @errors = []
    end

    def onboard?(x, y)
      x.between?(BOARD[:x_start], BOARD[:x_end]) && y.between?(BOARD[:y_start], BOARD[:y_end])
    end

    private

    attr_reader :compass
    attr_writer :errors
    attr_accessor :position, :target

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
    end

    def placed?
      errors.unshift 'ERROR! Command ignored, the robot is not placed on the board' if position.nil?
      return false if errors.any?
      true
    end

    def calculate_target
      move = DIRECTIONS[position[:facing]]
      @target = { x: position[:x], y: position[:y] }
      target[move.keys[0]] += move.values[0]
    end
  end
end
