defmodule Game2048.TileTest do
  use ExUnit.Case, async: true

  alias Game2048.{Tile}

  describe "new/1" do
    test "returns Tile with unique id" do
      tile1 = Tile.new(2)
      tile2 = Tile.new(2)

      assert tile1.id != tile2.id
    end

    test "returns Tile with type :number when given value" do
      int_value = 8
      tile = Tile.new(int_value)

      assert tile.type == :number
      assert tile.value == int_value
    end

    test "returns Tile with value 0 when given type :empty" do
      tile = Tile.new(:empty)

      assert tile.type == :empty
      assert tile.value == 0
    end

    test "returns error when given invalid value" do
      assert {:error, :invalid_value_or_type} = Tile.new("inv_value")
    end

    test "returns error when given invalid type" do
      assert {:error, :invalid_value_or_type} = Tile.new(:no_type)
    end
  end
end
