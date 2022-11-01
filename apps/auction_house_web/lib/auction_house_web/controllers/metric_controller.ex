defmodule AuctionHouseWeb.MetricController do
  use AuctionHouseWeb, :controller
  alias AuctionHouse.MetricContext
  alias Phoenix.Controller

  def index(conn, _params) do
    metrics = MetricContext.get_metrics_no_user()
    render(conn, "index.html", metrics: metrics)

  end

  def details(conn, %{"path" => path, "method" => method}) do
    metrics = MetricContext.get_metrics_of_path(path, method)
    render(conn, "details.html", metrics: metrics, path: path, method: method)
  end

  def browser(conn, _params) do
    data = MetricContext.get_metrics_browser()
    render(conn, "browser-stats.html", data: data)
  end
end
