defmodule AuctionHouseWeb.ItemView do
  use AuctionHouseWeb, :view

  def render("item.json", item) do
    IO.inspect(item)
    %{id: item[:item].id, auction_id: item[:item].auction_id, name: item[:item].name, description: item[:item].description, bid_end_date: item[:item].bid_end_date, bid_start_date: item[:item].bid_start_date, reserve: item[:item].reserve}
  end
end
