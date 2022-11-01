# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AuctionHouse.Repo.insert!(%AuctionHouse.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
{:ok, _cs} = AuctionHouse.UserContext.create_user(%{first_name: "admin", last_name: "admin", email: "admin@admin.be", date_of_birth: Date.utc_today, password: "t", username: "admin", role: "Admin"})
{:ok, _cs} = AuctionHouse.UserContext.create_user(%{first_name: "user", last_name: "user", email: "user@user.be", date_of_birth: Date.utc_today, password: "t", username: "user"})
{:ok, _cs} = AuctionHouse.UserContext.create_user(%{first_name: "ba", last_name: "ba", email: "ba@ba.be", date_of_birth: Date.utc_today, password: "t", username: "ba", role: "Business Analyst"})
