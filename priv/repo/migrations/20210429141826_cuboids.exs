defmodule App.Repo.Migrations.Initial do
  use Ecto.Migration

  def change do
    create table(:cuboids) do
      add :width, :integer, null: false
      add :height, :integer, null: false
      add :depth, :integer, null: false

      timestamps()
    end
  end
end
