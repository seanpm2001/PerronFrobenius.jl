

@testset "Transfer operator from triangulations" begin
    # Embeddings
    E = embed([diff(rand(15)) for i = 1:3])
    E_invariant = invariantize(E)

    # Triangulations
    triang = triangulate(E)
    triang_inv = triangulate(E_invariant)

    # Transfer operators from *invariant* triangulations
    TO = transferoperator(triang_inv)
    TO_approx = transferoperator(triang_inv, exact = false, parallel = false)
    TO_approx_rand = transferoperator(triang_inv, exact = false, parallel = false, sample_randomly = true)
    TO_exact = transferoperator(triang_inv, exact = true, parallel = false)
    TO_exact_p = transferoperator(triang_inv, exact = true, parallel = true)

    @test typeof(TO) == ApproxSimplexTransferOperator #default = approx
    @test typeof(TO_approx) == ApproxSimplexTransferOperator
    @test typeof(TO_approx_rand) == ApproxSimplexTransferOperator
    @test typeof(TO_exact) == ExactSimplexTransferOperator
    @test typeof(TO_exact_p) == ExactSimplexTransferOperator

    @test all(TO_exact.TO .== TO_exact_p.TO)

    @test is_almostmarkov(TO)
    @test is_almostmarkov(TO_approx)
    @test is_almostmarkov(TO_approx_rand)
    @test is_almostmarkov(TO_exact)
    @test is_almostmarkov(TO_exact_p)

    @test is_markov(TO)
    @test is_markov(TO_approx)
    @test is_markov(TO_approx_rand)
    @test is_markov(TO_exact)
    @test is_markov(TO_exact_p)

    # Transfer operators from triangulations *not guaranteed to be invariant*
    TO = transferoperator(triang)
    TO_approx = transferoperator(triang, exact = false, parallel = false)
    TO_approx_rand = transferoperator(triang, exact = false, parallel = false, sample_randomly = true)
    TO_exact = transferoperator(triang, exact = true, parallel = false)
    TO_exact_p = transferoperator(triang, exact = true, parallel = true)

    @test typeof(TO) == ApproxSimplexTransferOperator #default = approx
    @test typeof(TO_approx) == ApproxSimplexTransferOperator
    @test typeof(TO_approx_rand) == ApproxSimplexTransferOperator
    @test typeof(TO_exact) == ExactSimplexTransferOperator
    @test typeof(TO_exact_p) == ExactSimplexTransferOperator

    @test all(TO_exact.TO .== TO_exact_p.TO)

    # We can no longer guarantee the transfer operator to be markov, but
    # we should at least not have row sums greater than one.


end