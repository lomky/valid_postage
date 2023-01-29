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

  attr_accessor :stamp_limit, :target_postage, :valid_postage, :stamp_denoms, :valid_denoms

  # By default, what can we do with 3 US stamps on a postcard
  def initialize(stamp_limit: 3, target_postage: US_POSTAGE_COSTS[:postcard], stamp_denoms: US_POSTAGE_STAMPS)
    # External-facing vars
    self.stamp_limit = stamp_limit
    self.target_postage = target_postage
    self.stamp_denoms = stamp_denoms.sort.reverse

    # Working vars
    self.valid_postage = []
    self.valid_denoms = stamp_denoms.to_h { |x| [x, false] }
  end

  def calculate_combinations(current_depth, applied_postage, working_denoms)
    # we have gotten to the point where the stamp limit of
    # our highest remaining denomination won't make postage
    # stop checking!
    return if calculations_exhausted

    active_denom = working_denoms.first
    # We are over our stamp count, return
    # If we didn't get any valid combos with our
    # highest denom, flag exhaustion
    if current_depth > stamp_limit
      calculations_exhausted unless valid_denoms.active_denom
      return
    end

    # Check the math!
    applied_postage.push(active_denom)

    # we made postage! yay!
    return unless applied_postage.sum >= target_postage

    valid_postage.push(applied_postage)
  end
end
