defmodule TaxCalculator do
  
  require Decimal
  alias Decimal, as: D

  def spain(salary) do
    d_spain(D.new(salary))
  end

  def d_spain(salary) do
    cond do
      lte?(salary, 1245) -> 
        D.mult(salary, D.from_float(0.81))
      lte?(salary, 20200) -> 
        nextStepTax = d_spain(D.new(1245))
        thisStep = D.sub(salary, 1245)
        thisStepTax = D.mult(thisStep, D.from_float(0.76))
        D.add(thisStepTax, nextStepTax)
      lte?(salary, 35200) ->
        nextStepTax = d_spain(D.new(20200))
        thisStep = D.sub(salary, 20200)
        thisStepTax = D.mult(thisStep, D.from_float(0.7))
        D.add(thisStepTax, nextStepTax)
      lte?(salary, 60000) ->
        nextStepTax = d_spain(D.new(35200))
        thisStep = D.sub(salary, 35200)
        thisStepTax = D.mult(thisStep, D.from_float(0.63))
        D.add(thisStepTax, nextStepTax)
      lte?(salary, 300000) ->
        nextStepTax = d_spain(D.new(60000))
        thisStep = D.sub(salary, 60000)
        thisStepTax = D.mult(thisStep, D.from_float(0.55))
        D.add(thisStepTax, nextStepTax)
      true ->
        nextStepTax = d_spain(D.new(300000))
        thisStep = D.sub(salary, 300000)
        thisStepTax = D.mult(thisStep, D.from_float(0.53))
        D.add(thisStepTax, nextStepTax)
    end
  end

  def lte?(i, j) do
    cmp = D.compare(i, j)
    cmp == :lt or cmp == :eq
  end
end