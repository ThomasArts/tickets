defmodule Tickets.PageView do
  use Tickets.Web, :view

  def ticket do
    File.read!("priv/static/ticket.txt")
  end
end
