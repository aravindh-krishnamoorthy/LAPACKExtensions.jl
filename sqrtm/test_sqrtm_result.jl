using LinearAlgebra
using BenchmarkTools

for iter = 1:1000
    println("$iter/1000...")
    for N in [8, 64, 1000]
            # Real _sqrt_quasi_triu!
            X = randn(N,N)
            X1 = MatrixAlgorithms.sqrtm(X)
            @assert X1*X1 ≈ X
            X1 = MatrixAlgorithms.sqrtm(X+X')
            @assert X1*X1 ≈ X+X'
            X1 = MatrixAlgorithms.sqrtm(X+N*I(N))
            @assert X1*X1 ≈ X+N*I(N)
            X1 = MatrixAlgorithms.sqrtm(X+X'+N*I(N))
            @assert X1*X1 ≈ X+X'+N*I(N)
            # Complex _sqrt_quasi_triu!
            X = complex.(randn(N,N),randn(N,N))
            X1 = MatrixAlgorithms.sqrtm(X)
            @assert X1*X1 ≈ X
            X1 = MatrixAlgorithms.sqrtm(X+X')
            @assert X1*X1 ≈ X+X'
            X1 = MatrixAlgorithms.sqrtm(X+N*I(N))
            @assert X1*X1 ≈ X+N*I(N)
            X1 = MatrixAlgorithms.sqrtm(X+X'+N*I(N))
            @assert X1*X1 ≈ X+X'+N*I(N)
            # Complex z_sqrt_quasi_triu!
            X = complex.(randn(N,N),randn(N,N))
            X1 = MatrixAlgorithms.sqrtm(X, MatrixAlgorithms.z_sqrt_quasi_triu!)
            @assert X1*X1 ≈ X
            X1 = MatrixAlgorithms.sqrtm(X+X', MatrixAlgorithms.z_sqrt_quasi_triu!)
            @assert X1*X1 ≈ X+X'
            X1 = MatrixAlgorithms.sqrtm(X+N*I(N), MatrixAlgorithms.z_sqrt_quasi_triu!)
            @assert X1*X1 ≈ X+N*I(N)
            X1 = MatrixAlgorithms.sqrtm(X+X'+N*I(N), MatrixAlgorithms.z_sqrt_quasi_triu!)
            @assert X1*X1 ≈ X+X'+N*I(N)
        end
    end
end
