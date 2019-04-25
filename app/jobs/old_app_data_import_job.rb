class OldAppDataImportJob < ApplicationJob
  def perform(model_name:, csv_filename:)
    old_app_modified_records = OldAppDataImportService.new(model_name: model_name, csv_filename: csv_filename).find_modified_records
    OldAppModificationsSavingService.new(model_name: model_name, modified_records: old_app_modified_records).validate_and_save_modifications
  end
end
