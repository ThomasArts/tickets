defmodule Tickets.PageController do
  use Tickets.Web, :controller
  
  def index(conn, _params) do
    render conn, "index.html"
  end

  def reset(conn, params) do
    :ets.insert(:roll, {"ticket", 1})
    index(conn, params)
  end

  def take(conn, params) do
    index(conn, params)
    [{"ticket", n}] = :ets.lookup(:roll, "ticket")
    :ets.insert(:roll, {"ticket", n+1})
  end

end
