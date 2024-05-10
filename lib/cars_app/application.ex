defmodule CarsApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CarsAppWeb.Telemetry,
      CarsApp.Repo,
      {DNSCluster, query: Application.get_env(:cars_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CarsApp.PubSub},
      # Start a worker by calling: CarsApp.Worker.start_link(arg)
      # {CarsApp.Worker, arg},
      # Start to serve requests, typically the last entry
      CarsAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CarsApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CarsAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
