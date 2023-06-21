# frozen_string_literal: true

require 'valid_postage'

RSpec.describe ValidPostage, '#initalize' do
  context 'with defaults' do
    it 'initializes fine' do
      postage = ValidPostage.new

      expect(postage.stamp_limit).to eq(3)
      expect(postage.target_postage).to eq(ValidPostage::US_POSTAGE_COSTS[:postcard])
      expect(postage.stamp_denoms).to eq(ValidPostage::US_POSTAGE_STAMPS)
      expect(postage.valid_postage).to be_empty
    end
  end
end

RSpec.describe ValidPostage, '#calculate' do
  context 'with inane arguments like' do
    context 'unreachable target for given stamps denoms' do
      it 'finds no valid postage' do
        postage = ValidPostage.new

        postage.stamp_limit = 2
        postage.target_postage = 2000
        postage.stamp_denoms = [9, 5]

        postage.calculate

        expect(postage.valid_postage).to be_empty
        expect(postage.calculations_complete).to be(true)
      end
    end
  end
  context 'with good arguments like' do
    context 'stamps [145] and target 145' do
      it 'finds valid postage' do
        postage = ValidPostage.new

        postage.stamp_limit = 3
        postage.target_postage = 145
        postage.stamp_denoms = [145]

        postage.calculate

        expect(postage.valid_postage).to eq([[145]])
        expect(postage.calculations_complete).to be(true)
      end
    end

    context 'stamps [1000] and target 145' do
      it 'finds valid postage' do
        postage = ValidPostage.new

        postage.stamp_limit = 2
        postage.target_postage = 145
        postage.stamp_denoms = [1000]

        postage.calculate

        expect(postage.valid_postage).to eq([[1000]])
        expect(postage.calculations_complete).to be(true)
      end
    end

    context 'stamps [10,5,3,1] and target 13' do
      it 'finds valid postage' do
        postage = ValidPostage.new

        postage.stamp_limit = 4
        postage.target_postage = 13
        postage.stamp_denoms = [10, 5, 3, 1]

        postage.calculate

        expect(postage.valid_postage).to eq([[10, 10], [10, 5], [10, 3], [10, 1, 1, 1], [5, 5, 5], [5, 5, 3],
                                             [5, 3, 3, 3]])
        expect(postage.calculations_complete).to be(true)
      end
    end

    context 'US 2023 stamps and postcard target with limit 4' do
      it 'finds valid postage' do
        postage = ValidPostage.new

        postage.stamp_limit = 4
        postage.target_postage = 48
        postage.stamp_denoms = [145, 111, 103, 100, 87, 63, 48, 40, 24, 10, 5, 4, 3, 2, 1]

        postage.calculate

        expect(postage.calculations_complete).to be(true)
        expect(postage.valid_postage).to match_array([[145], [111], [103], [100], [87], [63], [48], [40, 40], [40, 24],
                                                      [40, 10], [24, 24], [40, 5, 5], [40, 5, 4], [40, 5, 3], [40, 4, 4], [40, 5, 2, 2], [40, 5, 2, 1], [40, 4, 3, 3], [40, 4, 3, 2], [40, 4, 3, 1], [40, 4, 2, 2], [40, 3, 3, 3], [40, 3, 3, 2], [24, 10, 10, 10], [24, 10, 10, 5], [24, 10, 10, 4]])
      end
    end
  end
end
