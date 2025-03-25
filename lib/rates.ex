defmodule Tax.Rates do
  
  require Decimal
  alias Decimal, as: D

  # In EUR
  @spain_tax_rates  [
    {D.new(12450),  D.from_float(0.19)},
    {D.new(20200),  D.from_float(0.24)},
    {D.new(35200),  D.from_float(0.30)},
    {D.new(60000),  D.from_float(0.37)},
    {D.new(300000), D.from_float(0.45)},
    {D.new(-1),     D.from_float(0.47)}
  ]

  # In EUR
  @spain_beckham_law_tax_rates  [
    {D.new(600000), D.from_float(0.24)},
    {D.new(-1),     D.from_float(0.47)}
  ]

  # In EUR
  @portugal_tax_rates  [
    {D.new(7703),  D.from_float(0.1325)},
    {D.new(11623), D.from_float(0.18)},
    {D.new(16472), D.from_float(0.23)},
    {D.new(21321), D.from_float(0.26)},
    {D.new(27146), D.from_float(0.3275)},
    {D.new(39791), D.from_float(0.37)},
    {D.new(51997), D.from_float(0.435)},
    {D.new(81199), D.from_float(0.45)},
    {D.new(-1),    D.from_float(0.48)}
  ]

  # In GBP
  @uk_tax_rates [
    {D.new(12570),  D.from_float(0.0)},
    {D.new(50270),  D.from_float(0.2)},
    {D.new(125140), D.from_float(0.4)},
    {D.new(-1),     D.from_float(0.45)}
  ]

  # In RUB
  @russia_tax_rates  [
    {D.new(2400000),  D.from_float(0.13)},
    {D.new(5000000),  D.from_float(0.15)},
    {D.new(20000000), D.from_float(0.18)},
    {D.new(50000000), D.from_float(0.20)},
    {D.new(-1),       D.from_float(0.22)}
  ]

  def spain(beckham_law? \\ false), do: beckham_law? |> exact_esp_tax_rate() |> prepare_rates()

  def portugal(), do: @portugal_tax_rates |> prepare_rates()

  def uk(), do: @uk_tax_rates |> prepare_rates()

  def russia(), do: @russia_tax_rates |> prepare_rates()


  defp exact_esp_tax_rate(beckham_law?) do
    if beckham_law? do
      @spain_beckham_law_tax_rates
    else
      @spain_tax_rates
    end
  end

  defp prepare_rates(rates), do: [{D.new(0), D.new(1)} | rates] |> prepare_rates_difs()

  defp prepare_rates_difs([_, rate_2 | []]), do: [rates_dif({D.new(0), D.new(-1)}, rate_2) | []]

  defp prepare_rates_difs([rate_1, rate_2 | tail]), do: [rates_dif(rate_1, rate_2) | prepare_rates_difs([rate_2 | tail])]

  defp rates_dif({rate_1, _}, {rate_2, perc}), do: {D.sub(rate_2, rate_1), D.sub(1, perc)}
end