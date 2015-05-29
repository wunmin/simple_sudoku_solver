class Sudoku
  def initialize(board_string)
    # Convert string into array of 9 arrays of strings
    board_string = board_string.split("")
    @board_grid = Array.new(9) { board_string.shift(9) }
    create_hash
  end

  def solve!
    solved = false

    until solved
      @board_grid.each_with_index do |row, x_index|
        row.each_with_index do |col, y_index|
          if col == "0"
            if all_possible_solutions(x_index, y_index).count == 1
              @board_grid[x_index][y_index] = all_possible_solutions(x_index, y_index)[0]
              solved = true if @board_grid.flatten.index("0") == nil
            end
          end
        end
      end
    end
    # p @board_grid
  end

  # Returns a string representing the current state of the board
  # Don't spend too much time on this method; flag someone from staff
  # if you are.
  def board
    count = 0
    while count < 9
        @board_grid.each do |row|
            if count % 3 == 0
                p "---------------------"
            end
            p "#{row[0]} #{row[1]} #{row[2]} | #{row[3]} #{row[4]} #{row[5]} | #{row[6]} #{row[7]} #{row[8]}"
            count += 1
        end
    end
    p "---------------------"
  end


  def create_hash
    @hash = Hash.new {|h,k| h[k]=[]}
    (0...9).each do |row|
      (0...9).each do |col|
        key = "#{row/3}#{col/3}"
        @hash[key] << @board_grid[row][col]
      end
    end
  end

  # Return all numbers not use in that row
  def check_row(row)
    @possible_solutions_row = []
    (1..9).each do |i|
        if @board_grid[row].include?(i.to_s) == false
          @possible_solutions_row << i.to_s
        end
    end
    @possible_solutions_row
  end

  # Return all numbers not used in that column
  def check_col(col)
    @possible_solutions_col = []
    @board_grid_transposed = @board_grid.transpose
    (1..9).each do |i|
        if @board_grid_transposed[col].include?(i.to_s) == false
          @possible_solutions_col << i.to_s
        end
    end
    @possible_solutions_col
  end

  # Return all numbers not used in that box
  def check_box(row, col)
    @possible_solutions_box = []
    key = "#{row/3}#{col/3}"
    (0..9).each do |i|
      if @hash[key].include?(i.to_s) == false
        @possible_solutions_box << i.to_s
      end
    end
    @possible_solutions_box
  end

  def all_possible_solutions(row,col)
    (check_row(row) & check_col(col)) & check_box(row,col)
  end

end

# The file has newlines at the end of each line, so we call
# String#chomp to remove them.
board_string = File.readlines('sample.unsolved.txt').first.chomp
# board_string = "619030040270061008000047621486302079000014580031009060005720806320106057160400030"
game = Sudoku.new(board_string)

# Remember: this will just fill out what it can and not "guess"
game.solve!

puts game.board