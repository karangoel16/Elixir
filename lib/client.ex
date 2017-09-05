require Logger

defmodule Project1.Client do
    use GenServer
  
    #client
    def connect(args) do
      Project1.Exdistutils.start_distributed(:project1,:ok)
      val="project1@"<>List.first(args);
      IO.puts(val);
      ping=Node.ping :"#{val}"
      IO.puts(ping)
      if ping == :pang do
        IO.puts("Not able to Connect")
        Process.sleep(1_000_000)
      end
      IO.puts("connecting to node successful")
    end
    
    def start_link() do
      GenServer.start_link(__MODULE__, :ok)
    end

    def lookup(server, name) do
      GenServer.call(server, {:lookup, name})
    end

    def create(server, name) do
      GenServer.cast(server, {:create, name})
    end

    def stop(server) do
      GenServer.stop(server)
    end
    
    def find_item(server,input,times) do
      GenServer.call(server,{:initialize,input,times},:infinity)
    end
  
    def final_call(server,output) do
      GenServer.call(server,{:final,output})
    end
    
    #Server callbacks

    def init(:ok) do
      {:ok,%{}}
    end

    def handle_call({choice, name,times}, _from, names) do
      if choice ==:lookup do
        {:reply, Map.fetch(names, name), names}  
      else
        find_hash(name,times)
        {:reply,"test"}
      end
      
    end

    def handle_cast({:create, name}, names) do
      if Map.has_key?(names, name) do
        {:noreply, names}
      else
        {:ok, bucket} = Project1.Agent.start_link([])
        {:noreply, Map.put(names, name, bucket)}
      end
    end

    defp check_string(val,key,test) do
      if String.to_integer(key)==test do
        Project1.Banker.log(val);
        {:reply,val}
      end
      if String.at("#{val}",test)=="0" do
        test=test+1
        check_string(val,key,test)
      end
      {:noreply,[]}
    end
    defp find_hash(key,times) do
      key=:crypto.hash(:sha256,key)|>Base.encode16|>String.downcase;
      if(check_string(key,times,0)) do
        #final_call(key)
        {:reply,key}
      end
      find_hash(key,times)
      {:noreply,[]} 
    end

    def handle_info({:reply, from}, state) do
      GenServer.reply(from, :one_second_has_passed)
      {:noreply, state}
    end
end