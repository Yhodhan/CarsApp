defmodule CarsApp.Groups.Group do
  import Ecto.Changeset
  @types %{id: :integer, people: :integer}

  def changeset(params) do
    {%{}, @types}
    |> cast(params, Map.keys(@types))
    |> validate_required([:id, :people])
    |> validate_number(:id, greater_than: 0)
    |> validate_number(:people, greater_than: 0, less_than: 8)
  end
end
