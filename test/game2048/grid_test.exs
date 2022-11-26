defmodule Game2048.GridTest do
  use ExUnit.Case, async: true

  alias Game2048.{Grid, Tile, Coordinate}

  describe "contains_combinable_cells?/1" do
    test "returns true when grid contains combinable cells vertically" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 2, y: 1} => Tile.new(2)
        }
      }

      assert Grid.contains_combinable_cells?(grid)
    end

    test "returns true when grid contains combinable cells horizontally" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 1, y: 2} => Tile.new(2)
        }
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
        }
      }

      refute Grid.contains_combinable_cells?(grid)
    end

    test "returns false when grid is empty" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(:empty),
          %Coordinate{x: 2, y: 1} => Tile.new(:empty)
        }
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
        }
      }

      assert Grid.contains_empty_cells?(grid)
    end

    test "returns false when grid does not contain empty cells" do
      grid = %Grid{
        cells: %{
          %Coordinate{x: 1, y: 1} => Tile.new(2),
          %Coordinate{x: 2, y: 1} => Tile.new(2)
        }
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
        }
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
        }
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
          }
        })

      assert length(result_cooridnates) == 2
      assert coordinate1 in result_cooridnates
      assert coordinate2 in result_cooridnates
    end
  end
end
