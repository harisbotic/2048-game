defmodule Game2048.Grid do
  @moduledoc """
  Represents the Grid section of a Game2048.Board

  A Grid is a custom sized matrix of Game2048.Tile structs.
  Contains utility functions for moving and merging tiles in the grid.
  """

  alias __MODULE__
  alias Game2048.{GridSize, Coordinate, Tile}

  @vectors %{
    up: %{x: 0, y: -1},
    down: %{x: 0, y: 1},
    left: %{x: -1, y: 0},
    right: %{x: 1, y: 0}
  }

  @enforce_keys [:cells, :size]

  defstruct [:cells, :size]

  @type direction :: :up | :down | :left | :right
  @type cell_key :: Coordinate.t()
  @type cell_value :: Tile.t()
  @type t :: %Grid{cells: %{cell_key => cell_value}, size: GridSize.t()}

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

  @spec contains_tile_with_value?(Game2048.Grid.t(), integer()) :: boolean
  def contains_tile_with_value?(%Grid{cells: cells}, value) do
    cells
    |> Enum.any?(fn {_, tile} -> tile.value == value end)
  end

  @spec get_neighbor_cells(
          Game2048.Grid.t(),
          Game2048.Coordinate.t(),
          direction()
        ) :: %{
          farthest_empty_coordinate: Game2048.Coordinate.t(),
          next_nonempty_coordinate: Game2048.Coordinate.t(),
          next_nonempty_tile: nil | Game2048.Tile.t()
        }
  def get_neighbor_cells(%Grid{} = grid, %Coordinate{} = coordinate, direction) do
    %{tile: next_tile, coordinate: next_coordinate} = next_cell(grid, coordinate, direction)

    case next_tile do
      %{type: :empty} ->
        get_neighbor_cells(grid, next_coordinate, direction)

      _ ->
        %{
          farthest_empty_coordinate: coordinate,
          next_nonempty_tile: next_tile,
          next_nonempty_coordinate: next_coordinate
        }
    end
  end

  @spec next_cell(Game2048.Grid.t(), Game2048.Coordinate.t(), direction) :: %{
          coordinate: Game2048.Coordinate.t(),
          tile: Game2048.Tile.t() | nil
        }
  def next_cell(%Grid{cells: cells}, %Coordinate{} = coordinate, direction) do
    next_coordinate =
      Coordinate.new(coordinate.x + @vectors[direction].x, coordinate.y + @vectors[direction].y)

    next_tile = cells[next_coordinate]
    %{coordinate: next_coordinate, tile: next_tile}
  end

  @spec get_empty_coordinates(Game2048.Grid.t()) :: [Coordinate.t()]
  def get_empty_coordinates(%Grid{cells: cells}) do
    cells
    |> Enum.filter(fn {_, tile} -> tile.type === :empty end)
    |> Enum.map(fn {coordinate, _} -> coordinate end)
  end

  @spec merge_tiles(Game2048.Grid.t(), Game2048.Coordinate.t(), Game2048.Coordinate.t()) ::
          Game2048.Grid.t()
  def merge_tiles(%Grid{cells: cells} = grid, %Coordinate{} = from, %Coordinate{} = to) do
    %Grid{
      grid
      | cells:
          cells
          |> Map.put(to, Tile.merge(cells[from], cells[to]))
          |> Map.put(from, Tile.new(:empty))
    }
  end

  @spec move_tile(Game2048.Grid.t(), Game2048.Coordinate.t(), Game2048.Coordinate.t()) ::
          Game2048.Grid.t()
  def move_tile(%Grid{cells: cells} = grid, %Coordinate{} = from, %Coordinate{} = to) do
    if from === to do
      grid
    else
      %Grid{
        grid
        | cells:
            cells
            |> Map.put(to, cells[from])
            |> Map.put(from, Tile.new(:empty))
      }
    end
  end

  @spec place_tile(Game2048.Grid.t(), Game2048.Coordinate.t(), Game2048.Tile.t()) ::
          Game2048.Grid.t()
  def place_tile(%Grid{cells: cells} = grid, %Coordinate{} = coordinate, %Tile{} = tile) do
    %Grid{
      grid
      | cells:
          cells
          |> Map.put(coordinate, tile)
    }
  end

  @spec spawn_tile_at_random_empty_place(Game2048.Grid.t(), Game2048.Tile.t()) ::
          Game2048.Grid.t()
  def spawn_tile_at_random_empty_place(%Grid{} = grid, %Tile{} = tile) do
    case get_empty_coordinates(grid) do
      [] ->
        grid

      empty_coordinates ->
        empty_coordinate = Enum.random(empty_coordinates)
        place_tile(grid, empty_coordinate, tile)
    end
  end

  @spec move_tiles_in_direction(Game2048.Grid.t(), direction()) :: Game2048.Grid.t()
  def move_tiles_in_direction(%Grid{size: size} = grid, direction) do
    %{column_count: c, row_count: r} = size

    columns_order = if direction == :right, do: c..1, else: 1..c
    rows_order = if direction == :down, do: r..1, else: 1..r

    for x <- columns_order, y <- rows_order, reduce: grid do
      grid ->
        coordinate = Coordinate.new(x, y)
        tile = grid.cells[coordinate]

        if tile.type !== :number do
          grid
        else
          %{
            farthest_empty_coordinate: farthest_empty_coordinate,
            next_nonempty_tile: next_nonempty_tile,
            next_nonempty_coordinate: next_nonempty_coordinate
          } = Grid.get_neighbor_cells(grid, coordinate, direction)

          case next_nonempty_tile do
            %{type: :number, value: value} when value == tile.value ->
              Grid.merge_tiles(
                grid,
                coordinate,
                next_nonempty_coordinate
              )

            _ ->
              Grid.move_tile(
                grid,
                coordinate,
                farthest_empty_coordinate
              )
          end
        end
    end
  end

  @spec new(GridSize.t()) :: Game2048.Grid.t()
  def new(%GridSize{column_count: column_count, row_count: row_count} = grid_size) do
    cells =
      for x <- 1..column_count,
          y <- 1..row_count,
          into: %{},
          do: {Coordinate.new(x, y), Tile.new(:empty)}

    %Grid{cells: cells, size: grid_size}
  end
end
