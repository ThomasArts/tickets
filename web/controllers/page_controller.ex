defmodule Tickets.PageController do
  use Tickets.Web, :controller
  
  def index(conn, _params) do
    render conn, "index.html"
  end

  def reset(conn, _params) do
    Tickets.write(1)
    text conn, "reset"
  end

  def take(conn, params) do
    n = Tickets.read
    Tickets.write(n+1)
    json conn, n
  end

end
