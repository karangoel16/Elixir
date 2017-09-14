defmodule Project1 do
  def main(args \\ [1]) do
    {check_add,_}=:inet_parse.strict_address('#{args}');
    if check_add == :error do
      Project1.Exdistutils.start_distributed(:project1,check_add)
      {:ok,pid_banker}=Project1.Banker.start_link()
      spawn(Project1,:server_prod,[args,pid_banker])
      wait(0,args,pid_banker)#in this we will see if any new Node is Connected
    else
      #we need to start connecting here
      Project1.Client.connect(args);
    end
  end
  def wait(val,args,pid_banker) do
    list=Node.list
    if length(list) > val do
      var="81160185"<>RandomBytes.base16
      if Project1.Banker.get(pid_banker,String.to_atom(var))==nil do
        Node.spawn(List.last(Node.list),Project1.Supervisor,:start_child,[var,List.first(args)])
        Project1.Banker.put(pid_banker,String.to_atom(var),1)
        wait(length(list),args,pid_banker)
      end
    end
    wait(length(list),args,pid_banker)
  end
  def server_prod(args,pid_banker) do
    var="81160185"<>RandomBytes.base16
    if Project1.Banker.get(pid_banker,String.to_atom(var))== nil do
      Project1.Supervisor.start_child(var,List.first(args))
      Project1.Banker.put(pid_banker,String.to_atom(var),1)
    end
    server_prod(args,pid_banker)
  end
end