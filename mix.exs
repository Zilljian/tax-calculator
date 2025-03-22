defmodule TaxCalculator.MixProject do
  use Mix.Project

  def project do
    [
      app: :taxcalculator,
      version: "1.0.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:decimal, "~> 2.0"}
    ]
  end
end
