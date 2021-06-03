defmodule App.StoreTest do
  use App.DataCase
  @sample_size 3

  alias App.Store

  describe "cuboids" do
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

    test "list_cuboids/0 returns all cuboids" do
      %{cuboids: cuboids} = fixtures()
      assert Store.list_cuboids() == cuboids
    end

    test "get_cuboid/1 returns the cuboid with given id" do
      %{cuboids: cuboids} = fixtures()
      cuboid = hd(cuboids)
      assert Store.get_cuboid(cuboid.id) == cuboid
    end

    test "get_cuboid/1 returns nil with invalid id" do
      assert Store.get_cuboid(2) == nil
    end

    test "create_cuboid/1 with valid data creates a cuboid" do
      %{bag: bag} = fixture()

      assert {:ok, _} =
               Store.create_cuboid(%{
                 depth: 1,
                 height: 2,
                 width: 3,
                 bag_id: bag.id
               })
    end

    test "create_cuboid/1 with invalid data returns error changeset" do
      %{bag: bag} = fixture()

      assert {:error, %Ecto.Changeset{}} =
               Store.create_cuboid(%{
                 depth: nil,
                 height: 20,
                 width: 20,
                 bag_id: bag.id
               })
    end
  end

  describe "bags" do
    @valid_attrs %{
      volume: 10,
      title: "Bag 1",
      payloadVolume: 8,
      availableVolume: 2
    }

    @invalid_attrs %{
      title: nil
    }

    def bag_fixture(attrs \\ %{}) do
      {:ok, bag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Store.create_bag()

      {:ok, _} =
        Store.create_cuboid(%{
          depth: 2,
          height: 2,
          width: 2,
          bag_id: bag.id
        })

      bag |> Repo.preload(:cuboids)
    end

    test "list_bags/0 returns all bags" do
      bag = bag_fixture()
      assert Store.list_bags() == [bag]
    end

    test "get_bag/1 returns the bag with given id" do
      bag = bag_fixture()
      assert Store.get_bag(bag.id) == bag
    end

    test "create_bag/1 with valid data creates a bag" do
      assert {:ok, _} = Store.create_bag(@valid_attrs)
    end

    test "create_bag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_bag(@invalid_attrs)
    end

    test "create_bag/1 with one cuboid and check payloadVolume" do
      bag = bag_fixture()
      assert bag.payloadVolume == @valid_attrs.payloadVolume
    end

    test "create_bag/1 with one cuboid and check availableVolume" do
      bag = bag_fixture()
      assert bag.availableVolume == @valid_attrs.availableVolume
    end
  end
end
