defmodule Tickets.PageController do
  use Tickets.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
