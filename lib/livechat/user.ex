defmodule Livechat.UsersManager do
  use GenServer
  @table_name :users

  ###################
  #   public api    #
  ###################
  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(_args) do
    name = :ets.new(@table_name, [:named_table])

    {:ok, name}
  end

  @doc """
    Create a registry in the table with the given username and password,
    the first element will be the key for the registry
    iex> create(key)
    {:username, :password, :rooms}
  """
  def create(name, password) do
    GenServer.call(__MODULE__, {:create, {name, password}})
  end

  def lookup(name) do
    GenServer.call(__MODULE__, {:lookup, name})
  end
  def validate_user(name, password) do
    GenServer.call(__MODULE__, {:validate_user, {name, password}})
  end

  def add_room(name, room_id) do
    GenServer.cast(__MODULE__, {:add_room, {name, room_id}})
  end

  ####################
  # process handlers #
  ####################
  def handle_call({:lookup, name}, _from, state) do
    result =
    case :ets.lookup(@table_name, name) do
      [{name, _, rooms}] ->
        %{
          username: name,
          rooms: rooms
        }
        _ -> nil
      end
      {:reply, result, state}
  end

  def handle_call({:create, {name, password}}, _from, state) do
    user = {name, password, MapSet.new()}
    result =
      if :ets.insert_new(@table_name, user) do
        user
      else
        :already_exists
      end

    {:reply, result, state}
  end

  def handle_call({:validate_user, {name, password}}, _from, state) do
    result =
      case :ets.lookup(@table_name, name) do
        [registry] ->
          if elem(registry, 0) == name and elem(registry, 1) == password do
            registry
          else
            :invalid_credentials
          end
        _  -> :not_found
      end
    {:reply, result, state}
  end

  def handle_cast({:add_room, {username, room_id}}, state) do
    case :ets.lookup(@table_name, username) do
      [{_, _ , rooms}] ->
        updated_rooms = MapSet.put(rooms, room_id)
        :ets.update_element(@table_name, username, {3, updated_rooms})
      _ -> nil
    end

    {:noreply, state}
  end
end
