defmodule Project1.Supervisor do
    use Supervisor
  
    def start_link() do
      Supervisor.start_link(__MODULE__,:ok)
    end
  
    def init(:ok) do
        children = [Project1.Client]
        Supervisor.init(children, strategy: :simple_one_for_one,type: :worker)
    end
    
    def start_child(args1,args2) do
        {:ok,pid}=Project1.Client.start_link();
        Project1.Client.find_item(pid,args1,args2)
    end
end