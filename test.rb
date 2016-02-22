require_relative 'mother_nature'

initial_cells = [Cell.new(5, 5), Cell.new(4, 5), Cell.new(3, 5)]

nature = MotherNature.new(10, initial_cells)

def print_grid(grid)
  grid.length.times do |x|
    grid.length.times do |y|
      puts "X: #{x}, Y: #{y}" if grid[x][y]
    end
  end
end

while true do
  puts "*" * 20
  puts "NEW GENERATION"
  nature.update_world
  puts "Updating done"
  print_grid(nature.grid)
end


10000.times do
  nature.update_world
end
