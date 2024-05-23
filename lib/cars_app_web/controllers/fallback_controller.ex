defmodule CarsAppWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CarsAppWeb, :controller

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: CarsAppWeb.ErrorHTML, json: CarsAppWeb.ErrorJSON)
    |> render(:"404")
  end

  # This clause is an example of how to handle internal server errors.
  def call(conn, {:error, :connection_closed}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(html: CarsAppWeb.ErrorHTML, json: CarsAppWeb.ErrorJSON)
    |> render(:"500")
  end

  # This clause is an example of how to handle bad requests.
  def call(conn, {:error, :bad_request}) do
    conn
    |> put_status(:bad_request)
    |> put_view(html: CarsAppWeb.ErrorHTML, json: CarsAppWeb.ErrorJSON)
    |> render(:"400")
  end

  # This clause is an example of how to handle unknown errors.
  def call(conn, {:error, :unknown_error}) do
    conn
    |> put_status(:not_implemented)
    |> put_view(html: CarsAppWeb.ErrorHTML, json: CarsAppWeb.ErrorJSON)
    |> render(:"501")
  end
end
