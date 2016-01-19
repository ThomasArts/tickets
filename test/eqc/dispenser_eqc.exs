defmodule TicketDispenser_eqc do
	use ExUnit.Case, async: false
	use EQC.ExUnit
	use EQC.StateM

  defmodule ErlangClient do

    def take do
      {:ok, {{'HTTP/1.1', 200, 'OK'}, _, body}} =
        :httpc.request(:get, {'http://localhost:4000/take', []}, [], [])
      :erlang.list_to_integer(body)
    end

    def reset do
      {:ok, {{'HTTP/1.1', 200, 'OK'}, _, body}} =
        :httpc.request(:get, {'http://localhost:4000/reset', []}, [], [])
      body
    end

    def start do
      {:ok, []}
    end

    def stop do
      :ok
    end
  end

  defmodule IbrowseClient do

    def take do
      {:ok, '200', _, body} =
        :ibrowse.send_req('http://localhost:4000/take', [], :get)
      :erlang.list_to_integer(body)
    end

    def reset do
      {:ok, '200', _, body} =
        :ibrowse.send_req('http://localhost:4000/reset', [], :get)
      body
    end

    def start do
      :ibrowse.start
    end

    def stop do
      :ibrowse.stop
    end
  end

  
	#alias Client, as: HTTPClient
  alias IbrowseClient, as: HTTPClient

	def initial_state() do :undefined end
	
## reset command
	def reset_args(_state), do: []
    
	def reset, do: HTTPClient.reset

	def reset_next(_state, _var, []), do: 1

  ## take command
  def take_pre(state), do: state != :undefined
    
	def take_args(_state), do: []

	def take, do: HTTPClient.take

	def take_next(state, _var, []), do: state+1 
	
	def take_post(state, [], result), do: eq(result, state) 

  def weight(_, :take), do: 10
  def weight(_, :reset), do: 1

  property "random_ticket_sequence" do
		forall cmds <- commands(__MODULE__) do
			{:ok, _} = HTTPClient.start()
			run_result =
				run_commands(__MODULE__, cmds, [])
			HTTPClient.stop
			pretty_commands(__MODULE__, cmds, run_result,
											run_result[:result] == :ok)
		end
	end
  
	property "random_ticket_parallel_sequence" do
		forall cmds <- parallel_commands(__MODULE__) do
			{:ok, _} = HTTPClient.start()
			run_result =
				run_parallel_commands(__MODULE__, cmds, [])
			HTTPClient.stop
			pretty_commands(__MODULE__, cmds, run_result,
											run_result[:result] == :ok)
		end
	end
  
end

