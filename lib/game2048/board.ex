defmodule Game2048.Board do
  @moduledoc """
    Contains logic for the 2048 game board.
    Holds the state of the game and provides functions for manipulating it.
  """

  alias __MODULE__
  alias Game2048.{Grid, GridSize}

  @tile_spawn_value_after_move 1

  @enforce_keys [:grid, :state]
  defstruct [:grid, :state]

  @type state :: :playing | :won | :lost
  @type t :: %Board{grid: Grid.t(), state: state}

  @spec moves_available?(Game2048.Grid.t()) :: boolean
  def moves_available?(grid) do
    Grid.contains_empty_cells?(grid) or Grid.contains_combinable_cells?(grid)
  end

  def new(%GridSize{} = grid_size) do
    %Board{
      grid: Grid.new(grid_size),
      state: :playing
    }
  end

  def new(%Grid{} = grid) do
    %Board{
      grid: grid,
      state: game_state(grid)
    }
  end

  @spec move(Game2048.Board.t(), Game2048.Grid.direction()) :: Game2048.Board.t()
  def move(%Board{grid: grid} = board, direction) do
    new_grid =
      case Grid.move_tiles_in_direction(grid, direction) do
        ^grid ->
          grid

        updated_grid ->
          Grid.spawn_tile_at_random_empty_place(updated_grid, @tile_spawn_value_after_move)
      end

    new_state = game_state(new_grid)

    %Board{board | grid: new_grid, state: new_state}
  end

  defp game_state(grid) do
    cond do
      Grid.contains_tile_with_value?(grid, 2048) -> :won
      moves_available?(grid) -> :playing
      true -> :lost
    end
  end
end
