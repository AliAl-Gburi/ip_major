defmodule AuctionHouse.LoginContext do
  @moduledoc """
  The UserContext context.
  """

  import Ecto.Query, warn: false
  alias AuctionHouse.Repo

  alias AuctionHouse.LoginContext.Login

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def get_attempt(username) do
    Repo.get_by(Login, username: username)
  end

  def create_attempt(attrs \\ %{}) do
    %Login{}
    |> Login.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%Login{} = login, attrs) do
    login
    |> Login.changeset(attrs)
    |> Repo.update()
  end
end
