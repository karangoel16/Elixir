defmodule Project1.Banker do
    use GenServer
    def start_link() do
        GenServer.start_link(__MODULE__,:ok)
    end
    
    def log(data) do
        IO.puts(data)
    end
end