defmodule AuctionHouse.ItemContext do
  @moduledoc """
  The ItemContext context.
  """

  import Ecto.Query
  alias AuctionHouse.Repo
  alias AuctionHouse.AuctionContext
  alias AuctionHouse.ImageContext
  alias AuctionHouse.AuctionContext.Auction
  alias AuctionHouse.UserContext.User
  alias AuctionHouse.ItemContext.Item
  alias AuctionHouse.BidContext

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Repo.all(Item)
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id) do
    Repo.get!(Item, id)
    |> Repo.preload(:auction)
  end

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def getIdOfLastItem() do
    Repo.one(from i in "items",
    select: max(i.id))
  end

  def create_item(attrs \\ %{}, auction) do
    item = %Item{}

    item
    |> Item.changeset(attrs, auction)
    |> Repo.insert()


  end

  def addBid(item_id, %User{} = user, bidamount) do
    item = get_item!(item_id)
    preloaded_item = Repo.preload(item, :users)
    updated_changeset = Item.addBid(preloaded_item, user)
    bwid = Repo.update!(updated_changeset)


    nbid = BidContext.get_bid_by_item_and_user(bwid, user)
    attrs = %{:user_id => user.id, :item_id => item_id, :bid => bidamount["bidamount"]}
    BidContext.insert_bid(Enum.at(nbid, 0), attrs)
  end


  def create_item_auction(attrs \\ %{}, auction_id) do

    item = %Item{}
    auction = Repo.get!(Auction, auction_id)
    item
    |> Item.changeset(attrs, auction)
    |> Repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs, auction) do
    item
    |> Item.changeset(attrs, auction)
    |> Repo.update()
  end

  def getAllItemsOfAuction(auction_id) do
    from(i in Item, where: i.auctions_id == ^auction_id)
      |> Repo.all()

  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    BidContext.deleteAllBidsOfItem(item.id)
    ImageContext.deleteAllImagesOfItem(item.id)
    Repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def new_item(%Item{} = item, attrs \\ %{}, auction_id) do
    auction = AuctionContext.get_auction!(auction_id)
    Item.changeset(item, attrs, auction)
  end
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs, item.auction)
  end

  def bid_temp(bidamount) do
    Item.getBidTemp(bidamount)
  end
end
