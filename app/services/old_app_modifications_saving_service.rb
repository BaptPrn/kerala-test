class OldAppModificationsSavingService
  def initialize(model_name:, modified_records: )
    @model_name = model_name
    @modified_records = modified_records
  end

  def validate_and_save_modifications
    @modified_records.each do |old_app_record|
      old_app_record_modifications = attributes_modified_by(old_app_record)
      puts "Modified attributes: #{ old_app_record_modifications }"
      attributes_to_update_in_db = validate_attributes_to_update_in(old_app_record_modifications)
      if attributes_to_update_in_db.present?
        current_db_record_for(old_app_record).update(attributes_to_update_in_db)
        puts "Updated attributes: #{ attributes_to_update_in_db }"
      else
        puts 'No attribute to update'
      end
      puts ''
    end
  end

  private

  def attributes_modified_by(old_app_record)
    (old_app_record.to_a - current_db_record_for(old_app_record).attributes.to_a).to_h
  end

  def current_db_record_for(old_app_record)
    @model_name.constantize.find_by(reference: old_app_record['reference'])
  end

  def validate_attributes_to_update_in(modified_attributes)
    attributes_to_update = modified_attributes
    attributes_to_validate = attributes_to_update.keys & model_monitored_attributes
    if attributes_to_validate.present?
      attributes_to_validate.each do |attribute|
        attributes_to_update.delete(attribute) if PaperTrail::Version
          .where(item_type: @model_name)
          .where_object(attribute => attributes_to_update[attribute])
          .present?
      end
    end
    attributes_to_update
  end

  def model_monitored_attributes
    @model_name.constantize.paper_trail_options[:only]
  end
end
