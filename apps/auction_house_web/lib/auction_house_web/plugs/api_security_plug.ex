defmodule AuctionHouseWeb.Plugs.ApiSecurityPlug do
  import Plug.Conn
  import Phoenix.Controller

  def init(options), do: options

  def call(conn, _options) do
    conn
    |> getApiKey()
    |> verifyKey()

  end




  def getApiKey(conn) do
    key = get_req_header(conn, "api-key")

    #IO.inspect(Enum.at(key, 0))

    if key != nil do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(AuctionHouseWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end

  def verifyKey(conn) do
    key = get_req_header(conn, "api-key")
    if Enum.at(key, 0) == conn.private.guardian_default_token do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(AuctionHouseWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end

  end
end
