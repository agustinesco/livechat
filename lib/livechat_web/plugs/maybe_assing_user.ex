defmodule LivechatWeb.MaybeAssingUser do
  import Plug.Conn
  def init(default), do: default

  def call(conn, _default) do
    get_session(conn, :username)
    |> case do
      nil -> conn
      name -> assign(conn, :username, name)
    end
  end
end
