require Logger

defmodule Project1.Client do
    use GenServer
  
    #client
    def connect(args) do
      #unless Node.alive?() do
        Project1.Exdistutils.start_distributed(:project1,:ok)
        val="project1@"<>List.first(args);
        ping=Node.ping :"#{val}"
        if ping == :pang do
         IO.puts("Not able to Connect")
          Process.exit(self(),2);
        end
      #end
      IO.puts("connecting to node successful")
      Process.sleep(1000)
      connect(args)
    end
    
    def start_link() do
      GenServer.start_link(__MODULE__,:ok)
    end

    def stop(server) do
      GenServer.stop(server)
    end
    
    def find_item(server,input,times) do
      GenServer.call(server,{:initialize,input,times},:infinity)
    end
  
    #Server callbacks

    def init(:ok) do
      {:ok,%{}}
    end

    def handle_call({:initialize, name,times}, _from, _) do
        find_hash(name,name,times)
    end

    defp check_string(val,name,key,test) do
      if String.to_integer(key)==test do
        IO.puts(name<>" "<>val);
        #Node.stop()
        #Process.exit(self(),1);
        {:reply,val}
      end
      if String.at("#{val}",test)=="0" do
        test=test+1
        check_string(val,name,key,test)
      end
      {:noreply,[]}
    end 
    defp find_hash(key,name,times) do
      key=:crypto.hash(:sha256,key)|>Base.encode16|>String.downcase;
      if(check_string(key,name,times,0)) do
        {:reply,key}
      end
      find_hash(key,name,times)
      {:noreply,[]} 
    end

    def handle_info({:reply, from}, state) do
      GenServer.reply(from, :one_second_has_passed)
      {:noreply, state}
    end
end