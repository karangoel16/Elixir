defmodule Project1.Supervisor do
    use Supervisor
  
    def start_link() do
      Supervisor.start_link(__MODULE__,:ok)
    end
  
    def init(:ok) do
        children = [Project1.Client]
        Supervisor.init(children, strategy: :simple_one_for_one,type: :worker)
    end
  
end