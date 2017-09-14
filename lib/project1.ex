defmodule Project1 do
  def main(args \\ [1]) do
    {check_add,_}=:inet_parse.strict_address('#{args}');
    if check_add == :error do
      Project1.Exdistutils.start_distributed(:project1,check_add)
      var="81160185"<>RandomBytes.base16
      spawn(Project1.Supervisor,:start_child,[var,List.first(args)])
      wait(0,args)#in this we will see if any new Node is Connected
    else
      #we need to start connecting here
      Project1.Client.connect(args);
    end
  end
  def wait(val,args,map\\%{}) do
    list=Node.list
    if length(list) > val do
      var="81160185"<>RandomBytes.base16
      if Map.get(map,String.to_atom(var))==nil do
        Node.spawn(List.last(Node.list),Project1.Supervisor,:start_child,[var,List.first(args)])
        wait(length(list),args,Map.put(map,String.to_atom(var),1))
      end
    end
    wait(length(list),args,map)
  end
end