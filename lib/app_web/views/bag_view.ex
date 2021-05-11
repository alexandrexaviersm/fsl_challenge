defmodule AppWeb.BagView do
  use AppWeb, :view
  alias AppWeb.BagView
  alias AppWeb.CuboidView

  def render("index.json", %{bags: bags}) do
    render_many(bags, BagView, "bag.json")
  end

  def render("show.json", %{bag: bag}) do
    render_one(bag, BagView, "bag.json")
  end

  def render("bag.json", %{bag: bag}) do
    %{
      id: bag.id,
      volume: bag.volume,
      title: bag.title,
      cuboids: render_many(bag.cuboids, CuboidView, "cuboid.json")
    }
  end
end
