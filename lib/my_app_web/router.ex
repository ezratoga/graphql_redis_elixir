# route the base endpoint for the application
defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  # base endpoint is localhost:4000/api
  scope "/api" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug,
      schema: MyAppWeb.Schema

    # to access the interface GraphQL, go to localhost:4000/api/graphiql
    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: MyAppWeb.Schema,
      interface: :simple
  end
end
