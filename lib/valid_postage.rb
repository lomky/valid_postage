# frozen_string_literal: true

require 'csv'
require 'optparse'

# Given a set of stamps, the desired postage, and stamp limit, calculate how many ways we can make postage
class ValidPostage
  # As of 2023-Jan
  US_POSTAGE_STAMPS = [145, 111, 103, 100, 87, 63, 48, 40, 24, 10, 5, 4, 3, 2, 1].freeze
  US_POSTAGE_COSTS = {
    international: 145,
    letter: 63,
    postcard: 48
  }.freeze

  attr_accessor :stamp_limit, :overpay_limit, :target_postage, :valid_postage, :stamp_denoms, :calculations_complete, :valid_denoms, :verbose

  # By default, what can we do with 3 US stamps on a postcard, limit overspending to 10 cents
  def initialize
    # External-facing vars
    self.stamp_limit = 3
    self.overpay_limit = 9999
    self.target_postage = US_POSTAGE_COSTS[:postcard]
    self.stamp_denoms = US_POSTAGE_STAMPS.sort.reverse

    self.verbose = false

    # Working vars
    self.valid_postage = []
    self.valid_denoms = stamp_denoms.to_h { |x| [x, false] }
    self.calculations_complete = false
  end

  # don't make the external interface think about the args
  def calculate
    puts "Let's do this!" if self.verbose
    calculate_combinations(1, [], stamp_denoms)
    # in case we didn't exhaust depth during calculations
    self.calculations_complete = true
  end

  # actual calculation logic
  def calculate_combinations(current_depth, applied_postage, working_denoms)
    prefix ="  "*current_depth
    puts "#{prefix}Applied #{applied_postage}. Checking #{working_denoms.first}" if self.verbose

    if calculations_complete
      puts "#{prefix}| Nothing more can make postage on this chain" if self.verbose
      return
    end

    if working_denoms.empty?
      puts "#{prefix}| Denoms all checked on this chain" if self.verbose
      return
    end

    active_denom = working_denoms.first

    # We are over our stamp count, return
    if current_depth > stamp_limit
      # we got to the depth limit with a single denom and it wasn't valid, quit checking
      print "#{prefix}| We are out of stamp slots" if self.verbose
      if applied_postage.first == active_denom && !valid_denoms[active_denom]
        print "#{prefix}| and shouldn't check any further down this chain" if self.verbose
        self.calculations_complete = true
      end
      puts if self.verbose
      return
    end

    # Add our active denomination
    new_postage = [*applied_postage, active_denom]

    if new_postage.sum >= target_postage # We made postage,
      puts "#{prefix}| We can make postage this level" if self.verbose
      valid_postage.push(new_postage)
      valid_denoms[active_denom] = true
    else
      # Otherwise, continue depth-wise
      depth_copy = working_denoms.map(&:clone)
      puts "#{prefix}> Let's add another stamp!" if self.verbose
      calculate_combinations(current_depth + 1, new_postage, depth_copy)
    end

    # Regardless, continue breadth-wise
    # Remove the current largest denom
    # call at our same depth with the same applied postage passed into us
    breadth_copy = working_denoms.map(&:clone)
    breadth_copy.shift
    puts "#{prefix}> Let's check the next denomination!" if self.verbose
    calculate_combinations(current_depth, applied_postage, breadth_copy)
  end

  # eventually, support other outputs
  def output
    format_summary
  end

  def format_csv
    CSV.generate do |csv|
      csv << %w[target num_stamps overpayment stamps]
      valid_postage.each do |postage|
        overpay = postage.sum - target_postage
        next if overpay > self.overpay_limit
        csv << [target_postage, postage.size, overpay, postage.to_s]
      end
    end
  end

  def format_pretty
    (1..stamp_limit).each do |count|
      count_stamps = valid_postage.select { |e| e.size == count }
    end
  end

  def format_summary
    within_overpay = valid_postage.select { |e| e.sum - target_postage <= self.overpay_limit }
    counts = {}
    stamp_denoms.each do |denom|
      counts[denom] = within_overpay.select do |e|
        e.include? denom
      end.size
    end

    output = "There are #{within_overpay.size} ways to make #{target_postage} in #{stamp_limit} stamps without overpaying by more than #{overpay_limit}.\n\n"
    counts.each do |denom, count|
      output += "%3d: " % denom
      output += "%3d/#{within_overpay.size} use this denom\n" % count
    end

    sorted_combos = {}
    (1..stamp_limit).each do |count|
      sorted_combos[count] = within_overpay.select do |e|
        e.size == count
      end
    end

    sorted_combos.each do |num_stamps, combos|
      output += "with %2d stamps: #{combos}\n" % num_stamps
    end
    output
  end

  def parse
    OptionParser.new do |parser|
      parser.banner = 'Usage: ./bin/calculate_postage [options]'
      parser.separator ''
      parser.separator 'Given a target postage, some stamp denominations, and how many stamps you wanna'
      parser.separator 'use, this program will tell you how many ways you can make postage'
      parser.separator ''

      parser.on('-n', '--number LIMIT', Integer, 'How many stamps max. Default 3.') do |number|
        self.stamp_limit = number
      end

      parser.on('-p', '--postage POSTAGE', Integer, 'Your target postage. Default is a US Postcard') do |postage|
        self.target_postage = postage
      end

      parser.on('-o', '--overpay OVERPAY', Integer, 'How much you want to limit overpaying. Default 9999') do |overpay|
        self.overpay_limit = overpay
      end

      parser.on('-s', '--stamps STAMPS', Array,
                'Your stamp denominations, cents (or equivalent). Default is USPS denominations') do |stamps|
        self.stamp_denoms = stamps.map(&:to_i)
      end

      parser.on('-v', '--verbose', 'Prints out (lots) of context') do
        self.verbose = true
      end

      parser.on('-h', '--help', 'Show this message') do
        puts parser
        exit
      end
    end.parse!
  end
end
