using MathOptInterface
using Xpress
using XpressPSR
using Test

const MOI = MathOptInterface

XpressPSR.initialize()

#Example of simple Thermal Generation Dispatch and the derivatives of the generation by the demand (dg/dd)
mutable struct DispachModel
    optimizer::MOI.AbstractOptimizer # Optimizer
    g::Vector{MOI.VariableIndex}     # Generation Variable Indexes
    Df::MOI.VariableIndex            # Decifit Variable Index
    c_limit_lower                    # Constraint of lower limit for variables
    c_limit_upper                    # Constraint of upper limite for variables
    c_demand                         # Constraint of the generation by the demand
end

#Simple Model of Thermal Generation Dispatch by Constraints with MOI.SingleVariable
function GenerateModel_SingleVariable()
    # Parameters
    d = 45.0                   # Demand
    I = 3                      # Number of generators
    g_sup = [10.0, 20.0, 30.0] # Upper limit of generation for each generator
    c_g = [1.0, 3.0, 5.0]      # Cost of generation for each generator
    c_Df = 10.0                # Cost of deficit
    
    # Creation of the Optimizer
    optimizer = Xpress.Optimizer(PRESOLVE=0, logfile = "outputXpress_SV.log")
    # Variables
    g = MOI.add_variables(optimizer, I) # Generation for each generator
    Df = MOI.add_variable(optimizer)    # Deficit

    # Constraints
    c_limit_inf = Vector{Any}(undef, I + 1) # Lower limit constraints
    c_limit_sup = Vector{Any}(undef, I)     # Upper limit constraints
    for i in 1:I
        c_limit_inf[i] = MOI.add_constraint(optimizer, MOI.SingleVariable(g[i]), MOI.GreaterThan(0.0))
        c_limit_sup[i] = MOI.add_constraint(optimizer, MOI.SingleVariable(g[i]), MOI.LessThan(g_sup[i]))
    end
    c_limit_inf[I+1] = MOI.add_constraint(optimizer, MOI.SingleVariable(Df), MOI.GreaterThan(0.0))

    c_demand = MOI.add_constraint(optimizer, 
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(ones(I+1),[g;Df]), 0.0),
        MOI.EqualTo(d)
    ) # Constraint of the Demand

    # Objectives
    objective_function = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([c_g; c_Df], [g; Df]), 0.0)     # Total cost function
    MOI.set(optimizer, MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(), objective_function)  # Pass the objective function to the optimizer
    MOI.set(optimizer, MOI.ObjectiveSense(), MOI.MIN_SENSE)                                             # Set the objective sense to MIN

    # Solve the optimizer
    MOI.optimize!(optimizer)

    MOI.write_to_file(optimizer, "LP_SV.lp")

    # Return the solved optimizer with interest variables and constraints
    return DispachModel(optimizer, g, Df, c_limit_inf, c_limit_sup, c_demand)
end

#Simple Model of Thermal Generation Dispatch by Constraints with MOI.ScalarAffineFunction
function GenerateModel_ScalarAffineFunction()
    # Parameters
    d = 45.0                   # Demand
    I = 3                      # Number of generators
    g_sup = [10.0, 20.0, 30.0] # Upper limit of generation for each generator
    c_g = [1.0, 3.0, 5.0]      # Cost of generation for each generator
    c_Df = 10.0                # Cost of deficit
    
    # Creation of the Optimizer
    optimizer = Xpress.Optimizer(PRESOLVE=0, logfile = "outputXpress_SAF.log")
    # Variables
    g = MOI.add_variables(optimizer, I) # Generation for each generator
    Df = MOI.add_variable(optimizer)    # Deficit

    # Constraints
    c_limit_inf = Vector{Any}(undef, I + 1) # Lower limit constraints
    c_limit_sup = Vector{Any}(undef, I)     # Upper limit constraints
    vectAux = zeros(I + 1)                  # Auxiliar Vector
    for i in 1:I
        vectAux[i] = 1.0
        c_limit_inf[i] = MOI.add_constraint(optimizer,
            MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(vectAux,[g;Df]), 0.0),
            MOI.GreaterThan(0.0)
        )
        c_limit_sup[i] = MOI.add_constraint(optimizer,
            MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(vectAux,[g;Df]), 0.0),
            MOI.LessThan(g_sup[i])
        )
        vectAux[i] = 0.0
    end
    vectAux[I+1] = 1.0
    c_limit_inf[I+1] = MOI.add_constraint(optimizer, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(vectAux,[g;Df]),0.0), MOI.GreaterThan(0.0))
    vectAux[I+1] = 0.0

    c_demand = MOI.add_constraint(optimizer, 
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(ones(I+1),[g;Df]), 0.0),
        MOI.EqualTo(d)
    ) # Constraint of the Demand

    # Objectives
    objective_function = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([c_g; c_Df], [g; Df]), 0.0)     # Total cost function
    MOI.set(optimizer, MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(), objective_function)  # Pass the objective function to the optimizer
    MOI.set(optimizer, MOI.ObjectiveSense(), MOI.MIN_SENSE)                                             # Set the objective sense to MIN

    # Solve the optimizer
    MOI.optimize!(optimizer)

    MOI.write_to_file(optimizer, "LP_SAF.lp")

    # Return the solved optimizer with interest variables and constraints
    return DispachModel(optimizer, g, Df, c_limit_inf, c_limit_sup, c_demand)
end

#It uses a solved (optimized) Dispach Model created by the function GenerateModel
function Forward(model::DispachModel, ϵ::Float64 = 1.0)
    #Initialization of parameters and references to simplify the notation
    optimizer = model.optimizer
    vectRef = [model.g; model.Df]
    I = length(model.g)

    #Get the primal solution of the model
    vect =  MOI.get.(optimizer, MOI.VariablePrimal(), vectRef)
     
    #Pass the perturbation to the Xpress Framework and set the context to Forward
    MOI.set(optimizer, Xpress.ForwardSensitivityInConstraint(), model.c_demand, ϵ)
    
    #Get the derivative of the model
    dvect = MOI.get.(optimizer, Xpress.ForwardSensitivityOutVariable(), vectRef)

    #Return the values as a vector
    return [vect;dvect]
end

function Backward(model::DispachModel, ϵ::Float64 = 1.0)
    #Initialization of parameters and references to simplify the notation
    optimizer = model.optimizer
    vectRef = [model.g; model.Df]
    I = length(model.g)

    #Get the primal solution of the model
    vect =  MOI.get.(optimizer, MOI.VariablePrimal(), vectRef)

    #Set variables needed for the Xpress Backward Framework
    dvect = zeros(I + 1)

    #Loop for each primal variable
    for i in 1:I + 1
        #Set the perturbation in the Primal Variables and set the context to Backward
        MOI.set(optimizer, Xpress.BackwardSensitivityInVariable(), vectRef[i], ϵ)

        #Get the value of the derivative of the model
        dvect[i] = MOI.get(optimizer, Xpress.BackwardSensitivityOutConstraint(), model.c_demand)

        #Reset perturbation
        MOI.set(optimizer, Xpress.BackwardSensitivityInVariable(), vectRef[i], 0.0)
    end

    #Return the values as a vector
    return [vect;dvect]
end

#Initialization of Parameters
@testset verbose = true "Results" begin
    @testset verbose = true "Single_Variable" begin
        #Generate model by SingleVariable
        model1 = GenerateModel_SingleVariable()
        #Get the results of models with the DiffOpt Forward context
        @testset "Forward" begin
            resultForward = Forward(model1)
            @test resultForward[1:4] == [10.0;20.0;15.0;0.0]
            @test resultForward[5:8] == [0.0;0.0;1.0;0.0]
        end
        #Get the results of models with the DiffOpt Backward context
        @testset "Backward" begin
           resultBackward = Backward(model1)
           @test resultBackward[1:4] == [10.0;20.0;15.0;0.0]
           @test resultBackward[5:8] == [0.0;0.0;1.0;0.0]
        end
    end
    @testset verbose = true "Scalar_Affine_Function" begin
        #Generate model by ScalarAffineFunction
        model2 = GenerateModel_ScalarAffineFunction()
        #Get the results of models with the DiffOpt Forward context
        @testset verbose = true "Forward" begin
            resultForward = Forward(model2)
            @test resultForward[1:4] == [10.0;20.0;15.0;0.0]
            @test resultForward[5:8] == [0.0;0.0;1.0;0.0]
        end
       #Get the results of models with the DiffOpt Backward context
       @testset verbose = true "Backward" begin
           resultBackward = Backward(model2)
           @test resultBackward[1:4] == [10.0;20.0;15.0;0.0]
           @test resultBackward[5:8] == [0.0;0.0;1.0;0.0]
       end
    end
end

;#END