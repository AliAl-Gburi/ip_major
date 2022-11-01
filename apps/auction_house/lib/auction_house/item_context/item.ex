defmodule AuctionHouse.ItemContext.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuctionHouse.ItemContext.Item
  alias AuctionHouse.AuctionContext.Auction
  alias AuctionHouse.ImageContext.Image
  alias AuctionHouse.UserContext.User

  schema "items" do
    field :name, :string
    field :description, :string
    field :reserve, :integer
    field :bid_start_date, :naive_datetime
    field :bid_end_date, :naive_datetime
    belongs_to :auction, Auction
    has_many :image, Image
    many_to_many :users, User, join_through: "bid"

  end

  @doc false
  def changeset(item, attrs, auction) do
    item
    |> cast(attrs, [:name, :description, :reserve, :bid_start_date, :bid_end_date])
    |> validate_required([:name, :description, :reserve, :bid_start_date, :bid_end_date])
    |> put_assoc(:auction, auction)
  end

  def addBid(%Item{} = item, %User{} = user) do
    new_users = [user | item.users]

    item
    |> cast(%{}, [])
    |> put_assoc(:users, new_users)
  end

  def getBidTemp(bidamount), do: bidamount


end
