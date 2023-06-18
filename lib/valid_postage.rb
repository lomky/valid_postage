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

  attr_accessor :stamp_limit, :target_postage, :valid_postage, :stamp_denoms, :calculations_complete, :valid_denoms

  # By default, what can we do with 3 US stamps on a postcard
  def initialize
    # External-facing vars
    self.stamp_limit = 3
    self.target_postage = US_POSTAGE_COSTS[:postcard]
    self.stamp_denoms = US_POSTAGE_STAMPS.sort.reverse

    # Working vars
    self.valid_postage = []
    self.valid_denoms = stamp_denoms.to_h { |x| [x, false] }
    self.calculations_complete = false
  end

  # don't make the external interface think about the args
  def calculate
    calculate_combinations(1, [], stamp_denoms)
    # in case we didn't exhaust depth during calculations
    self.calculations_complete = true
  end

  # actual calculation logic
  def calculate_combinations(current_depth, applied_postage, working_denoms)
    # we discovered deeper in that we can't meet postage anymore, stop checking!
    return if calculations_complete

    # oops we're out of stamps options!
    return if working_denoms.empty?

    active_denom = working_denoms.first

    # We are over our stamp count, return
    if current_depth > stamp_limit
      # we got to the depth limit with a single denom and it wasn't valid, quit checking
      self.calculations_complete = true if applied_postage.first == active_denom && !valid_denoms[active_denom]
      return
    end

    # Add our active denomination
    new_postage = [*applied_postage, active_denom]

    # If we made postage, Add to valid combos
    if new_postage.sum >= target_postage
      valid_postage.push(new_postage)
      valid_denoms[active_denom] = true
    else # Otherwise, continue depth-wise
      depth_copy = working_denoms.map(&:clone)
      calculate_combinations(current_depth + 1, new_postage, depth_copy)
    end

    # Regardless, continue breadth-wise
    # Remove the current largest denom
    # call at our same depth with the same applied postage passed into us
    breadth_copy = working_denoms.map(&:clone)
    breadth_copy.shift
    calculate_combinations(current_depth, applied_postage, breadth_copy)
  end

  def format_csv
    CSV.generate do |csv|
      csv << %w[target num_stamps overpayment stamps]
      valid_postage.each do |postage|
        csv << [target_postage, postage.size, postage.sum - target_postage, postage.to_s]
      end
    end
  end

  def format_pretty
    (1..stamp_limit).each do |count|
      count_stamps = valid_postage.select { |e| e.size == count }
    end
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

      parser.on('-s', '--stamps STAMPS', Array,
                'Your stamp denominations, cents (or equivalent). Default is USPS denominations') do |stamps|
        self.stamp_denoms = stamps.map(&:to_i)
      end

      parser.on('-h', '--help', 'Show this message') do
        puts parser
        exit
      end
    end.parse!
  end
end
