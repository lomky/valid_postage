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

Using six stamps, make the US Letter postage:  
```bash
./bin/calculate_postage --number 6 --postage 63
```

Using four stamps, make the US Postcard postage:  
```bash
./bin/calculate_postage --number 4
```

Using seven stamps, make the US International postage:  
```bash
./bin/calculate_postage --number 6 --postage 145
```

Using three stamps and a custom set of stamp values and postage:  
(currently bugged as a command line argument, must be modified in-code)  
```bash
./bin/calculate_postage --number 6 --postage 55 --stamps 1,2,3,5,8,13,21,34,55,89
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
