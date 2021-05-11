defmodule AppWeb.BagControllerTest do
  use AppWeb.ConnCase

  @sample_size 3

  alias App.Store
  alias App.Store.Bag

  @create_attrs %{
    volume: 200,
    title: "Bag 0"
  }

  @update_attrs %{}
  @invalid_attrs %{}

  def fixtures(:bags) do
    1..@sample_size
    |> Enum.to_list()
    |> Enum.map(fn i ->
      {:ok, bag} =
        Store.create_bag(%{
          volume: i * 100,
          title: "Bag #{i}"
        })

      bag
    end)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_bags]

    test "lists all bags", %{conn: conn, bags: bags} do
      conn = get(conn, Routes.bag_path(conn, :index))

      assert json_response(conn, 200) ==
               bags
               |> Enum.map(fn bag ->
                 %{
                   "id" => bag.id,
                   "volume" => bag.volume,
                   "title" => bag.title,
                   "cuboids" => []
                 }
               end)
    end

    test "get bag with valid id ", %{conn: conn, bags: bags} do
      bag = hd(bags)
      conn = get(conn, Routes.bag_path(conn, :show, bag.id))

      assert json_response(conn, 200) == %{
               "id" => bag.id,
               "volume" => bag.volume,
               "title" => bag.title,
               "cuboids" => []
             }
    end

    test "get bag with invalid id ", %{conn: conn} do
      conn = get(conn, Routes.cuboid_path(conn, :show, 0))
      assert response(conn, 404)
    end
  end

  describe "create bag" do
    test "renders bag when data is valid", %{conn: conn} do
      conn = post(conn, Routes.bag_path(conn, :create), @create_attrs)
      assert %{"id" => id, "volume" => volume, "title" => title} = json_response(conn, 201)

      conn = get(conn, Routes.bag_path(conn, :show, id))

      assert %{
               "id" => id,
               "volume" => volume,
               "title" => title,
               "cuboids" => []
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.bag_path(conn, :create), bag: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_bags(_) do
    bags = fixtures(:bags)
    %{bags: bags}
  end
end
