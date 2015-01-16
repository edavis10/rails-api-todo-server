class TodosController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def index
    render json: Todo.order(created_at: :asc).all
  end

  def show
    render json: Todo.find(params[:id])
  end

  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      render json: @todo, status: :created
    else
      render json: @todo.errors, status: :bad_request
    end
  end

  def update
    @todo = Todo.find(params[:id])

    if @todo.update_attributes(todo_params)
      render json: @todo
    else
      render json: @todo.errors, status: :bad_request
    end
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy

    head :no_content

  end

  private

  def record_not_found
    head :not_found
  end

  def todo_params
    params.require(:todo).permit(:title, :status)
  end
end
