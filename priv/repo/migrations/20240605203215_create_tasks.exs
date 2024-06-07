defmodule ToDo.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :string
      add :person_id, :integer
      add :status, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
