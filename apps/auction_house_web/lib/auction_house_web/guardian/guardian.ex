defmodule AuctionHouseWeb.Guardian do
  use Guardian, otp_app: :auction_house_web

  alias AuctionHouse.UserContext
  alias AuctionHouse.UserContext.User

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    case UserContext.get_user(id) do
      %User{} = u -> {:ok, u}
      nil -> {:error, :resource_not_found}
    end
  end
end
