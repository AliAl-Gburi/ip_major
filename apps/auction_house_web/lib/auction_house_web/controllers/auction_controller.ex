defmodule AuctionHouseWeb.AuctionController do
  use AuctionHouseWeb, :controller
  alias AuctionHouseWeb.Guardian
  alias AuctionHouse.AuctionContext
  alias AuctionHouse.AuctionContext.Auction
  alias Phoenix.Controller

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    IO.inspect(conn)
    newuser = AuctionContext.getAuctionsOfUser(user)
    if apiRequest(conn) do
      render(conn, "index.json", auctions: newuser.auctions)
    else
      render(conn, "index.html", auctions: newuser.auctions)
    end

  end

  def apiRequest(conn) do
    String.contains? conn.request_path, "/api"
  end

  def allAuctions(conn, _params) do
    auctions = AuctionContext.list_auctions()

    if apiRequest(conn) do
      IO.inspect(conn)
      render(conn, "index.json", auctions: auctions)
    else
      render(conn, "index.html", auctions: auctions)
    end

  end

  def new(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    changeset = AuctionContext.change_auction(%Auction{}, user)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"auction" => auction_params}) do
    user = Guardian.Plug.current_resource(conn)
    if apiRequest(conn) do
      case AuctionContext.create_auction(auction_params, user) do
        {:ok, auction} ->
          conn
          |> render("show.json", auction: auction)

        {:error, %Ecto.Changeset{} = _changeset} ->
          json(conn, %{error: "Something is wrong with your input"})
        end
    else
      case AuctionContext.create_auction(auction_params, user) do
        {:ok, auction} ->
          conn
          |> put_flash(:info, "Auction created successfully.")
          |> redirect(to: Routes.auction_path(conn, :show, auction))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
        end
    end
  end

  def show(conn, %{"id" => id}) do

    auction = AuctionContext.get_auction!(id)
    preloadedAuction = AuctionContext.preloadItems(auction)

    if apiRequest(conn) do
      render(conn, "show.json", auction: preloadedAuction)
    else
      render(conn, "show.html", auction: preloadedAuction)
    end




  end

  def edit(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    auction = AuctionContext.get_auction!(id)
    preauction = AuctionContext.preloadItems(auction)
    if user.id == preauction.user_id do
      changeset = AuctionContext.change_auction(preauction, user)
      render(conn, "edit.html", auction: preauction, changeset: changeset)
    else
      conn
      |> Controller.put_flash(:error, "Unauthorized access")
      |> Controller.redirect(to: "/")
      |> halt
    end

  end

  def update(conn, %{"id" => id, "auction" => auction_params}) do
    auction = AuctionContext.get_auction!(id)
    preauction = AuctionContext.preloadItems(auction)
    user = Guardian.Plug.current_resource(conn)
    case AuctionContext.update_auction(preauction, auction_params, user) do
      {:ok, preauction} ->
        if apiRequest(conn) do
          render(conn, "show.json", auction: preauction)
        else
          conn
        |> put_flash(:info, "Auction updated successfully.")
        |> redirect(to: Routes.auction_path(conn, :show, preauction))
        end
      {:error, %Ecto.Changeset{} = changeset} ->
        if apiRequest(conn) do
          json(conn, %{error: "Something went wrong"})
        else
          render(conn, "edit.html", auction: preauction, changeset: changeset)
        end



    end
  end

  def delete(conn, %{"id" => id}) do
    auction = AuctionContext.get_auction!(id)
    preauction = AuctionContext.preloadItems(auction)
    {:ok, deauction} = AuctionContext.delete_auction(preauction)

    if apiRequest(conn) do
      json(conn, %{deleted: deauction.id})
    else
      conn
      |> put_flash(:info, "Auction deleted successfully.")
      |> redirect(to: Routes.auction_path(conn, :index))

    end


  end
end
