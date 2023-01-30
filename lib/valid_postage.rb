# frozen_string_literal: true

# Given a set of stamps, the desired postage, and stamp limit, calculate how many ways we can make postage
class ValidPostage
  # As of 2023-Jan
  US_POSTAGE_STAMPS = [145, 111, 103, 100, 87, 63, 40, 24, 10, 5, 4, 3, 2, 1].freeze
  US_POSTAGE_COSTS = {
    international: 145,
    letter: 63,
    postcard: 48
  }.freeze

  attr_accessor :stamp_limit, :target_postage, :valid_postage, :stamp_denoms, :calculations_complete

  # By default, what can we do with 3 US stamps on a postcard
  # TODO Validate args
  def initialize(stamp_limit: 3, target_postage: US_POSTAGE_COSTS[:postcard], stamp_denoms: US_POSTAGE_STAMPS)
    # External-facing vars
    self.stamp_limit = stamp_limit
    self.target_postage = target_postage
    self.stamp_denoms = stamp_denoms.sort.reverse

    # Working vars
    self.valid_postage = []
    self.calculations_complete = false
  end

  # don't make the external users think about the args
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
      # we got to the depth limit with a single denom, quit checking
      self.calculations_complete = true if applied_postage.first == active_denom
      return
    end

    # Add our active denomination
    new_postage = [*applied_postage, active_denom]

    # If we made postage, Add to valid combos
    if new_postage.sum >= target_postage
      valid_postage.push(new_postage)
    else # Otherwise, continue depth-wise
      calculate_combinations(current_depth + 1, new_postage, working_denoms)
    end

    # Regardless, continue breadth-wise
    # Remove the current largest denom
    # call at our same depth with the same applied postage passed into us
    working_denoms.shift
    calculate_combinations(current_depth, applied_postage, working_denoms)
  end
end
