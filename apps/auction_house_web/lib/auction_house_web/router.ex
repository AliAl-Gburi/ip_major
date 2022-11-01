defmodule AuctionHouseWeb.Router do
  use AuctionHouseWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AuctionHouseWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AuctionHouseWeb.Plugs.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :put_secure_browser_headers
  end

  pipeline :metrics do
    plug AuctionHouseWeb.Plugs.MetricsPlug
  end

  pipeline :auth do
    plug AuctionHouseWeb.Pipeline
  end

  pipeline :allowed_for_members do
    plug AuctionHouseWeb.Plugs.AuthorizationPlug, ["Admin", "Member", "Business Analyst"]
  end

  pipeline :allowed_for_admins do
    plug AuctionHouseWeb.Plugs.AuthorizationPlug, ["Admin", "Business Analyst"]
  end

  pipeline :check_api_key do
    plug AuctionHouseWeb.Plugs.ApiSecurityPlug
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
    plug AuctionHouseWeb.Plugs.AddApiKey
  end

  scope "/", AuctionHouseWeb do
    pipe_through [:browser, :auth, :metrics]

    get "/auctions", AuctionController, :allAuctions
    get "/auctions/:id", AuctionController, :show
    get "/auctions/:aid/items/:iid", ItemController, :showItem
    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout

    get "/users/new", UserController, :new
    post "/users", UserController, :create
    get "/auctions/:aid/items/:iid/images/:imid", ImageController, :display


  end

  scope "/member", AuctionHouseWeb do
    pipe_through [:browser, :auth, :ensure_auth, :metrics, :allowed_for_members]

    get "/auctions", AuctionController, :index
    get "/auctions/new", AuctionController, :new
    get "/auctions/edit/:id", AuctionController, :edit
    post "/auctions", AuctionController, :create
    patch "/auctions/:id", AuctionController, :update
    put "/auctions/:id", AuctionController, :update
    delete "/auctions/:id", AuctionController, :delete

    get "/auctions/:id/addItem/", ItemController, :newI
    post "/auctions/:id/addItem/", ItemController, :confirmNewI
    get "/auctions/:id/items", ItemController, :showItems
    get "/auctions/:aid/items/:iid", ItemController, :edit
    post "/auctions/:aid/items/:iid", ItemController, :update
    put "/auctions/:aid/items/:iid", ItemController, :update
    delete "/auctions/:aid/items/:iid", ItemController, :delete

    get "/auctions/:aid/items/:iid/images/:imid", ImageController, :display



    #post "/auctions/:aid/items/:iid/image", ImageController, :create
    post "/auctions/:aid/items/:iid/image", ImageController, :create2




    post "/auctions/:aid/items/:iid/bid", ItemController, :bid
    get "/bids", UserController, :getAllBidsOfUser
    #resources "/images", ImageController
  end

  scope "/admin", AuctionHouseWeb do
    pipe_through [:browser, :auth, :ensure_auth, :metrics, :allowed_for_admins]
    get "/business-analyst/statistics", MetricController, :index
    get "/business-analyst/statistics/path=:path/method=:method", MetricController, :details
    get "/business-analyst/browser-statistics", MetricController, :browser
    resources "/users", UserController
  end

  scope "/api", AuctionHouseWeb do
    pipe_through [:api, :auth]
    post "/login", SessionController, :login
    get "/auctions", AuctionController, :allAuctions
    get "/auctions/:id", AuctionController, :show
    get "/auctions/:aid/items/:iid", ItemController, :showItem

  end

  # Other scopes may use custom stacks.
  scope "/member/api", AuctionHouseWeb do
     pipe_through [:api, :auth, :ensure_auth, :check_api_key]
     #get "/users", ApiController, :users
     get "/auctions", AuctionController, :index
     post "/auctions", AuctionController, :create
     patch "/auctions/:id", AuctionController, :update
     put "/auctions/:id", AuctionController, :update
     delete "/auctions/:id", AuctionController, :delete


   end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AuctionHouseWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
