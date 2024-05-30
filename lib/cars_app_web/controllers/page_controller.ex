defmodule CarsAppWeb.PageController do
  alias CarsApp.Groups
  alias CarsApp.Cars
  use CarsAppWeb, :controller

  action_fallback CarsAppWeb.FallbackController

  def status(conn, _params) do
    # I'll get the status of the redis connection by using a GET command
    case Redix.command(:redix, ["GET", "val"]) do
      {:error, %Redix.ConnectionError{reason: :closed}} ->
        {:error, :connection_closed}

      {:error, _} ->
        {:error, :unknown_error}

      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{status: "200 OK"})
    end
  end

  @doc """
    We'll receive a json with a list of cars and we are going to store them.

    When the format is correct we will respond with a 200 OK
    Otherwise we'll response with a 400 Bad Request
  """
  def cars(conn, %{"_json" => json_data}) do
    is_json_format_valid? = Cars.is_list_cars_format_valid(json_data)

    with {:ok, :valid} <- is_json_format_valid? do
      {:ok, _} = Cars.store_cars(json_data)

      conn
      |> put_status(:ok)
      |> json(%{status: "200 OK"})
    end
  end

  def cars(_, _), do: {:error, :bad_request}

  def journey(conn, %{"_json" => json_data}) do
    is_json_format_valid? = Groups.is_list_group_format_valid?(json_data)

    with {:ok, :valid} <- is_json_format_valid? do
      {:ok, _} = Groups.store_group(json_data)

      conn
      |> put_status(:ok)
      |> json(%{status: "200 OK"})
    end
  end

  def journey(_, _), do: {:error, :bad_request}

  def dropoff(conn, %{"ID" => _id}) do
    # TODO
    conn
    |> put_status(:ok)
    |> json(%{status: "200 OK"})
  end

  def dropoff(_, _), do: {:error, :bad_request}

  def locate(conn, %{"ID" => _id}) do
    # TODO
    conn
    |> put_status(:ok)
    |> json(%{status: "200 OK"})
  end

  def locate(_, _), do: {:error, :bad_request}
end
