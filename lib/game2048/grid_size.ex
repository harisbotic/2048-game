defmodule Game2048.GridSize do
  @moduledoc """
  Holds a column and row count for a Game2048.Grid
  """

  alias __MODULE__

  @enforce_keys [:column_count, :row_count]
  defstruct [:column_count, :row_count]

  @type t :: %GridSize{column_count: integer, row_count: integer}

  @spec new(integer(), integer()) :: Game2048.GridSize.t()
  def new(column_count, row_count) when is_integer(column_count) and is_integer(row_count) do
    %GridSize{column_count: column_count, row_count: row_count}
  end

  def new(_column_count, _row_count) do
    {:error, :invalid_size}
  end
end
