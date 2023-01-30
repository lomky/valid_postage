## INSTALL

- clone repo
- install ruby 3.2.0
- (for tests) `gem install bundler && bundle install`

## USAGE

Usage: ./bin/calculate_postage [options]

Given a target postage, some stamp denominations, and how many stamps you wanna use, this program will t
ell you how many ways you can make postage

  -n, --number LIMIT               How many stamps max. Default 3.
  -p, --postage POSTAGE            Your target postage. Default is a US Postcard
  -s, --stamps STAMPS              Your stamp denominations, cents (or equivalent). Default is US Postage Stamp denominations
  -h, --help                       Show this message


## ISSUES

- Passing in new stamp denominations isn't working quite right.
- It'd be nice to save to file
