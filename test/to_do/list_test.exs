defmodule ToDo.ListTest do
  use ToDo.DataCase

  alias ToDo.List

  describe "tasks" do
    alias ToDo.List.Task

    import ToDo.ListFixtures

    @invalid_attrs %{status: nil, description: nil, title: nil, person_id: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert List.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert List.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{status: 42, description: "some description", title: "some title", person_id: 42}

      assert {:ok, %Task{} = task} = List.create_task(valid_attrs)
      assert task.status == 42
      assert task.description == "some description"
      assert task.title == "some title"
      assert task.person_id == 42
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = List.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{status: 43, description: "some updated description", title: "some updated title", person_id: 43}

      assert {:ok, %Task{} = task} = List.update_task(task, update_attrs)
      assert task.status == 43
      assert task.description == "some updated description"
      assert task.title == "some updated title"
      assert task.person_id == 43
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = List.update_task(task, @invalid_attrs)
      assert task == List.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = List.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> List.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = List.change_task(task)
    end
  end
end
