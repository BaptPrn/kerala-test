class OldAppDataImportService
  require 'csv'

  def initialize(model_name:, csv_filename:)
    @model_name = model_name
    @csv_filename = csv_filename
  end

  def find_modified_records
    puts "--- Importing records from #{@csv_filename}"
    puts ''
    modified_records = []
    CSV.foreach(@csv_filename, headers: true) do |row|
      record = row.to_hash
      modified_records << record unless database_records.include?(record)
    end
    modified_records
  end

  private

  def database_records
    @_database_records ||=
      if @model_name == 'Building'
        Building.all.pluck_to_hash(:reference, :address, :zip_code, :city, :country, :manager_name)
        # I tried to do something more flexible, like Building.attribute_names - ['id', 'created_at', 'updated_at'] but could not make it work with the pluck_to_hash method
      elsif @model_name == 'Person'
        Person.all.pluck_to_hash(:reference, :email, :home_phone_number, :mobile_phone_number, :firstname, :lastname, :address)
      end
  end
end
