defmodule LivechatWeb.MaybeAddRoomId do
  import Plug.Conn
  def init(default), do: default

  def call(%{params: %{"room_id" => room_id}} = conn, _) do
    session_list = get_session(conn, :rooms_ids, MapSet.new())
    new_list = MapSet.put(session_list, room_id)

    put_session(conn, :rooms_ids, new_list)
    |> assign(:rooms_ids, new_list)
  end

  def call(conn, _) do
    session_list = get_session(conn, :rooms_ids, [])
    assign(conn, :rooms_ids, session_list)
  end
end
