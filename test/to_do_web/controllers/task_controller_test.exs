defmodule ToDoWeb.TaskControllerTest do
  use ToDoWeb.ConnCase
  alias ToDo.List

  import ToDo.ListFixtures

  @create_active_attrs %{status: 0, description: "some description", title: "some title", person_id: 42}
  @create_completed_attrs %{status: 1, description: "some other description", title: "some other title", person_id: 42}
  @update_attrs %{
    status: 43,
    description: "some updated description",
    title: "some updated title",
    person_id: 43
  }
  @invalid_attrs %{status: nil, description: nil, title: nil, person_id: nil}

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      conn = get(conn, ~p"/tasks")
      assert html_response(conn, 200) =~ "To Do List"
    end
  end

  describe "new task" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/tasks/new")
      assert html_response(conn, 200) =~ "New task"
    end
  end

  describe "create task" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/tasks", task: @create_active_attrs)

      assert %{} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/tasks"
    end

    test "errors when invalid attributes are passed", %{conn: conn} do
      conn = post(conn, ~p"/tasks", task: @invalid_attrs)
      assert html_response(conn, 200) =~ "can&#39;t be blank"
    end
  end

  describe "edit task" do
    setup [:create_task]

    test "renders form for editing chosen task", %{conn: conn, task: task} do
      conn = get(conn, ~p"/tasks/#{task}/edit")
      assert html_response(conn, 200) =~ "Edit Task"
    end
  end

  describe "update task" do
    setup [:create_task]

    test "redirects when data is valid", %{conn: conn, task: task} do
      conn = put(conn, ~p"/tasks/#{task}", task: @update_attrs)
      assert redirected_to(conn) == ~p"/tasks/"

      conn = get(conn, ~p"/tasks/#{task}")
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, task: task} do
      conn = put(conn, ~p"/tasks/#{task}", task: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Task"
    end
  end

  describe "delete task" do
    setup [:create_task]

    test "deletes chosen task", %{conn: conn, task: task} do
      conn = delete(conn, ~p"/tasks/#{task}")
      assert redirected_to(conn) == ~p"/tasks"

      assert_error_sent 404, fn ->
        get(conn, ~p"/tasks/#{task}")
      end
    end
  end

  describe "toggle changes the status of the task 0 -> 1, 1 -> 0" do
    setup [:create_task]

    test "toggle task status", %{conn: conn, task: task} do
      assert(task.status == 0)
      # First toggle
      get(conn, ~p'/tasks/toggle/#{task.id}')
      updated_task = List.get_task!(task.id)
      assert(updated_task.status == 1)
      # Second toggle
      get(conn, ~p'/tasks/toggle/#{updated_task.id}')
      second_updated_task = List.get_task!(updated_task.id)
      assert(second_updated_task.status == 0)
    end
  end

  describe "filter tasks" do
    test "Renders only active tasks", %{conn: conn} do
      conn = post(conn, ~p'/tasks', task: @create_active_attrs)
      conn = post(conn, ~p'/tasks', task: @create_completed_attrs)
      conn = get(conn, ~p'/tasks/filter/active')
      assert (html_response(conn, 200) =~ @create_active_attrs.title)
      assert !(html_response(conn, 200) =~ @create_completed_attrs.title)
    end

    test "Renders only completed tasks", %{conn: conn} do
      conn = post(conn, ~p'/tasks', task: @create_completed_attrs)
      conn = post(conn, ~p'/tasks', task: @create_active_attrs)
      conn = get(conn, ~p'/tasks/filter/completed')
      assert !(html_response(conn, 200) =~ @create_active_attrs.title)
      assert (html_response(conn, 200) =~ @create_completed_attrs.title)
    end

    test "Renders all tasks", %{conn: conn} do
      conn = post(conn, ~p'/tasks', task: @create_completed_attrs)
      conn = post(conn, ~p'/tasks', task: @create_active_attrs)
      conn = get(conn, ~p'/tasks/filter/all')
      assert (html_response(conn, 200) =~ @create_active_attrs.title)
      assert (html_response(conn, 200) =~ @create_completed_attrs.title)
    end
  end

  defp create_task(_) do
    task = task_fixture(@create_active_attrs)
    %{task: task}
  end
end
