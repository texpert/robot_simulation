# frozen_string_literal: true

# Robotics namespace
module Robotics
  module Validations
    def self.included(base)
      base.extend(ClassMethods)
    end

    private

    def command_valid?(command)
      errors.unshift 'ERROR! Command format invalid, should be an array' unless command.is_a?(Array)
      errors.any? ? false : true
    end

    def action_exist?(action)
      errors.unshift "ERROR! Action is undefined: #{action}" unless respond_to?(action, include_all: true)
      errors.any? ? false : true
    end

    def left_valid?(_options)
      placed?
    end
    alias right_valid? left_valid?
    alias report_valid? left_valid?

    def move_valid?(_options)
      return false unless placed?
      calculate_target
      Robot.validate_target(self, target.values)
      errors.any? ? false : true
    end

    def place_valid?(options)
      %w[presence size target facing].each do |v|
        Robot.__send__("validate_#{v}".to_sym, self, options)
        return false if errors.any?
      end
      true
    end

    module ClassMethods
      def validate_facing(instance, options)
        instance.errors.unshift 'ERROR! 3rd option should be a cardinal direction' unless DIRECTIONS.keys.include?(options[2])
      end

      def validate_presence(instance, options)
        instance.errors.unshift 'ERROR! PLACE command invalid, options missing' if options.empty?
      end

      def validate_size(instance, options)
        instance.errors.unshift "ERROR! PLACE command invalid, not enough data: #{options}" if options.size < 3
      end

      def validate_target(instance, options)
        instance.errors.unshift "ERROR! Command invalid, position out of border: #{options}" unless onboard?(options[0], options[1])
      end

      def onboard?(x, y)
        x.between?(BOARD[:x_start], BOARD[:x_end]) && y.between?(BOARD[:y_start], BOARD[:y_end])
      end
    end
  end
end
