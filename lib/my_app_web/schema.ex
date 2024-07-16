# handler for endpoint api/graphiql
defmodule MyAppWeb.Schema do
  use Absinthe.Schema

  # query to get a value of key in redis
  query do
    @desc "Get a value from Redis by key"
    field :get_redis_value, :string do
      arg :key, non_null(:string)

      resolve fn %{key: key}, _ ->
        case MyApp.Redis.command(["GET", key]) do
          {:ok, value} -> {:ok, value}
          {:error, _reason} -> {:error, "Could not retrieve value"}
        end
      end
    end
  end

  # mutation to set key-value in redis
  mutation do
    @desc "Set a value in Redis by key"
    field :set_redis_value, :string do
      arg :key, non_null(:string)
      arg :value, non_null(:string)

      resolve fn %{key: key, value: value}, _ ->
        case MyApp.Redis.command(["SET", key, value]) do
          {:ok, "OK"} -> {:ok, "Value set successfully"}
          {:error, _reason} -> {:error, "Could not set value"}
        end
      end
    end
  end
end
