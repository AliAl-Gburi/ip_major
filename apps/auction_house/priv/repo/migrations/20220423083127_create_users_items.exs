defmodule AuctionHouse.Repo.Migrations.CreateUsersItems do
  use Ecto.Migration

  def change do
    create table(:bid) do
      add :user_id, references(:users), null: false
      add :item_id, references(:items), null: false
      add :bid, :integer


    end

  end
end
