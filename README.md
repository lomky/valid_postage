## Install

- clone repo
- install ruby 3.2.0
- (for tests) `gem install bundler && bundle install`

## Usage

```bash
Usage: ./bin/calculate_postage [options]

Given a target postage, some stamp denominations, and how many stamps you wanna use, this program will tell you how many ways you can make postage

  -n, --number LIMIT               How many stamps max. Default 3
  -p, --postage POSTAGE            Your target postage. Default is a US Postcar
  -s, --stamps STAMPS              Your stamp denominations, in cents (or equivalent). Default is US Postage Stamp denominations
  -h, --help                       Show this message
```

### Examples

Using two stamps and limiting overpayment by 20, make the US Letter postage and output as csv:  
```bash
./bin/calculate_postage --number 2 --postage 63 --overpay 20 --csv
target,num_stamps,overpayment,stamps
63,1,0,[63]
63,2,9,"[48, 24]"
63,2,17,"[40, 40]"
63,2,1,"[40, 24]"
```

Using three stamps and limiting overpayment to 50, make the US International postage:  
```bash
❯ ./bin/calculate_postage --overpay 50 -p 145 -n3
There are 39 ways to make 145 in 3 stamps without overpaying by more than 50.

145:   1/39 use this denom
111:   5/39 use this denom
103:  11/39 use this denom
100:   8/39 use this denom
 87:  10/39 use this denom
 63:  10/39 use this denom
 48:  10/39 use this denom
 40:  17/39 use this denom
 24:   9/39 use this denom
 10:   4/39 use this denom
  5:   2/39 use this denom
  4:   1/39 use this denom
  3:   1/39 use this denom
  2:   1/39 use this denom
  1:   0/39 use this denom
with  1 stamps: [[145]]
with  2 stamps: [[111, 63], [111, 48], [111, 40], [103, 87], [103, 63], [103, 48], [100, 87], [100, 63], [100, 48], [87, 87], [87, 63]]
with  3 stamps: [[111, 24, 24], [111, 24, 10], [103, 40, 40], [103, 40, 24], [103, 40, 10], [103, 40, 5], [103, 40, 4], [103, 40, 3], [103, 40, 2], [103, 24, 24], [100, 40, 40], [100, 40, 24], [100, 40, 10], [100, 40, 5], [100, 24, 24], [87, 48, 48], [87, 48, 40], [87, 48, 24], [87, 48, 10], [87, 40, 40], [87, 40, 24], [63, 63, 63], [63, 63, 48], [63, 63, 40], [63, 63, 24], [63, 48, 48], [63, 48, 40]]
```

## Testing

`bundle exec rspec`

## Linting

`bundle exec rubocop`

## Issues & Todo

- Passing in new stamp denominations isn't working quite right.
- Output format saying how many ways a denomination can be used
- Add option to limit overpaying as a parameter
- It'd be nice to save to file
- Add tests for stamps with half-penny values
