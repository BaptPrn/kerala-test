require 'rails_helper'

describe OldAppModificationsSavingService do
  context 'for the Person model and people.csv' do
    describe '#validate_and_save_modifications' do
      before do
        create(:person, reference: 1, firstname: 'Jean', lastname: 'Dupond')
        create(:person, reference: 2, email: 'email@example.com', mobile_phone_number: '0000000000')
        create(:person, reference: 3, address: 'a random address')
      end

      after do
        Person.destroy_all
      end

      it 'modifies all attributes when their values are new' do
        service = OldAppModificationsSavingService.new(model_name: 'Person', modified_records: modified_records)

        service.validate_and_save_modifications

        expect(Person.find_by(reference: 1).firstname).to eq('Modified firstname')
        expect(Person.find_by(reference: 1).lastname).to eq('Modified lastname')
        expect(Person.find_by(reference: 2).email).to eq('a_modified_email@example.com')
        expect(Person.find_by(reference: 2).mobile_phone_number).to eq('1111111111')
        expect(Person.find_by(reference: 3).address).to eq('a modified address')
      end

      it 'modifies only non monitored attributes when values ahve already been used' do
        initial_values_for_records = Person.all.pluck_to_hash(:reference, :email, :home_phone_number, :mobile_phone_number, :firstname, :lastname, :address)
        OldAppModificationsSavingService.new(model_name: 'Person', modified_records: modified_records).validate_and_save_modifications # we give new values to the records
        OldAppModificationsSavingService.new(model_name: 'Person', modified_records: initial_values_for_records).validate_and_save_modifications # we assign their initial values to the records

        expect(Person.find_by(reference: 1).firstname).to eq('Jean') # updated a second time as the attribute is not monitored
        expect(Person.find_by(reference: 1).lastname).to eq('Dupond') # updated a second time as the attribute is not monitored
        expect(Person.find_by(reference: 2).email).to eq('a_modified_email@example.com') # NOT updated a second time as the attribute is monitored
        expect(Person.find_by(reference: 2).mobile_phone_number).to eq('0000000000') # updated a second time as the attribute is not monitored
        expect(Person.find_by(reference: 3).address).to eq('a modified address') # NOT updated a second time as the attribute is monitored
      end
    end
  end

  def create_records_from(csv_file)
    CSV.foreach(csv_file, headers: true) do |row|
      Person.create(row.to_hash)
    end
  end

  private

  def modified_records
    first_user_attributes = Person.find_by(reference: 1).attributes
    second_user_attributes = Person.find_by(reference: 2).attributes
    third_user_attributes = Person.find_by(reference: 3).attributes

    first_user_attributes['firstname'] = 'Modified firstname'
    first_user_attributes['lastname'] = 'Modified lastname'
    second_user_attributes['email'] = 'a_modified_email@example.com'
    second_user_attributes['mobile_phone_number'] = '1111111111'
    third_user_attributes['address'] = 'a modified address'

    [
      first_user_attributes,
      second_user_attributes,
      third_user_attributes
    ]
  end
end
