require 'json'

class Cell < Struct.new(:x, :y)
end

class MotherNature
  attr_reader :grid

  def initialize(grid_size)
    @grid  = Array.new(grid_size) { Array.new(grid_size) }
    @cells = create_cells
    @cells.each { |c| @grid[c.x][c.y] = c }
  end

  def update_world
    new_cells = []

    @cells.each do |cell|
      if of_the_fittest?(cell)
        @new_cells << cell
      else
        @grid[cell.x][cell.y] = nil
      end
    end

    @cells = new_cells
  end

  private

  def create_cells
    [Cell.new(4,5), Cell.new(5,6)]
  end

  def of_the_fittest?(cell)
    count = neighbor_count_of(cell)
    count == 2 || count == 3
  end

  def neighbor_count_of(cell)
    neighbors_of(cell).inject(0) { |sum, neighbor| sum += neighbor ? 1 : 0 } || 0
  end

  def neighbors_of(cell)
    [top_left(cell), top_middle(cell), top_right(cell), middle_left(cell), middle_right(cell), bottom_left(cell), bottom_middle(cell), bottom_right(cell)]
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
