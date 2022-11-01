defmodule AuctionHouse.MetricContext do
  import Ecto.Query, warn: false
  alias AuctionHouse.Repo

  alias AuctionHouse.MetricContext.Metric
  alias AuctionHouse.UserContext.User

  def get_metric_of_user(path, type, user) do
    Repo.get_by(Metric, [path: path, "request-type": type, user: user])
  end

  def list_metrics(), do: Repo.all(Metric)

  def get_metrics_no_user() do
    from(m in Metric, group_by: [m.path, m."request-type"], select: [m.path, m."request-type", sum(m."n-visits")]) |> Repo.all()
  end

  def get_metrics_browser() do
    from(m in Metric, group_by: m.browser, select: [m.browser, sum(m."n-visits")]) |> Repo.all()
  end


  def get_metrics_of_path(path, method) do
    from(m in Metric, left_join: u in User, on: m.user == u.username, where: m.path == ^path and m."request-type" == ^method, select: [u.id, u.first_name, u.last_name, u.username, u.email, m."n-visits"]) |> Repo.all()
  end

  def get_metric_of_user(path, type) do
    from(m in Metric, where: m.path == ^path and m."request-type" == ^type and is_nil(m.user)) |> Repo.one()
  end

  def create_metric(attrs \\ %{}) do
    %Metric{}
    |> Metric.changeset(attrs)
    |> Repo.insert()
  end

  def update_metric(%Metric{} = metric, attrs) do
    metric
    |> Metric.changeset(attrs)
    |> Repo.update()
  end

  def delete_metric(%Metric{} = metric) do
    Repo.delete(metric)
  end

  def delete_metric_by_username(username) do
    from(m in Metric, where: m.user == ^username) |> Repo.delete_all()
  end

end
