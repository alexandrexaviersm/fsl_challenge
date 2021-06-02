defmodule App.Repo.Migrations.Bag do
  use Ecto.Migration

  def change do
    create table(:bags) do
      add :volume, :integer, null: false

      timestamps()
    end
  end
end
