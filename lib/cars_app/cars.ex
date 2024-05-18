defmodule CarsApp.Cars do
  import Ecto.Changeset

  @doc """
  We receive the parameters of the car and we'll return if the format is valid creating
  a changeset to validate all the parameters
  """
  def is_car_format_valid?(car_params) do
    types = %{id: :integer, seats: :integer}

    changeset_car =
      {%{}, types}
      |> cast(car_params, Map.keys(types))
      |> validate_required([:id, :seats])
      |> validate_number(:id, greater_than: 0)
      |> validate_number(:seats, greater_than: 0, less_than: 6)

    changeset_car.valid?
  end

  @doc """
    We receive a list of maps with the id and seats of the car.

    Every car in the list will be stored as follow:
    * C[4 number ID padded with zeroes] as the key
    * String with json format with the seats of car and availability (0 as default)

    If everything is stored correctly we'll return {:ok, nil}
    Otherwise we'll respond {:error, error_msg}
  """
  def store_cars(cars_map) do
    # TODO: We should check redis connection and inform if anything went wrong
    Enum.each(cars_map, fn car_map ->
      str_id = Integer.to_string(car_map["id"]) |> String.pad_leading(4, "0")
      car_values = "{\"seats\":#{car_map["seats"]}, \"availability\":0}"
      Redix.command(:redix, ["SET", "C#{str_id}", car_values])
    end)

    {:ok, nil}
  end
end
