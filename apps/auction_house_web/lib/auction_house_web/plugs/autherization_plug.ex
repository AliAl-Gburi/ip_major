defmodule AuctionHouseWeb.Plugs.AuthorizationPlug do
  import Plug.Conn
  alias AuctionHouse.UserContext.User
  alias AuctionHouse.AuctionContext
  alias Phoenix.Controller

  def init(options), do: options

  def call(%{private: %{guardian_default_resource: %User{} = u}} = conn, roles) do
    conn
    |> grant_access(u.username != "" and u.role in roles)
  end

  def grant_access(conn, true), do: conn

  def grant_access(conn, false) do
    conn
    |> Controller.put_flash(:error, "Unauthorized access")
    |> Controller.redirect(to: "/")
    |> halt
  end

  def isAdmin(conn) do
    user = Guardian.Plug.current_resource(conn)
    if user do
      user.role == "Admin" or user.role == "Business Analyst"
    else
      false
    end

  end

  def userOwnsAuction(conn, auction_id) do
    user = Guardian.Plug.current_resource(conn)
    auction = AuctionContext.get_auction!(auction_id)
    if user != nil do
      if user.id == auction.user_id do
        true
      else
        false
      end
    else
      false
    end


  end
end
