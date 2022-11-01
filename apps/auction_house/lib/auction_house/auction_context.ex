defmodule AuctionHouse.AuctionContext do
  @moduledoc """
  The AuctionContext context.
  """

  import Ecto.Query, warn: false
  alias AuctionHouse.Repo
  alias AuctionHouse.UserContext.User
  alias AuctionHouse.AuctionContext.Auction
  alias AuctionHouse.ItemContext


  @doc """
  Returns the list of auctions.

  ## Examples

      iex> list_auctions()
      [%Auction{}, ...]

  """
  def list_auctions do
    Repo.all(Auction)
  end

  def getAuctionsOfUser(%User{} = user) do
    Repo.preload(user, :auctions)
  end

  @doc """
  Gets a single auction.

  Raises `Ecto.NoResultsError` if the Auction does not exist.

  ## Examples

      iex> get_auction!(123)
      %Auction{}

      iex> get_auction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_auction!(id), do: Repo.get!(Auction, id)

  def preloadItems(%Auction{} = auction) do
    breloaded = Repo.preload(auction, :item)
    Repo.preload(breloaded, :user)
  end

  @doc """
  Creates a auction.

  ## Examples

      iex> create_auction(%{field: value})
      {:ok, %Auction{}}

      iex> create_auction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_auction(attrs \\ %{}, %User{} = user) do
    %Auction{}
    |> Auction.changeset(attrs, user)
    |> Repo.insert()
  end

  @doc """
  Updates a auction.

  ## Examples

      iex> update_auction(auction, %{field: new_value})
      {:ok, %Auction{}}

      iex> update_auction(auction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_auction(%Auction{} = auction, attrs, %User{} = user) do
    auction
    |> Auction.changeset(attrs, user)
    |> Repo.update()
  end

  @doc """
  Deletes a auction.

  ## Examples

      iex> delete_auction(auction)
      {:ok, %Auction{}}

      iex> delete_auction(auction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_auction(%Auction{} = auction) do
    Enum.each(auction.item, fn i -> ItemContext.delete_item(i) end)
    Repo.delete(auction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking auction changes.

  ## Examples

      iex> change_auction(auction)
      %Ecto.Changeset{data: %Auction{}}

  """
  def change_auction(%Auction{} = auction, attrs \\ %{}, %User{} = user) do
    Auction.changeset(auction, attrs, user)
  end
end
