class MotherNature
  attr_reader :grid, :cells

  def initialize(grid_size, initial_cells)
    @grid  = Array.new(grid_size) { Array.new(grid_size) }
    @cells = initial_cells
    init_grid(true)
  end

  def init_grid(state)
    @cells.each { |cell| @grid[cell[0]][cell[1]] = state }
  end

  def update_world
    new_cells = generate_new_grid
    init_grid(false)
    @cells = new_cells
    init_grid(true)
  end

  private

  def generate_new_grid
    checked_already_cache = {}
    temp_new_cells = []

    @cells.each do |cell|
      neighbors_of(cell).each do |neighbor|
        if !checked_already_cache[neighbor] && born?(neighbor)
          checked_already_cache[neighbor] = true
          temp_new_cells << neighbor
        end
      end

      temp_new_cells << cell if survived?(cell)
      checked_already_cache[cell] = true
    end

    temp_new_cells
  end

  def survived?(cell)
    count = neighbor_count_of(cell)
    count == 2 || count == 3
  end

  def born?(cell)
    within_range?(cell) && neighbor_count_of(cell) == 3
  end

  def within_range?(neighbor)
    x = neighbor[0]; y = neighbor[1]
    x >= 0 && x < @grid.length && y >= 0 && y < @grid.length
  end

  def neighbor_count_of(cell)
    neighbors_of(cell).inject(0) do |sum, neighbor|
      x = neighbor[0]; y = neighbor[1]
      if @grid[x] && @grid[x][y]
        sum += 1
      else
        sum
      end
    end
  end

  def neighbors_of(cell)
    x = cell[0]; y = cell[1]
    [
      [x-1, y-1],    [x, y-1],    [x+1, y-1],
      [x-1,   y],                 [x+1,   y],
      [x-1, y+1],    [x, y+1],    [x+1, y+1],
    ]
  end
end
