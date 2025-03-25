defmodule Tax.Taxable do

  defstruct [:amount, :take_home]
  
  require Decimal
  alias Decimal, as: D

  def apply_rate(taxable, rate), do: %{ taxable | amount: D.mult(taxable.amount, rate) }

  def add(taxable, n), do: %{ taxable | amount: D.add(taxable.amount, n) }

  def sub(taxable, n), do: %{ taxable | amount: D.sub(taxable.amount, n) }
end