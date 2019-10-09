using JuMP, Xpress
using Random
using Test

# Based on original model implemented in Mosel, courtesy of Truls Flatberg
function wordhunt(Words::Array{String,1}, D = [:E,:S,:W, :N, :SE, :NE], Gridsize=7,woptimizer=with_optimizer(Xpress.Optimizer,MIPRELSTOP=0.1),printres=true)

    Maxlength = maximum(length.(Words))
    M = 1:Gridsize
    N = uppercase.(Words)
    L = unique(join(N,""))

    model = Model(woptimizer)

    @variable(model, x[M,M,L],Bin)  # Letter in location M,M
    @variable(model, y[N,M,M,D])    # Word in location M,M in direction D

    # Allowed start positions for each direction in D
    for n in N, i in M, j in M, d in D
        if (d == :E) && (j > Gridsize - length(n) + 1)
            @constraint(model, y[n,i,j,d] <=0)
        elseif (d == :S) && (i > Gridsize - length(n) + 1 )
            @constraint(model, y[n,i,j,d] <=0)
        elseif (d == :W) && (j < length(n))
            @constraint(model, y[n,i,j,d] <=0)
        elseif (d == :N) && (i < length(n))
            @constraint(model, y[n,i,j,d] <=0)
        elseif (d == :SE) && ((i > Gridsize - length(n) + 1) || (j > Gridsize - length(n) + 1))
            @constraint(model, y[n,i,j,d] <=0)
	    elseif (d == :NE) && ((j > Gridsize - length(n) + 1) || (i < length(n) ))
            @constraint(model, y[n,i,j,d] <=0)
        else
            set_binary(y[n,i,j,d])
        end
    end

    # Each position has maximum one letter
    for i in M, j in M
	    @constraint(model,sum( x[i,j,l] for l in L) <= 1)
    end

    # Each word is allowed one position and direction (if inserted)
    for n in N
	    @constraint(model,sum( y[n,i,j,d] for i in M, j in M, d in D) <= 1)
    end

    # Placement of words
    for n in N, i in M, j in M, d in D
	    ii = i
	    jj = j
        for l in 1:length(n)
            if  ii in M && jj in M
                @constraint(model, x[ii,jj,n[l]] >= y[n,i,j,d] )
        	    if d == :E
		    	    jj = jj + 1
                elseif d == :S
	    	 	    ii = ii + 1
                elseif d == :SE
			        ii = ii + 1
			        jj = jj + 1
                elseif d == :NE
           	        ii = ii -1
           	        jj = jj +1
                elseif d == :W
           	        jj = jj - 1
                elseif d == :N
           	        ii = ii - 1
                end
            end
        end
    end

    # Objective function
    most_words = sum( 2 * Maxlength * y[n,i,j,d] for n in N, i in M, j in M, d in D)
    least_letters = sum( x[i,j,l] for i in M, j in M, l in L)

    P  = [:W,:N,:SE]
    if length(intersect(P,D)) > 0
        pref = sum( y[n,i,j,d] for n in N, i in M, j in M, d in intersect(P,D))
    else
        pref = 0
    end

    @objective(model, Max, most_words - least_letters + 0.1 * pref )

    optimize!(model)


    function printSol(x,L,fillrand=true)
        letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for i in 1:size(x,1)
            for j in 1:size(x,2)
                gotsol = false
                for l in L
                    if JuMP.value(x[i,j,l])>0.5
                        print(l)
                        gotsol = true
                    end
                end
                if !gotsol
                    if fillrand
                        print(letters[rand(1:end)])
                    else
                        print(' ')
                    end
                end
                print(' ')
            end
            println()
        end
    end

    if printres
        # Show status and objective value
        print(JuMP.termination_status(model),"\t")
        println(JuMP.objective_value(model))
        println()

        # Print solution to console
        printSol(x,L,false)
        println()
        printSol(x,L)
    end

    return JuMP.termination_status(model)
end

const Words = ["Ada","Claire","Hugo","Idris","Julia","Karel","Mary","Max","Maya","Miranda"]

# Demo
# @time wordhunt(Words,[:SE,:NE]);

# Tests:
@testset "Solver parameters" begin
    # Easy problem, should solve sub second
    @test wordhunt(Words,[:E],4,with_optimizer(Xpress.Optimizer,MAXTIME=15),false) == MOI.OPTIMAL
    # Check time limit
    @test wordhunt(Words,[:E,:S,:SE,:NE],7,with_optimizer(Xpress.Optimizer,MAXTIME=1),false) == MOI.TIME_LIMIT
    # Check miprelstop
    @test wordhunt(Words,[:E,:S,:SE,:NE],7,with_optimizer(Xpress.Optimizer,MIPRELSTOP=.9),false) == MOI.OPTIMAL
    # Test combinations of miprelstop and maxtime
    @test wordhunt(Words,[:E,:W,:S,:SE,:NE],7,with_optimizer(Xpress.Optimizer,MIPRELSTOP=.01,MAXTIME=1),false) == MOI.TIME_LIMIT
    @test wordhunt(Words,[:E,:W,:S,:SE,:NE],7,with_optimizer(Xpress.Optimizer,MIPRELSTOP=.9,MAXTIME=15),false) == MOI.OPTIMAL
end
