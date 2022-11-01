defmodule AuctionHouse.Repo do
  use Ecto.Repo,
    otp_app: :auction_house,
    adapter: Ecto.Adapters.MyXQL
end
