defmodule LivechatWeb.RoomLive do
  alias Phoenix.PubSub
  alias Livechat.RegistryManager
  alias Livechat.Room

  use LivechatWeb, :live_view

  def render(assigns) do
    LivechatWeb.RoomHTML.room(assigns)
  end

  def mount(%{"room_id" => id}, _session, socket) do
    room_pid = RegistryManager.create(id)
    messages = Room.get_messages(room_pid)
    PubSub.subscribe(Livechat.PubSub, id)

    assigns = %{
      room_id: id,
      room_pid: room_pid,
      messages: messages
    }

    {:ok, assign(socket, assigns)}
  end

  def handle_event("send_message", %{"message" => message}, socket) do
    send(socket.assigns.room_pid, {:send_message, message})

    {:noreply, socket}
  end

  def handle_info({:update_messages, messages}, socket) do
    {:noreply, assign(socket, :messages, messages)}
  end
end
