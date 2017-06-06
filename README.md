# Toy Robot Simulator Application

## Requirements

Ensure you have a Ruby interpreter installed. 

Developed and tested with Ruby version 2.3.4

To run the application as a shell script it must have execution flag enabled.

The file with the simulation commands as a command line argument.

## Running the application

Clone the git repository into a user accessible folder:

```
$ git clone https://github.com/texpert/robot_simulation.git
```

Navigate to application's root folder:

```
$ cd robot_simulation
```

###### See below 3 methods of starting the application:

### Run the application as a shell script

Ensure the application's execution flag is enabled:
```
chmod u+x simulation.rb

```

```
$ ./simulation simulation.txt
```

### Run the application with the default Ruby interpreter

```
$ ruby simulation.rb simulation.txt
```

### Run the application explicitely with the Ruby interpreter of your choice:

```
$ /home/user/.rvm/rubies/ruby-2.4.1/bin/ruby simulation.rb simulation.txt
```
