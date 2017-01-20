class GameOfLife
  attr_reader :grid, :cells

  def initialize(grid_size, initial_cells)
    @grid  = Array.new(grid_size) { Array.new(grid_size) }
    @cells = initial_cells
    init_grid(true)
  end

  def init_grid(state)
    @cells.each { |x, y| @grid[x][y] = state }
  end

  # - Generate a list of co-ordinates for new cells
  # - Set the previous state of all cells to false in the grid
  # - Set the state of new cells to true in the grid
  def update_world
    new_cells = generate_new_cells
    init_grid(false)
    @cells = new_cells
    init_grid(true)
  end

  private

  def generate_new_cells
    visited = {}
    living_cells = []

    # Iterate through each cell
    # For each of a cell's neighbors:
    #   - Check to see if it can be brought to life (has to have 3 living neighbors)
    # Add a cell to new cells if it passes the conditions
    @cells.each do |cell|
      neighbors_of(*cell).each do |neighbor|
        if !visited[neighbor] && born?(neighbor)
          visited[neighbor] = true
          living_cells << neighbor
        end
      end

      living_cells << cell if survived?(cell)
      visited[cell] = true
    end

    living_cells
  end

  def survived?(cell)
    count = neighbor_count_of(cell)
    count == 2 || count == 3
  end

  def born?(cell)
    neighbor_count_of(cell) == 3
  end

  # Counts the live cells that are neighbors to cell
  def neighbor_count_of(cell)
    neighbors_of(*cell).inject(0) do |sum, neighbor|
      x = neighbor[0]; y = neighbor[1]
      @grid[x][y] ? sum + 1 : sum
    end
  end

  def neighbors_of(x, y)
    # Top left,     Top middle,    Top right
    # Middle left,                 Middle right
    # Bottom left,  Bottom middle, Bottom right
    all_possible = [
      [x-1, y-1],    [x, y-1],    [x+1, y-1],
      [x-1,   y],                 [x+1,   y],
      [x-1, y+1],    [x, y+1],    [x+1, y+1],
    ]

    all_possible.select { |cell| within_range?(*cell) }
  end

  # Make sure we don't go outside of the grid
  def within_range?(x, y)
    x >= 0 && x < @grid.length && y >= 0 && y < @grid.length
  end
end
