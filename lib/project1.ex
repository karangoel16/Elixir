defmodule Project1 do
  def main(args \\ [1]) do
    {check_add,_}=:inet_parse.strict_address('#{args}');
    if check_add == :error do
      Project1.Exdistutils.start_distributed(:project1,check_add)
      #wait()
    else
      #we need to start connecting here
      IO.puts('hi');
      Project1.Exdistutils.start_distributed(:project1,check_add)
      val="project1@"<>List.first(args);
      Node.connect :val
      IO.puts("connecting to node successful")
      wait()
      {:ok,pid}=Project1.Client.start_link()
      #IO.inspect Project1.Client.find_item(pid,"karangoel81160185",List.first(args))
    end
   
    IO.puts(args)
    IO.puts(check_add)
    
  end
  def wait() do
    IO.puts("hello")
    wait()
  end
end