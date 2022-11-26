defmodule Game2048.Grid do
  @moduledoc """
  Represents the Grid section of a Game2048.Board

  A Grid is a custom sized matrix of Game2048.Tile structs.
  Contains utility functions for moving and merging tiles in the grid.
  """

  alias __MODULE__
  alias Game2048.{Coordinate, Tile}

  @vectors %{
    up: %{x: 0, y: -1},
    down: %{x: 0, y: 1},
    left: %{x: -1, y: 0},
    right: %{x: 1, y: 0}
  }

  @enforce_keys [:cells]

  defstruct [:cells]

  @type cell_key :: Coordinate.t()
  @type cell_value :: Tile.t()
  @type t :: %Grid{cells: %{cell_key => cell_value}}

  @spec contains_combinable_cells?(Game2048.Grid.t()) :: boolean
  def contains_combinable_cells?(%Grid{cells: cells}) do
    Enum.any?(cells, fn
      {%Coordinate{x: x, y: y}, %Tile{value: value}} ->
        Enum.any?(@vectors, fn {_direction, vector} ->
          adjacent_coordinate = Coordinate.new(x + vector.x, y + vector.y)
          adjacent_tile = cells[adjacent_coordinate]

          adjacent_tile &&
            adjacent_tile.type == :number &&
            adjacent_tile.value === value
        end)

      _ ->
        false
    end)
  end

  @spec contains_empty_cells?(Game2048.Grid.t()) :: boolean
  def contains_empty_cells?(%Grid{} = grid) do
    grid
    |> get_empty_coordinates()
    |> Enum.any?()
  end

  def farthest_empty_cell(%Grid{cells: cells} = grid, %Coordinate{} = coordinate, direction) do
    next_coordinate =
      Coordinate.new(coordinate.x + @vectors[direction].x, coordinate.y + @vectors[direction].y)

    next_tile = cells[next_coordinate]
    obstruction? = next_tile.type !== :empty

    case obstruction? do
      false -> farthest_empty_cell(grid, next_tile, direction)
      true -> %{coordinate: coordinate, next: next_tile}
    end
  end

  @spec get_empty_coordinates(Game2048.Grid.t()) :: [Coordinate.t()]
  def get_empty_coordinates(%Grid{cells: cells}) do
    cells
    |> Enum.filter(fn {_, tile} -> tile.type === :empty end)
    |> Enum.map(fn {coordinate, _} -> coordinate end)
  end

  @spec new(integer(), integer()) :: Game2048.Grid.t()
  def new(column_count, row_count) when is_integer(column_count) and is_integer(row_count) do
    cells =
      for x <- 1..column_count,
          y <- 1..row_count,
          into: %{},
          do: {Coordinate.new(x, y), Tile.new(:empty)}

    %Grid{cells: cells}
  end

  def new(_columns_count, _rows_count) do
    {:error, :invalid_dimension}
  end
end
