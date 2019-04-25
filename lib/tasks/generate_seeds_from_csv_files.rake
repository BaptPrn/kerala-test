require 'csv'

namespace :seeds do
  desc 'Generate seeds from the csv files'
  task generate_from_csvs: :environment do
    CSV.foreach('people.csv', headers: true) do |row|
      Person.create(row.to_hash)
    end

    CSV.foreach('buildings.csv', headers: true) do |row|
      Building.create(row.to_hash)
    end
  end
end
