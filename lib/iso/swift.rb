require 'yaml'
require 'countries'

module ISO

  # SWIFT
  #
  # Usage
  # =====
  #
  #     require 'iso/swift'
  #     ==== new instance - valid SWIFT code
  #     swift = ISO::SWIFT.new('PSST FR PP SCE') # => #<ISO::SWIFT:0x007fb4a393e220 @data={"formatted"=>"PSSTFRPPSCE", "bank_code"=>"PSST", "country_code"=>"FR", "country_name"=>"France", "location_code"=>"PP", "branch_code"=>"SCE", "bank_name"=>"LA BANQUE POSTALE", "location_name"=>"ORLEANS", "branch_name"=>"CENTRE FINANCIER DORLEANS LA SOURCE"}, @errors=[]>
  #     ==== validation
  #     swift.valid? # => true
  #     swift.errors # => []
  #     ==== attributes
  #     swift.original # => "PSST FR PP SCE"
  #     swift.formatted # => "PSSTFRPPSCE"
  #     swift.bank_code # => "PSST"
  #     swift.bank_name # => "LA BANQUE POSTALE"
  #     swift.country_code # => "FR"
  #     swift.country_name # => "France"
  #     swift.location_code # => "PP"
  #     swift.location_name # => "ORLEANS"
  #     swift.branch_code # => "SCE"
  #     swift.branch_name # => "CENTRE FINANCIER DORLEANS LA SOURCE"
  #
  #     ==== new instance - invalid SWIFT code
  #     swift = ISO::SWIFT.new('PSSTFRCEE') # #<ISO::SWIFT:0x007f8abe708820 @data={}, @errors=[:bad_format]>
  #     ==== validation
  #     swift.valid? # => false
  #     swift.errors # => [:bad_format]

  class SWIFT

    # Swift regular expression
    Regex = /^[A-Z]{4}[A-Z]{2}[A-Z0-9]{2}([A-Z0-9]{3})?$/

    # Attributes
    AttrReaders = [
      :original,
      :formatted,
      :bank_code,
      :bank_name,
      :country_code,
      :country_name,
      :location_code,
      :location_name,
      :branch_code,
      :branch_name
    ]

    AttrReaders.each do |meth|
      define_method meth do
        @data[meth.to_s]
      end
    end

    attr_reader :data
    attr_reader :errors

    # @param [String] swift
    #   The SWIFT in either compact or human readable form.
    #
    # @return [ISO::SWIFT]
    #   A new instance of ISO::SWIFT
    def initialize(swift)
      @data = {}
      @errors = []
      @data["original"] = swift
      swift = parse(swift)
      validate(swift)
      if @errors.empty?
        feed_codes(swift)
        feed_lookup_info(swift)
      end
    end

    # @param [String] swift
    #   The SWIFT in either compact or human readable form.
    #
    # Extracts bank, country, location and branch codes from the parameter
    def feed_codes(swift)
      if @errors.empty?
        @data["formatted"] = swift
        @data["bank_code"] = swift[0..3]
        @data["country_code"] = swift[4..5]
        country = ISO3166::Country.new(country_code)
        if country
          @data["country_name"] = country.iso_short_name
        else
          @errors << :bad_country_code
        end
        @data["location_code"] = swift[6..7]
        @data["branch_code"] = swift[8..10]
      end
    end

    # @param [String] swift
    #   The SWIFT in either compact or human readable form.
    #
    # Lookup for the formatted swift in data/*country_code*.yml
    # If found, extract the bank, location and branch names
    def feed_lookup_info(swift)
      cc = country_code.downcase
      path = File.expand_path("../../data/#{cc}.yml", __FILE__)
      if File.file?(path)
        db = YAML.load_file(path) || nil
        if db
          lk = db[formatted]
          if lk
            @data["bank_name"] = lk["institution"]
            @data["location_name"] = lk["city"]
            @data["branch_name"] = lk["branch"]
          end
        end
      end
    end

    # @return [String]
    #   Retuns the original swift from an ISO::SWIFT instance
    def original
      @data["original"]
    end

    # @return [String]
    #   Retuns the formatted swift from an ISO::SWIFT instance
    def formatted
      @data["formatted"]
    end

    # @return [String]
    #   Retuns the bank code from an ISO::SWIFT instance
    def bank_code
      @data["bank_code"]
    end

    # @return [String]
    #   Retuns the bank name from an ISO::SWIFT instance
    def bank_name
      @data["bank_name"]
    end

    # @return [String]
    #   Retuns the country code from an ISO::SWIFT instance
    def country_code
      @data["country_code"]
    end

    # @return [String]
    #   Retuns the country name from an ISO::SWIFT instance
    #   The country name was fetched using https://github.com/hexorx/countries
    def country_name
      @data["country_name"]
    end

    # @return [String]
    #   Retuns the location code from an ISO::SWIFT instance
    def location_code
      @data["location_code"]
    end

    # @return [String]
    #   Retuns the location name from an ISO::SWIFT instance
    def location_name
      @data["location_name"]
    end

    # @return [String]
    #   Retuns the branch code from an ISO::SWIFT instance
    def branch_code
      @data["branch_code"]
    end

    # @return [String]
    #   Retuns the branch name from an ISO::SWIFT instance
    def branch_name
      @data["branch_name"]
    end

    # @return [Array<Sym>]
    #   Retuns an array of errors in symbol format from validation step, if any
    def errors
      @errors.to_a
    end

    # @return [Boolean]
    #   Returns if the current ISO::SWIFT instance if valid
    def valid?
      @errors.empty?
    end

    private

    # @param [String] swift
    #   The SWIFT in either compact or human readable form.
    #
    # Validation of the length and format of the formatted swift
    def validate(swift)
      @errors << :too_short if swift.size < 8
      @errors << :too_long if swift.size > 11
      @errors << :bad_chars unless swift =~ /^[A-Z0-9]+$/
      @errors << :bad_format unless swift =~ Regex
    end

    # @param [String] swift
    #   The SWIFT in either compact or human readable form.
    #
    # @return [String]
    #   The SWIFT in compact form, all whitespace and dashes stripped.
    def strip(swift)
      swift.delete("\n\r\t -")
    end

    # @param [String, nil] swift
    #   The SWIFT in either compact or human readable form.
    #
    # @return [String]
    #   The SWIFT in either compact or human readable form.
    def parse(swift)
      strip(swift || "").upcase
    end
  end
end
