defmodule LivechatWeb.RoomHTML do
  use LivechatWeb, :html

  embed_templates "room_html/*"

  def get_username(nil), do: "Anon"
  def get_username(name), do: name
end
