require 'rails_helper'
require 'csv'

describe OldAppDataImportService do
  describe '#find_modified_records' do
    context 'for the People model' do
      before do
        CSV.foreach('people.csv', headers: true) do |row|
          Person.create(row.to_hash)
        end
      end

      after do
        Person.destroy_all
      end

      it 'finds all the records modified in the csv provided' do
        modified_records = OldAppDataImportService.new(model_name: 'Person', csv_filename: 'spec/support/services/people_modified.csv').find_modified_records

        expect(modified_records.pluck('reference')).to eq(["1", "2", "6", "9", "12", "14", "19"])
      end

      it 'returns a list of attributes hashes' do
        modified_records = OldAppDataImportService.new(model_name: 'Person', csv_filename: 'spec/support/services/people_modified.csv').find_modified_records

        expect(modified_records.class).to eq(Array)
        expect(modified_records.first.class).to eq(Hash)
        expect(modified_records.first).to eq({"reference"=>"1", "firstname"=>"John", "lastname"=>"Doe", "home_phone_number"=>"0107572353", "mobile_phone_number"=>"0605778066", "email"=>"providencia@schowalter.name", "address"=>"Suite 597 36020 Stracke Trace, North Alidafurt, WY 32448-9190"})
      end

      it 'checks all the attributes except the id and the timestamps' do
        a_modified_record = OldAppDataImportService.new(model_name: 'Person', csv_filename: 'spec/support/services/people_modified.csv').find_modified_records.first

        expect(a_modified_record.keys).to match_array(Person.attribute_names - ['id', 'created_at', 'updated_at'])
      end
    end

    context 'for the Building model' do
      it 'checks all the attributes except the id and the timestamps' do
        a_modified_record = OldAppDataImportService.new(model_name: 'Building', csv_filename: 'spec/support/services/buildings_modified.csv').find_modified_records.first

        expect(a_modified_record.keys).to match_array(Building.attribute_names - ['id', 'created_at', 'updated_at'])
      end
    end
  end
end
