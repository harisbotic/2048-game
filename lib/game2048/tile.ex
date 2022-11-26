defmodule Game2048.Tile do
  @moduledoc """
  Represents a single Tile in a Game2048.Grid

  A Tile can be one of two types:

    * :empty - An empty tile with fixed value of 0
    * :number - A tile with a number

  A Tile can have one of two states:

      * :merged - A tile got merged with another tile
      * not :merged - A tile is just spawned or is of type :empty
  """

  alias __MODULE__

  @enforce_keys [:id, :value, :type, :merged]
  defstruct [:id, :value, :type, :merged]

  @type type :: :empty | :number
  @type t :: %Tile{id: String.t(), value: integer, type: type, merged: boolean}

  @spec new(integer() | :empty) :: Game2048.Tile.t()
  def new(value) when is_integer(value) do
    new(:number, value)
  end

  def new(:empty) do
    new(:empty, 0)
  end

  def new(_) do
    {:error, :invalid_value_or_type}
  end

  defp new(type, value) when is_atom(type) and is_integer(value) do
    %Tile{
      id: random_id(),
      value: value,
      type: type,
      merged: false
    }
  end

  defp random_id() do
    make_ref()
    |> inspect()
    |> String.replace(["Reference", "#", ".", "<", ">"], "")
  end
end
