defmodule Server do
    def randomstr(length \\ 15) do
        Enum.join(["spahilwani;",:crypto.strong_rand_bytes(length) |> Base.encode64 |> binary_part(0, length)])
    end

    def hashfunction(str) do
        :crypto.hash(:sha256, str) |> Base.encode16 
    end

    
    def genzero(x,k) do
        for y<-1..k,
        do: x<> "0" 
    end

    def talktoworkers(k) do
        receive do
            {:bitcoin, response} ->
                IO.puts "Bitcoin from worker : #{inspect response}"
            {:ready, client} ->
                IO.puts "Got new connection. Sending k"
                :global.sync()
                #:global.whereis_name(client) |> send(:k,k)
                send(:global.whereis_name(client), k)
                IO.puts client
                IO.inspect :global.whereis_name(client)
        end
        talktoworkers(k)
    end 
    


    def mineCoins(k) do
            #IO.puts "Num : #{max}"
            Enum.each(1..9, fn(_)->
                spawn(fn ->
                    Server.generatebitcoinsParallel(k)
                    end)
              end)
    end  

    def generatebitcoinsParallel(k) do
        newstr = randomstr()
        hashstr = hashfunction(newstr)
        if String.slice(hashstr,0,k) == Enum.join(genzero("",k)) do 
            IO.puts newstr <> "\t" <> hashstr
        end
        generatebitcoinsParallel(k)
    end


end



