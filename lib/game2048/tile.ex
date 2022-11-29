defmodule Game2048.Tile do
  @moduledoc """
  Represents a single Tile in a Game2048.Grid

  A Tile can be one of two types:

    * :empty - An empty tile with fixed value of 0
    * :number - A tile with a number
    * :obstacle - A tile that cannot be moved or combined with a value of -1

  A Tile can have one of two states:

      * :merged - A tile got merged with another tile
      * not :merged - A tile is just spawned or is of type :empty
  """

  alias __MODULE__

  @enforce_keys [:value, :type, :merged]
  defstruct [:value, :type, :merged]

  @type type :: :empty | :number | :obstacle
  @type t :: %Tile{value: integer, type: type, merged: boolean}

  @spec merge(Game2048.Tile.t(), Game2048.Tile.t()) ::
          Game2048.Tile.t() | {:error, :invalid_tile_type}
  def merge(%Tile{} = tile1, %Tile{} = tile2) do
    if tile1.type != :number or tile2.type != :number do
      {:error, :invalid_tile_type}
    else
      new(:number, tile1.value + tile2.value, true)
    end
  end

  @spec new(integer() | :empty | :obstacle) :: Game2048.Tile.t()
  def new(value) when is_integer(value) do
    new(:number, value)
  end

  def new(:empty) do
    new(:empty, 0)
  end

  def new(:obstacle) do
    new(:obstacle, -1)
  end

  def new(_) do
    {:error, :invalid_value_or_type}
  end

  defp new(type, value, merged \\ false) when is_atom(type) and is_integer(value) do
    %Tile{
      value: value,
      type: type,
      merged: merged
    }
  end
end
