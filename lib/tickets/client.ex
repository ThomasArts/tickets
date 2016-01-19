defmodule Client do

  defp take do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("http://localhost:4000/take")
    body
  end

  defp reset do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("http://localhost:4000/reset")
    body
  end

  
  def start do
    HTTPoison.start
  end

  def test do
    start
    take
    take
    take
    take
    take
    take
    take
    reset
    take
    take
    spawn fn -> test1 end
    spawn fn -> test1 end
  end

   def test1 do
    take
    take
    take
    take
    take
    take
    take
    reset
    take
    take
  end

  
end
