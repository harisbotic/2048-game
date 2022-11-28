defmodule Game2048.GridTest do
  use ExUnit.Case, async: true

  alias Game2048.{Grid, GridSize, Tile, Coordinate}

  describe "contains_combinable_cells?/1" do
    test "returns true when grid contains combinable cells vertically" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 2, y: 1} => Tile.new(2)
        },
        size: %GridSize{column_count: 2, row_count: 1}
      }

      assert Grid.contains_combinable_cells?(grid)
    end

    test "returns true when grid contains combinable cells horizontally" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 1, y: 2} => Tile.new(2)
        },
        size: %GridSize{column_count: 1, row_count: 2}
      }

      assert Grid.contains_combinable_cells?(grid)
    end

    test "returns false when grid does not contain combinable cells" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 2, y: 1} => Tile.new(4),
          %Coordinate{x: 1, y: 2} => Tile.new(4),
          %Coordinate{x: 2, y: 2} => Tile.new(2)
        },
        size: %GridSize{column_count: 2, row_count: 2}
      }

      refute Grid.contains_combinable_cells?(grid)
    end

    test "returns false when grid is empty" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(:empty),
          %Coordinate{x: 2, y: 1} => Tile.new(:empty)
        },
        size: %GridSize{column_count: 2, row_count: 1}
      }

      refute Grid.contains_combinable_cells?(grid)
    end
  end

  describe "contains_empty_cells?/1" do
    test "returns true when grid contains empty cells" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 2, y: 1} => Tile.new(:empty)
        },
        size: %GridSize{column_count: 2, row_count: 1}
      }

      assert Grid.contains_empty_cells?(grid)
    end

    test "returns false when grid does not contain empty cells" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 2, y: 1} => Tile.new(2)
        },
        size: %GridSize{column_count: 2, row_count: 1}
      }

      refute Grid.contains_empty_cells?(grid)
    end
  end

  describe "empty_cells/1" do
    test "returns empty cells" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(:empty),
          %Coordinate{x: 2, y: 1} => Tile.new(2),
          %Coordinate{x: 1, y: 2} => Tile.new(2),
          %Coordinate{x: 2, y: 2} => Tile.new(:empty)
        },
        size: %GridSize{column_count: 2, row_count: 2}
      }

      assert Grid.get_empty_coordinates(grid) == [
               %Coordinate{x: 1, y: 1},
               %Coordinate{x: 2, y: 2}
             ]
    end

    test "returns no empty cells when grid is full" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 2, y: 1} => Tile.new(4),
          %Coordinate{x: 1, y: 2} => Tile.new(8),
          %Coordinate{x: 2, y: 2} => Tile.new(16)
        },
        size: %GridSize{column_count: 2, row_count: 2}
      }

      assert Grid.get_empty_coordinates(grid) == []
    end

    test "returns empty cells when grid contains only empty cells" do
      coordinate1 = %Coordinate{x: 1, y: 1}
      coordinate2 = %Coordinate{x: 2, y: 1}

      result_cooridnates =
        Grid.get_empty_coordinates(%Grid{
          cells: %{
            coordinate1 => Tile.new(:empty),
            coordinate2 => Tile.new(:empty)
          },
          size: nil
        })

      assert length(result_cooridnates) == 2
      assert coordinate1 in result_cooridnates
      assert coordinate2 in result_cooridnates
    end
  end

  describe "merge_tiles/1" do
    test "merges value of two tiles with correct positioning" do
      from_coordinate = %Coordinate{x: 1, y: 1}
      to_coordinate = %Coordinate{x: 2, y: 1}

      grid = %Grid{
        cells: %{
          from_coordinate => Tile.new(2),
          to_coordinate => Tile.new(2)
        },
        size: %GridSize{column_count: 2, row_count: 1}
      }

      result_grid = Grid.merge_tiles(grid, from_coordinate, to_coordinate)

      assert result_grid.cells == %{
               to_coordinate => %Tile{value: 4, type: :number, merged: true},
               from_coordinate => Tile.new(:empty)
             }
    end
  end

  describe "move_tile/3" do
    test "moves tile to empty cell" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 2, y: 1} => Tile.new(:empty)
        },
        size: %GridSize{column_count: 2, row_count: 1}
      }

      result_grid = Grid.move_tile(grid, %Coordinate{x: 1, y: 1}, %Coordinate{x: 2, y: 1})

      assert result_grid.cells == %{
               %Coordinate{x: 1, y: 1} => Tile.new(:empty),
               %Coordinate{x: 2, y: 1} => Tile.new(2)
             }
    end
  end

  describe "spawn_tile/3" do
    test "spawns tile in empty cell with correct value" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(:empty),
          %Coordinate{x: 2, y: 1} => Tile.new(:empty)
        },
        size: %GridSize{column_count: 2, row_count: 1}
      }

      result_grid = Grid.spawn_tile(grid, %Coordinate{x: 1, y: 1}, Tile.new(2))

      assert result_grid.cells == %{
               %Coordinate{x: 1, y: 1} => Tile.new(2),
               %Coordinate{x: 2, y: 1} => Tile.new(:empty)
             }
    end
  end

  describe "spawn_tile_at_random_empty_place/1" do
    test "returns a board with a random tile added" do
      grid = Grid.new(GridSize.new(2, 2))
      new_grid = Grid.spawn_tile_at_random_empty_place(grid, 5)

      assert new_grid.cells
             |> Enum.filter(fn {_, tile} -> tile.type == :number end)
             |> Enum.count() == 1

      assert new_grid.cells |> Enum.filter(fn {_, tile} -> tile.value == 5 end) |> Enum.count() ==
               1
    end
  end
end
