defmodule TaxcalculatorTest do
  use ExUnit.Case
  doctest Taxcalculator

  test "greets the world" do
    assert Taxcalculator.hello() == :world
  end
end
