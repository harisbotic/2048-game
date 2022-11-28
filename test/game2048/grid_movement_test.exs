defmodule Game2048.GridMovementTest do
  use ExUnit.Case, async: true

  alias Game2048.{Grid, GridSize, Tile, Coordinate}

  describe "move_tiles_in_direction/2" do
    test "returns a new board with the tiles moved in :right direction, small board" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 2, y: 1} => Tile.new(2)
        },
        size: %GridSize{column_count: 2, row_count: 1}
      }

      new_grid = Grid.move_tiles_in_direction(grid, :right)

      expected_cells = %{
        %Coordinate{x: 1, y: 1} => Tile.new(:empty),
        %Coordinate{x: 2, y: 1} => %Tile{type: :number, value: 4, merged: true}
      }

      assert new_grid.cells === expected_cells
    end

    test "returns a new board with the tiles moved in :left direction" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 2, y: 1} => Tile.new(2),
          %Coordinate{x: 1, y: 2} => Tile.new(2),
          %Coordinate{x: 2, y: 2} => Tile.new(2)
        },
        size: %GridSize{column_count: 2, row_count: 2}
      }

      new_grid = Grid.move_tiles_in_direction(grid, :left)

      expected_cells = %{
        %Coordinate{x: 1, y: 1} => %Tile{type: :number, value: 4, merged: true},
        %Coordinate{x: 2, y: 1} => Tile.new(:empty),
        %Coordinate{x: 1, y: 2} => %Tile{type: :number, value: 4, merged: true},
        %Coordinate{x: 2, y: 2} => Tile.new(:empty)
      }

      assert new_grid.cells === expected_cells
    end

    test "returns a new board with the tiles moved in :right direction" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 2, y: 1} => Tile.new(2),
          %Coordinate{x: 1, y: 2} => Tile.new(2),
          %Coordinate{x: 2, y: 2} => Tile.new(2)
        },
        size: %GridSize{column_count: 2, row_count: 2}
      }

      new_grid = Grid.move_tiles_in_direction(grid, :right)

      expected_cells = %{
        %Coordinate{x: 1, y: 1} => Tile.new(:empty),
        %Coordinate{x: 2, y: 1} => %Tile{type: :number, value: 4, merged: true},
        %Coordinate{x: 1, y: 2} => Tile.new(:empty),
        %Coordinate{x: 2, y: 2} => %Tile{type: :number, value: 4, merged: true}
      }

      assert new_grid.cells === expected_cells
    end

    test "returns a new board with the tiles moved in :up direction" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 2, y: 1} => Tile.new(2),
          %Coordinate{x: 1, y: 2} => Tile.new(2),
          %Coordinate{x: 2, y: 2} => Tile.new(2)
        },
        size: %GridSize{column_count: 2, row_count: 2}
      }

      new_grid = Grid.move_tiles_in_direction(grid, :up)

      expected_cells = %{
        %Coordinate{x: 1, y: 1} => %Tile{type: :number, value: 4, merged: true},
        %Coordinate{x: 2, y: 1} => %Tile{type: :number, value: 4, merged: true},
        %Coordinate{x: 1, y: 2} => Tile.new(:empty),
        %Coordinate{x: 2, y: 2} => Tile.new(:empty)
      }

      assert new_grid.cells === expected_cells
    end

    test "returns a new board with the tiles moved in :down direction" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 2, y: 1} => Tile.new(2),
          %Coordinate{x: 1, y: 2} => Tile.new(2),
          %Coordinate{x: 2, y: 2} => Tile.new(2)
        },
        size: %GridSize{column_count: 2, row_count: 2}
      }

      new_grid = Grid.move_tiles_in_direction(grid, :down)

      expected_cells = %{
        %Coordinate{x: 1, y: 1} => Tile.new(:empty),
        %Coordinate{x: 2, y: 1} => Tile.new(:empty),
        %Coordinate{x: 1, y: 2} => %Tile{type: :number, value: 4, merged: true},
        %Coordinate{x: 2, y: 2} => %Tile{type: :number, value: 4, merged: true}
      }

      assert new_grid.cells === expected_cells
    end

    test "returns a new board with the tiles moved in :right direction when there are empty cells" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 2, y: 1} => Tile.new(:empty),
          %Coordinate{x: 3, y: 1} => Tile.new(:empty)
        },
        size: %GridSize{column_count: 3, row_count: 1}
      }

      new_grid = Grid.move_tiles_in_direction(grid, :right)

      expected_cells = %{
        %Coordinate{x: 1, y: 1} => Tile.new(:empty),
        %Coordinate{x: 2, y: 1} => Tile.new(:empty),
        %Coordinate{x: 3, y: 1} => %Tile{type: :number, value: 2, merged: false}
      }

      assert new_grid.cells === expected_cells
    end

    test "returns a new board with the tiles blocked by obstacle Tile" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 1, y: 2} => Tile.new(:empty),
          %Coordinate{x: 1, y: 3} => Tile.new(:obstacle),
          %Coordinate{x: 1, y: 4} => Tile.new(:empty)
        },
        size: %GridSize{column_count: 1, row_count: 4}
      }

      new_grid = Grid.move_tiles_in_direction(grid, :down)

      expected_cells = %{
        %Coordinate{x: 1, y: 1} => Tile.new(:empty),
        %Coordinate{x: 1, y: 2} => %Tile{type: :number, value: 2, merged: false},
        %Coordinate{x: 1, y: 3} => Tile.new(:obstacle),
        %Coordinate{x: 1, y: 4} => Tile.new(:empty)
      }

      assert new_grid.cells === expected_cells
    end
  end
end
