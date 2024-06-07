defmodule ToDoWeb.TaskHTML do
  use ToDoWeb, :html

  embed_templates "task_html/*"

  @doc """
  Renders a task form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def task_form(assigns)

  def complete(item) do
    case item.status do
      1 -> "completed"
      _ -> ""
    end
  end

  def remaining_tasks(tasks) do
    Enum.count(tasks, &(&1.status == 0))
  end
end
