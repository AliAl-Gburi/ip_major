defmodule AuctionHouseWeb.ApiView do
  use AuctionHouseWeb, :view
  alias AuctionHouseWeb.ApiView

  def render("index.json", %{auctions: auctions}) do
    #IO.inspect(auctions)
    %{data: render_many(auctions, ApiView, "auction.json")}
  end


  def render("auction.json", auction) do
    #IO.inspect(auction)
    %{id: auction[:api].id, name: auction[:api].name, description: auction[:api].description}
  end


end
