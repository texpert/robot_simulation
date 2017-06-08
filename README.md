# Toy Robot Simulator Application

## Requirements

Ensure you have a Ruby interpreter installed. (Developed and tested with Ruby version 2.3.4)

Rubygems and bundle gem installed.

To run the application as a shell script it must have execution flag enabled.

The file with the simulation commands as a command line argument.

## Installing the application

Check to see whether RubyGems is installed:

```
$ gem --version
2.6.10
```

If it is not installed, follow the instructions on [Rubygems download page](https://rubygems.org/pages/download/).

Then, check if bundler gem is installed:

```
$ gem list bundler

*** LOCAL GEMS ***

bundler (1.15.1, 1.14.6, 1.14.5, 1.14.3, 1.13.7)

```

Install bundler, if it is missing:

```
$ gem install bundler
```

Clone the git repository into a user accessible folder:

```
$ git clone https://github.com/texpert/robot_simulation.git
```

Navigate to application's root folder:

```
$ cd robot_simulation
```

Install application's bundle:

```
$ bundle install
```

## Running the application

###### See below 3 methods of starting the application:

### Run the application as a shell script

Ensure the application's execution flag is enabled:
```
$ chmod u+x simulation.rb

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

## Running the specs

To run all the specs, run in the root application folder:

```
$ rspec
```
