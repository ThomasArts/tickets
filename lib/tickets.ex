defmodule Tickets do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    #:ets.new(:roll, [:named_table, :public, read_concurrency: true])
    #:ets.insert(:roll, {"ticket", 1})

    write(1)
    
    children = [
      # Start the endpoint when the application starts
      supervisor(Tickets.Endpoint, []),
      # Start the Ecto repository
      supervisor(Tickets.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(Tickets.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tickets.Supervisor]
    Supervisor.start_link(children, opts)
  end
  
  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Tickets.Endpoint.config_change(changed, removed)
    :ok
  end

  def write(nr) do
    File.write("priv/static/ticket.txt", Integer.to_string(nr))
  end

  def read do
    str = File.read!("priv/static/ticket.txt")
    String.to_integer(str)
  end
  
end
