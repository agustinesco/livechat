defmodule Livechat.RegistryManager do
  use GenServer

  ###################
  #   public api    #
  ###################
  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(_args) do
    name = :ets.new(:room_registry, [:named_table])

    {:ok, name}
  end

  def create(room_id) do
    GenServer.call(__MODULE__, {:create, room_id})
  end

  def handle_call({:create, room_id}, _from, state) do
    case :ets.lookup(:room_registry, room_id) do
      [{_room_id, pid}] ->
        {:reply, pid, state}
      [] ->
        {:ok, room_pid} = Livechat.Room.start_link(room_id)
        :ets.insert(:room_registry, {room_id, room_pid})
        {:reply, room_pid, state}
    end
  end
end
