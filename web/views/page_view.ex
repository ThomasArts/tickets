defmodule Tickets.PageView do
  use Tickets.Web, :view

  def ticket do
    [{"ticket", n}] = :ets.lookup(:roll, "ticket")
    n
  end
end
