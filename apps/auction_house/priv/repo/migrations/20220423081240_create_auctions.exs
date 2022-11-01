defmodule AuctionHouse.Repo.Migrations.CreateAuctions do
  use Ecto.Migration

  def change do
    create table(:auctions) do
      add :name, :string, null: false
      add :description, :string
      add :user_id, references(:users), null: false



    end
  end
end
