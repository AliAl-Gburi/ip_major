defmodule AuctionHouse.Repo.Migrations.CreateLogins do
  use Ecto.Migration

  def change do
    create table(:logins) do
      add :username, :string
      add :attempts, :integer
      add :lastattempt, :naive_datetime

    end
  end
end
