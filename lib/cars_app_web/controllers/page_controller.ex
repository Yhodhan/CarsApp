defmodule CarsAppWeb.PageController do
  use CarsAppWeb, :controller

  def home(conn, _params) do
    send_resp(conn, 200, "Welcome to Cars App")
  end

  def status(conn, _params) do
    # I'll get the status of the redis connection by using a GET command
    redis_state = Redix.command(:redix, ["GET", "val"])
    send_response_by_redis_status(conn, redis_state)
  end

  def cars(conn, _params) do
    send_resp(conn, 200, "")
  end

  def journey(conn, _params) do
    send_resp(conn, 200, "")
  end

  def dropoff(conn, _params) do
    send_resp(conn, 200, "")
  end

  def locate(conn, _params) do
    send_resp(conn, 200, "")
  end

  defp send_response_by_redis_status(conn, {:error, %Redix.ConnectionError{reason: :closed}}) do
    send_resp(conn, 500, "Redis connection closed")
  end

  defp send_response_by_redis_status(conn, {:error, _}) do
    send_resp(conn, 520, "Unknown error")
  end

  defp send_response_by_redis_status(conn, {:ok, _}) do
    send_resp(conn, 200, "OK")
  end
end
