require 'gosu'
require 'yaml'
require 'pry'
require_relative 'game_of_life'

GAME_UPDATE_SPEED = 0.09

class GameWindow < Gosu::Window
  def initialize(pattern)
    super(900, 900)

    patterns = YAML.load_file('patterns.yml')

    if patterns[pattern.to_s]
      initial_cells = patterns[pattern.to_s].map { |pair| pair.values }
    else
      raise "Pattern `#{pattern}` does not exist"
    end

    self.caption = 'The Game of Life'
    @game_of_life = GameOfLife.new(45, initial_cells)
    @last_time = Time.now
  end

  def update
    if next_gen?
      puts "*" * 14
      puts "NEW GENERATION"
      @game_of_life.update_world
      print_grid
    end
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end

  private

  def print_grid
    grid.length.times do |x|
      grid.length.times do |y|
        puts "X: #{x}, Y: #{y}" if grid[x][y]
      end
    end
  end

  def draw
    grid.length.times do |x|
      grid.length.times do |y|
        draw_life_at(x, y) if grid[x][y]
      end
    end
  end

  def grid
    @game_of_life.grid
  end

  def time_since_last_generation
    Time.now - @last_time
  end

  def next_gen?
    if time_since_last_generation > GAME_UPDATE_SPEED
      @last_time = Time.now
      true
    end
  end

  def draw_life_at(x, y)
    Gosu.draw_rect(x * 20, y * 20, 20, 20, 0xcc666666)
  end
end

window = ARGV.length == 0 ? GameWindow.new(:glider) : GameWindow.new(ARGV[0])
window.show
