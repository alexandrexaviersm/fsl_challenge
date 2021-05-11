defmodule AppWeb.BagController do
  use AppWeb, :controller

  alias App.Store
  alias App.Store.Bag
  alias App.Repo

  action_fallback AppWeb.FallbackController

  def index(conn, _params) do
    bags = Store.list_bags()
    render(conn, "index.json", bags: bags)
  end

  def create(conn, bag_params) do
    with {:ok, %Bag{} = bag} <- Store.create_bag(bag_params) do
      bag = bag |> Repo.preload(:cuboids)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.bag_path(conn, :show, bag))
      |> render("show.json", bag: bag)
    end
  end

  def show(conn, %{"id" => id}) do
    case Store.get_bag(id) do
      nil -> conn |> send_resp(404, "")
      bag -> render(conn, "show.json", bag: bag)
    end
  end
end
