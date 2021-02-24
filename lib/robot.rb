# frozen_string_literal: true

require_relative 'actions'
require_relative 'validations'

# Robotics namespace
module Robotics
  STEP = 1
  DIRECTIONS = { 'NORTH' => { y: STEP }, 'EAST' => { x: STEP }, 'SOUTH' => { y: -STEP }, 'WEST' => { x: -STEP } }.freeze
  POSITION_KEYS = %i[x y facing].freeze
  BOARD = { x_start: 0, y_start: 0, x_end: 5, y_end: 5 }.freeze

  # Toy Robot Simulator
  class Robot
    include Robotics::Actions
    include Robotics::Validations

    attr_reader :errors

    def initialize
      @position = nil
      @errors = []
      @compass = DIRECTIONS.cycle.each
    end

    def run(command)
      reset_errors
      return errors unless command_valid?(command)

      action = command[0].downcase.to_sym
      options = command.drop(1)

      return errors unless action_exist?(action)
      return errors unless __send__("#{action}_valid?", options)

      __send__(action, options)
    end

    private

    attr_reader :compass
    attr_writer :errors
    attr_accessor :position, :target

    def reset_errors
      @errors = []
    end

    def placed?
      errors.unshift 'ERROR! Command ignored, the robot is not placed on the board' if position.nil?
      errors.none?
    end

    def calculate_target
      move = DIRECTIONS[position[:facing]]
      @target = { x: position[:x], y: position[:y] }
      target[move.keys[0]] += move.values[0]
    end
  end
end
