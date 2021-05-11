defmodule App.Repo.Migrations.CuboidBagRelationship do
  use Ecto.Migration

  def change do
    alter table(:cuboids) do
      add :bag_id, references(:bags), null: false
    end
  end
end
