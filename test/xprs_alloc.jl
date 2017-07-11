using Xpress

M = 3000
N = 2000
A = rand(M,N)
b = rand(M)
f = rand(N)
lb = zeros(N)

for i in 1:4000
    if mod(i,10) == 0
        @show i
    end
    model = Xpress.xpress_model(
        name="lp_02", 
        sense=:maximize, 
        f = f,
        A = A, 
        b = b, 
        lb = lb,
        finalize_env = true)
end