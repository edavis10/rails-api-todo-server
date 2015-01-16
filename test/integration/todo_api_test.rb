require 'test_helper'

# Tests the public api for todos
class TodoApiTest < ActionDispatch::IntegrationTest
  fixtures :all

  # GET /todos
  test "GET /todos with no items" do
    Todo.destroy_all

    get "/todos"
    assert_response :success

    todos = JSON.parse(response.body)
    assert_equal 0, todos.length
  end

  test "GET /todos with items" do
    get "/todos"
    assert_response :success

    todos = JSON.parse(response.body)
    assert_equal 2, todos.length
    assert_equal "Walk the dog", todos.first["title"]
    assert_equal "Take out the trash", todos.second["title"]
  end

  # GET /todos/n.json
  test "GET /todos/n.json" do
    @todo = Todo.last
    get "/todos/#{@todo.id}.json"
    assert_response :success

    todo = JSON.parse(response.body)
    assert todo.present?
    assert_equal "Walk the dog", todo["title"]
    assert todo.has_key?("id")
    assert todo.has_key?("title")
    assert todo.has_key?("status")
  end

  test "GET /todos/n.json for an invalid item" do
    Todo.destroy_all

    get "/todos/10.json"
    assert_response :not_found

    refute response.body.present?
  end

  # POST /todos
  test "POST /todos.json" do
    post "/todos.json", todo: { title: "Something new" }
    assert_response :created

    todo = JSON.parse(response.body)
    assert todo.present?
    assert_equal "Something new", todo["title"]
    assert todo.has_key?("id")
    assert todo.has_key?("title")
    assert todo.has_key?("status")
  end

  test "POST /todos.json with an invalid item" do
    post "/todos.json", todo: { title: "" }
    assert_response :bad_request

    errors = JSON.parse(response.body)
    assert errors.present?
    assert_equal ["can't be blank"], errors["title"]
  end

  # PUT /todos/n.json
  test "PUT /todos/n.json" do
    @todo = Todo.last
    put "/todos/#{@todo.id}.json", todo: { title: "An edit" }
    assert_response :success

    todo = JSON.parse(response.body)
    assert todo.present?
    assert_equal "An edit", todo["title"]
    assert todo.has_key?("id")
    assert todo.has_key?("title")
    assert todo.has_key?("status")
  end

  test "PUT /todos/n.json to complete an item" do
    @todo = Todo.last
    assert_equal "open", @todo.status

    put "/todos/#{@todo.id}.json", todo: { status: "complete" }
    assert_response :success

    @todo.reload
    assert_equal "complete", @todo.status
  end

  test "PUT /todos/n.json with an invalid item" do
    @todo = Todo.last
    put "/todos/#{@todo.id}.json", todo: { title: "" }
    assert_response :bad_request

    errors = JSON.parse(response.body)
    assert errors.present?
    assert_equal ["can't be blank"], errors["title"]
  end

  # DELETE /todos/n.json
  test "DELETE /todos/n.json" do
    @todo = Todo.last
    delete "/todos/#{@todo.id}.json"
    assert_response :no_content

    refute response.body.present?
  end

  test "DELETE /todos/n.json for an invalid item" do
    Todo.destroy_all

    delete "/todos/10.json"
    assert_response :not_found

    refute response.body.present?
  end
end
