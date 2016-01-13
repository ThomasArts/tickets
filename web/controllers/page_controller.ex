defmodule Tickets.PageController do
  use Tickets.Web, :controller
  
  def index(conn, _params) do
    [{"ticket", n}] = :ets.lookup(:roll, "ticket")
    render conn, "index.html", ticket: n
  end

end
