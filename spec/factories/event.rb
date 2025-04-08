FactoryBot.define do
  factory :event do
    association :user 
    nome { Faker::Lorem.words(number: 3).join(" ") }
    indirizzo { Faker::Address.street_address }
    paese { Faker::Address.city }
    data_inizio { Faker::Date.forward(days: 10) }
    data_fine { data_inizio + rand(1..5).days }
    orario_inizio { Faker::Time.forward(days: 10, period: :morning) }
    orario_fine { Faker::Time.forward(days: 10, period: :evening) }
    max_partecipanti { Faker::Number.between(from: 1, to: 100) }
  end
end