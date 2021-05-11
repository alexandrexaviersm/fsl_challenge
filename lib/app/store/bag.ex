defmodule App.Store.Bag do
  @moduledoc """
  This module defines the Bag schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "bags" do
    field :title, :string
    field :volume, :integer
    has_many :cuboids, App.Store.Cuboid

    timestamps()
  end

  @doc false
  def changeset(bag, attrs) do
    bag
    |> cast(attrs, [:volume, :title])
    |> validate_required([:volume, :title])
  end
end
