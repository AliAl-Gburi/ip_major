defmodule AuctionHouse.Repo.Migrations.CreateMetrics do
  use Ecto.Migration

  def change do
    create table(:metrics) do
      add :path, :string
      add :"request-type", :string
      add :user, :string
      add :"n-visits", :integer
      add :browser, :string

    end
  end
end
