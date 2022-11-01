defmodule AuctionHouse.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string, null: false
      add :description, :string
      add :reserve, :integer, null: false
      add :bid_start_date, :naive_datetime, null: false
      add :bid_end_date, :naive_datetime, null: false
      add :auction_id, references(:auctions), null: false



    end
  end
end
