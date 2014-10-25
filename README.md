# ISO-SWIFT - A SWIFT validation/lookup Ruby gem.

[![Build Status](https://secure.travis-ci.org/hugolantaume/iso-swift.png?branch=master)](http://travis-ci.org/hugolantaume/iso-swift)
[![Gem Version](https://badge.fury.io/rb/credit_card_bins.svg)](http://badge.fury.io/rb/iso-swift)
[![Coverage Status](https://coveralls.io/repos/hugolantaume/iso-swift/badge.png?branch=master)](https://coveralls.io/r/hugolantaume/iso-swift?branch=master)

Swift code (ISO 9362/SWIFT-BIC/BIC code/SWIFT ID) is a standard format of Bank Identifier Codes (BIC) and it is unique identification code for a particular bank.
ISO::SWIFT implements the Swift specification as per ISO 9362.
It provides methods to validate a given Swift code and/or retrieve information such as bank, location or branch names for a given Swift code. 


## Installation

Add this line to your application's Gemfile:

    gem 'iso-swift'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iso-swift

## Usage

    require 'iso/swift'
    
    swift = ISO::SWIFT.new('PSST FR PP SCE') # => #<ISO::SWIFT:0x007fb4a393e220 @data={"formatted"=>"PSSTFRPPSCE", "bank_code"=>"PSST", "country_code"=>"FR", "country_name"=>"France", "location_code"=>"PP", "branch_code"=>"SCE", "bank_name"=>"LA BANQUE POSTALE", "location_name"=>"ORLEANS", "branch_name"=>"CENTRE FINANCIER DORLEANS LA SOURCE"}, @errors=[]>
    swift.valid? # => true
    swift.errors # => []
    swift.original # => "PSST FR PP SCE"
    swift.formatted # => "PSSTFRPPSCE"
    swift.bank_code # => "PSST"
    swift.bank_name # => "LA BANQUE POSTALE"
    swift.country_code # => "FR"
    swift.country_name # => "France"
    swift.location_code # => "PP"
    swift.location_name # => "ORLEANS"
    swift.branch_code # => "SCE"
    swift.branch_name # => "CENTRE FINANCIER DORLEANS LA SOURCE"
    
    swift = ISO::SWIFT.new('PSSTFRCEE') # #<ISO::SWIFT:0x007f8abe708820 @data={}, @errors=[:bad_format]>
    swift.valid? # => false
    swift.errors # => [:bad_format]


## Contributors

* Hugo Lantaume


## License

You can use this code under the {file:LICENSE.txt MIT License}, free of charge.
If you need a different license, please ask the author.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
