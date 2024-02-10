defmodule LivechatWeb.RoomLive do
  alias Livechat.UsersManager
  alias Phoenix.PubSub
  alias Livechat.RegistryManager
  alias Livechat.Room

  use LivechatWeb, :live_view

  def render(assigns) do
    LivechatWeb.RoomHTML.room(assigns)
  end

  def mount(%{"room_id" => id}, %{"user" => session_user}, socket) do
    room_pid = RegistryManager.create(id)
    messages = Room.get_messages(room_pid)
    PubSub.subscribe(Livechat.PubSub, id)
    UsersManager.add_room(session_user.username, id)
    user = UsersManager.lookup(session_user.username)

    assigns = %{
      room_id: id,
      room_pid: room_pid,
      messages: messages,
      user: user
    }

    {:ok, assign(socket, assigns)}
  end

  def handle_event("send_message", %{"message" => message}, socket) do
    send(socket.assigns.room_pid, {:send_message,  {socket.assigns.user.username, message}})

    {:noreply, socket}
  end

  def handle_info({:update_messages, messages}, socket) do
    {:noreply, assign(socket, :messages, messages)}
  end
end
