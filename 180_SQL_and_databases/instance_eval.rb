require 'Sequel'

DB = Sequel.connect('postgres://localhost/sequel-single-table')

# [:menu_items].select { [item, (menu_price - ingredient_cost).as(profit)] }.order(Sequel.desc(:profit)).first

puts DB[:menu_items].all
