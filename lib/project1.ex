defmodule Project1 do
  def main(args \\ [1]) do
    {check_add,_}=:inet_parse.strict_address('#{args}');
    if check_add == :error do
      Project1.Exdistutils.start_distributed(:project1,check_add)
      wait(0,args)#in this we will see if any new Node is Connected
    else
      #we need to start connecting here
      Project1.Client.connect(args);
      {:ok,pid}=Project1.Client.start_link()
      IO.inspect Node.spawn(List.last(Node.list),Project1.Client.find_item(pid,"karan81160185","2"))
      #IO.inspect Project1.Client.find_item(pid,"karangoel81160185",List.first(args))
    end
  end
  def wait(val,args) do
    list=Node.list
    IO.puts(length(list));
    if length(list) > val do
      IO.puts("New Node Added")
      val=val+1;
      wait(val,args)
    end
    wait(val,args)
  end
end