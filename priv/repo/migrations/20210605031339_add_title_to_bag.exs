defmodule App.Repo.Migrations.AddTitleToBag do
  use Ecto.Migration

  def change do
    alter table(:bags) do
      add :title, :string
    end
  end
end
