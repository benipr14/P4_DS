class AddOwnerToPizzas < ActiveRecord::Migration[7.1]
  def change
    add_column :pizzas, :dueño, :string
  end
end
