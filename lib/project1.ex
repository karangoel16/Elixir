defmodule Project1 do
  def main(args \\ [1]) do
    {check_add,_}=:inet_parse.strict_address('#{args}');
    if check_add == :error do
      Project1.Exdistutils.start_distributed(:project1,check_add)
      {:ok,pid_banker}=Project1.Banker.start_link()
      {:ok,var}=get_seed(pid_banker)
      spawn(Project1,:server_prod,[var,args])
      wait(0,args,pid_banker)#in this we will see if any new Node is Connected
    else
      #we need to start connecting here
      Project1.Client.connect(args);
    end
  end
  def wait(val,args,pid_banker) do
    list=Node.list
    if length(list) > val do
        #this will tell us how many cores does the machine have  
        Node.spawn(List.last(Node.list),Project1.Client,:start_link,["test"])
        core=GenServer.call({String.to_atom("test"), List.last(Node.list)}, {:check,"",""})
        spawner(core-1,0,List.last(Node.list),args,pid_banker)
        wait(length(list),args,pid_banker)
    end
    wait(length(list),args,pid_banker)
  end
  def server_prod(var,args) do
      Project1.Supervisor.start_child(var,List.first(args))
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
            Node.spawn(List.last(Node.list),Project1.Supervisor,:start_child,[var,List.first(args)])
            times=times+1
            spawner(core,times,node,args,pid_banker)
            {:ok,%{}}
      false->{:ok,%{}}
    end
  end
end