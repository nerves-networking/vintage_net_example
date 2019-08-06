defmodule VintageNetExampleTest do
  use ExUnit.Case
  doctest VintageNetExample

  test "greets the world" do
    assert VintageNetExample.hello() == :world
  end
end
