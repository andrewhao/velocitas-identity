defmodule VelocitasIdentity.Router do
  use VelocitasIdentity.Web, :router

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VelocitasIdentity do
    pipe_through [:browser, :browser_auth]

    get "/", PageController, :index
    resources "/users", UserController
  end

  scope "/auth", VelocitasIdentity do
    pipe_through :browser
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", VelocitasIdentity do
  #   pipe_through :api
  # end
end
