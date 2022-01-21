defmodule ParagonRoller.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ParagonRoller.Repo,
      # Start the Telemetry supervisor
      ParagonRollerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ParagonRoller.PubSub},
      # Start the Endpoint (http/https)
      ParagonRollerWeb.Endpoint,
      # Start a worker by calling: ParagonRoller.Worker.start_link(arg)
      # {ParagonRoller.Worker, arg}
      ParagonRollerWeb.Presence
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ParagonRoller.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ParagonRollerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
