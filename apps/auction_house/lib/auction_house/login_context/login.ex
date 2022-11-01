defmodule AuctionHouse.LoginContext.Login do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logins" do
    field :attempts, :integer
    field :lastattempt, :naive_datetime
    field :username, :string

  end

  @doc false
  def changeset(login, attrs) do
    login
    |> cast(attrs, [:username, :attempts, :lastattempt])
    |> validate_required([:username, :attempts, :lastattempt])
  end
end
