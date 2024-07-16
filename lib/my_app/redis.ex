# this module use to connect the redis
defmodule MyApp.Redis do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    {:ok, conn} = Redix.start_link("redis://localhost:6379/0")
    {:ok, conn}
  end

  def command(command) do
    GenServer.call(__MODULE__, {:command, command})
  end

  def handle_call({:command, command}, _from, conn) do
    case Redix.command(conn, command) do
      {:ok, result} -> {:reply, {:ok, result}, conn}
      {:error, reason} -> {:reply, {:error, reason}, conn}
    end
  end
end
