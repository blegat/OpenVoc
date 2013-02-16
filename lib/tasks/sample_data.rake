### BEGIN LICENSE
# Copyright (C) 2012 Benoît Legat benoit.legat@gmail.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
### END LICENSE

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_languages
    make_words
    make_links
  end
end

def make_users
  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@openvoc.com"
    User.create!(name: name,
                 email: email)
  end
end

def make_languages
  Language.create!(name: "Latin")
  Language.create!(name: "Random")
end

def make_words
  latin = Language.find_by_name("Latin")
  latin_words = []
  content = "est"
  99.times do |n|
    while latin_words.include?(content) do
      content = Faker::Lorem.sentence.split(' ')[0].downcase
    end
    word = latin.words.build(content: content)
    word.owner = User.random # uses random_record gem
    word.save!
    latin_words.push(content)
  end
  random = Language.find_by_name("Random")
  random_words = []
  99.times do |n|
    while random_words.include?(content) do
      content = Faker::Lorem.characters(5)
    end
    word = random.words.build(content: content)
    word.owner = User.random
    word.save!
    random_words.push(content)
  end
end

def make_links
  latin = Language.find_by_name("Latin")
  random = Language.find_by_name("Random")
  latin_words = latin.words
  random_words = random.words
  99.times do |n|
    latin_word_id = latin_words[rand(0..98)]
    random_word_id = random_words[rand(0..98)]
    link = Link.new
    link.word1 = latin_word_id
    link.word2 = random_word_id
    link.owner = User.random
    link.save!
  end
end
