defmodule Tax.View do
  
  require Decimal
  alias Decimal, as: D

  def render(taxable, verbose?) do
    view = [
      {"Annual Gross",      taxable.amount},
      {"Annual Take Home",  taxable.take_home}
    ]

    if verbose? do
      view ++ render_verbose(taxable)
    else
      view
    end
  end

  defp render_verbose(taxable) do
    monthly_gross = taxable.amount |> D.from_float() |> D.div(12) |> D.to_float |> Float.round(3)
    monthly_take_home = taxable.take_home |> D.from_float() |> D.div(12) |> D.to_float |> Float.round(3)

    [
      {"Monthly Gross",     monthly_gross},
      {"Monthly Take Home", monthly_take_home}
    ]
  end
end