require_relative 'mother_nature'


initial_cells = [Cell.new(4, 4)]

nature = MotherNature.new(10, initial_cells)

p nature.grid

nature.update_world

p nature.grid
