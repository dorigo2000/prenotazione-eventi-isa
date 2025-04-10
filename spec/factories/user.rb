FactoryBot.define do
  factory :user do
    nome { Faker::Name.first_name }
    cognome { Faker::Name.last_name }
    telefono { Faker::Number.number(digits: 10).to_s }
    data_nascita { Faker::Date.between(from: "1970-01-01", to: Date.today).to_s }
    tipo { "partecipante" }
    email { Faker::Internet.unique.email }
    password { "password12345" }
    password_confirmation { "password12345" }
  end
end