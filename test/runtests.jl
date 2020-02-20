using Test

@testset "$(folder)" for folder in [
    "MathOptInterface",
]
    @testset "$(file)" for file in readdir(folder)
        include(joinpath(folder, file))
    end
end
