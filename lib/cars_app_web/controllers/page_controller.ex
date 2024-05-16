defmodule CarsAppWeb.PageController do
  use CarsAppWeb, :controller

  def home(conn, _params) do
    send_resp(conn, 200, "Welcome to Cars App")
  end
end
