class PopulateBoard
  HORIZONTAL = 'HORIZONTAL'
  VERTICAL = 'VERTICAL'
  DIRECTIONS = [HORIZONTAL, VERTICAL].freeze

  attr_reader :board_height,
              :board_width,
              :random

  def self.call(board_height: 8, seed: Random.new_seed, board_width: 8)
    new(board_height:, seed:, board_width:).generate_board
  end

  def initialize(board_height:, seed:, board_width:)
    @board_height = 8
    @board_width = 8
    @number_of_ships = 0
    @random = Random.new(seed)
  end

  def generate_board
    board = Matrix.build(board_height, board_width) { Game::EMPTY_SPACE }
    board = add_ship_to_board(board:, ship_length: 2)
    board = add_ship_to_board(board:, ship_length: 3)
    add_ship_to_board(board:, ship_length: 4)
  end

  private

  def add_ship_to_board(board:, ship_length:)
    @number_of_ships += 1
    Rails.logger.info "Adding ship #{@number_of_ships}"
    Rails.logger.info board
    Rails.logger.info "Seed: #{random.seed}"

    if random_direction == HORIZONTAL
      starting_spots = Matrix.build(board_height, board_width) do |row, col|
        ((col <= board_width - ship_length) && board.minor(row..row, col..(col + ship_length - 1)).zero?) ? @number_of_ships : Game::EMPTY_SPACE
      end
      return board if starting_spots.zero? # can't add ship to board

      starting_spots_array = starting_spots.to_a.reduce([], :concat).each_with_index.map { |value, index| value == Game::EMPTY_SPACE ? false : index }.reject { |value| value == false }
      random_starting_spot = starting_spots_array.shuffle(random:).first

      Rails.logger.info "There are #{starting_spots_array.size} spots to choose from; selecting spot #{random_starting_spot}"

      starting_row = (random_starting_spot / board_width).floor
      starting_col = random_starting_spot % board_width

      Rails.logger.info "Adding horizontal ship (#{ship_length}) at position #{starting_row}, #{starting_col}"

      ship_length.times.each do |x|
        board[starting_row, starting_col + x] = @number_of_ships
      end
    else
      starting_spots = Matrix.build(board_height, board_width) do |row, col|
        ((row <= board_height - ship_length) && board.minor(row..(row + ship_length - 1), col..col).zero?) ? @number_of_ships : Game::EMPTY_SPACE
      end
      return board if starting_spots.zero? # can't add ship to board

      starting_spots_array = starting_spots.to_a.reduce([], :concat).each_with_index.map { |value, index| value == Game::EMPTY_SPACE ? false : index }.reject { |value| value == false }
      random_starting_spot = starting_spots_array.shuffle(random:).first
      starting_row = (random_starting_spot / board_width).floor
      starting_col = random_starting_spot % board_width

      Rails.logger.info "Adding vertical ship (#{ship_length}) at position #{starting_row}, #{starting_col}"

      ship_length.times.each do |y|
        board[starting_row + y, starting_col] = @number_of_ships
      end
    end

    board
  end

  def random_direction
    DIRECTIONS[random.rand(DIRECTIONS.length)]
  end
end
