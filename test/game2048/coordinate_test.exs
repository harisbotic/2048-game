defmodule Game2048.CoordinateTest do
  use ExUnit.Case, async: true

  alias Game2048.{Coordinate}

  describe "new/2" do
    test "returns Coordinate when given valid x and y" do
      assert %Coordinate{x: 1, y: 1} = Coordinate.new(1, 1)
    end

    test "returns error when given invalid x and y" do
      assert {:error, :invalid_coordinate} = Coordinate.new("inv_x", "inv_y")
    end
  end
end
