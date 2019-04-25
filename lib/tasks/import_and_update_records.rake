namespace :data do
  desc 'Import records from CSV and update them in db when relevant'
  task import_and_update_records: :environment do
    OldAppDataImportJob.perform_now(model_name: 'Building', csv_filename: 'buildings.csv')
    OldAppDataImportJob.perform_now(model_name: 'Person', csv_filename: 'people.csv')
  end
end
