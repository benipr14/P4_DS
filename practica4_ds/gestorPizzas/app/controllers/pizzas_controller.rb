# app/controllers/pizzas_controller.rb
class PizzasController < ApplicationController
  def index
    # @tareas = Tarea.where(usuario: params[:usuario])
    @pizzas = Pizza.all
    logger.info "Cargando pizzas para usuario: Total: #{@pizzas.count}"
    render json: @pizzas
  end

  def create
    @pizza = Pizza.new(pizza_params)
    if @pizza.save
      render json: @pizza, status: :created
    else
      render json: @pizza.errors, status: :unprocessable_entity
    end
  end
  
  def show
    render json: @pizza
  end

  def update
    @pizza = Pizza.find(params[:id])
    if @pizza.update(pizza_params)
      render json: @pizza
    else
      render json: @pizza.errors, status: :unprocessable_entity
    end
  end

  def destroy
    pizza = Pizza.find(params[:id])
    if pizza.destroy
      head :ok
    else
      render json: { error: "Failed to delete" }, status: :unprocessable_entity
    end
  end

  private

  def pizza_params
    params.require(:pizza).permit(:name, :dough, :sauce, :price, :dueño, ingredients: [])
  end
end

