defmodule Tax do
  
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


  def esp_take_home(amount, verbose? \\ false, beckham_law? \\ false) do
    rates = select_esp_tax_rate(beckham_law?)
    amount |> calculate_take_home(rates) |> render_view(amount, verbose?)
  end

  defp select_esp_tax_rate(beckham_law?) do
    if beckham_law? do
      @spain_beckham_law_tax_rates
    else
      @spain_tax_rates
    end
  end

  def prt_take_home(amount), do: calculate_take_home(amount, @portugal_tax_rates)

  def uk_take_home(amount), do: calculate_take_home(amount, @uk_tax_rates)

  def ru_take_home(amount), do: calculate_take_home(amount, @russia_tax_rates)

  defp render_view(take_home, amount, verbose?) do
    view = [
      {"Annual Gross",      amount},
      {"Annual Take Home",  take_home}
    ]

    if verbose? do
      view ++ render_verbose_view(take_home, amount)
    else
      view
    end
  end

  defp render_verbose_view(take_home, amount) do
    monthly_gross = amount |> D.from_float() |> D.div(12) |> D.to_float |> Float.round(3)
    monthly_take_home = take_home |> D.from_float() |> D.div(12) |> D.to_float |> Float.round(3)

    [
      {"Monthly Gross",     monthly_gross},
      {"Monthly Take Home", monthly_take_home}
    ]
  end

  defp calculate_take_home(amount, rates), do: rates |> prepare_rates() |> take_home(amount)

  defp prepare_rates(rates), do: [{D.new(0), D.new(1)} | rates] |> prepare_rates_difs()

  defp prepare_rates_difs([_, rate_2 | []]), do: [rates_dif({D.new(0), D.new(-1)}, rate_2) | []]

  defp prepare_rates_difs([rate_1, rate_2 | tail]), do: [rates_dif(rate_1, rate_2) | prepare_rates_difs([rate_2 | tail])]

  defp rates_dif({rate_1, _}, {rate_2, perc}), do: {D.sub(rate_2, rate_1), D.sub(1, perc)}

  defp take_home(rates, amount), do: amount |> D.from_float() |> next_tax(rates) |> D.to_float()

  defp next_tax(0, _), do: 0

  defp next_tax(amount, [{_, rate} | []]), do: amount |> D.mult(rate)

  defp next_tax(amount, [{rate_amount, rate} | others]) do
    if D.compare(amount, rate_amount) != :gt do
      amount |> D.mult(rate)
    end

    next_rate_tax = amount |> D.sub(rate_amount) |> next_tax(others)
    rate_amount |> D.mult(rate) |> D.add(next_rate_tax)
  end
end