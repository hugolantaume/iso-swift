require 'yaml'
require 'countries'

module ISO

  # SWIFT
  #
  # Usage
  # =====
  #
  class SWIFT

    # Swift regular expression
    Regex = /^[A-Z]{4}[A-Z]{2}[A-Z0-9]{2}([A-Z0-9]{3})?$/

    # Attributes
    AttrReaders = [
      :formatted_swift,
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

    def initialize(swift)
      @data = {}
      @errors = []
      swift = parse(swift)
      validate(swift)
      feed_codes(swift)
      feed_country_name
      feed_lookup_info
    end

    def feed_codes(swift)
      if @errors.empty?
        @data["formatted_swift"] = swift
        @data["bank_code"] = swift[0..3]
        @data["country_code"] = swift[4..5]
        @data["location_code"] = swift[6..7]
        @data["branch_code"] = swift[8..10]
      end
    end

    def feed_country_name
      country = ::Country.new(country_code)
      @data["country_name"] = country.name if country
    end

    def feed_lookup_info
    end

    def formatted_swift
      @data["formatted_swift"].to_s
    end

    def bank_code
      @data["bank_code"].to_s
    end

    def bank_name
      @data["bank_name"].to_s
    end

    def country_code
      @data["country_code"].to_s
    end

    def country_name
      @data["country_name"].to_s
    end

    def location_code
      @data["location_code"].to_s
    end

    def location_name
      @data["location_name"].to_s
    end

    def branch_code
      @data["branch_code"].to_s
    end

    def branch_name
      @data["branch_name"].to_s
    end

    def errors
      @errors.to_a
    end

    def valid?
      @errors.empty?
    end

    private

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