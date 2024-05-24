class CreatePizzas < ActiveRecord::Migration[7.1]
  def change
    create_table :pizzas do |t|
      t.string :name
      t.string :dough
      t.string :sauce
      t.text :ingredients
      t.decimal :price

      t.timestamps
    end
  end
end
