FactoryBot.define do
  factory :building do
    sequence(:reference) {|n| n}
    sequence(:address) {|n| "#{n} avenue des Champs-Élysées"}
    zip_code { 75008 }
    city { 'Paris' }
    country { 'France' }
    manager_name { 'John Doe' }
  end

  factory :person do
    sequence(:reference) {|n| n}
    sequence(:email) { |n| "manager#{n}@example.com" }
    home_phone_number { "01234567#{(10..99).to_a.sample}" }
    mobile_phone_number { "061234567#{(10..99).to_a.sample}" }
    sequence(:firstname) { |n| "John#{n}" }
    sequence(:lastname) { |n| "Doe#{n}" }
    sequence(:address) {|n| "#{n} avenue de la République, 75011, Paris"}
  end
end




