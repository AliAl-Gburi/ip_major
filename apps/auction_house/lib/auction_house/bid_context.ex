defmodule AuctionHouse.BidContext do
  import Ecto.Query
  alias AuctionHouse.Repo
  alias AuctionHouse.BidContext.Bid
  alias AuctionHouse.ItemContext.Item
  alias AuctionHouse.UserContext.User


  def insert_bid(nbid, attrs) do
    nbid
    |> Bid.changeset(attrs)
    |> Repo.update!()
  end

  def get_bid_by_item_and_user(%Item{} = item, %User{} = user) do
    Repo.all(from b in Bid, where: b.item_id == ^item.id and b.user_id == ^user.id, select: b)
  end

  def getHighestBid(item_id) do
    Repo.one!(from b in Bid, where: b.item_id == ^item_id, select: max(b.bid) )
  end

  def getBidsOnItemsByUser(user_id) do
    Repo.all(from b in Bid, join: i in Item, on: b.item_id == i.id, where: b.user_id == ^user_id, select: {b, i})
  end

  def getHighestUserBid(item_id, user_id) do
    Repo.one!(from b in Bid, where: b.item_id == ^item_id and b.user_id == ^user_id, select: max(b.bid) )
  end

  def deleteAllBidsOfItem(item_id) do
    from(b in Bid, where: b.item_id == ^item_id)
    |> Repo.delete_all()

  end
end
