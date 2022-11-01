defmodule AuctionHouseWeb.SessionController do
  use AuctionHouseWeb, :controller

  alias AuctionHouseWeb.Guardian
  alias AuctionHouse.UserContext
  alias AuctionHouse.UserContext.User
  alias AuctionHouse.LoginContext

  def new(conn, _) do
    changeset = UserContext.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/user_scope")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
    end
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    attempt = LoginContext.get_attempt(username)
    attempt_date = NaiveDateTime.utc_now()

    if attempt do
      diff = NaiveDateTime.diff(attempt_date, attempt.lastattempt)
      if attempt.attempts == 3 and diff < 300 do
        login_reply({:error, "Please wait 5 minutes before trying again"}, conn)
      else
        UserContext.authenticate_user(username, password)
        |> login_reply(conn)
      end
    else
      UserContext.authenticate_user(username, password)
      |> login_reply(conn)

    end


  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end


  defp login_reply({:ok, user}, conn) do
    if apiRequest(conn) do
      conn
      |> Guardian.Plug.sign_in(user)
      |> json(%{success: true})

    else
      conn
      |> put_flash(:info, "Welcome back!")
      |> Guardian.Plug.sign_in(user)
      |> redirect(to: "/")
    end


  end

  defp login_reply({:error, reason}, conn) do
    username = conn.body_params["user"]["username"]
    attempt_date = NaiveDateTime.utc_now()
    #attrs = %{username: username, lastattempt: attempt_date, attempts: 1}
    #LoginContext.create_attempt(attrs)
    user = LoginContext.get_attempt(username)
    if user do
      diff = NaiveDateTime.diff(attempt_date, user.lastattempt)
      if diff > 300 do
        attrs = %{username: username, lastattempt: attempt_date, attempts: 1}
        LoginContext.update_user(user, attrs)
        conn
        |> put_flash(:error, to_string("Password incorrect, You have 2 more attempts"))
        |> new(%{})
      end
      if diff > 60 do

        attrs = %{username: username, lastattempt: attempt_date, attempts: 1}
        LoginContext.update_user(user, attrs)
        conn
        |> put_flash(:error, to_string("Password incorrect, You have 2 more attempts"))
        |> new(%{})
      else
        if user.attempts == 3 do
          conn
          |> put_flash(:error, to_string("Please wait 5 minutes before trying again"))
          |> new(%{})
        else
          attrs = %{username: username, lastattempt: attempt_date, attempts: user.attempts + 1}
          LoginContext.update_user(user, attrs)
          if user.attempts + 1 == 3 do
            conn
            |> put_flash(:error, to_string("Please wait 5 minutes before trying again"))
            |> new(%{})
          else
            conn
            |> put_flash(:error, to_string("Password incorrect, You have #{2 - user.attempts} attempts left"))
            |> new(%{})

          end

        end
      end
    else
      attrs = %{username: username, lastattempt: attempt_date, attempts: 1}
      LoginContext.create_attempt(attrs)
      conn
        |> put_flash(:error, to_string("Password incorrect, You have 2 more attempts"))
        |> new(%{})
    end

  end

  def apiRequest(conn) do
    String.contains? conn.request_path, "/api"
  end
end
