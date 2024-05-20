defmodule CarsApp.Cars.Car do
  import Ecto.Changeset
  @types %{id: :integer, seats: :integer}

  def changeset(params) do
    {%{}, @types}
    |> cast(params, Map.keys(@types))
    |> validate_required([:id, :seats])
    |> validate_number(:id, greater_than: 0)
    |> validate_number(:seats, greater_than: 0, less_than: 8)
  end
end
