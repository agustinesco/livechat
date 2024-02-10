defmodule LivechatWeb.MaybeAssingUser do
  alias Livechat.UsersManager
  import Plug.Conn
  def init(default), do: default

  def call(conn, _default) do
    case get_session(conn, :user) do
      nil ->
        assign(conn, :user, nil)
      user ->
        user = UsersManager.lookup(user.username)

        assign(conn, :user, user)
    end
  end
end
