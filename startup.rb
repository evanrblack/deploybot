require 'faker'
require 'active_support/inflector'

def startup_of_the_week
  intro1 = ['Hi', 'Hello', 'Hey'].sample
  name = Faker::Name.first_name
  position = Faker::Name.title
  app = Faker::App.name
  intro2 = ["I'm #{name}", "my name is #{name}", "#{name} here"].sample
  adjective = Faker::Company.buzzword.downcase
  article = ['a','e','i','o','u'].include?(adjective[0]) ? 'an' : 'a'
  what = ['PaaS', 'SaaS', 'webapp', 'platform', 'service', 'app'].sample
  who = Faker::Company.profession.pluralize
  for_what = Faker::Company.catch_phrase.downcase.pluralize
  transition2 = ['aims to', 'finds ways to', 'provides solutions to', "helps #{who}"].sample
  transition3 = ['so that users can', 'which allows users to', 'to better', 'to', 'while users', 'by letting users'].sample
  first = Faker::Company.bs
  second = Faker::Company.bs

  "#{intro1}, #{intro2}, #{position} for #{app}. #{app} is #{article} #{adjective} #{what} for #{who} in need of #{for_what}. #{app} #{transition2} #{first} #{transition3} #{second}."
end

#puts startup_of_the_week
