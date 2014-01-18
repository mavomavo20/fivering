# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'date'
JsonFile.create(name:'3mee33tw7c8d', updated:Date.parse("2014-01-08 12:12:12"), json:'{"title":"テスト","center":[35.658517,139.70133399999997],"zoom":16,"data":[{"address":"渋谷駅","name":"あああ","comment":""}]}')