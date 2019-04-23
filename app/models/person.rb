class Person < ApplicationRecord
  has_paper_trail only: [:email, :mobile_phone_number, :home_phone_number, :address]
end
