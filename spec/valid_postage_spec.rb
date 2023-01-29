# frozen_string_literal: true

require 'valid_postage'

RSpec.describe ValidPostage, '#initalize' do
  context 'with defaults' do
    it 'initializes fine' do
      postage = ValidPostage.new

      expect(postage.stamp_limit).to eq(3)
      expect(postage.target_postage).to eq(ValidPostage::US_POSTAGE_COSTS[:postcard])
      expect(postage.stamp_denoms).to eq(ValidPostage::US_POSTAGE_STAMPS)
      expect(postage.valid_denoms[145]).to eq(false)
      expect(postage.valid_postage).to be_empty
    end
  end

  context 'fully specified' do
    it 'initializes fine' do
      postage = ValidPostage.new(stamp_limit: 2, target_postage: 99, stamp_denoms: [80, 5])

      expect(postage.stamp_limit).to eq(2)
      expect(postage.target_postage).to eq(99)
      expect(postage.stamp_denoms).to eq([80, 5])

      expect(postage.valid_denoms[80]).to eq(false)
      expect(postage.valid_postage).to be_empty
    end
  end
end
