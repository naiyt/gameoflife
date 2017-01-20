require_relative 'game_of_life'

initial_cells = [[5, 5], [4, 5], [3, 5],
                 [20, 5], [21, 5], [22, 5]]

nature = GameOfLife.new(300, initial_cells)

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


10.times do
  nature.update_world
end
