defmodule Project1 do
  use GenServer
  
  def start_link(args) do
    Project1.Exdistutils.start_distributed(:project1,:error)
    {:ok,pid_banker}=Project1.Banker.start_link
    {:ok,var}=get_seed(pid_banker)
    GenServer.start_link(__MODULE__,{:ok,pid_banker},name: Server)
    spawn(Project1.Supervisor,:start_child,[var,List.first(args),Node.self()])
    spawn(fn->wait(0,args,pid_banker)end)#in this we will see if any new Node is Connected
    loop()
  end
  def loop() do
    Process.sleep(100000000)
    loop()
  end
  def init(:ok,pid_banker) do
    {:ok,Map.put(%{},"BANKER",pid_banker)}
  end

  def handle_call({:get_seed},_from,state) do
    {:ok,pid_banker}=state
    {:ok,var}=get_seed(pid_banker) 
    {:reply,var,state}
  end
  
  def main(args \\ [1]) do
    {check_add,_}=:inet_parse.strict_address('#{args}');
    if check_add == :error do
      Project1.start_link(args)
    else
      Project1.Client.connect(args);
    end
  end
  
  def wait(val,args,pid_banker) do
    list=Node.list
    if length(list) > val do
        #this will tell us how many cores does the machine have  
        Node.spawn(List.last(Node.list),Project1.Client,:start_link,["test"])
        core=GenServer.call({String.to_atom("test"), List.last(Node.list)}, {:check,"","",""})
        spawner(core,0,List.last(Node.list),args,pid_banker)
        wait(length(list),args,pid_banker)
    end
    wait(length(list),args,pid_banker)
  end


  def get_seed(pid_banker) do
    var="karangoel16"<>RandomBytes.base16
    case Project1.Banker.get(pid_banker,String.to_atom(var))==nil do
      true->Project1.Banker.put(pid_banker,String.to_atom(var),1)
          {:ok,var}
      false->{:ok,get_seed(pid_banker)}
    end
  end

  def spawner(core,times,node,args,pid_banker) do
    case core>times do
      true->
            {:ok,var}=get_seed(pid_banker)
            Node.spawn(node,Project1.Supervisor,:start_child,[var,List.first(args),node])
            times=times+1
            spawner(core,times,node,args,pid_banker)
            {:ok,%{}}
      false->{:ok,%{}}
    end
  end
end