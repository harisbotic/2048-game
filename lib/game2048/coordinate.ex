defmodule Game2048.Coordinate do
  @moduledoc """
  A Coordinate is a 2D point on a Game2048.Grid

  * x is the column index.
  * y is the row index.

  They are 1-based indexes.
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
