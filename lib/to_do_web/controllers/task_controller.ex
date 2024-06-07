defmodule ToDoWeb.TaskController do
  use ToDoWeb, :controller

  alias ToDo.List
  alias ToDo.List.Task

  def index(conn, params) do
    tasks =
      if not is_nil(params) and Map.has_key?(params, :tasks) do
        params.tasks
      else
        List.list_tasks()
      end
    changeset = List.change_task(%Task{})
    render(conn, "index.html", tasks: tasks, changeset: changeset)
  end

  def new(conn, _params) do
    changeset = List.change_task(%Task{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    case List.create_task(task_params) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: ~p"/tasks")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = List.get_task!(id)
    render(conn, :show, task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = List.get_task!(id)
    changeset = List.change_task(task)
    render(conn, :edit, task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = List.get_task!(id)

    case List.update_task(task, task_params) do
      {:ok, _task} ->
        conn
        |> redirect(to: ~p"/tasks/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, task: task, changeset: changeset)
    end
  end

  def toggle(conn, %{"id" => id}) do
    task = List.get_task!(id)

    status =
      case task.status do
        1 -> 0
        0 -> 1
      end

    List.update_task(task, %{status: status})

    conn
    |> redirect(to: ~p"/tasks")
  end

  def delete(conn, %{"id" => id}) do
    task = List.get_task!(id)
    {:ok, _task} = List.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: ~p"/tasks")
  end

  def filter(conn, %{"filter" => filter}) do
    tasks =
      case filter do
        "completed" -> Enum.filter(List.list_tasks(), fn x -> x.status == 1 end)
        "active" -> Enum.filter(List.list_tasks(), fn x -> x.status == 0 end)
        _ -> List.list_tasks()
      end

    index(conn, Map.put(conn.assigns, :tasks, tasks))
  end
end
