defmodule Tax do
  
  require Decimal
  alias Decimal, as: D

  alias Tax.{View, Rates, Taxable}

  def esp_take_home(amount, beckham_law? \\ false, verbose? \\ false) do
    %Taxable{amount: amount} 
    |> calculate_take_home(Rates.spain(beckham_law?)) 
    |> View.render(verbose?)
  end

  def prt_take_home(amount, verbose? \\ false) do
    %Taxable{amount: amount} 
    |> calculate_take_home(Rates.portugal())
    |> View.render(verbose?)
  end 

  def uk_take_home(amount, verbose? \\ false) do
    %Taxable{amount: amount} 
    |> calculate_take_home(Rates.uk())
    |> View.render(verbose?)
  end 

  def ru_take_home(amount, verbose? \\ false) do
    %Taxable{amount: amount} 
    |> calculate_take_home(Rates.russia())
    |> View.render(verbose?)
  end 

  defp calculate_take_home(taxable, rates), do: taxable |> next_tax(rates)

  defp next_tax(0, _), do: 0

  # Suppose if the tail is empty it's the last rate in taxation. It's rate applies to the resTaxable.
  defp next_tax(taxable, [{_, rate} | []]), do: taxable |> Taxable.apply_rate(rate)

  defp next_tax(taxable, [{rate_ceiling, rate} | others]) do
    if D.compare(taxable.amount, rate_ceiling) != :gt do
      Taxable.apply_rate(taxable, rate)
    end

    this_tax = D.mult(rate_ceiling, rate) 

    taxable 
    |> Taxable.sub(rate_ceiling)
    |> next_tax(others)
    |> Taxable.add(this_tax)
  end
end