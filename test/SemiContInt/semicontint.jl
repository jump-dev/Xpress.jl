# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

function semiconttest(model::MOI.ModelLike, config::MOIT.Config{T}) where T
    atol = config.atol
    rtol = config.rtol

    @test MOIU.supports_default_copy_to(model, #=copy_names=# false)
    @test MOI.supports(model, MOI.ObjectiveFunction{MOI.ScalarAffineFunction{T}}())
    @test MOI.supports(model, MOI.ObjectiveSense())
    @test MOI.supports_constraint(model, MOI.VariableIndex, MOI.MathOptInterface.Semicontinuous{T})

    # 2 variables
    # min  x
    # st   x >= y
    #      x ∈ {0.0} U [2.0,3.0]
    #      y = 0.0

    MOI.empty!(model)
    @test MOI.is_empty(model)

    v = MOI.add_variables(model, 2)
    @test MOI.get(model, MOI.NumberOfVariables()) == 2

    vc1 = MOI.add_constraint(model, v[1], MOI.Semicontinuous(T(2), T(3)))
    @test MOI.get(model, MOI.NumberOfConstraints{MOI.VariableIndex,MOI.Semicontinuous{T}}()) == 1

    vc2 = MOI.add_constraint(model, v[2], MOI.EqualTo(zero(T)))
    @test MOI.get(model, MOI.NumberOfConstraints{MOI.VariableIndex,MOI.EqualTo{T}}()) == 1

    cf = MOI.ScalarAffineFunction{T}(MOI.ScalarAffineTerm{T}.([one(T), -one(T)], v), zero(T))
    c = MOI.add_constraint(model, cf, MOI.GreaterThan(zero(T)))
    @test MOI.get(model, MOI.NumberOfConstraints{MOI.ScalarAffineFunction{T},MOI.GreaterThan{T}}()) == 1

    objf = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, 0.0], v), 0.0)
    MOI.set(model, MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(), objf)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)

    @test MOI.get(model, MOI.ObjectiveSense()) == MOI.MIN_SENSE

    if config.solve
        @test MOI.get(model, MOI.TerminationStatus()) == MOI.OPTIMIZE_NOT_CALLED

        MOI.optimize!(model)

        @test MOI.get(model, MOI.TerminationStatus()) == config.optimal_status

        @test MOI.get(model, MOI.ResultCount()) >= 1

        @test MOI.get(model, MOI.PrimalStatus()) in [ MOI.FEASIBLE_POINT, MOI.NEARLY_FEASIBLE_POINT ]

        @test MOI.get(model, MOI.ObjectiveValue()) ≈ 0.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.VariablePrimal(), v) ≈ [0,0] atol=atol rtol=rtol

        @test MOI.get(model, MOI.ConstraintPrimal(), c) ≈ 0.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.ObjectiveBound()) <= 0.0
    end

    # Change y fixed value

    MOI.set(model, MOI.ConstraintSet(), vc2, MOI.EqualTo(one(T)))

    if config.solve
        MOI.optimize!(model)

        @test MOI.get(model, MOI.TerminationStatus()) == config.optimal_status

        @test MOI.get(model, MOI.ResultCount()) >= 1

        @test MOI.get(model, MOI.PrimalStatus()) == MOI.FEASIBLE_POINT

        @test MOI.get(model, MOI.ObjectiveValue()) ≈ 2.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.VariablePrimal(), v) ≈ [2.0,1.0] atol=atol rtol=rtol

        @test MOI.get(model, MOI.ConstraintPrimal(), c) ≈ 1.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.ObjectiveBound()) <= 2.0
    end

    MOI.set(model, MOI.ConstraintSet(), vc2, MOI.EqualTo(T(2)))

    if config.solve
        MOI.optimize!(model)

        @test MOI.get(model, MOI.TerminationStatus()) == config.optimal_status

        @test MOI.get(model, MOI.ResultCount()) >= 1

        @test MOI.get(model, MOI.PrimalStatus()) == MOI.FEASIBLE_POINT

        @test MOI.get(model, MOI.ObjectiveValue()) ≈ 2.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.VariablePrimal(), v) ≈ [2.0,2.0] atol=atol rtol=rtol

        @test MOI.get(model, MOI.ConstraintPrimal(), c) ≈ 0.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.ObjectiveBound()) <= 2.0
    end

    MOI.set(model, MOI.ConstraintSet(), vc2, MOI.EqualTo(T(5//2)))

    if config.solve
        MOI.optimize!(model)

        @test MOI.get(model, MOI.TerminationStatus()) == config.optimal_status

        @test MOI.get(model, MOI.ResultCount()) >= 1

        @test MOI.get(model, MOI.PrimalStatus()) == MOI.FEASIBLE_POINT

        @test MOI.get(model, MOI.ObjectiveValue()) ≈ 2.5 atol=atol rtol=rtol

        @test MOI.get(model, MOI.VariablePrimal(), v) ≈ [2.5,2.5] atol=atol rtol=rtol

        @test MOI.get(model, MOI.ConstraintPrimal(), c) ≈ 0.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.ObjectiveBound()) <= 2.5
    end

    MOI.set(model, MOI.ConstraintSet(), vc2, MOI.EqualTo(T(3)))

    if config.solve
        MOI.optimize!(model)

        @test MOI.get(model, MOI.TerminationStatus()) == config.optimal_status

        @test MOI.get(model, MOI.ResultCount()) >= 1

        @test MOI.get(model, MOI.PrimalStatus()) == MOI.FEASIBLE_POINT

        @test MOI.get(model, MOI.ObjectiveValue()) ≈ 3.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.VariablePrimal(), v) ≈ [3.0,3.0] atol=atol rtol=rtol

        @test MOI.get(model, MOI.ConstraintPrimal(), c) ≈ 0.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.ObjectiveBound()) <= 3.0
    end

    MOI.set(model, MOI.ConstraintSet(), vc2, MOI.EqualTo(T(5)))

     if config.solve

        MOI.optimize!(model)

        @test MOI.get(model, MOI.TerminationStatus()) == MOI.INFEASIBLE ||
            MOI.get(model, MOI.TerminationStatus()) == MOI.INFEASIBLE_OR_UNBOUNDED
    end
end

function semiinttest(model::MOI.ModelLike, config::MOIT.Config{T}) where T
    atol = config.atol
    rtol = config.rtol

    @test MOIU.supports_default_copy_to(model, #=copy_names=# false)
    @test MOI.supports(model, MOI.ObjectiveFunction{MOI.ScalarAffineFunction{T}}())
    @test MOI.supports(model, MOI.ObjectiveSense())
    @test MOI.supports_constraint(model, MOI.VariableIndex, MOI.MathOptInterface.Semiinteger{T})

    # 2 variables
    # min  x
    # st   x >= y
    #      x ∈ {0.0} U {2.0} U {3.0}
    #      y = 0.0

    MOI.empty!(model)
    @test MOI.is_empty(model)

    v = MOI.add_variables(model, 2)
    @test MOI.get(model, MOI.NumberOfVariables()) == 2

    vc1 = MOI.add_constraint(model, v[1], MOI.Semiinteger(T(2), T(3)))
    @test MOI.get(model, MOI.NumberOfConstraints{MOI.VariableIndex,MOI.Semiinteger{T}}()) == 1

    vc2 = MOI.add_constraint(model, v[2], MOI.EqualTo(zero(T)))
    @test MOI.get(model, MOI.NumberOfConstraints{MOI.VariableIndex,MOI.EqualTo{T}}()) == 1

    cf = MOI.ScalarAffineFunction{T}(MOI.ScalarAffineTerm{T}.([one(T), -one(T)], v), zero(T))
    c = MOI.add_constraint(model, cf, MOI.GreaterThan(zero(T)))
    @test MOI.get(model, MOI.NumberOfConstraints{MOI.ScalarAffineFunction{T},MOI.GreaterThan{T}}()) == 1

    objf = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, 0.0], v), 0.0)
    MOI.set(model, MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(), objf)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)

    @test MOI.get(model, MOI.ObjectiveSense()) == MOI.MIN_SENSE

    if config.solve
        @test MOI.get(model, MOI.TerminationStatus()) == MOI.OPTIMIZE_NOT_CALLED

        MOI.optimize!(model)

        @test MOI.get(model, MOI.TerminationStatus()) == config.optimal_status

        @test MOI.get(model, MOI.ResultCount()) >= 1

        @test MOI.get(model, MOI.PrimalStatus()) in [ MOI.FEASIBLE_POINT, MOI.NEARLY_FEASIBLE_POINT ]

        @test MOI.get(model, MOI.ObjectiveValue()) ≈ 0.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.VariablePrimal(), v) ≈ [0,0] atol=atol rtol=rtol

        @test MOI.get(model, MOI.ConstraintPrimal(), c) ≈ 0.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.ObjectiveBound()) <= 0.0
    end

    # Change y fixed value

    MOI.set(model, MOI.ConstraintSet(), vc2, MOI.EqualTo(one(T)))

    if config.solve
        MOI.optimize!(model)

        @test MOI.get(model, MOI.TerminationStatus()) == config.optimal_status

        @test MOI.get(model, MOI.ResultCount()) >= 1

        @test MOI.get(model, MOI.PrimalStatus()) == MOI.FEASIBLE_POINT

        @test MOI.get(model, MOI.ObjectiveValue()) ≈ 2.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.VariablePrimal(), v) ≈ [2.0,1.0] atol=atol rtol=rtol

        @test MOI.get(model, MOI.ConstraintPrimal(), c) ≈ 1.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.ObjectiveBound()) <= 2.0
    end

    MOI.set(model, MOI.ConstraintSet(), vc2, MOI.EqualTo(T(2)))

    if config.solve
        MOI.optimize!(model)

        @test MOI.get(model, MOI.TerminationStatus()) == config.optimal_status

        @test MOI.get(model, MOI.ResultCount()) >= 1

        @test MOI.get(model, MOI.PrimalStatus()) == MOI.FEASIBLE_POINT

        @test MOI.get(model, MOI.ObjectiveValue()) ≈ 2.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.VariablePrimal(), v) ≈ [2.0,2.0] atol=atol rtol=rtol

        @test MOI.get(model, MOI.ConstraintPrimal(), c) ≈ 0.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.ObjectiveBound()) <= 2.0
    end

    MOI.set(model, MOI.ConstraintSet(), vc2, MOI.EqualTo(T(5//2)))

    if config.solve
        MOI.optimize!(model)

        @test MOI.get(model, MOI.TerminationStatus()) == config.optimal_status

        @test MOI.get(model, MOI.ResultCount()) >= 1

        @test MOI.get(model, MOI.PrimalStatus()) == MOI.FEASIBLE_POINT

        @test MOI.get(model, MOI.ObjectiveValue()) ≈ 3.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.VariablePrimal(), v) ≈ [3.0,2.5] atol=atol rtol=rtol

        @test MOI.get(model, MOI.ConstraintPrimal(), c) ≈ 0.5 atol=atol rtol=rtol

        @test MOI.get(model, MOI.ObjectiveBound()) <= 3.0
    end

    MOI.set(model, MOI.ConstraintSet(), vc2, MOI.EqualTo(T(3)))

    if config.solve
        MOI.optimize!(model)

        @test MOI.get(model, MOI.TerminationStatus()) == config.optimal_status

        @test MOI.get(model, MOI.ResultCount()) >= 1

        @test MOI.get(model, MOI.PrimalStatus()) == MOI.FEASIBLE_POINT

        @test MOI.get(model, MOI.ObjectiveValue()) ≈ 3.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.VariablePrimal(), v) ≈ [3.0,3.0] atol=atol rtol=rtol

        @test MOI.get(model, MOI.ConstraintPrimal(), c) ≈ 0.0 atol=atol rtol=rtol

        @test MOI.get(model, MOI.ObjectiveBound()) <= 3.0
    end

    MOI.set(model, MOI.ConstraintSet(), vc2, MOI.EqualTo(T(4)))

    if config.solve
        MOI.optimize!(model)

        @test MOI.get(model, MOI.TerminationStatus()) == MOI.INFEASIBLE ||
            MOI.get(model, MOI.TerminationStatus()) == MOI.INFEASIBLE_OR_UNBOUNDED
    end
end