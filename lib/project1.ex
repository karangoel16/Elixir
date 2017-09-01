require Logger
defmodule Project1 do
  @moduledoc """
  Documentation for Project1.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Project1.hello
      :world

  """ 
  def main(args\\[4000]) do
    {:ok,port}=Enum.fetch(args,0)
    {intport, _} = Integer.parse(port)
    {:ok,socket}=:gen_tcp.listen(intport,[:binary,packet: :line,active: false,reuseaddr: true])
    Logger.info("Accepting Connections on port #{intport}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok,client}=:gen_tcp.accept(socket)
    serve(client)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    socket
    |>read_line()
    |>write_line(socket)
    serve(socket)
  end
  defp read_line(socket) do
    {:ok,data}=:gen_tcp.recv(socket,0)
    IO.puts(data);
    data
  end
  defp write_line(line,socket) do
    :gen_tcp.send(socket,line)
  end
end
