defmodule AuctionHouse.AuctionContext.Auction do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuctionHouse.UserContext.User
  alias AuctionHouse.ItemContext.Item

  schema "auctions" do
    field :description, :string
    field :name, :string
    belongs_to :user, User
    has_many :item, Item
  end

  @doc false
  def changeset(auction, attrs, %User{} = user) do
    auction
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> put_assoc(:user, user)
  end
end
