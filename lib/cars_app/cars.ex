defmodule CarsApp.Cars do
  alias CarsApp.Cars.Car

  @doc """
  We receive a list of the parameters of the car and we'll check if all those car parameters are valid.
  """
  def is_list_cars_format_valid?(list_cars_params) when is_list(list_cars_params) do
    is_format_valid? =
      Enum.reduce(list_cars_params, true, fn car_map, acc ->
        acc and is_car_format_valid?(car_map)
      end)

    if is_format_valid?, do: {:ok, :valid}, else: {:error, :bad_request}
  end

  def is_list_cars_format_valid(_), do: {:error, :bad_request}

  @doc """
  We receive the parameters of the car and we'll return if the format is valid creating
  a changeset to validate all the parameters
  """
  def is_car_format_valid?(car_params) do
    Car.changeset(car_params)
    |> Map.get(:valid?)
  end

  @doc """
    We receive a list of maps with the id and seats of the car.

    Every car in the list will be stored as follow:
    * We'll store them in a hash with the seats quantity
    * We'll keep a list of available cars

    If everything is stored correctly we'll return {:ok, nil}
    Otherwise we'll respond {:error, error_msg}
  """
  def store_cars(cars_map) do
    Enum.each(cars_map, fn %{"id" => id, "seats" => seats} ->
      new_car_id = "C:#{Integer.to_string(id) |> String.pad_leading(4, "0")}"
      Redix.command!(:redix, ["LPUSH", "available_cars", new_car_id])
      Redix.command!(:redix, ["HSET", new_car_id, "seats", seats])
    end)

    {:ok, nil}
  end
end
