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

  @doc """
    We'll store all cars in the list when the format is correct, the json needs to have
    the car id and the seats.

    Every car in the list will be stored as follow:
    * C[4 number ID padded with zeroes] as the key
    * String with json format with the seats of car and availability (0 as default)

    When the format is correct we will respond with a 200 OK
    Otherwise we'll response with a 400 Bad Request
  """
  def cars(conn, %{"_json" => json_data}) do
    is_json_format_valid? =
      Enum.reduce(json_data, true, fn car_map, acc ->
        acc and is_format_valid?(car_map)
      end)

    store_cars_and_send_resp(conn, json_data, is_json_format_valid?)
  end

  def cars(conn, _), do: send_resp(conn, 400, "400 Bad Request")

  def journey(conn, %{"_json" => _json_data}) do
    # TODO: Store group of people from json_data
    send_resp(conn, 200, "")
  end

  def journey(conn, _), do: send_resp(conn, 400, "400 Bad Request")

  def dropoff(conn, %{"ID" => id}) do
    case Redix.command(:redix, ["GET", id]) do
      {:error, _} -> send_resp(conn, 500, "500 Redis connection closed")
      {:ok, nil} -> send_resp(conn, 404, "404 Not Found")
      {:ok, _group_id} ->
        # TODO: Send the correct response
        # 200 OK or 204 No Content When the group is unregistered correctly
        send_resp(conn, 200, "200 OK")
    end
  end

  def dropoff(conn, _), do: send_resp(conn, 400, "400 Bad Request")

  def locate(conn, %{"ID" => id}) do
    case Redix.command(:redix, ["GET", id]) do
      {:error, _} -> send_resp(conn, 500, "500 Redis connection closed")
      {:ok, nil} -> send_resp(conn, 404, "404 Not Found")
      {:ok, _group_id} ->
        # TODO: Send the correct response
        # * 200 OK With the car as the payload when the group is assigned to a car.
        # * 204 No Content When the group is waiting to be assigned to a car.
        send_resp(conn, 200, "200 OK")
    end
  end

  def locate(conn, _), do: send_resp(conn, 400, "400 Bad Request")

  defp send_response_by_redis_status(conn, {:error, %Redix.ConnectionError{reason: :closed}}) do
    send_resp(conn, 500, "500 Redis connection closed")
  end

  defp send_response_by_redis_status(conn, {:error, _}) do
    send_resp(conn, 520, "520 Unknown error")
  end

  defp send_response_by_redis_status(conn, {:ok, _}) do
    send_resp(conn, 200, "200 OK")
  end

  defp store_cars_and_send_resp(conn, cars_map, true = _is_format_valid?) do
    # TODO: We should check redis connection and send correct response if it is closed
    Enum.each(cars_map, fn car_map ->
      str_id = Integer.to_string(Map.get(car_map, "id")) |> String.pad_leading(4, "0")
      car_values= "{\"seats\":#{Map.get(car_map, "seats")}, \"availability\":0}"
      Redix.command(:redix, ["SET", "C#{str_id}", car_values])
    end)

    send_resp(conn, 200, "200 OK")
  end

  defp store_cars_and_send_resp(conn, _, false = _is_format_valid?), do: cars(conn, %{})

  defp is_format_valid?(%{"id" => _id, "seats" => _seats}), do: true
  defp is_format_valid?(_), do: false
end
