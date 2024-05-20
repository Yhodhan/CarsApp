defmodule CarsApp.Cars do
  import Ecto.Changeset

  @doc """
  We receive the parameters of the car and we'll return if the format is valid creating
  a changeset to validate all the parameters
  """
  def is_car_format_valid?(car_params) do
    types = %{id: :integer, seats: :integer}

    {%{}, types}
    |> cast(car_params, Map.keys(types))
    |> validate_required([:id, :seats])
    |> validate_number(:id, greater_than: 0)
    |> validate_number(:seats, greater_than: 0, less_than: 8)
    |> Map.get(:valid?)
  end

  @doc """
    We receive a list of maps with the id and seats of the car.

    Every car in the list will be stored as follow:
    * C[4 number ID padded with zeroes] as the key
    * String with json format with the seats of car

    If everything is stored correctly we'll return {:ok, nil}
    Otherwise we'll respond {:error, error_msg}
  """
  def store_cars(cars_map) do
    Enum.each(cars_map, fn car_map ->
      new_car_id = Integer.to_string(car_map["id"]) |> String.pad_leading(4, "0")
      car_values = Map.delete(car_map, "id") |> Jason.encode!()
      Redix.command(:redix, ["SET", "C#{new_car_id}", car_values])
    end)

    {:ok, nil}
  end
end
