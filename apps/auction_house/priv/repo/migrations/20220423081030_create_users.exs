defmodule AuctionHouse.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string, null: false
      add :date_of_birth, :date, null: false
      add :hashed_password, :string, null: false
      add :username, :string, null: false
      add :role, :string, null: false

    end

    create unique_index(:users, [:username],
      name: :unique_username
    )
    create unique_index(:users, [:email],
      name: :unique_email
    )
  end
end
