defmodule CarsApp.Groups do
  alias CarsApp.Groups.Group

  @doc """
  We receive a list of the parameters of the group and we'll check if all those group parameters are valid.
  """
  def is_list_group_format_valid?(list_group_params) when is_list(list_group_params) do
    is_format_valid? =
      Enum.reduce(list_group_params, true, fn group_map, acc ->
        acc and is_group_format_valid?(group_map)
      end)

    if is_format_valid?, do: {:ok, :valid}, else: {:error, :bad_request}
  end

  def is_list_group_format_valid(_), do: {:error, :bad_request}

  @doc """
  We receive the parameters of the group and we'll return if the format is valid creating
  a changeset to validate all the parameters
  """
  def is_group_format_valid?(group_params) do
    Group.changeset(group_params)
    |> Map.get(:valid?)
  end

  @doc """
    We receive a group with the id and quantity of people.

    * We'll store the group in a hash with the people quantity
    * We'll keep a list of available people

    If everything is stored correctly we'll return {:ok, nil}
    Otherwise we'll respond {:error, error_msg}
  """
  def store_group(%{"id" => id, "people" => people}) do
    new_group_id = "G:#{Integer.to_string(id) |> String.pad_leading(4, "0")}"
    Redix.command!(:redix, ["LPUSH", "available_people", new_group_id])
    Redix.command!(:redix, ["HSET", new_group_id, "people", people])

    {:ok, nil}
  end
end
