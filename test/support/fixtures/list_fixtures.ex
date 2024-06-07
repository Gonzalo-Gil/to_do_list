defmodule ToDo.ListFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ToDo.List` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
        person_id: 42,
        status: 42,
        title: "some title"
      })
      |> ToDo.List.create_task()

    task
  end
end
