defmodule Game2048.Coordinate do
  @moduledoc """
  Represents a coordinate on a Game2048.Grid
  """

  alias __MODULE__

  @enforce_keys [:x, :y]
  defstruct [:x, :y]

  @type t :: %Coordinate{x: integer, y: integer}

  @spec new(integer(), integer()) :: Game2048.Coordinate.t()
  def new(x, y) when is_integer(x) and is_integer(y) do
    %Coordinate{x: x, y: y}
  end

  def new(_x, _y) do
    {:error, :invalid_coordinate}
  end
end
