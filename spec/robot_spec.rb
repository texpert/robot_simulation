# frozen_string_literal: true

require_relative '../lib/robot'

RSpec.describe Robotics::Robot do
  let(:in_range_x) { rand(Robotics::BOARD[:x_end]) }
  let(:in_range_y) { rand(Robotics::BOARD[:y_end]) }
  let(:direction)  { Robotics::DIRECTIONS.keys.sample }
  let(:step) { Robotics::STEP }

  describe '#initialize' do
    describe 'instance variables' do
      it '`errors` instance variable' do
        expect(subject.instance_variable_get('@errors')).to be_truthy
      end

      it '`errors` as an array' do
        expect(subject.errors.is_a?(Array)).to be_truthy
      end

      it '`errors` array in empty state and with a public getter method' do
        expect(subject.errors).to be_empty
      end

      it '`position` instance variable with nil' do
        expect(subject.instance_variable_get('@position')).to be_falsey
      end

      it '`compass` instance variable' do
        expect(subject.instance_variable_get('@compass')).to be_truthy
      end

      it '`compass` as a enumerator' do
        expect(subject.instance_variable_get('@compass').is_a?(Enumerator)).to be_truthy
      end

      it '`compass` as a cycle enumerator of cardinal directions with defined coordinates changes for each direction' do
        compass_ivar = subject.instance_variable_get('@compass')
        expect(compass_ivar).to be_instance_of(Enumerator)
        expect(compass_ivar.inspect)
          .to eql("#<Enumerator: {\"NORTH\"=>{:y=>#{step}}, \"EAST\"=>{:x=>#{step}}, \"SOUTH\"=>{:y=>-#{step}}," \
                  " \"WEST\"=>{:x=\>-#{step}}}:cycle>")
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

    it 'returns error if the command is not a private method of Robotics::Actions, even if defined on the object' do
      expect(subject.respond_to?(:run)).to be_truthy
      expect(subject.run(['RUN'])).to eql(['ERROR! Action is undefined: run'])
    end

    it 'returns error for all the commands except PLACE if the robot is not placed on board' do
      %w[LEFT RIGHT MOVE REPORT].each do |command|
        expect(subject.run([command])).to eql(['ERROR! Command ignored, the robot is not placed on the board'])
      end
    end

    context 'with PLACE command' do
      context 'with valid params' do
        it 'sets the robot\'s position according to command options' do
          subject.run(['PLACE', in_range_x, in_range_y, direction])
          expect(subject.run(['REPORT'])).to eql(x: in_range_x, y: in_range_y, facing: direction)
        end

        it 'sets the robot\'s compass according to 3rd command options, or :facing value of robot\'s position' do
          subject.run(['PLACE', in_range_x, in_range_y, direction])

          # Setting the compass before current position and then doing next to get the current position
          3.times { subject.instance_variable_get('@compass').next }

          expect(subject.instance_variable_get('@compass').next[0]).to eql(direction)
        end
      end

      it 'resets the error array - any command is resetting it' do
        subject.run(['PLACE'])
        expect(subject.errors).to eql(['ERROR! PLACE command invalid, options missing'])
        subject.run(['PLACE', in_range_x, in_range_y, direction])

        expect(subject.errors).to be_empty
      end

      context 'with invalid params' do
        it 'returns error if no options were sent along with the command' do
          expect(subject.run(['PLACE'])).to eql(['ERROR! PLACE command invalid, options missing'])
        end

        it 'returns error if options are less than 3' do
          expect(subject.run(['PLACE', 0])).to eql(['ERROR! PLACE command invalid, not enough data: [0]'])
          expect(subject.run(['PLACE', 0, 0])).to eql(['ERROR! PLACE command invalid, not enough data: [0, 0]'])
        end

        it 'returns error if at least one target coordinate is out of the board' do
          expect(subject.run(['PLACE', 0, 6, 'NORTH']))
            .to eql(['ERROR! Command invalid, position out of border: [0, 6, "NORTH"]'])
          expect(subject.run(['PLACE', 6, 0, 'NORTH']))
            .to eql(['ERROR! Command invalid, position out of border: [6, 0, "NORTH"]'])
          expect(subject.run(['PLACE', 6, 6, 'NORTH']))
            .to eql(['ERROR! Command invalid, position out of border: [6, 6, "NORTH"]'])
        end

        it 'returns error if the 3rd option is not a cardinal direction' do
          expect(subject.run(['PLACE', 0, 0, 'NORT'])).to eql(['ERROR! 3rd option should be a cardinal direction'])
        end
      end
    end

    context 'with LEFT command' do
      context 'with valid params' do
        it 'sets the robot\'s :facing position key according to command options' do
          subject.run(['PLACE', in_range_x, in_range_y, direction])

          # Get the direction LEFT of current position
          2.times { subject.instance_variable_get('@compass').next }
          target = subject.instance_variable_get('@compass').next[0]

          # Return the compass back into current position
          subject.instance_variable_get('@compass').next

          subject.run(['LEFT'])

          expect(subject.run(['REPORT'])).to eql(x: in_range_x, y: in_range_y, facing: target)
        end

        it 'sets the robot\'s compass according to the command' do
          subject.run(['PLACE', in_range_x, in_range_y, direction])

          # Get the LEFT direction
          2.times { subject.instance_variable_get('@compass').next }
          target = subject.instance_variable_get('@compass').next[0]

          # Return the compass back into current position
          subject.instance_variable_get('@compass').next
          subject.run(['LEFT'])

          # Setting the compass before current position and then doing next to get the current position
          3.times { subject.instance_variable_get('@compass').next }

          expect(subject.instance_variable_get('@compass').next[0]).to eql(target)
        end
      end

      it 'resets the error array - any command is resetting it' do
        subject.run(['PLACE', in_range_x, in_range_y, direction])
        subject.run(['PLACE'])
        expect(subject.errors).to eql(['ERROR! PLACE command invalid, options missing'])
        subject.run(['LEFT'])

        expect(subject.errors).to be_empty
      end

      context 'with invalid params' do
        it 'returns error if the robot is not yet placed on the board' do
          expect(subject.run(['LEFT'])).to eql(['ERROR! Command ignored, the robot is not placed on the board'])
        end
      end
    end

    context 'with RIGHT command' do
      context 'with valid params' do
        it 'sets the robot\'s :facing position key according to command options' do
          subject.run(['PLACE', in_range_x, in_range_y, direction])

          # Get the direction RIGHT of current position
          target = subject.instance_variable_get('@compass').peek[0]

          subject.run(['RIGHT'])

          expect(subject.run(['REPORT'])).to eql(x: in_range_x, y: in_range_y, facing: target)
        end

        it 'sets the robot\'s compass according to the command' do
          subject.run(['PLACE', in_range_x, in_range_y, direction])

          # Get the LEFT direction
          target = subject.instance_variable_get('@compass').peek[0]

          subject.run(['RIGHT'])

          # Setting the compass before current position and then doing next to get the current position
          3.times { subject.instance_variable_get('@compass').next }

          expect(subject.instance_variable_get('@compass').next[0]).to eql(target)
        end
      end

      it 'resets the error array - any command is resetting it' do
        subject.run(['PLACE', in_range_x, in_range_y, direction])
        subject.run(['PLACE'])
        expect(subject.errors).to eql(['ERROR! PLACE command invalid, options missing'])
        subject.run(['RIGHT'])

        expect(subject.errors).to be_empty
      end

      context 'with invalid params' do
        it 'returns error if the robot is not yet placed on the board' do
          expect(subject.run(['RIGHT'])).to eql(['ERROR! Command ignored, the robot is not placed on the board'])
        end
      end
    end

    context 'with MOVE command' do
      context 'with valid params' do
        it 'increments the robot\'s :y position key when moving NORTH' do
          subject.run(['PLACE', 0, 0, 'NORTH'])

          subject.run(['MOVE'])

          expect(subject.run(['REPORT'])).to eql(x: 0, y: 1, facing: 'NORTH')
        end

        it 'increments the robot\'s :x position key when moving EAST' do
          subject.run(['PLACE', 0, 0, 'EAST'])

          subject.run(['MOVE'])

          expect(subject.run(['REPORT'])).to eql(x: 1, y: 0, facing: 'EAST')
        end

        it 'decrements the robot\'s :y position key when moving SOUTH' do
          subject.run(['PLACE', 4, 4, 'SOUTH'])

          subject.run(['MOVE'])

          expect(subject.run(['REPORT'])).to eql(x: 4, y: 3, facing: 'SOUTH')
        end

        it 'decrements the robot\'s :x position key when moving WEST' do
          subject.run(['PLACE', 4, 4, 'WEST'])

          subject.run(['MOVE'])

          expect(subject.run(['REPORT'])).to eql(x: 3, y: 4, facing: 'WEST')
        end
      end

      it 'resets the error array - any command is resetting it' do
        subject.run(['PLACE', 0, 0, 'NORTH'])
        subject.run(['PLACE'])
        expect(subject.errors).to eql(['ERROR! PLACE command invalid, options missing'])
        subject.run(['MOVE'])

        expect(subject.errors).to be_empty
      end

      context 'with invalid params' do
        it 'returns error if the robot is not yet placed on the board' do
          expect(subject.run(['MOVE'])).to eql(['ERROR! Command ignored, the robot is not placed on the board'])
        end
      end
    end

    context 'with REPORT command' do
      context 'with valid params' do
        it 'returns the robot\'s :y position' do
          subject.run(['PLACE', in_range_x, in_range_y, direction])

          subject.run(['REPORT'])

          expect(subject.run(['REPORT'])).to eql(subject.instance_variable_get('@position'))
        end
      end

      it 'resets the error array - any command is resetting it' do
        subject.run(['PLACE', 0, 0, 'NORTH'])
        subject.run(['PLACE'])
        expect(subject.errors).to eql(['ERROR! PLACE command invalid, options missing'])
        subject.run(['REPORT'])

        expect(subject.errors).to be_empty
      end

      context 'with invalid params' do
        it 'returns error if the robot is not yet placed on the board' do
          expect(subject.run(['REPORT'])).to eql(['ERROR! Command ignored, the robot is not placed on the board'])
        end
      end
    end
  end
end
