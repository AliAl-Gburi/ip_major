defmodule AuctionHouse.MetricContext.Metric do
  use Ecto.Schema
  import Ecto.Changeset

  schema "metrics" do
    field :"n-visits", :integer
    field :path, :string
    field :"request-type", :string
    field :user, :string
    field :browser, :string
  end

  @doc false
  def changeset(metric, attrs) do
    metric
    |> cast(attrs, [:path, :"request-type", :user, :"n-visits", :browser])
    |> validate_required([:path, :"request-type", :"n-visits", :browser])
  end
end
