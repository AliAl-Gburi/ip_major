defmodule AuctionHouse.Repo.Migrations.CreateImages do
  use Ecto.Migration


  #def change do
  #  create table(:images) do
  #    add :link, :string
  #    add :item_id, references(:items)
  #  end

  def change do
    create table(:images) do
      add :filename, :string
      add :content_type, :string
      add :hash, :string, size: 64
      add :size, :bigint
      add :item_id, references(:items)
    end
  end
end
