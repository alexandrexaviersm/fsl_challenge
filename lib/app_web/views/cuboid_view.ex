defmodule AppWeb.CuboidView do
  use AppWeb, :view
  alias AppWeb.CuboidView

  def render("index.json", %{cuboids: cuboids}) do
    render_many(cuboids, CuboidView, "cuboid.json")
  end

  def render("show.json", %{cuboid: cuboid}) do
    render_one(cuboid, CuboidView, "cuboid.json")
  end

  def render("cuboid.json", %{cuboid: cuboid}) do
    %{
      id: cuboid.id,
      depth: cuboid.depth,
      height: cuboid.height,
      width: cuboid.width,
      bag: %{id: cuboid.bag_id}
    }
  end
end
