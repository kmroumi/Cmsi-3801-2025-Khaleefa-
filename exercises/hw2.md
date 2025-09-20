1. the null reference is hideous because it combines silent infiltration with catastrophic faliure.

2. he introduced it because it provided a quick and uniform way to represent the absence of a value.

3. in this instance, python is correct. JavaScript’s Number is an IEEE-754 double around 5×10^16 the spacing between representable integers is 16, so 50031545098999707 cannot be represented.

4. {"x": 3, y: 5, "z": z}

5. because == does type coercion beofre comparison so it is not true equality.

6. function arithmeticsequence(start, delta)
  return coroutine.create(function()
    local value = start
    while true do
      coroutine.yield(value)
      value = value + delta
    end
  end)
end

7. static scoping: f()*h()-x = 1*1-1 = 0
dynamic scoping: f()*h()-x = 1*3-1 = 2

8. shallow binding only matters under dynamic scoping where the caller determines bindings, under static scoping the binding environment is already unambiguous so shallow binding has no effect and makes no sense.