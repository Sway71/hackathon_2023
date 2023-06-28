defmodule Hackathon2023.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      Hackathon2023Web.Telemetry,
      # Start the Ecto repository
      Hackathon2023.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Hackathon2023.PubSub},
      # Start Finch
      {Finch, name: Hackathon2023.Finch},
      # Start the Endpoint (http/https)
      Hackathon2023Web.Endpoint,
      # add Redis connection to supervisor tree so it's globally available!!
      # very cool!
      {Redix, name: :redix, host: "localhost", port: 6379}
      # Start a worker by calling: Hackathon2023.Worker.start_link(arg)
      # {Hackathon2023.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hackathon2023.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Hackathon2023Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
