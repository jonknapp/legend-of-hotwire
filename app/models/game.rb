class Game < ApplicationRecord
  EMPTY_SPACE = 0
  MISS = -1_000

  self.implicit_order_column = :created_at

  attr_accessor :links_memory

  before_validation :generate_seed
  before_validation :populate_board

  validates :links_memory, presence: true
  validates :seed, presence: true

  def number_of_guesses
    return 0 if self.board.empty?

    self.board.each.reduce(0) do |memo, row|
      row.reduce(memo) do |memo, value|
        next memo if value == EMPTY_SPACE
        next memo if value.positive?

        memo + 1
      end
    end
  end

  def ships
    return {} if self.board.empty?

    self.board.each.reduce({}) do |memo, row|
      row.reduce(memo) do |memo, value|
        next memo if value == EMPTY_SPACE
        next memo if value == MISS

        key = "ship_#{value.abs}"
        memo[key] = { damage: 0, length: 0 } unless memo.key?(key)
        memo[key][:damage] += 1 if value.negative?
        memo[key][:length] += 1
        memo
      end
    end
  end

  private

  def generate_seed
    return if self.seed.present?

    self.seed = Random.new_seed
  end

  def populate_board
    return unless self.board.empty?

    self.board = PopulateBoard.call(seed:)
  end
end
