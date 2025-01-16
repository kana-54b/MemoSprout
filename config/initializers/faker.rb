# config/initializers/faker.rb
if Rails.env.development? || Rails.env.test?
  Faker::Config.locale = "ja"
end
