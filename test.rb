require_relative 'mother_nature'

nature = MotherNature.new(10)

p nature.grid

nature.update_world

p nature.grid