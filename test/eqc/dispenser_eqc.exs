defmodule TicketDispenser_eqc do
	use ExUnit.Case, async: false
	use EQC.ExUnit
	use EQC.StateM

	alias Client, as: HTTPClient

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

# weight state,
#	  take: 10,
#   reset: state

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

