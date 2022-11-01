defmodule AuctionHouseWeb.Plugs.AddApiKey do
  import Plug.Conn


  def init(options), do: options

  def call(conn, _options) do
    if Guardian.Plug.current_resource(conn) do
      conn
      |> put_req_header("api-key", Guardian.Plug.current_token(conn))
    else
      conn
    end

  end
end
