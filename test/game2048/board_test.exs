defmodule Game2048.BoardTest do
  use ExUnit.Case, async: true

  alias Game2048.{Board, Grid, GridSize, Tile, Coordinate}

  describe "new/1" do
    test "returns a new board with a grid of the given size" do
      board = Board.new(GridSize.new(2, 2))

      expected_cells = %{
        %Coordinate{x: 1, y: 1} => Tile.new(:empty),
        %Coordinate{x: 2, y: 1} => Tile.new(:empty),
        %Coordinate{x: 1, y: 2} => Tile.new(:empty),
        %Coordinate{x: 2, y: 2} => Tile.new(:empty)
      }

      assert board.grid.cells === expected_cells
      assert board.state === :playing
    end

    test "returns a board state when grid is moved and there is nothing else to play. No win" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(4),
          %Coordinate{x: 2, y: 1} => Tile.new(2)
        },
        size: %GridSize{column_count: 2, row_count: 1}
      }

      board = Board.new(grid) |> Board.move(:left)

      assert board.state === :lost
    end

    test "returns a board state when grid is moved and player has a 2048 tile. Win" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(1024),
          %Coordinate{x: 2, y: 1} => Tile.new(1024)
        },
        size: %GridSize{column_count: 2, row_count: 1}
      }

      board = Board.new(grid) |> Board.move(:left)

      assert board.state === :won
    end
  end
end
