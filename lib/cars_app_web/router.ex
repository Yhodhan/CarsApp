defmodule CarsAppWeb.Router do
  use CarsAppWeb, :router

  use Plug.ErrorHandler

  defp handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  defp handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CarsAppWeb do
    pipe_through :api
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:cars_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: CarsAppWeb.Telemetry
    end
  end

  scope "/", CarsAppWeb do
    pipe_through :api

    get "/status", PageController, :status
    put "/cars", PageController, :cars
    post "/journey", PageController, :journey
    post "/dropoff", PageController, :dropoff
    post "/locate", PageController, :locate
  end
end
