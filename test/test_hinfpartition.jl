using RobustAndOptimalControl, ControlSystems

Gtrue = tf([11.2], [1, 0.12, 0])
M, wB, A = 1.5, 20.0, 1e-8
WS = tf([1 / M, wB], [1, wB * A])

WU = ss(1.0)

WT = []



P_test = let
    _A = [-2.0e-7 0.0 -22.4; 0.0 -0.12 0.0; 0.0 0.25 0.0]
    _B = [4.0 0.0; 0.0 8.0; 0.0 0.0]
    _C = [4.99999996666667 0.0 -3.73333333333333; 0.0 0.0 0.0; 0.0 0.0 -5.6]
    _D = [0.666666666666667 0.0; 0.0 1.0; 1.0 0.0]
    ss(_A, _B, _C, _D)
end

P = RobustAndOptimalControl.hinfpartition(Gtrue, WS, WU, WT)
@test tf(ss(P)) ≈ tf(P_test)

# P = RobustAndOptimalControl.hinfpartition2(Gtrue, WS, WU, WT)
# @test tf(ss(P)) ≈ tf(P_test)


## Flexible servo example

A = [
    -0.015948101119319734 0.0 0.04185849126302005 0.0
    0.0 -0.011069870050970518 0.0 0.03334113387614947
    0.0 0.0 -0.04185849126302005 0.0
    0.0 0.0 0.0 -0.03334113387614947
]
B = [0.08325 0.0; 0.0 0.0628125; 0.0 0.04785714285714286; 0.031218750000000007 0.0]
C = [0.5 0.0 0.0 0.0; 0.0 0.5 0.0 0.0]
D = [0.0 0.0; 0.0 0.0]
G = ss(A, B, C, D)


A = [-0.001 0.0; 0.0 -0.001]
B = [1.0 0.0; 0.0 1.0]
C = [0.0999 0.0; 0.0 0.0999]
D = [0.1 0.0; 0.0 0.1]
WS = ss(A, B, C, D)


D = [0.01 0.0; 0.0 0.01]
WU = ss(D)


A = [-1.0 0.0; 0.0 -1.0]
B = [1.0 0.0; 0.0 1.0]
C = [-9.9 0.0; 0.0 -9.9]
D = [10.0 0.0; 0.0 10.0]
WT = ss(A, B, C, D)

P_test = let
    _A = [
        -0.001 0.0 0.0 0.0 -0.5 0.0 0.0 0.0
        0.0 -0.001 0.0 0.0 0.0 -0.5 0.0 0.0
        0.0 0.0 -1.0 0.0 0.5 0.0 0.0 0.0
        0.0 0.0 0.0 -1.0 0.0 0.5 0.0 0.0
        0.0 0.0 0.0 0.0 -0.0159481011193197 0.0 0.04185849126302 0.0
        0.0 0.0 0.0 0.0 0.0 -0.0110698700509705 0.0 0.0333411338761495
        0.0 0.0 0.0 0.0 0.0 0.0 -0.04185849126302 0.0
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 -0.0333411338761495
    ]
    _B = [
        1.0 0.0 0.0 0.0
        0.0 1.0 0.0 0.0
        0.0 0.0 0.0 0.0
        0.0 0.0 0.0 0.0
        0.0 0.0 0.08325 0.0
        0.0 0.0 0.0 0.0628125
        0.0 0.0 0.0 0.0478571428571429
        0.0 0.0 0.03121875 0.0
    ]
    _C = [
        0.0999 0.0 0.0 0.0 -0.05 0.0 0.0 0.0
        0.0 0.0999 0.0 0.0 0.0 -0.05 0.0 0.0
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
        0.0 0.0 -9.9 0.0 5.0 0.0 0.0 0.0
        0.0 0.0 0.0 -9.9 0.0 5.0 0.0 0.0
        0.0 0.0 0.0 0.0 -0.5 0.0 0.0 0.0
        0.0 0.0 0.0 0.0 0.0 -0.5 0.0 0.0
    ]
    _D = [
        0.1 0.0 0.0 0.0
        0.0 0.1 0.0 0.0
        0.0 0.0 0.01 0.0
        0.0 0.0 0.0 0.01
        0.0 0.0 0.0 0.0
        0.0 0.0 0.0 0.0
        1.0 0.0 0.0 0.0
        0.0 1.0 0.0 0.0
    ]
    ss(_A, _B, _C, _D)
end

P = RobustAndOptimalControl.hinfpartition(G, WS, WU, WT)
@test_broken tf(ss(P)) ≈ tf(P_test)

# P = RobustAndOptimalControl.hinfpartition2(G, WS, WU, WT)
# @test tf(ss(P)) ≈ tf(P_test)
