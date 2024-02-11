defmodule LivechatWeb.Layouts do
  use LivechatWeb, :html

  embed_templates "layouts/*"

  def maybe_active(%{room_id: room_id}, room_id), do: "active"
  def maybe_active(_, _), do: ""
end
