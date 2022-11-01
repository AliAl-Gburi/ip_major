defmodule AuctionHouseWeb.PageController do
  use AuctionHouseWeb, :controller

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    if user do
      render(conn, "index.html", user: user)
    else
      render(conn, "index.html")
    end

  end


end
