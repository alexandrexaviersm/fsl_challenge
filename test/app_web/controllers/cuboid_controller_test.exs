defmodule AppWeb.CuboidControllerTest do
  use AppWeb.ConnCase
  @sample_size 3

  alias App.Store
  alias App.Store.Cuboid
  alias App.Repo

  def fixture do
    {:ok, bag} =
      Store.create_bag(%{
        volume: 25,
        title: "Bag 0"
      })

    %{bag: bag}
  end

  def fixtures do
    {:ok, bag} =
      Store.create_bag(%{
        volume: 100,
        title: "Bag 0"
      })

    cuboids =
      1..@sample_size
      |> Enum.to_list()
      |> Enum.map(fn i ->
        {:ok, cuboid} =
          Store.create_cuboid(%{
            depth: i,
            height: i,
            width: i,
            bag_id: bag.id
          })

        cuboid |> Repo.preload(:bag)
      end)

    %{bag: bag, cuboids: cuboids}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all cuboids", %{conn: conn} do
      fixtures()
      conn = get(conn, Routes.cuboid_path(conn, :index))

      for cuboid <- json_response(conn, 200) do
        assert cuboid["width"] != nil
        assert cuboid["height"] != nil
        assert cuboid["depth"] != nil
        assert cuboid["bag"] != nil
        assert cuboid["bag"]["id"] != nil
      end
    end

    test "get cuboid with valid id ", %{conn: conn} do
      %{cuboids: cuboids} = fixtures()
      cuboid = hd(cuboids)
      conn = get(conn, Routes.cuboid_path(conn, :show, cuboid.id))
      assert json_response(conn, 200)["id"] == cuboid.id
    end

    test "get cuboid with volume ", %{conn: conn} do
      %{bag: bag, cuboids: cuboids} = fixtures()
      cuboid = hd(cuboids)
      conn = get(conn, Routes.cuboid_path(conn, :show, cuboid.id))

      assert json_response(conn, 200) == %{
               "id" => cuboid.id,
               "depth" => cuboid.depth,
               "height" => cuboid.height,
               "width" => cuboid.width,
               "volume" => cuboid.volume,
               "bag" => %{"id" => bag.id}
             }
    end

    test "get cuboid with invalid id ", %{conn: conn} do
      fixtures()
      conn = get(conn, Routes.cuboid_path(conn, :show, 0))
      assert response(conn, 404)
    end
  end

  describe "create cuboid" do
    test "renders cuboid when data is valid", %{conn: conn} do
      %{bag: bag} = fixture()

      conn =
        post(conn, Routes.cuboid_path(conn, :create), %{
          depth: 2,
          height: 3,
          width: 4,
          bag_id: bag.id
        })

      cuboid_created = json_response(conn, 201)
      assert cuboid_created["id"] != nil

      conn = get(conn, Routes.cuboid_path(conn, :show, cuboid_created["id"]))
      cuboid_fetched = json_response(conn, 200)

      assert cuboid_created["id"] == cuboid_fetched["id"]
      assert cuboid_created["width"] == cuboid_fetched["width"]
      assert cuboid_created["height"] == cuboid_fetched["height"]
      assert cuboid_created["depth"] == cuboid_fetched["depth"]
      assert cuboid_created["bag"] != nil
      assert cuboid_fetched["bag"] != nil
      assert cuboid_created["bag"]["id"] == cuboid_fetched["bag"]["id"]
    end

    test "renders cuboid when bag is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.cuboid_path(conn, :create), %{
          depth: 6,
          height: 6,
          width: 6,
          bag_id: -1
        })

      assert response(conn, 422) == "{\"errors\":{\"bag\":[\"does not exist\"]}}"
    end

    test "renders cuboid when data is invalid", %{conn: conn} do
      %{bag: bag} = fixture()

      conn =
        post(conn, Routes.cuboid_path(conn, :create), %{
          depth: 6,
          height: 6,
          width: 6,
          bag_id: bag.id
        })

      assert response(conn, 422) == "{\"errors\":{\"volume\":[\"Insufficient space in bag\"]}}"
    end
  end

  # DO NOT modify the tests ABOVE
  # IMPLEMENT the tests BELOW

  describe "update cuboid" do
    test "renders cuboid when data is valid", %{conn: conn} do
      %{cuboids: cuboids} = fixtures()
      cuboid = hd(cuboids)

      cuboid_to_update = %{
        depth: 2,
        height: 2,
        width: 2
      }

      conn = put(conn, Routes.cuboid_path(conn, :update, cuboid), cuboid: cuboid_to_update)

      cuboid_updated = json_response(conn, 200)
      assert cuboid.id == cuboid_updated["id"]
      assert cuboid_to_update.height == cuboid_updated["height"]
      assert cuboid_to_update.width == cuboid_updated["width"]
      assert cuboid_to_update.depth == cuboid_updated["depth"]
    end

    test "renders cuboid when data is not valid", %{conn: conn} do
      %{cuboids: cuboids} = fixtures()
      cuboid = hd(cuboids)

      cuboid_to_update = %{
        depth: 10,
        height: 10,
        width: 10
      }

      conn = put(conn, Routes.cuboid_path(conn, :update, cuboid), cuboid: cuboid_to_update)

      assert response(conn, 422) == "{\"errors\":{\"volume\":[\"Insufficient space in bag\"]}}"
    end
  end

  describe "delete cuboid" do
    test "renders cuboid when is valid", %{conn: conn} do
      %{cuboids: cuboids} = fixtures()
      cuboid = hd(cuboids)

      conn = delete(conn, Routes.cuboid_path(conn, :delete, cuboid))

      assert response(conn, 204)
    end

    test "renders cuboid when is invalid", %{conn: conn} do
      %{cuboids: cuboids} = fixtures()
      cuboid = hd(cuboids)

      Store.delete_cuboid(cuboid)

      conn = delete(conn, Routes.cuboid_path(conn, :delete, cuboid))

      assert response(conn, 404)
    end
  end
end
