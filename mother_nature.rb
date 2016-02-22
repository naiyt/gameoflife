require 'pry'
require 'pry-nav'

class Cell
  attr_reader :x, :y
  attr_accessor :alive

  def initialize(x, y, alive=true)
    @x = x
    @y = y
    @alive = alive
  end

  def alive?
    @alive
  end

  def dead?
    !alive?
  end
end

class MotherNature
  attr_reader :grid, :cells

  def initialize(grid_size, initial_cells)
    @grid  = Array.new(grid_size) { Array.new(grid_size) }
    @cells = initial_cells
    update_grid!
  end

  def update_world
    new_cells = generate_new_cells
    clear_grid!
    @cells = new_cells
    update_grid!
  end

  def update_grid!
    @cells.each do |cell|
      cell.alive = true
      @grid[cell.x][cell.y] = cell
    end
  end

  def clear_grid!
    @cells.each { |c| grid[c.x][c.y] = nil }
  end

  private

  def generate_new_cells
    checked_cache = Array.new(@grid.length) { Array.new(@grid.length) { false } }

    new_cells = []

    @cells.each do |cell|
      checked_cache[cell.x][cell.y] = true

      neighbors_of(cell).each do |neighbor|
        unless checked_cache[neighbor.x][neighbor.y]
          new_cells << neighbor if born?(neighbor)
        end
        checked_cache[neighbor.x][neighbor.y] = true
      end

      new_cells << cell if survived?(cell)
    end

    new_cells
  end

  def survived?(cell)
    count = neighbor_count_of(cell)
    count == 2 || count == 3
  end

  def born?(cell)
    neighbor_count_of(cell) == 3
  end

  def neighbor_count_of(cell)
    neighbors_of(cell).inject(0) { |sum, neighbor| sum += neighbor.alive? ? 1 : 0 }
  end

  def neighbors_of(cell)
    [
      top_left(cell),    top_middle(cell),    top_right(cell),
      middle_left(cell),                      middle_right(cell),
      bottom_left(cell), bottom_middle(cell), bottom_right(cell)
    ]
  end

  def top_left(cell)
    @grid[cell.x-1][cell.y-1] || Cell.new(cell.x-1, cell.y-1, false)
  end

  def top_middle(cell)
    @grid[cell.x][cell.y-1] || Cell.new(cell.x, cell.y-1, false)
  end

  def top_right(cell)
    @grid[cell.x+1][cell.y-1] || Cell.new(cell.x+1, cell.y-1, false)
  end

  def middle_left(cell)
    @grid[cell.x-1][cell.y] || Cell.new(cell.x-1, cell.y, false)
  end

  def middle_right(cell)
    @grid[cell.x+1][cell.y] || Cell.new(cell.x+1, cell.y, false)
  end

  def bottom_left(cell)
    @grid[cell.x-1][cell.y+1] || Cell.new(cell.x-1, cell.y+1, false)
  end

  def bottom_middle(cell)
    @grid[cell.x][cell.y+1] || Cell.new(cell.x, cell.y+1, false)
  end

  def bottom_right(cell)
    @grid[cell.x+1][cell.y+1] || Cell.new(cell.x+1, cell.y+1, false)
  end
end
