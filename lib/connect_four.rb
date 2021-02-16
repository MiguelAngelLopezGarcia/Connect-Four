class Game
    attr_accessor :board
    def initialize
      @board = Board.new
    end
  
    def play
      start_game
      until is_winner? do
        board.display
        play_round(@player_1)
        board.display
        if is_winner?
          announce_winner
          return
        end
        play_round(@player_2)
        board.display
      end
      announce_winner
    end
  
    def start_game
      puts "Player one, please select between X or O"
      puts "Write your selection and press enter"
      first_symbol = gets.chomp.downcase
      if first_symbol != "x" || first_symbol != "o"
        until first_symbol == "x" || first_symbol == "o"
          puts "Please choose between X or O"
          first_symbol = gets.chomp.downcase
        end
      end
      first_symbol == "x" ? second_symbol = "o" : second_symbol = "x"
      @player_1 = Player.new(1, first_symbol)
      @player_2 = Player.new(2, second_symbol)
    end
  
    def play_round(player)
      puts "It\'s player #{player.number}\'s turn"
      puts "Please select the column and press enter"
      column = gets.chomp.to_i
      until column.class == Integer && column >= 1 && column <= 7
        puts "Please select a number between 1 to 7"
        column = gets.chomp.to_i
      end    
      place_on_board = board.place_symbol(column, player.symbol)
      until place_on_board != 0
        column = gets.chomp.to_i
        place_on_board = board.place_symbol(column, player.symbol)
      end
    end
  
    def is_winner?
      row = board.are_four_in_row
      if row == "x" || row == "o"
        @winner = row
        return true
      end
      column = board.are_four_in_column
      if column == "x" || column == "o"
        @winner = column
        return true
      end
      diagonal = board.are_four_in_diagonal
      if diagonal == "x" || diagonal == "o"
        @winner = diagonal
        return true
      end
      return true if board.is_full?
      return false
    end
  
    def announce_winner
      if board.is_full?
        puts "The board is full, it's a tie"
      else
        @player_1.symbol == @winner ? player = @player_1 : player = @player_2
        puts "Player #{player.number} is the winner!!!"
      end
    end
  end
  
  class Board
    attr_accessor :grid
    def initialize
      @grid = make_grid
    end
  
    def make_grid
      grid = []
      6.times do
        grid.push(Array.new(7, " "))
      end
      grid
    end
  
    def display
      puts `clear`
      i = 0
      until i >= grid.size do
        puts "|#{disp(grid[i])}|"
        i += 1
      end
      puts "_______________"
      puts "|1|2|3|4|5|6|7|"
    end
  
    def disp(row)
      row.join("|")
    end
  
    def place_symbol(column, symbol)
      column -= 1
      height = grid.size - 1
      until grid[height][column] == " " do
        height -= 1
        if height < 0
          puts "Column full, please select another one"
          return 0
        end
      end
      grid[height][column] = symbol
    end
  
    def are_four_in_row
      i = 0
      until i == grid.size
        this_row = grid[i].join
        return "x" if this_row.include? "xxxx"
        return "o" if this_row.include? "oooo"
        i += 1
      end
      return ""
    end
  
    def are_four_in_column
      i = 0
      j = 0
      until i > 7
        this_column = []
        until j == grid.size
          this_column.push(grid[j][i])
          j += 1
        end
        this_column = this_column.join
        return "x" if this_column.include? "xxxx"
        return "o" if this_column.include? "oooo"
        i += 1
        j = 0
      end
      return ""
    end
  
    def are_four_in_diagonal
      four_in_left = are_in_left_diagonal
      return four_in_left if four_in_left == "x" || four_in_left == "o"
      four_in_right = are_in_right_diagonal
      return four_in_right if four_in_right == "x" || four_in_right == "o"
      return ""
    end
  
    def are_in_right_diagonal
      i = 5 
      j = 0 
      k = 0 
      l = 0
      until l == grid.size
        until k > 6
          this_diagonal = []
          until j > 6
            this_diagonal.push(grid[i][j])
            i -= 1
            j += 1
          end
          this_diagonal = this_diagonal.join
          return "x" if this_diagonal.include? "xxxx"
          return "o" if this_diagonal.include? "oooo"
          k += 1
          j = k
          if l == 0 
            i = 5
          else
            i = grid.size - 1 - l
          end
        end
        l += 1
        k = 0
        j = 0
      end
      return ""
    end
  
    def are_in_left_diagonal
      i = 0 
      j = 0 
      k = 0 
      l = 0
      until l == grid.size
        until k > 6
          this_diagonal = []
          until i > 5
            this_diagonal.push(grid[i][j])
            i += 1
            j += 1
          end
          this_diagonal = this_diagonal.join
          return "x" if this_diagonal.include? "xxxx"
          return "o" if this_diagonal.include? "oooo"
          k += 1
          j = k
          if l == 0 
            i = 0
          else
            i = l
          end
        end
        l += 1
        k = 0
        j = 0
      end
      return ""
    end
  
    def is_full? 
      grid.map do |row|
        row.map do |place|
          return false if place == " "
        end
      end
      return true
    end
  end
  
  class Player
    attr_accessor :number, :symbol
    def initialize (number, symbol)
      @number = number
      @symbol = symbol
    end
  end
  
  new_game = Game.new.play