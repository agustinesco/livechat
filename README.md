# Livechat
This projecct is a simple chatting aplication where you can join rooms by typing a name and chat with every other user connected to that room, you can also chat anonymously or create and login with an user 

### Purpose

The main purpose of this project is reinforce the knowledge on the phoenix frameworn and process communication and creation


### Disclaimer

For the sake of simplicity this project will not implement a database for the system, instead of that we'll use the build-in table system from [erlang ETS](https://hexdocs.pm/elixir/erlang-term-storage.html) for information that we need to keep alive while the system lives (user registration for example)

Also the system will have a simple user registration and login

### How it works

The principal actor of this project will be the `Livechat.Room` Genserver, this process will have 3 main tasks
1. Save the message list from that room (This means that if the process dies, the messages will also do so)
2. Receive message from users and save them in memory
3. Broadcast the messages everytime the users send one

We'll define rooms by their name, where every room name represents an instance of a process. This comes with a problem, when you create a process you need the PID to send messages to that process (You can name processes too), so we need a way to retrieve the PID from the room based on the room name, that's where the `Livechat.RegistryManager` comes into action, this process will be the one in charge of every room instance being their [Monitor](https://hexdocs.pm/elixir/1.12.3/Port.html#monitor/1) and creating new rooms when there's no room defined, i found this a little bit intricated so i craeted a diagram to show this a little bit better


![livechat live processes-user joining process (1)](https://github.com/agustinesco/livechat/assets/106101218/e57454f3-7352-48eb-b207-2ed27294dc5b)


Once we hace a room created the next challenge is: ¿how the users will "join" rooms? this will be achieved using phoenix [Pubsub](https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html) module, a room will broadcast his message list everytime it receives a message to every process listening to the rooms name topic (the room could also just send the received message on this update), so all we need to do is suscribe a process to the rooms name topic and handle messages updates and that's it, to do so we'll use [Liveview](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html) that's basically a process that renders a template with every update
