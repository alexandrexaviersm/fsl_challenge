defmodule App.Store.Cuboid do
  @moduledoc """
  This module defines the Cuboid schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias App.Repo
  alias App.Store.Bag

  schema "cuboids" do
    field :depth, :integer
    field :height, :integer
    field :width, :integer
    field :volume, :integer
    belongs_to :bag, Bag

    timestamps()
  end

  @doc false
  def changeset(cuboid, attrs) do
    cuboid
    |> cast(attrs, [:width, :height, :depth, :bag_id])
    |> validate_required([:width, :height, :depth])
    |> calculate_volume()
    |> cast_assoc(:bag, require: true)
    |> assoc_constraint(:bag, require: true)
    |> validate_bag_space()
  end

  defp calculate_volume(%Ecto.Changeset{valid?: true} = changeset) do
    depth = get_field(changeset, :depth)
    height = get_field(changeset, :height)
    width = get_field(changeset, :width)

    volume = depth * height * width

    put_change(changeset, :volume, volume)
  end

  defp calculate_volume(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  defp validate_bag_space(
         %Ecto.Changeset{valid?: true, changes: %{volume: cuboid_volume}} = changeset
       ) do
    bag_id = get_field(changeset, :bag_id)

    Repo.get(Bag, bag_id)
    |> case do
      nil ->
        add_error(changeset, :bag, "does not exist")

      bag ->
        if bag.volume > cuboid_volume do
          changeset
        else
          add_error(changeset, :volume, "Insufficient space in bag")
        end
    end
  end

  defp validate_bag_space(%Ecto.Changeset{valid?: false} = changeset), do: changeset
end
