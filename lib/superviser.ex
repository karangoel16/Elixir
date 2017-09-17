defmodule Project1.Supervisor do
    use Supervisor
  
    def start_link() do
      Supervisor.start_link(__MODULE__,:ok)
    end
  
    def init(:ok) do
        children = [worker(Project1.Client,[])]
        supervise(children, strategy: :simple_one_for_one,type: :worker)
    end
    
    def start_child(args2,args3) do
        {:ok,pid}=start_link()
        {:ok,child}=Supervisor.start_child(pid,[])
        spawn(fn->Project1.Client.find_item(child,args2,args3)end)
        Process.sleep(300000)
        Supervisor.terminate_child(pid,child)
        Supervisor.stop(pid)
        start_child(args2,args3)
    end
end