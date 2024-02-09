defmodule Livechat.Room do
  alias Phoenix.PubSub
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(room_id) do
    messages = []
    state = %{
      room_id: room_id,
      messages: messages
    }
    {:ok, state}
  end

  def get_messages(room_pid) do
    GenServer.call(room_pid, :get_messages)
  end

  def handle_info({:send_message, message}, state) do
    state = Map.update(state, :messages, [message], fn messages -> [message | messages] end)
    PubSub.broadcast(Livechat.PubSub, state.room_id, {:update_messages, state.messages})

    {:noreply, state}
  end

  def handle_call(:get_messages, _from, state) do
    {:reply, state.messages, state}
  end
end
