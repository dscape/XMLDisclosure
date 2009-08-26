#!/usr/bin/ruby
################################################################################
##                                                                            ##
##  Script: runTests.rb                                                       ##
##    Author: Nuno Job  ( nunojobpinto at gmail )                             ##
##    Date: August 2009                                                       ##
##    License: creativecommons.org/licenses/by/3.0                            ##
##                                                                            ##
################################################################################
require 'optparse'
require 'rubygems'

####################################################################### Class ##
class Tests
  def self.run options
    orig_stdout = $stdout
    @options = options

    $stdout = File.new(options[:filename], 'w') if options[:filename]

    process_files @options[:dir]

    $stdout = orig_stdout
  end

  def self.process_files directory, depth=1
    files = Dir.entries(directory).reject do
      |file| file == "." or file == ".."
    end

    files.each do |filename|
      full_path_to_file = File.join(directory, filename)
      if File.directory? full_path_to_file
        puts_idented_file depth, full_path_to_file, '.'
        process_files full_path_to_file, depth + 1
      elsif File.executable? full_path_to_file
        puts_idented_file depth, filename, '+'
        run_unit_test filename, directory, depth + 1 
      end
    end
  end

  def self.run_unit_test file, directory, depth
    log_file = 
      File.join directory, "../" * (depth-1), "log", file.gsub(".sh", ".log")

    file = File.join(directory, file)
    out_file = file.gsub ".sh", ".out"
    aux_file = file.gsub ".sh", ".aux"

    output = `#{file} #{@options[:db]}`
    expected_output = File.open(out_file).readlines.join

    unless output == expected_output
      depth.times { print "  " }
      puts "NOK!"

      File.open(aux_file, 'w') { |file| file.write output }
      diff = `diff #{aux_file} #{out_file}`
      File.delete aux_file

      File.open(log_file, 'w') { |file| file.write diff }
    end
  end

  def self.puts_idented_file depth, file, symbol
    depth.times { print "  " }
    puts "#{symbol} #{file}"
  end
end

######################################################################## Main ##
options = {}

OptionParser.new do |opts|
  opts.banner = "USAGE: runTests.rb [options]"
  opts.on("-d",
          "--directory DIR",
          String,
          "The directory you want to scan test files.") do |dir|
            options[:dir] = dir
          end
  opts.on("-t",
          "--to FILENAME",
          String,
          "The desired filename for the output file.") do |to|
            options[:filename] = to
          end
end.parse!

options[:dir] = File.join(Dir.pwd, 'test') unless options[:dir]
options[:db] = ARGV[0]

Tests.run(options)
######################################################################### EOF ##
