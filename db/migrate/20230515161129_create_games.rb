class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games, id: :uuid do |t|
      t.jsonb :board, default: [], null: false
      t.integer :number_of_shots, default: 24, null: false
      t.decimal :seed, precision: 64, scale: 0, null: false

      t.timestamps
    end
  end
end
