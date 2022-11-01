defmodule AuctionHouse.BidContext.Bid do
  use Ecto.Schema
  import Ecto.Changeset


  schema "bid" do
    field :user_id, :integer
    field :item_id, :integer
    field :bid, :integer
  end

  @doc false
  def changeset(bid, attrs) do
    bid
    |> cast(attrs, [:user_id, :item_id, :bid])
    |> validate_required([:user_id, :item_id, :bid])
  end
end
