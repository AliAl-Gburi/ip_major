defmodule AuctionHouseWeb.Plugs.MetricsPlug do
  alias AuctionHouse.MetricContext
  import Plug.Conn

  def init(options), do: options


  def call(conn, _options) do
    #IO.inspect(conn)
    path = conn.request_path
    type = conn.method
    IO.inspect(path)
    IO.inspect(type)
    user = Guardian.Plug.current_resource(conn)
    browser = Enum.at(get_req_header(conn, "user-agent"), 0)
    IO.inspect(conn)
    IO.inspect(browser)
    if user do
      username = user.username
      metrics = MetricContext.get_metric_of_user(path, type, username)
      if metrics do
        attrs = %{path: path, "request-type": type, user: username, "n-visits": metrics."n-visits" + 1, browser: browser}
        MetricContext.update_metric(metrics, attrs)
      else
        attrs = %{path: path, "request-type": type, user: username, "n-visits": 1, browser: browser}
        MetricContext.create_metric(attrs)
      end
    else

      metric = MetricContext.get_metric_of_user(path, type)
      IO.inspect(metric)
      if metric do
        attrs = %{path: path, "request-type": type, user: nil, "n-visits": metric."n-visits" + 1, browser: browser}
        MetricContext.update_metric(metric, attrs)
      else
        attrs = %{path: path, "request-type": type, user: nil, "n-visits": 1, browser: browser}
        m = MetricContext.create_metric(attrs)
        IO.inspect(m)
      end
    end
    conn
  end
end
