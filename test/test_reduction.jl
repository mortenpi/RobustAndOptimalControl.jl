using RobustAndOptimalControl, ControlSystems

# example 19.1
A = [
    -1 0 4
    0 2 0
    0 0 -3
]
B1 = [
    0 0
    1 0
    0 0
]
C1 = B1'
B2 = [
    1
    1
    1
]
C2 = B2'
D11 = 0I(2)
D12 = [
    0
    1
]
D21 = D12'
D22 = 0I(1)

P = ExtendedStateSpace(A, B1, B2, C1, C2, D11, D12, D21, D22)
K = h2synthesize(P, 1000) # the example uses h2syn


K_matlab = let
    A = [-1.0 -4.236148004700622 4.0; -4.23607198996497 -6.472215758593602 -4.23607198996497; 0.0 -4.236148004700622 -3.0]
    B = [0.0; 4.23607198996497; 0.0]
    C = [0.0 -4.236148004700622 0.0]
    D = [0.0]
    sys = ss(A,B,C,D)
end
@test K ≈ K_matlab


Cl = lft(ss(P), K)

Cl_matlab = let
    A = [-1.0 0.0 4.0 0.0 -4.236148004700622 0.0; 0.0 2.0 0.0 0.0 -4.236148004700622 0.0; 0.0 0.0 -3.0 0.0 -4.236148004700622 0.0; 0.0 0.0 0.0 -1.0 -4.236148004700622 4.0; 4.23607198996497 4.23607198996497 4.23607198996497 -4.23607198996497 -6.472215758593602 -4.23607198996497; 0.0 0.0 0.0 0.0 -4.236148004700622 -3.0]
    B = [0.0 0.0; 1.0 0.0; 0.0 0.0; 0.0 0.0; 0.0 4.23607198996497; 0.0 0.0]
    C = [0.0 1.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 -4.236148004700622 0.0]
    D = [0.0 0.0; 0.0 0.0]
    ss(A,B,C,D)
end

@test Cl_matlab ≈ Cl