# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '[ISO::SWIFT]' do

  context 'a new ISO::SWIFT instance' do

    let(:swift) { ISO::SWIFT.new('PSSTFRPPSCE') }

    it 'responds to :valid?' do
      expect(swift).to respond_to(:valid?)
    end

    it 'responds to :errors' do
      expect(swift).to respond_to(:errors)
    end

    it 'responds to :original' do
      expect(swift).to respond_to(:original)
    end

    it 'responds to :formatted' do
      expect(swift).to respond_to(:formatted)
    end

    it 'responds to :bank_code' do
      expect(swift).to respond_to(:bank_code)
    end

    it 'responds to :bank_name' do
      expect(swift).to respond_to(:bank_name)
    end

    it 'responds to :country_code' do
      expect(swift).to respond_to(:country_code)
    end

    it 'responds to :country_name' do
      expect(swift).to respond_to(:country_name)
    end

    it 'responds to :location_code' do
      expect(swift).to respond_to(:location_code)
    end

    it 'responds to :location_name' do
      expect(swift).to respond_to(:location_name)
    end

    it 'responds to :branch_code' do
      expect(swift).to respond_to(:bank_code)
    end

    it 'responds to :branch_name' do
      expect(swift).to respond_to(:branch_name)
    end
  end

  context 'a new ISO::SWIFT instance with a valid SWIFT code' do
  
    let(:swift) { ISO::SWIFT.new('PSST FR PP SCE') }

    it 'is valid' do
      expect(swift).to be_valid
      expect(swift.valid?).to eq(true)
    end

    it 'has no error' do
      expect(swift.errors).to be_empty
    end

    context '[attributes]' do

      it '[:original] is OK' do
        expect(swift.original).to eq('PSST FR PP SCE')
      end

      it '[:formatted] is OK' do
        expect(swift.formatted).to eq('PSSTFRPPSCE')
      end

      it '[:bank_code] is OK' do
        expect(swift.bank_code).to eq('PSST')
      end

      it '[:bank_name] is OK' do
        expect(swift.bank_name).to eq('LA BANQUE POSTALE')
      end

      it '[:country_code] is OK' do
        expect(swift.country_code).to eq('FR')
      end

      it '[:country_name] is OK' do
        expect(swift.country_name).to eq('France')
      end

      it '[:location_code] is OK' do
        expect(swift.location_code).to eq('PP')
      end

      it '[:location_name] is OK' do
        expect(swift.location_name).to eq('ORLEANS')
      end

      it '[:branch_code] is OK' do
        expect(swift.branch_code).to eq('SCE')
      end

      it '[:branch_name] is OK' do
        expect(swift.branch_name).to eq('CENTRE FINANCIER DORLEANS LA SOURCE')
      end
    end
  end

  context 'a new ISO::SWIFT instance with ill-formed SWIFT code' do

    let(:swift) { ISO::SWIFT.new('PSSTFRPPS') }

    it 'is not valid' do
      expect(swift).not_to be_valid
    end

    it 'has errors' do
      expect(swift.errors).not_to be_empty
    end

    it 'has an error array including :bad_format' do
      expect(swift.errors).to include(:bad_format)
    end

    context '[attributes]' do

      it '[:original] is OK' do
        expect(swift.original).to eq('PSSTFRPPS')
      end

      it 'all other attributes are nil' do
        expect(swift.formatted).to be_nil
        expect(swift.bank_code).to be_nil
        expect(swift.bank_name).to be_nil
        expect(swift.country_code).to be_nil
        expect(swift.country_name).to be_nil
        expect(swift.location_code).to be_nil
        expect(swift.location_name).to be_nil
        expect(swift.branch_code).to be_nil
        expect(swift.branch_name).to be_nil
      end
    end
  end

  context 'a new ISO::SWIFT instance with an invalid country code' do

    let(:swift) { ISO::SWIFT.new('PSSTFAPPSCE') }

    it 'is not valid' do
      expect(swift).not_to be_valid
    end

    it 'has errors' do
      expect(swift.errors).not_to be_empty
    end

    it 'has an errors array including :bad_country_code' do
      expect(swift.errors).to include(:bad_country_code)
    end

    it 'has no country name' do
      expect(swift.country_name).to be_nil
    end
  end

  context 'a new ISO::SWIFT instance with an unknown SWIFT code' do

    let(:swift) { ISO::SWIFT.new('PSSTFIPPSCE') }

    it 'is valid' do
      expect(swift).to be_valid
    end

    it 'has no error' do
      expect(swift.errors).to be_empty
    end

    it 'has no lookup info' do
      expect(swift.bank_name).to be_nil
      expect(swift.location_name).to be_nil
      expect(swift.branch_name).to be_nil
    end
  end
end