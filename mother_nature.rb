require 'pry'
require 'pry-nav'

class Cell < Struct.new(:x, :y)
end

class MotherNature
  attr_reader :grid

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
    @cells.each { |c| @grid[c.x][c.y] = c }
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

      potential_neighbors_of(cell).each do |neighbor|
        unless checked_cache[neighbor.x][neighbor.y]
          new_cells << Cell.new(neighbor.x, neighbor.y) if neighbor_count_of(neighbor) == 3
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

  def neighbor_count_of(cell)
    neighbors_of(cell).inject(0) { |sum, neighbor| sum += neighbor ? 1 : 0 } || 0
  end

  def neighbors_of(cell)
    [
      top_left(cell),    top_middle(cell),    top_right(cell),
      middle_left(cell),                      middle_right(cell),
      bottom_left(cell), bottom_middle(cell), bottom_right(cell)
    ]
  end

  def potential_neighbors_of(cell)
    [
      top_left(cell)      || Cell.new(cell.x-1, cell.y-1),
      top_middle(cell)    || Cell.new(cell.x,   cell.y-1),
      top_right(cell)     || Cell.new(cell.x+1, cell.y-1),
      middle_left(cell)   || Cell.new(cell.x-1, cell.y  ),
      middle_right(cell)  || Cell.new(cell.x+1, cell.y  ),
      bottom_left(cell)   || Cell.new(cell.x-1, cell.y+1),
      bottom_middle(cell) || Cell.new(cell.x,   cell.y+1),
      bottom_right(cell)  || Cell.new(cell.x+1, cell.y+1),
    ]
  end

  def top_left(cell)
    @grid[cell.x-1][cell.y-1]
  end

  def top_middle(cell)
    @grid[cell.x][cell.y-1]
  end

  def top_right(cell)
    @grid[cell.x+1][cell.y-1]
  end

  def middle_left(cell)
    @grid[cell.x-1][cell.y]
  end

  def middle_right(cell)
    @grid[cell.x+1][cell.y]
  end

  def bottom_left(cell)
    @grid[cell.x-1][cell.y+1]
  end

  def bottom_middle(cell)
    @grid[cell.x][cell.y+1]
  end

  def bottom_right(cell)
    @grid[cell.x+1][cell.y+1]
  end
end
