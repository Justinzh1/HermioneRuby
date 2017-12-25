# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ee = Course.create!({ 
	title: "Designing Information Devices and Systems I",
	abbrev: "EE16A",
	description: "EECS 16A focuses on modeling as abstraction -- a way to see only the important and relevant underlying structure in a problem -- and introduces the basics of linear modeling, largely from a static and deterministic point of view.",
	code: '23164',
	year: 'FA17'
})

prof = ee.professors.build({:name => "Anant Sahai"})
prof.save!

# eeb Course.create!({
# 	title: "Designing Information Devices and Systems I",
# 	abbrev: "EE16B",
# 	description: "EECS 16B focuses on modeling as abstraction -- a way to see only the important and relevant underlying structure in a problem -- and introduces the basics of linear modeling, largely from a static and deterministic point of view.",
# 	code: '23165',
# 	year: 'FA17'	
# })