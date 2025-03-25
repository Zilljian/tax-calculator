defmodule Tax do
  
  require Decimal
  alias Decimal, as: D
  alias Tax.View, as: V
  alias Tax.Rates, as: R
  alias Tax.Taxable, as: T

  def esp_take_home(amount, beckham_law? \\ false, verbose? \\ false) do
    %T{amount: amount} 
    |> calculate_take_home(R.spain(beckham_law?)) 
    |> V.render(verbose?)
  end

  def prt_take_home(amount, verbose? \\ false) do
    %T{amount: amount} 
    |> calculate_take_home(R.portugal())
    |> V.render(verbose?)
  end 

  def uk_take_home(amount, verbose? \\ false) do
    %T{amount: amount} 
    |> calculate_take_home(R.uk())
    |> V.render(verbose?)
  end 

  def ru_take_home(amount, verbose? \\ false) do
    %T{amount: amount} 
    |> calculate_take_home(R.russia())
    |> V.render(verbose?)
  end 

  defp calculate_take_home(taxable, rates), do: taxable |> next_tax(rates)

  defp next_tax(0, _), do: 0

  # Suppose if the tail is empty it's the last rate in taxation. It's rate applies to the rest.
  defp next_tax(taxable, [{_, rate} | []]), do: taxable |> T.apply_rate(rate)

  defp next_tax(taxable, [{rate_ceiling, rate} | others]) do
    if D.compare(taxable.amount, rate_ceiling) != :gt do
      T.apply_rate(taxable, rate)
    end

    this_tax = D.mult(rate_ceiling, rate) 

    taxable 
    |> T.sub(rate_ceiling)
    |> next_tax(others)
    |> T.add(this_tax)
  end
end