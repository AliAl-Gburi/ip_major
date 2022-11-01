defmodule AuctionHouseWeb.ItemController do
  use AuctionHouseWeb, :controller

  alias AuctionHouse.ItemContext
  alias AuctionHouse.ItemContext.Item
  alias AuctionHouse.ImageContext.Image
  alias AuctionHouse.ImageContext
  alias AuctionHouse.AuctionContext
  alias AuctionHouse.BidContext
  alias Phoenix.Controller

  def index(conn, _params) do
    items = ItemContext.list_items()
    render(conn, "index.html", items: items)
  end


  def apiRequest(conn) do
    String.contains? conn.request_path, "/api"
  end



  def newI(conn, %{"id" => auction_id}) do
    changeset = ItemContext.new_item(%Item{}, auction_id)
    render(conn, "new.html", changeset: changeset, id: auction_id)
  end

  def confirmNewI(conn, %{"item" => item_params, "id" => auction_id}) do
    case ItemContext.create_item_auction(item_params, auction_id) do
      {:ok, item} ->
        redirect(conn, to: Routes.item_path(conn, :showItem, auction_id, item.id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def bid(conn, %{"aid" => aid, "iid" => iid, "bidamount" => bidamount}) do
    bidder = Guardian.Plug.current_resource(conn)
    highestbid = BidContext.getHighestBid(iid)
    ac = if highestbid == nil, do: 0, else: highestbid

    item = ItemContext.get_item!(iid)
    now = NaiveDateTime.utc_now()


    if NaiveDateTime.diff(now, item.bid_end_date) > 0 do
      conn
      |> put_flash(:error, "Sorry, the bidding period for this item has ended")
      |> redirect(to: Routes.item_path(conn, :showItem, aid, iid))
    end
    if NaiveDateTime.diff(now, item.bid_start_date) < 0 do
      conn
      |> put_flash(:error, "You are early, bidding on this item has not started yet")
      |> redirect(to: Routes.item_path(conn, :showItem, aid, iid))
    end

    IO.inspect(item.reserve)

    if elem(Integer.parse(bidamount["bidamount"]), 0) <= ac || elem(Integer.parse(bidamount["bidamount"]), 0) <= item.reserve do
      conn
      |> put_flash(:error, "Your bid must be higher than the current highest bid and the reserve")
      |> redirect(to: Routes.item_path(conn, :showItem, aid, iid))
    else
      ItemContext.addBid(iid, bidder, bidamount)

      redirect(conn, to: Routes.item_path(conn, :showItem, aid, iid))
    end

  end

  def show(conn, %{"id" => id}) do
    item = ItemContext.get_item!(id)
    bidamount = :bidamount


    render(conn, "show.html", item: item, bidamount: bidamount)
  end

  def showItem(conn, %{"aid" => aid,"iid" => id} ) do
    item = ItemContext.get_item!(id)
    highestbid = BidContext.getHighestBid(id)
    user = Guardian.Plug.current_resource(conn)
    ohighestbid = if highestbid == nil, do: 0, else: highestbid
    yhighestbid = if user == nil || BidContext.getHighestUserBid(id, user.id) == nil, do: 0, else: BidContext.getHighestUserBid(id, user.id)



      error = false
      bidamount = :bidamount
      changeset = ImageContext.change_image(%Image{})
      images = ImageContext.getImageByItem!(id)
      render(conn, "show.html", item: item, bidamount: bidamount, changeset: changeset, image: images, highestbid: ohighestbid, yhighestbid: yhighestbid, error: error, auction_id: aid)


  end

  def showItems(conn, %{"id" => auction_id}) do
    items = ItemContext.getAllItemsOfAuction(auction_id)
    render(conn, "index.html", items: items, id: auction_id)
  end

  def user_owns_item(conn, id) do
    user = Guardian.Plug.current_resource(conn)
    item = ItemContext.get_item!(id)
    auction = AuctionContext.get_auction!(item.auction_id)
    auction.user_id == user.id
  end




  def edit(conn, %{"aid" => aid,"iid" => id}) do
    item = ItemContext.get_item!(id)
    if !user_owns_item(conn, id) do
      unauthorized_access(conn)
    else
    changeset = ItemContext.change_item(item)
    render(conn, "edit.html", item: item, auction_id: aid, changeset: changeset)
    end
  end

  defp unauthorized_access(conn) do
    conn
      |> Controller.put_flash(:error, "Unauthorized access")
      |> Controller.redirect(to: "/")
      |> halt
  end

  def update(conn, %{"item" => item_params, "aid" => _aid, "iid" => id}) do
    item = ItemContext.get_item!(id)
    if user_owns_item(conn, id) do
      case ItemContext.update_item(item, item_params, item.auction) do
        {:ok, item} ->
          conn
          |> put_flash(:info, "Item updated successfully.")
          |> redirect(to: Routes.auction_path(conn, :show, item.auction))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", item: item, changeset: changeset)
        end
        else
          unauthorized_access(conn)
    end
  end

  def delete(conn, %{"aid" => aid,"iid" => id}) do
    if user_owns_item(conn, id) do
      item = ItemContext.get_item!(id)
      {:ok, _item} = ItemContext.delete_item(item)

      conn
      |> put_flash(:info, "Item deleted successfully.")
      |> redirect(to: Routes.item_path(conn, :showItems, aid))
    else
      unauthorized_access(conn)
    end

  end
end
