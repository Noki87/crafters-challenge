### GAME SPECIFIC ###
defmodule Craftcha.Scenario.Logistock do
  @behaviour Craftcha.Scenario

  alias Craftcha.Validation
  alias Craftcha.HttpRequest

  @max_level 1

  def get_max_level() do
    @max_level
  end

  @doc """
  For each level, returns {:ok} if successful, {:error, [errors]} in case of failure
  """
  def get_level_tests(level) do
    case level do
      0 -> get_tests_level_0()
      1 -> get_tests_level_1()
    end
  end

  @doc """
  The player must return a 200 OK with 'Hello Bob!' as a response
  """
  def get_tests_level_0 do
    request = %HttpRequest{verb: :get, route: "", params: [{'name', 'Bob'}]}
    checks = [
      &Validation.check_status(&1, 200),
      &Validation.check_body(&1, 'Hello Bob')
    ]
    first_test = {request, checks}

    request = %HttpRequest{verb: :get, route: '/noroute'}
    validations = [&Validation.check_status(&1, 404)]
    second_test = {request, validations}

    [first_test, second_test]
  end

  def get_tests_level_1 do
    [test_level_1_0(), test_level_1_1(), test_level_1_2(), test_level_1_4()]
  end

  def test_level_1_0 do
    request = %HttpRequest{verb: :get, route: '/fizzbuzz', params: [{'value', '3'}]}
    validations = [&Validation.check_body(&1, 'Fizz'), &Validation.check_status(&1, 200)]
    {request, validations}
  end

  def test_level_1_1 do
    request = %HttpRequest{verb: :get, route: '/fizzbuzz', params: [{'value', '2'}]}
    validations = [&Validation.check_body(&1, '2'), &Validation.check_status(&1, 200)]
    {request, validations}
  end

  def test_level_1_2 do
    request = %HttpRequest{verb: :get, route: '/fizzbuzz', params: [{'value', '7'}]}
    validations = [&Validation.check_body(&1, '7')]
    {request, validations}
  end

  def test_level_1_4 do
    request = %HttpRequest{verb: :get, route: '/fizzbuzz', params: [{'value', '12'}]}
    validations = [&Validation.check_body(&1, 'Fizz'), &Validation.check_status(&1, 200)]
    {request, validations}
  end

  def get_instructions(level) do
    case level do
      0 -> "
## Welcome to LogiStock Crafter's Challenge

Please start your server on the port you defined when registering.
Your server should:
- Answer 200 OK with the body *Hello Name* when the route _/_ is called with the method GET, the name to add
to the message will be passed in the query parameter _name_
- Answer 404 ERROR when any other route is called

Please click on _Check_ button when you are ready
"
      1 -> "
## Fizz

Add an endpoint _/fizzbuzz_

A GET on _/fizzbuzz_ with a query param *value* (integer) should return:
- *'Fizz'* if the value is a multiple of 3
- Else: the value in parameter
"
      2 -> "
## Buzz

A GET on _/fizzbuzz_ with a query param *value* (integer) should now return:
- *'Buzz'* if the value is a multiple of 5

The previous rules still apply
"
      3 -> "
## FizzBuzz

A GET on _/fizzbuzz_ with a query param *value* (integer) should now return:
- *'FizzBuzz'* if the value is both a multiple of 3 and 5

The previous rules still apply
"
    end
  end

end