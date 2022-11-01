defmodule AuctionHouse.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuctionHouse.AuctionContext.Auction
  alias AuctionHouse.ItemContext.Item

  @acceptable_roles ["Admin", "Member", "Business Analyst"]
  schema "users" do
    field :date_of_birth, :date
    field :email, :string
    field :first_name, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :role, :string, default: "Member"
    field :last_name, :string
    field :username, :string
    has_many :auctions, Auction
    many_to_many :items, Item, join_through: "bid"

  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :date_of_birth, :password, :username, :role])
    |> validate_required([:first_name, :last_name, :email, :date_of_birth, :password, :username, :role])
    |> unique_constraint(:username, name: :unique_username, message: "Username already taken")
    |> unique_constraint(:email, name: :unique_email, message: "A user with same email has already registered")
    |> validate_inclusion(:role, @acceptable_roles)
    |> put_password_hash()
  end

  defp put_password_hash(
    %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
  ) do
    change(changeset, hashed_password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

end
