################################################################################
# This file is a part of the package: MatrixAlgorithms
# Released under the MIT license, see LICENSE file for details.
# Copyright (C) 2023 Aravindh Krishnamoorthy and contributors.
################################################################################

using LinearAlgebra
using Libdl

################################################################################
# Invert a positive definite matrix using the algorithm in
# "Matrix Inversion Using Cholesky Decomposition", by Aravindh Krishnamoorthy
#   and Deepak Menon, arXiv:1111.4144.
################################################################################
# Reference version
################################################################################
function potri2!(uplo::Char, X::AbstractMatrix{T}) where {T}
    n = size(X,1)
    d = diag(X)
    if uplo == 'U'
        for j = 1:n
            X[j,j] = 1/X[j,j]
            for i = j+1:n
                X[i,j] = 0
            end
        end
        for j = n:-1:1
            for k = n:-1:j+1
                for i=1:j
                    X[j,i] = X[j,i] - X[i,k]*X[k,j]
                end
            end
            for k = j:-1:1
                X[j,k] = conj(X[j,k]/d[k])
                for i = 1:k-1
                    X[j,i] = X[j,i] - X[i,k]*conj(X[j,k])
                end
            end
        end
        for i=1:n for j=i+1:n X[i,j] = X[j,i]' end end
        return X
    else # uplo == 'L'
        for j = 1:n
            X[j,j] = 1/X[j,j]
            for i = 1:j-1
                X[i,j] = 0
            end
        end
        for j = n:-1:1
            for k = n:-1:j+1
                for i = 1:j
                    X[i,j] = X[i,j] - X[k,i]*X[j,k]
                end
            end
            for k = j:-1:1
                X[k,j] = conj(X[k,j]/d[k])
                for i = 1:k-1
                    X[i,j] = X[i,j] - X[k,i]*conj(X[k,j])
                end
            end
        end
        for i=1:n for j=1:i-1 X[i,j] = X[j,i]' end end
        return X
    end
end

################################################################################
# Invert a positive definite matrix using the algorithm in
# "Matrix Inversion Using Cholesky Decomposition", by Aravindh Krishnamoorthy
#   and Deepak Menon, arXiv:1111.4144.
################################################################################
# Fortran version
################################################################################
function dpotri2!(uplo::Char, X::AbstractMatrix{T}; rl::Bool=true) where {T}
    # DPOTRI2(UPLO, N, A, LDA, INFO)
    N = size(X,1)
    INFO = Ref{Int64}()
    if rl == true
        lib = Libdl.dlopen("./potri2.so")
        dpotri2 = Libdl.dlsym(lib, :dpotri2_)
        ccall(dpotri2, Cvoid,
            (Ref{UInt8}, Ref{Int64}, Ptr{Float64}, Ref{Int64}, Ptr{Int64}, Clong),
            uplo, N, X, N, INFO, 1)
    else
        ccall((:dpotri2_, "./potri2.so"), Cvoid,
            (Ref{UInt8}, Ref{Int64}, Ptr{Float64}, Ref{Int64}, Ptr{Int64}, Clong),
            uplo, N, X, N, INFO, 1)
    end
    
    if rl == true
        Libdl.dlclose(lib)
    end
    return X
end
