defmodule ToDo.List.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :status, :integer, default: 0
    field :description, :string, default: ""
    field :title, :string
    field :person_id, :integer, default: 1

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :person_id, :status])
    |> validate_required([:title])
  end
end
