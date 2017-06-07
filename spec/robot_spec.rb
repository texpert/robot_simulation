# frozen_string_literal: true

require_relative '../lib/robot'

RSpec.describe Robotics::Robot do
  describe '#initialize' do
    describe 'instance variables' do
      it 'initializes the `errors` instance variable' do
        expect(subject.instance_variable_get('@errors')).to be_truthy
      end

      it 'initializes the `errors` as an array' do
        expect(subject.errors.is_a?(Array)).to be_truthy
      end

      it 'initializes the `errors` array in empty state and with a public getter method' do
        expect(subject.errors).to be_empty
      end

      it 'initializes the `position` instance variable with nil' do
        expect(subject.instance_variable_get('@position')).to be_falsey
      end

      it 'initializes the `compass` instance variable' do
        expect(subject.instance_variable_get('@compass')).to be_truthy
      end

      it 'initializes the `compass` as a enumerator' do
        expect(subject.instance_variable_get('@compass').is_a?(Enumerator)).to be_truthy
      end

      it 'initializes the `compass` as a cycle enumerator of cardinal directions with defined changes of coordinates for each direction' do
        expect(subject.instance_variable_get('@compass').inspect)
          .to eql("#<Enumerator: {\"NORTH\"=>{:y=>#{Robotics::STEP}}, \"EAST\"=>{:x=>#{Robotics::STEP}}, \"SOUTH\"=>{:y=>-#{Robotics::STEP}}, \"WEST\"=>{:x=\
>-#{Robotics::STEP}}}:cycle>")
      end
    end

    describe 'public methods' do
      it 'has a `run` public method' do
        expect(subject.respond_to?(:run)).to be_truthy
      end

      it 'has a `errors` public getter method' do
        expect(subject.respond_to?(:errors)).to be_truthy
      end

      it 'has a `errors` private setter method' do
        expect(subject.respond_to?('errors=')).to be_falsey
        expect(subject.respond_to?('errors=', include_all: true)).to be_truthy
      end
    end
  end

  describe '#run method' do
    it 'returns error if the command is not an array' do
      expect(subject.run('some command')).to eql(['ERROR! Command format invalid, should be an array'])
    end

    it 'returns error if the command is not recognized' do
      expect(subject.run(['UP'])).to eql(['ERROR! Action is undefined: up'])
    end

    it 'returns error for all the commands except PLACE if the robot is not placed on board' do
      %w[LEFT RIGHT MOVE REPORT].each do |command|
        expect(subject.run([command])).to eql(['ERROR! Command ignored, the robot is not placed on the board'])
      end
    end

    context 'with PLACE command' do
      it 'returns error if no options were sent along with the command' do
        expect(subject.run(['PLACE'])).to eql(['ERROR! PLACE command invalid, options missing'])
      end

      it 'returns error if options are less than 3' do
        expect(subject.run(['PLACE', 0])).to eql(['ERROR! PLACE command invalid, not enough data: [0]'])
        expect(subject.run(['PLACE', 0, 0])).to eql(['ERROR! PLACE command invalid, not enough data: [0, 0]'])
      end

      it 'returns error if at least one target coordinate is out of the board' do
        expect(subject.run(['PLACE', 0, 6, 'NORTH'])).to eql(['ERROR! Command invalid, position out of border: [0, 6, "NORTH"]'])
        expect(subject.run(['PLACE', 6, 0, 'NORTH'])).to eql(['ERROR! Command invalid, position out of border: [6, 0, "NORTH"]'])
        expect(subject.run(['PLACE', 6, 6, 'NORTH'])).to eql(['ERROR! Command invalid, position out of border: [6, 6, "NORTH"]'])
      end

      it 'returns error if the 3rd option is not a cardinal direction' do
        expect(subject.run(['PLACE', 0, 0, 'NORT'])).to eql(['ERROR! 3rd option should be a cardinal direction'])
      end
    end
  end
end
