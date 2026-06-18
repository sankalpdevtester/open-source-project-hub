FactoryBot.define do
  factory :project do
    name { 'Example Project' }
    description { 'This is an example project' }
    url { 'https://example.com' }
    user { create(:user) }
  end
end