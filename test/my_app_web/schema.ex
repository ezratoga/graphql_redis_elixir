defmodule MyAppWeb.SchemaTest do
  use ExUnit.Case, async: true
  use MyAppWeb.ConnCase

  alias MyApp.Redis

  setup do
    {:ok, _pid} = Redis.start_link()
    :ok
  end

  @get_redis_value_query """
  query GetRedisValue($key: String!) {
    getRedisValue(key: $key)
  }
  """

  @set_redis_value_mutation """
  mutation SetRedisValue($key: String!, $value: String!) {
    setRedisValue(key: $key, value: $value)
  }
  """

  test "set and get Redis value", %{conn: conn} do
    # Set the value
    variables = %{"key" => "test_key", "value" => "test_value"}
    conn =
      post(conn, "/api/graphql", %{
        query: @set_redis_value_mutation,
        variables: variables
      })

    assert json_response(conn, 200) == %{
             "data" => %{
               "setRedisValue" => "Value set successfully"
             }
           }

    # Get the value
    variables = %{"key" => "test_key"}
    conn =
      post(conn, "/api/graphql", %{
        query: @get_redis_value_query,
        variables: variables
      })

    assert json_response(conn, 200) == %{
             "data" => %{
               "getRedisValue" => "test_value"
             }
           }
  end

  test "get non-existent Redis value", %{conn: conn} do
    variables = %{"key" => "non_existent_key"}
    conn =
      post(conn, "/api/graphql", %{
        query: @get_redis_value_query,
        variables: variables
      })

    assert json_response(conn, 200) == %{
             "data" => %{
               "getRedisValue" => "Key not found"
             }
           }
  end
end
