# Taxcalculator

**A simple tax calculator. Can be run in iex.**

## Run

In order to run application clone this repo and run `iex`:
```shell
git clone git@github.com:Zilljian/tax-calculator.git tax-calculator
cd tax-calculator
iex -S mix run
```

## Functions

Allowed 3 similar funcions for calculating simple take home from annual gross value.

```elixir
prt_take_home/2

uk_take_home/2

ru_take_home/2
```

And one more for Spain, since Spain has unique Beckham's law applied for some cases.
```elixir
esp_take_home/3
```