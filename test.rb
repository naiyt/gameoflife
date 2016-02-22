require_relative 'mother_nature'

initial_cells = [Cell.new(5, 5), Cell.new(4, 5), Cell.new(3, 5)]

nature = MotherNature.new(10, initial_cells)

p nature.grid

nature.update_world

p nature.grid
