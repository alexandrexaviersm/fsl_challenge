defmodule App.Store.Cuboid do
  @moduledoc """
  This module defines the Cuboid schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "cuboids" do
    field :depth, :integer
    field :height, :integer
    field :width, :integer
    belongs_to :bag, App.Store.Bag

    timestamps()
  end

  @doc false
  def changeset(cuboid, attrs) do
    cuboid
    |> cast(attrs, [:width, :height, :depth, :bag_id])
    |> validate_required([:width, :height, :depth])
    |> cast_assoc(:bag, require: true)
    |> assoc_constraint(:bag, require: true)
  end
end
