FactoryBot.define do
  factory :notification do
      messaggio { Faker::Lorem.sentence }
      letto { false }
      association :user
      association :event
  end
end