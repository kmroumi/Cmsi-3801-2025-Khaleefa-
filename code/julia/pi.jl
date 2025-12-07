using Distributed

addprocs(parse(Int, ARGS[1]))

@everywhere function approximate_pi(trials::Int)
    hits = 0
    for i in 1:trials
        hits += (rand()^2 + rand()^2 < 1) ? 1 : 0
    end
    return hits
end

function main()
    total_trials = 500_000_000
    trials_per_worker = div(total_trials, nworkers())
    hits = pmap(w -> approximate_pi(trials_per_worker), workers())
    return 4 * sum(hits) / total_trials
end

println("Estimating π with $(nworkers()) workers...")
@time estimate = main()
println("π ≈ $estimate")

#=
Times (seconds):
1  -> 
2  -> 
3  -> 
4  -> 
5  -> 
6  -> 
7  -> 
8  -> 
9  -> 
10 ->
11 ->
12 ->
13 ->
14 ->
15 ->
16 ->
17 ->
18 ->
19 ->
20 ->
=#
