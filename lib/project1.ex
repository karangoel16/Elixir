defmodule Project1 do
  def main(args \\ [1]) do
    {check_add,_}=:inet_parse.strict_address('#{args}');
    if check_add == :error do
      Project1.Exdistutils.start_distributed(:project1,check_add)
      wait(0,args)#in this we will see if any new Node is Connected
    else
      #we need to start connecting here
      Project1.Client.connect(args);
      
      #IO.inspect Project1.Client.find_item(pid,"karangoel81160185",List.first(args))
    end
  end
  def wait(val,args,map\\%{}) do
    list=Node.list
    if length(list) > val do
      
      pid=Node.spawn(List.last(Node.list),Project1.Supervisor,:start_child,["81160185"<>RandomBytes.base16,List.first(args)])
      wait(length(list),args,map)
    end
    wait(length(list),args)
  end
end