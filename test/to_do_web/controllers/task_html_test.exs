defmodule ToDoWeb.TaskHTMLTest do
  use ToDoWeb.ConnCase, async: true
  alias ToDoWeb.TaskHTML

  test "complete/1 returns completed if Task.status == 1" do
    assert TaskHTML.complete(%{status: 1}) == "completed"
  end

  test "complete/1 returns empty string if Task.status == 0" do
    assert TaskHTML.complete(%{status: 0}) == ""
  end
end
