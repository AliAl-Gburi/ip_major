defmodule AuctionHouseWeb.AuctionView do
  use AuctionHouseWeb, :view

  alias AuctionHouseWeb.AuctionView
  alias AuctionHouseWeb.ItemView

  def render("index.json", %{auctions: auctions}) do
    #IO.inspect(auctions)
    %{data: render_many(auctions, AuctionView, "auction.json")}
  end

  def render("show.json", %{auction: auction}) do
    %{data: render_one(auction, AuctionView, "preloadedAuction.json")}
  end


  def render("auction.json", auction) do

    %{id: auction[:auction].id, name: auction[:auction].name, description: auction[:auction].description}
  end
  def render("preloadedAuction.json", auction) do
    IO.inspect(auction)
    %{id: auction[:auction].id, name: auction[:auction].name, description: auction[:auction].description, items: render_many(auction[:auction].item, ItemView, "item.json")}
  end
end
