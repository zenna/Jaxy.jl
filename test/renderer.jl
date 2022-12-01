using Jaxy
using RayTrace
import Base.vect
import RayTrace: Sphere, Vec3, FancySphere, Intersection, ListScene
function r(arg1, arg2, arg3)
    out1 = arg1 - 0.0
    out2 = arg2 - 0.0
    out3 = arg3 - 0.0
    out4 = out1 * 0.23968096505675238
    out5 = out2 * -0.23968096505675238
    out6 = out3 * -0.9408007599799905
    out7 = out4 + out5
    out8 = out7 + out6
    out9 = out1 * out1
    out10 = out2 * out2
    out11 = out3 * out3
    out12 = out9 + out10
    out13 = out12 + out11
    out14 = out8 * out8
    out15 = out13 - out14
    out16 = isless(out8, 0)
    out17 = isless(16.0, out15)
    out18 = vect(out15, 4.0)
    out19 = vect(out15, out8, 16.0)
    out20 = cond(out17, function (arg1, arg2)
                out1 = arg2 - arg1
                out2 = tuple(out1, 0.0, 0.0)
                out2
            end, function ()
            end, out18, out19)
    out21 = tuple(out8, 0.0, 0.0)
    out22 = ifelse(out16, out21, out20)
    out23 = isless(0.0, -23.85113425474131)
    out24 = isless(0.0, 0.0)
    out25 = out23 & out24
    out26 = ifelse(out25, Inf, 0.0)
    out27 = isless(0.0, -23.85113425474131)
    out28 = isless(out26, 16.696035517812106)
    out29 = out27 & out28
    out30 = ifelse(out29, out26, 16.696035517812106)
    out31 = isless(0.0, -23.85113425474131)
    out32 = isless(out26, out30)
    out33 = out31 & out32
    out34 = vect(arg1, arg2, arg3)
    out35 = FancySphere(out34, 4.0, [1.0, 0.32, 0.36], 1.0, 0.5, [0.0, 0.0, 0.0])
    out36 = ifelse(out33, out35, FancySphere{Vector{Float64}, Float64, Vector{Float64}, Float64, Float64, Vector{Float64}}([0.0, -10004.0, -20.0], 10000.0, [0.2, 0.2, 0.2], 0.0, 0.0, [0.0, 0.0, 0.0]))
    out37 = isless(0.0, -23.85113425474131)
    out38 = isless(out26, out30)
    out39 = out37 & out38
    out40 = ifelse(out39, true, false)
    out41 = [0.23968096505675238, -0.23968096505675238, -0.9408007599799905] * out30
    out42 = [0.0, 0.0, 0.0] + out41
    out43 = map(function (arg1, arg2)
                out1 = arg1 - arg2
                out1
            end, out42, [0.0, -10004.0, -20.0])
    out44 = map(function (arg1, arg2)
                out1 = arg1 * arg2
                out1
            end, out43, out43)
    out45 = 16.013778209206816 + 9.999996556189233e7
    out46 = out45 + 18.42432944120799
    out47 = sqrt(out46)
    out48 = out43 / out47
    out49 = map(function (arg1, arg2)
                out1 = arg1 * arg2
                out1
            end, [0.23968096505675238, -0.23968096505675238, -0.9408007599799905], out48)
    out50 = 9.591365682064208e-5 + -0.23968092378595443
    out51 = out50 + -0.0004038252818200546
    out52 = map(function (arg1, arg2)
                out1 = arg1 * arg2
                out1
            end, [0.23968096505675238, -0.23968096505675238, -0.9408007599799905], out48)
    out53 = 9.591365682064208e-5 + -0.23968092378595443
    out54 = out53 + -0.0004038252818200546
    out55 = isless(0.0, out54)
    out56 = -out48
    out57 = ifelse(out55, out56, out48)
    out58 = isless(0.0, 0.0)
    out59 = isless(0.0, 0.0)
    out60 = out58 | out59
    out61 = out60 & true
    out62 = vect(arg1, arg2, arg3)
    out63 = FancySphere(out62, 4.0, [1.0, 0.32, 0.36], 1.0, 0.5, [0.0, 0.0, 0.0])
    out64 = vect(FancySphere{Vector{Float64}, Float64, Vector{Float64}, Float64, Float64, Vector{Float64}}([0.0, -10004.0, -20.0], 10000.0, [0.2, 0.2, 0.2], 0.0, 0.0, [0.0, 0.0, 0.0]), out63)
    out65 = ListScene(out64)
    out66 = vect(arg1, arg2, arg3)
    out67 = FancySphere(out66, 4.0, [1.0, 0.32, 0.36], 1.0, 0.5, [0.0, 0.0, 0.0])
    out68 = vect(FancySphere{Vector{Float64}, Float64, Vector{Float64}, Float64, Float64, Vector{Float64}}([0.0, -10004.0, -20.0], 10000.0, [0.2, 0.2, 0.2], 0.0, 0.0, [0.0, 0.0, 0.0]), out67)
    out69 = ListScene(out68)
    out70 = vect(out65, out36, out42, out57, 0.0001, RayTrace.Ray{Vector{Float64}, Vector{Float64}}([0.0, 0.0, 0.0], [0.23968096505675238, -0.23968096505675238, -0.9408007599799905]), [1.0, 1.0, 1.0])
    out71 = vect(out69, out36, out42, out57, 0.0001)
    out72 = cond(out61, function ()
            end, function (arg1, arg2, arg3, arg4, arg5)
                out1 = [0.0, -10004.0, -20.0] - arg3
                out2 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out1, out1)
                out3 = 16.013778209206816 + 9.999996556189233e7
                out4 = out3 + 18.42432944120799
                out5 = sqrt(out4)
                out6 = out1 / out5
                out7 = arg4 * arg5
                out8 = arg3 + out7
                out9 = map(function (arg1, arg2)
                            out1 = arg1 - arg2
                            out1
                        end, [0.0, -10004.0, -20.0], out8)
                out10 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out9, out6)
                out11 = 0.0016013778369344596 + 9999.9966561892
                out12 = out11 + 0.0018424329625451282
                out13 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out9, out9)
                out14 = 16.01377852948238 + 9.999996756189166e7
                out15 = out14 + 18.424329809694576
                out16 = out12 * out12
                out17 = out15 - out16
                out18 = 10000.0 * 10000.0
                out19 = isless(out12, 0)
                out20 = isless(out18, out17)
                out21 = vect(out17, 10000.0)
                out22 = vect(out17, out12, out18)
                out23 = cond(out20, function ()
                        end, function (arg1, arg2, arg3)
                            out1 = arg3 - arg1
                            out2 = sqrt(out1)
                            out3 = arg3 - arg1
                            out4 = arg2 - out2
                            out5 = arg2 + out2
                            out6 = tuple(out3, out4, out5)
                            out6
                        end, out21, out22)
                out24 = tuple(out12, 0.0, 0.0)
                out25 = ifelse(out19, out24, out23)
                out26 = isless(0, 1.0000000000000001e8)
                out27 = false & out26
                out28 = ifelse(out27, 0.0, 1.0)
                out29 = arg4 * arg5
                out30 = arg3 + out29
                out31 = map(function (arg1, arg2)
                            out1 = arg1 - arg2
                            out1
                        end, [1.0, 1.0, -15.0], out30)
                out32 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out31, out6)
                out33 = 0.0012012056463813576 + -5.001621044316197
                out34 = out33 + -0.0003037455855496004
                out35 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out31, out31)
                out36 = 9.010334638385903 + 25.01622168606
                out37 = out36 + 0.5007584185642988
                out38 = out34 * out34
                out39 = out37 - out38
                out40 = 4.0 * 4.0
                out41 = isless(out34, 0)
                out42 = isless(out40, out39)
                out43 = vect(out39, 4.0)
                out44 = vect(out39, out34, out40)
                out45 = cond(out42, function ()
                        end, function (arg1, arg2, arg3)
                            out1 = arg3 - arg1
                            out2 = sqrt(out1)
                            out3 = arg3 - arg1
                            out4 = arg2 - out2
                            out5 = arg2 + out2
                            out6 = tuple(out3, out4, out5)
                            out6
                        end, out43, out44)
                out46 = tuple(out34, 0.0, 0.0)
                out47 = ifelse(out41, out46, out45)
                out48 = isless(0, -5.000723584255365)
                out49 = true & out48
                out50 = ifelse(out49, 0.0, out28)
                out51 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, arg4, out6)
                out52 = -1.6013778209206814e-7 + -0.9999996556189233
                out53 = out52 + -1.8424329441207989e-7
                out54 = isless(out53, 0)
                out55 = ifelse(out54, 0, out53)
                out56 = [0.2, 0.2, 0.2] * out50
                out57 = out56 * out55
                out58 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out57, [0.0, 0.0, 0.0])
                out59 = [0.0, 0.0, 0.0] + out58
                out60 = [1.0, 1.0, -15.0] - arg3
                out61 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out60, out60)
                out62 = 9.010334398144776 + 25.017222020268857
                out63 = out62 + 0.500758479313417
                out64 = sqrt(out63)
                out65 = out60 / out64
                out66 = arg4 * arg5
                out67 = arg3 + out66
                out68 = map(function (arg1, arg2)
                            out1 = arg1 - arg2
                            out1
                        end, [0.0, -10004.0, -20.0], out67)
                out69 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out68, out65)
                out70 = 2.0442295960020442 + -8512.003216749976
                out71 = out70 + -0.5169187835966221
                out72 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out68, out68)
                out73 = 16.01377852948238 + 9.999996756189166e7
                out74 = out73 + 18.424329809694576
                out75 = out71 * out71
                out76 = out74 - out75
                out77 = 10000.0 * 10000.0
                out78 = isless(out71, 0)
                out79 = isless(out77, out76)
                out80 = vect(out76, 10000.0)
                out81 = vect(out76, out71, out77)
                out82 = cond(out79, function ()
                        end, function (arg1, arg2, arg3)
                            out1 = arg3 - arg1
                            out2 = sqrt(out1)
                            out3 = arg3 - arg1
                            out4 = arg2 - out2
                            out5 = arg2 + out2
                            out6 = tuple(out3, out4, out5)
                            out6
                        end, out80, out81)
                out83 = tuple(out71, 0.0, 0.0)
                out84 = ifelse(out78, out83, out82)
                out85 = isless(0, -8510.47590593757)
                out86 = true & out85
                out87 = ifelse(out86, 0.0, 1.0)
                out88 = arg4 * arg5
                out89 = arg3 + out88
                out90 = map(function (arg1, arg2)
                            out1 = arg1 - arg2
                            out1
                        end, [1.0, 1.0, -15.0], out89)
                out91 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out90, out65)
                out92 = 1.5333921055871564 + 4.257382865406665
                out93 = out92 + 0.08521981629564847
                out94 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out90, out90)
                out95 = 9.010334638385903 + 25.01622168606
                out96 = out95 + 0.5007584185642988
                out97 = out93 * out93
                out98 = out96 - out97
                out99 = 4.0 * 4.0
                out100 = isless(out93, 0)
                out101 = isless(out99, out98)
                out102 = vect(out98, 4.0)
                out103 = vect(out98, out93, out99)
                out104 = cond(out101, function ()
                        end, function (arg1, arg2, arg3)
                            out1 = arg3 - arg1
                            out2 = sqrt(out1)
                            out3 = arg3 - arg1
                            out4 = arg2 - out2
                            out5 = arg2 + out2
                            out6 = tuple(out3, out4, out5)
                            out6
                        end, out102, out103)
                out105 = tuple(out93, 0.0, 0.0)
                out106 = ifelse(out100, out105, out104)
                out107 = isless(0, 15.999999997242817)
                out108 = false & out107
                out109 = ifelse(out108, 0.0, out87)
                out110 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, arg4, out65)
                out111 = -0.00020442295755597484 + 0.8512003131629945
                out112 = out111 + 5.1691877842743446e-5
                out113 = isless(out112, 0)
                out114 = ifelse(out113, 0, out112)
                out115 = [0.2, 0.2, 0.2] * out109
                out116 = out115 * out114
                out117 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out116, [0.0, 0.0, 0.0])
                out118 = out59 + out117
                out118
            end, out70, out71)
    out73 = !out40
    out74 = out72 + [0.0, 0.0, 0.0]
    out75 = ifelse(out73, [1.0, 1.0, 1.0], out74)
    out76 = arg1 - 0.0
    out77 = arg2 - 0.0
    out78 = arg3 - 0.0
    out79 = out76 * 0.5951706195734227
    out80 = out77 * -0.19839020652447426
    out81 = out78 * -0.7787254070285394
    out82 = out79 + out80
    out83 = out82 + out81
    out84 = out76 * out76
    out85 = out77 * out77
    out86 = out78 * out78
    out87 = out84 + out85
    out88 = out87 + out86
    out89 = out83 * out83
    out90 = out88 - out89
    out91 = isless(out83, 0)
    out92 = isless(16.0, out90)
    out93 = vect(out90, 4.0)
    out94 = vect(out90, out83, 16.0)
    out95 = cond(out92, function (arg1, arg2)
                out1 = arg2 - arg1
                out2 = tuple(out1, 0.0, 0.0)
                out2
            end, function ()
            end, out93, out94)
    out96 = tuple(out83, 0.0, 0.0)
    out97 = ifelse(out91, out96, out95)
    out98 = isless(0.0, -77.1300922450989)
    out99 = isless(0.0, 0.0)
    out100 = out98 & out99
    out101 = ifelse(out100, Inf, 0.0)
    out102 = isless(0.0, -77.1300922450989)
    out103 = isless(out101, 20.203314677754406)
    out104 = out102 & out103
    out105 = ifelse(out104, out101, 20.203314677754406)
    out106 = isless(0.0, -77.1300922450989)
    out107 = isless(out101, out105)
    out108 = out106 & out107
    out109 = vect(arg1, arg2, arg3)
    out110 = FancySphere(out109, 4.0, [1.0, 0.32, 0.36], 1.0, 0.5, [0.0, 0.0, 0.0])
    out111 = ifelse(out108, out110, FancySphere{Vector{Float64}, Float64, Vector{Float64}, Float64, Float64, Vector{Float64}}([0.0, -10004.0, -20.0], 10000.0, [0.2, 0.2, 0.2], 0.0, 0.0, [0.0, 0.0, 0.0]))
    out112 = isless(0.0, -77.1300922450989)
    out113 = isless(out101, out105)
    out114 = out112 & out113
    out115 = ifelse(out114, true, false)
    out116 = [0.5951706195734227, -0.19839020652447426, -0.7787254070285394] * out105
    out117 = [0.0, 0.0, 0.0] + out116
    out118 = map(function (arg1, arg2)
                out1 = arg1 - arg2
                out1
            end, out117, [0.0, -10004.0, -20.0])
    out119 = map(function (arg1, arg2)
                out1 = arg1 * arg2
                out1
            end, out118, out118)
    out120 = 144.58665984360772 + 9.999983720463829e7
    out121 = out120 + 18.20870186729267
    out122 = sqrt(out121)
    out123 = out118 / out122
    out124 = map(function (arg1, arg2)
                out1 = arg1 * arg2
                out1
            end, [0.5951706195734227, -0.19839020652447426, -0.7787254070285394], out123)
    out125 = 0.0007156581093240613 + -0.19839004503938137
    out126 = out125 + -0.0003322950233083735
    out127 = map(function (arg1, arg2)
                out1 = arg1 * arg2
                out1
            end, [0.5951706195734227, -0.19839020652447426, -0.7787254070285394], out123)
    out128 = 0.0007156581093240613 + -0.19839004503938137
    out129 = out128 + -0.0003322950233083735
    out130 = isless(0.0, out129)
    out131 = -out123
    out132 = ifelse(out130, out131, out123)
    out133 = isless(0.0, 0.0)
    out134 = isless(0.0, 0.0)
    out135 = out133 | out134
    out136 = out135 & true
    out137 = vect(arg1, arg2, arg3)
    out138 = FancySphere(out137, 4.0, [1.0, 0.32, 0.36], 1.0, 0.5, [0.0, 0.0, 0.0])
    out139 = vect(FancySphere{Vector{Float64}, Float64, Vector{Float64}, Float64, Float64, Vector{Float64}}([0.0, -10004.0, -20.0], 10000.0, [0.2, 0.2, 0.2], 0.0, 0.0, [0.0, 0.0, 0.0]), out138)
    out140 = ListScene(out139)
    out141 = vect(arg1, arg2, arg3)
    out142 = FancySphere(out141, 4.0, [1.0, 0.32, 0.36], 1.0, 0.5, [0.0, 0.0, 0.0])
    out143 = vect(FancySphere{Vector{Float64}, Float64, Vector{Float64}, Float64, Float64, Vector{Float64}}([0.0, -10004.0, -20.0], 10000.0, [0.2, 0.2, 0.2], 0.0, 0.0, [0.0, 0.0, 0.0]), out142)
    out144 = ListScene(out143)
    out145 = vect(out140, out111, out117, out132, 0.0001, RayTrace.Ray{Vector{Float64}, Vector{Float64}}([0.0, 0.0, 0.0], [0.5951706195734227, -0.19839020652447426, -0.7787254070285394]), [1.0, 1.0, 1.0])
    out146 = vect(out144, out111, out117, out132, 0.0001)
    out147 = cond(out136, function ()
            end, function (arg1, arg2, arg3, arg4, arg5)
                out1 = [0.0, -10004.0, -20.0] - arg3
                out2 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out1, out1)
                out3 = 144.58665984360772 + 9.999983720463829e7
                out4 = out3 + 18.20870186729267
                out5 = sqrt(out4)
                out6 = out1 / out5
                out7 = arg4 * arg5
                out8 = arg3 + out7
                out9 = map(function (arg1, arg2)
                            out1 = arg1 - arg2
                            out1
                        end, [0.0, -10004.0, -20.0], out8)
                out10 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out9, out6)
                out11 = 0.014458666128947435 + 9999.983820463667
                out12 = out11 + 0.0018208702049379692
                out13 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out9, out9)
                out14 = 144.58666273534095 + 9.999983920463505e7
                out15 = out14 + 18.208702231466717
                out16 = out12 * out12
                out17 = out15 - out16
                out18 = 10000.0 * 10000.0
                out19 = isless(out12, 0)
                out20 = isless(out18, out17)
                out21 = vect(out17, 10000.0)
                out22 = vect(out17, out12, out18)
                out23 = cond(out20, function ()
                        end, function (arg1, arg2, arg3)
                            out1 = arg3 - arg1
                            out2 = sqrt(out1)
                            out3 = arg3 - arg1
                            out4 = arg2 - out2
                            out5 = arg2 + out2
                            out6 = tuple(out3, out4, out5)
                            out6
                        end, out21, out22)
                out24 = tuple(out12, 0.0, 0.0)
                out25 = ifelse(out19, out24, out23)
                out26 = isless(0, 1.0e8)
                out27 = false & out26
                out28 = ifelse(out27, 0.0, 1.0)
                out29 = arg4 * arg5
                out30 = arg3 + out29
                out31 = map(function (arg1, arg2)
                            out1 = arg1 - arg2
                            out1
                        end, [1.0, 1.0, -15.0], out30)
                out32 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out31, out6)
                out33 = 0.013256224197527842 + -5.008035695050147
                out34 = out33 + -0.0003127125721820486
                out35 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out31, out31)
                out36 = 121.53782386646073 + 25.080462352725817
                out37 = out36 + 0.5370462623497968
                out38 = out34 * out34
                out39 = out37 - out38
                out40 = 4.0 * 4.0
                out41 = isless(out34, 0)
                out42 = isless(out40, out39)
                out43 = vect(out39, 4.0)
                out44 = vect(out39, out34, out40)
                out45 = cond(out42, function (arg1, arg2)
                            out1 = arg2 - arg1
                            out2 = tuple(out1, 0.0, 0.0)
                            out2
                        end, function ()
                        end, out43, out44)
                out46 = tuple(out34, 0.0, 0.0)
                out47 = ifelse(out41, out46, out45)
                out48 = isless(0, -4.9950921834248)
                out49 = true & out48
                out50 = ifelse(out49, 0.0, out28)
                out51 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, arg4, out6)
                out52 = -1.4458665984360775e-6 + -0.999998372046383
                out53 = out52 + -1.820870186729267e-7
                out54 = isless(out53, 0)
                out55 = ifelse(out54, 0, out53)
                out56 = [0.2, 0.2, 0.2] * out50
                out57 = out56 * out55
                out58 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out57, [0.0, 0.0, 0.0])
                out59 = [0.0, 0.0, 0.0] + out58
                out60 = [1.0, 1.0, -15.0] - arg3
                out61 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out60, out60)
                out62 = 121.5378212152159 + 25.081463969864814
                out63 = out62 + 0.5370463248923143
                out64 = sqrt(out63)
                out65 = out60 / out64
                out66 = arg4 * arg5
                out67 = arg3 + out66
                out68 = map(function (arg1, arg2)
                            out1 = arg1 - arg2
                            out1
                        end, [0.0, -10004.0, -20.0], out67)
                out69 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out68, out65)
                out70 = 10.927740260667166 + -4128.446067699221
                out71 = out70 + -0.2577839624906113
                out72 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out68, out68)
                out73 = 144.58666273534095 + 9.999983920463505e7
                out74 = out73 + 18.208702231466717
                out75 = out71 * out71
                out76 = out74 - out75
                out77 = 10000.0 * 10000.0
                out78 = isless(out71, 0)
                out79 = isless(out77, out76)
                out80 = vect(out76, 10000.0)
                out81 = vect(out76, out71, out77)
                out82 = cond(out79, function ()
                        end, function (arg1, arg2, arg3)
                            out1 = arg3 - arg1
                            out2 = sqrt(out1)
                            out3 = arg3 - arg1
                            out4 = arg2 - out2
                            out5 = arg2 + out2
                            out6 = tuple(out3, out4, out5)
                            out6
                        end, out80, out81)
                out83 = tuple(out71, 0.0, 0.0)
                out84 = ifelse(out78, out83, out82)
                out85 = isless(0, -4117.7761114010455)
                out86 = true & out85
                out87 = ifelse(out86, 0.0, 1.0)
                out88 = arg4 * arg5
                out89 = arg3 + out88
                out90 = map(function (arg1, arg2)
                            out1 = arg1 - arg2
                            out1
                        end, [1.0, 1.0, -15.0], out89)
                out91 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out90, out65)
                out92 = 10.018944595292407 + 2.067543872402832
                out93 = out92 + 0.044271297184779825
                out94 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out90, out90)
                out95 = 121.53782386646073 + 25.080462352725817
                out96 = out95 + 0.5370462623497968
                out97 = out93 * out93
                out98 = out96 - out97
                out99 = 4.0 * 4.0
                out100 = isless(out93, 0)
                out101 = isless(out99, out98)
                out102 = vect(out98, 4.0)
                out103 = vect(out98, out93, out99)
                out104 = cond(out101, function ()
                        end, function (arg1, arg2, arg3)
                            out1 = arg3 - arg1
                            out2 = sqrt(out1)
                            out3 = arg3 - arg1
                            out4 = arg2 - out2
                            out5 = arg2 + out2
                            out6 = tuple(out3, out4, out5)
                            out6
                        end, out102, out103)
                out105 = tuple(out93, 0.0, 0.0)
                out106 = ifelse(out100, out105, out104)
                out107 = isless(0, 15.999999991695574)
                out108 = false & out107
                out109 = ifelse(out108, 0.0, out87)
                out110 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, arg4, out65)
                out111 = -0.0010927740151389764 + 0.4128446026414761
                out112 = out111 + 2.5778395991277163e-5
                out113 = isless(out112, 0)
                out114 = ifelse(out113, 0, out112)
                out115 = [0.2, 0.2, 0.2] * out109
                out116 = out115 * out114
                out117 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out116, [0.0, 0.0, 0.0])
                out118 = out59 + out117
                out118
            end, out145, out146)
    out148 = !out115
    out149 = out147 + [0.0, 0.0, 0.0]
    out150 = ifelse(out148, [1.0, 1.0, 1.0], out149)
    out151 = arg1 - 0.0
    out152 = arg2 - 0.0
    out153 = arg3 - 0.0
    out154 = out151 * 0.19839020652447426
    out155 = out152 * -0.5951706195734227
    out156 = out153 * -0.7787254070285394
    out157 = out154 + out155
    out158 = out157 + out156
    out159 = out151 * out151
    out160 = out152 * out152
    out161 = out153 * out153
    out162 = out159 + out160
    out163 = out162 + out161
    out164 = out158 * out158
    out165 = out163 - out164
    out166 = isless(out158, 0)
    out167 = isless(16.0, out165)
    out168 = vect(out165, 4.0)
    out169 = vect(out165, out158, 16.0)
    out170 = cond(out167, function (arg1, arg2)
                out1 = arg2 - arg1
                out2 = tuple(out1, 0.0, 0.0)
                out2
            end, function ()
            end, out168, out169)
    out171 = tuple(out158, 0.0, 0.0)
    out172 = ifelse(out166, out171, out170)
    out173 = isless(0.0, -95.66907156424851)
    out174 = isless(0.0, 0.0)
    out175 = out173 & out174
    out176 = ifelse(out175, Inf, 0.0)
    out177 = isless(0.0, -95.66907156424851)
    out178 = isless(out176, 6.739194364073228)
    out179 = out177 & out178
    out180 = ifelse(out179, out176, 6.739194364073228)
    out181 = isless(0.0, -95.66907156424851)
    out182 = isless(out176, out180)
    out183 = out181 & out182
    out184 = vect(arg1, arg2, arg3)
    out185 = FancySphere(out184, 4.0, [1.0, 0.32, 0.36], 1.0, 0.5, [0.0, 0.0, 0.0])
    out186 = ifelse(out183, out185, FancySphere{Vector{Float64}, Float64, Vector{Float64}, Float64, Float64, Vector{Float64}}([0.0, -10004.0, -20.0], 10000.0, [0.2, 0.2, 0.2], 0.0, 0.0, [0.0, 0.0, 0.0]))
    out187 = isless(0.0, -95.66907156424851)
    out188 = isless(out176, out180)
    out189 = out187 & out188
    out190 = ifelse(out189, true, false)
    out191 = [0.19839020652447426, -0.5951706195734227, -0.7787254070285394] * out180
    out192 = [0.0, 0.0, 0.0] + out191
    out193 = map(function (arg1, arg2)
                out1 = arg1 - arg2
                out1
            end, out192, [0.0, -10004.0, -20.0])
    out194 = map(function (arg1, arg2)
                out1 = arg1 * arg2
                out1
            end, out193, out193)
    out195 = 1.787542692474732 + 9.999978059041853e7
    out196 = out195 + 217.6220387837145
    out197 = sqrt(out196)
    out198 = out193 / out197
    out199 = map(function (arg1, arg2)
                out1 = arg1 * arg2
                out1
            end, [0.19839020652447426, -0.5951706195734227, -0.7787254070285394], out198)
    out200 = 2.6524575430027004e-5 + -0.5951699666423818
    out201 = out200 + -0.0011487771319500261
    out202 = map(function (arg1, arg2)
                out1 = arg1 * arg2
                out1
            end, [0.19839020652447426, -0.5951706195734227, -0.7787254070285394], out198)
    out203 = 2.6524575430027004e-5 + -0.5951699666423818
    out204 = out203 + -0.0011487771319500261
    out205 = isless(0.0, out204)
    out206 = -out198
    out207 = ifelse(out205, out206, out198)
    out208 = isless(0.0, 0.0)
    out209 = isless(0.0, 0.0)
    out210 = out208 | out209
    out211 = out210 & true
    out212 = vect(arg1, arg2, arg3)
    out213 = FancySphere(out212, 4.0, [1.0, 0.32, 0.36], 1.0, 0.5, [0.0, 0.0, 0.0])
    out214 = vect(FancySphere{Vector{Float64}, Float64, Vector{Float64}, Float64, Float64, Vector{Float64}}([0.0, -10004.0, -20.0], 10000.0, [0.2, 0.2, 0.2], 0.0, 0.0, [0.0, 0.0, 0.0]), out213)
    out215 = ListScene(out214)
    out216 = vect(arg1, arg2, arg3)
    out217 = FancySphere(out216, 4.0, [1.0, 0.32, 0.36], 1.0, 0.5, [0.0, 0.0, 0.0])
    out218 = vect(FancySphere{Vector{Float64}, Float64, Vector{Float64}, Float64, Float64, Vector{Float64}}([0.0, -10004.0, -20.0], 10000.0, [0.2, 0.2, 0.2], 0.0, 0.0, [0.0, 0.0, 0.0]), out217)
    out219 = ListScene(out218)
    out220 = vect(out215, out186, out192, out207, 0.0001, RayTrace.Ray{Vector{Float64}, Vector{Float64}}([0.0, 0.0, 0.0], [0.19839020652447426, -0.5951706195734227, -0.7787254070285394]), [1.0, 1.0, 1.0])
    out221 = vect(out219, out186, out192, out207, 0.0001)
    out222 = cond(out211, function ()
            end, function (arg1, arg2, arg3, arg4, arg5)
                out1 = [0.0, -10004.0, -20.0] - arg3
                out2 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out1, out1)
                out3 = 1.787542692474732 + 9.999978059041853e7
                out4 = out3 + 217.6220387837145
                out5 = sqrt(out4)
                out6 = out1 / out5
                out7 = arg4 * arg5
                out8 = arg3 + out7
                out9 = map(function (arg1, arg2)
                            out1 = arg1 - arg2
                            out1
                        end, [0.0, -10004.0, -20.0], out8)
                out10 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out9, out6)
                out11 = 0.0001787542710350159 + 9999.978159041633
                out12 = out11 + 0.021762204095993488
                out13 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out9, out9)
                out14 = 1.787542728225586 + 9.999978259041415e7
                out15 = out14 + 217.62204313615527
                out16 = out12 * out12
                out17 = out15 - out16
                out18 = 10000.0 * 10000.0
                out19 = isless(out12, 0)
                out20 = isless(out18, out17)
                out21 = vect(out17, 10000.0)
                out22 = vect(out17, out12, out18)
                out23 = cond(out20, function ()
                        end, function (arg1, arg2, arg3)
                            out1 = arg3 - arg1
                            out2 = sqrt(out1)
                            out3 = arg3 - arg1
                            out4 = arg2 - out2
                            out5 = arg2 + out2
                            out6 = tuple(out3, out4, out5)
                            out6
                        end, out21, out22)
                out24 = tuple(out12, 0.0, 0.0)
                out25 = ifelse(out19, out24, out23)
                out26 = isless(0, 1.0000000000000001e8)
                out27 = false & out26
                out28 = ifelse(out27, 0.0, 1.0)
                out29 = arg4 * arg5
                out30 = arg3 + out29
                out31 = map(function (arg1, arg2)
                            out1 = arg1 - arg2
                            out1
                        end, [1.0, 1.0, -15.0], out30)
                out32 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out31, out6)
                out33 = 4.505525486530985e-5 + -5.01086498803289
                out34 = out33 + 0.014386195033097168
                out35 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out31, out31)
                out36 = 0.11356237809166181 + 25.108823019457358
                out37 = out36 + 95.1018604030271
                out38 = out34 * out34
                out39 = out37 - out38
                out40 = 4.0 * 4.0
                out41 = isless(out34, 0)
                out42 = isless(out40, out39)
                out43 = vect(out39, 4.0)
                out44 = vect(out39, out34, out40)
                out45 = cond(out42, function (arg1, arg2)
                            out1 = arg2 - arg1
                            out2 = tuple(out1, 0.0, 0.0)
                            out2
                        end, function ()
                        end, out43, out44)
                out46 = tuple(out34, 0.0, 0.0)
                out47 = ifelse(out41, out46, out45)
                out48 = isless(0, -4.996433737744927)
                out49 = true & out48
                out50 = ifelse(out49, 0.0, out28)
                out51 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, arg4, out6)
                out52 = -1.787542692474732e-8 + -0.9999978059041852
                out53 = out52 + -2.1762203878371446e-6
                out54 = isless(out53, 0)
                out55 = ifelse(out54, 0, out53)
                out56 = [0.2, 0.2, 0.2] * out50
                out57 = out56 * out55
                out58 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out57, [0.0, 0.0, 0.0])
                out59 = [0.0, 0.0, 0.0] + out58
                out60 = [1.0, 1.0, -15.0] - arg3
                out61 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out60, out60)
                out62 = 0.113562369080611 + 25.109825202454946
                out63 = out62 + 95.10185752578812
                out64 = sqrt(out63)
                out65 = out60 / out64
                out66 = arg4 * arg5
                out67 = arg3 + out66
                out68 = map(function (arg1, arg2)
                            out1 = arg1 - arg2
                            out1
                        end, [0.0, -10004.0, -20.0], out67)
                out69 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out68, out65)
                out70 = 0.04107400582258538 + -4568.177760115301
                out71 = out70 + 13.114977927118922
                out72 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out68, out68)
                out73 = 1.787542728225586 + 9.999978259041415e7
                out74 = out73 + 217.62204313615527
                out75 = out71 * out71
                out76 = out74 - out75
                out77 = 10000.0 * 10000.0
                out78 = isless(out71, 0)
                out79 = isless(out77, out76)
                out80 = vect(out76, 10000.0)
                out81 = vect(out76, out71, out77)
                out82 = cond(out79, function ()
                        end, function (arg1, arg2, arg3)
                            out1 = arg3 - arg1
                            out2 = sqrt(out1)
                            out3 = arg3 - arg1
                            out4 = arg2 - out2
                            out5 = arg2 + out2
                            out6 = tuple(out3, out4, out5)
                            out6
                        end, out80, out81)
                out83 = tuple(out71, 0.0, 0.0)
                out84 = ifelse(out78, out83, out82)
                out85 = isless(0, -4555.021708182359)
                out86 = true & out85
                out87 = ifelse(out86, 0.0, 1.0)
                out88 = arg4 * arg5
                out89 = arg3 + out88
                out90 = map(function (arg1, arg2)
                            out1 = arg1 - arg2
                            out1
                        end, [1.0, 1.0, -15.0], out89)
                out91 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out90, out65)
                out92 = 0.010352758510107396 + 2.289057199247526
                out93 = out92 + 8.669830936335766
                out94 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out90, out90)
                out95 = 0.11356237809166181 + 25.108823019457358
                out96 = out95 + 95.1018604030271
                out97 = out93 * out93
                out98 = out96 - out97
                out99 = 4.0 * 4.0
                out100 = isless(out93, 0)
                out101 = isless(out99, out98)
                out102 = vect(out98, 4.0)
                out103 = vect(out98, out93, out99)
                out104 = cond(out101, function ()
                        end, function (arg1, arg2, arg3)
                            out1 = arg3 - arg1
                            out2 = sqrt(out1)
                            out3 = arg3 - arg1
                            out4 = arg2 - out2
                            out5 = arg2 + out2
                            out6 = tuple(out3, out4, out5)
                            out6
                        end, out102, out103)
                out105 = tuple(out93, 0.0, 0.0)
                out106 = ifelse(out100, out105, out104)
                out107 = isless(0, 15.999999992074834)
                out108 = false & out107
                out109 = ifelse(out108, 0.0, out87)
                out110 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, arg4, out65)
                out111 = -4.107400541184532e-6 + 0.4568177714433524
                out112 = out111 + -0.0013114977795969144
                out113 = isless(out112, 0)
                out114 = ifelse(out113, 0, out112)
                out115 = [0.2, 0.2, 0.2] * out109
                out116 = out115 * out114
                out117 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out116, [0.0, 0.0, 0.0])
                out118 = out59 + out117
                out118
            end, out220, out221)
    out223 = !out190
    out224 = out222 + [0.0, 0.0, 0.0]
    out225 = ifelse(out223, [1.0, 1.0, 1.0], out224)
    out226 = arg1 - 0.0
    out227 = arg2 - 0.0
    out228 = arg3 - 0.0
    out229 = out226 * 0.5190392208641064
    out230 = out227 * -0.5190392208641064
    out231 = out228 * -0.679114551758069
    out232 = out229 + out230
    out233 = out232 + out231
    out234 = out226 * out226
    out235 = out227 * out227
    out236 = out228 * out228
    out237 = out234 + out235
    out238 = out237 + out236
    out239 = out233 * out233
    out240 = out238 - out239
    out241 = isless(out233, 0)
    out242 = isless(16.0, out240)
    out243 = vect(out240, 4.0)
    out244 = vect(out240, out233, 16.0)
    out245 = cond(out242, function (arg1, arg2)
                out1 = arg2 - arg1
                out2 = tuple(out1, 0.0, 0.0)
                out2
            end, function ()
            end, out243, out244)
    out246 = tuple(out233, 0.0, 0.0)
    out247 = ifelse(out241, out246, out245)
    out248 = isless(0.0, -119.23077075784832)
    out249 = isless(0.0, 0.0)
    out250 = out248 & out249
    out251 = ifelse(out250, Inf, 0.0)
    out252 = isless(0.0, -119.23077075784832)
    out253 = isless(out251, 7.729058325739061)
    out254 = out252 & out253
    out255 = ifelse(out254, out251, 7.729058325739061)
    out256 = isless(0.0, -119.23077075784832)
    out257 = isless(out251, out255)
    out258 = out256 & out257
    out259 = vect(arg1, arg2, arg3)
    out260 = FancySphere(out259, 4.0, [1.0, 0.32, 0.36], 1.0, 0.5, [0.0, 0.0, 0.0])
    out261 = ifelse(out258, out260, FancySphere{Vector{Float64}, Float64, Vector{Float64}, Float64, Float64, Vector{Float64}}([0.0, -10004.0, -20.0], 10000.0, [0.2, 0.2, 0.2], 0.0, 0.0, [0.0, 0.0, 0.0]))
    out262 = isless(0.0, -119.23077075784832)
    out263 = isless(out251, out255)
    out264 = out262 & out263
    out265 = ifelse(out264, true, false)
    out266 = [0.5190392208641064, -0.5190392208641064, -0.679114551758069] * out255
    out267 = [0.0, 0.0, 0.0] + out266
    out268 = map(function (arg1, arg2)
                out1 = arg1 - arg2
                out1
            end, out267, [0.0, -10004.0, -20.0])
    out269 = map(function (arg1, arg2)
                out1 = arg1 * arg2
                out1
            end, out268, out268)
    out270 = 16.093611816708567 + 9.999976631190842e7
    out271 = out270 + 217.59447975340902
    out272 = sqrt(out271)
    out273 = out268 / out272
    out274 = map(function (arg1, arg2)
                out1 = arg1 * arg2
                out1
            end, [0.5190392208641064, -0.5190392208641064, -0.679114551758069], out273)
    out275 = 0.00020822215512482473 + -0.5190386143973271
    out276 = out275 + -0.0010017675811918813
    out277 = map(function (arg1, arg2)
                out1 = arg1 * arg2
                out1
            end, [0.5190392208641064, -0.5190392208641064, -0.679114551758069], out273)
    out278 = 0.00020822215512482473 + -0.5190386143973271
    out279 = out278 + -0.0010017675811918813
    out280 = isless(0.0, out279)
    out281 = -out273
    out282 = ifelse(out280, out281, out273)
    out283 = isless(0.0, 0.0)
    out284 = isless(0.0, 0.0)
    out285 = out283 | out284
    out286 = out285 & true
    out287 = vect(arg1, arg2, arg3)
    out288 = FancySphere(out287, 4.0, [1.0, 0.32, 0.36], 1.0, 0.5, [0.0, 0.0, 0.0])
    out289 = vect(FancySphere{Vector{Float64}, Float64, Vector{Float64}, Float64, Float64, Vector{Float64}}([0.0, -10004.0, -20.0], 10000.0, [0.2, 0.2, 0.2], 0.0, 0.0, [0.0, 0.0, 0.0]), out288)
    out290 = ListScene(out289)
    out291 = vect(arg1, arg2, arg3)
    out292 = FancySphere(out291, 4.0, [1.0, 0.32, 0.36], 1.0, 0.5, [0.0, 0.0, 0.0])
    out293 = vect(FancySphere{Vector{Float64}, Float64, Vector{Float64}, Float64, Float64, Vector{Float64}}([0.0, -10004.0, -20.0], 10000.0, [0.2, 0.2, 0.2], 0.0, 0.0, [0.0, 0.0, 0.0]), out292)
    out294 = ListScene(out293)
    out295 = vect(out290, out261, out267, out282, 0.0001, RayTrace.Ray{Vector{Float64}, Vector{Float64}}([0.0, 0.0, 0.0], [0.5190392208641064, -0.5190392208641064, -0.679114551758069]), [1.0, 1.0, 1.0])
    out296 = vect(out294, out261, out267, out282, 0.0001)
    out297 = cond(out286, function ()
            end, function (arg1, arg2, arg3, arg4, arg5)
                out1 = [0.0, -10004.0, -20.0] - arg3
                out2 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out1, out1)
                out3 = 16.093611816708567 + 9.999976631190842e7
                out4 = out3 + 217.59447975340902
                out5 = sqrt(out4)
                out6 = out1 / out5
                out7 = arg4 * arg5
                out8 = arg3 + out7
                out9 = map(function (arg1, arg2)
                            out1 = arg1 - arg2
                            out1
                        end, [0.0, -10004.0, -20.0], out8)
                out10 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out9, out6)
                out11 = 0.0016093611977644686 + 9999.976731190609
                out12 = out11 + 0.021759448192935384
                out13 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out9, out9)
                out14 = 16.093612138580806 + 9.999976831190374e7
                out15 = out14 + 217.59448410529868
                out16 = out12 * out12
                out17 = out15 - out16
                out18 = 10000.0 * 10000.0
                out19 = isless(out12, 0)
                out20 = isless(out18, out17)
                out21 = vect(out17, 10000.0)
                out22 = vect(out17, out12, out18)
                out23 = cond(out20, function ()
                        end, function (arg1, arg2, arg3)
                            out1 = arg3 - arg1
                            out2 = sqrt(out1)
                            out3 = arg3 - arg1
                            out4 = arg2 - out2
                            out5 = arg2 + out2
                            out6 = tuple(out3, out4, out5)
                            out6
                        end, out21, out22)
                out24 = tuple(out12, 0.0, 0.0)
                out25 = ifelse(out19, out24, out23)
                out26 = isless(0, 1.0000000000000001e8)
                out27 = false & out26
                out28 = ifelse(out27, 0.0, 1.0)
                out29 = arg4 * arg5
                out30 = arg3 + out29
                out31 = map(function (arg1, arg2)
                            out1 = arg1 - arg2
                            out1
                        end, [1.0, 1.0, -15.0], out30)
                out32 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out31, out6)
                out33 = 0.001208192756623985 + -5.011578555780275
                out34 = out33 + 0.01438390618313351
                out35 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out31, out31)
                out36 = 9.070243235537443 + 25.115978313807112
                out37 = out36 + 95.0836424341528
                out38 = out34 * out34
                out39 = out37 - out38
                out40 = 4.0 * 4.0
                out41 = isless(out34, 0)
                out42 = isless(out40, out39)
                out43 = vect(out39, 4.0)
                out44 = vect(out39, out34, out40)
                out45 = cond(out42, function (arg1, arg2)
                            out1 = arg2 - arg1
                            out2 = tuple(out1, 0.0, 0.0)
                            out2
                        end, function ()
                        end, out43, out44)
                out46 = tuple(out34, 0.0, 0.0)
                out47 = ifelse(out41, out46, out45)
                out48 = isless(0, -4.995986456840518)
                out49 = true & out48
                out50 = ifelse(out49, 0.0, out28)
                out51 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, arg4, out6)
                out52 = -1.6093611816708565e-7 + -0.9999976631190842
                out53 = out52 + -2.1759447975340902e-6
                out54 = isless(out53, 0)
                out55 = ifelse(out54, 0, out53)
                out56 = [0.2, 0.2, 0.2] * out50
                out57 = out56 * out55
                out58 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out57, [0.0, 0.0, 0.0])
                out59 = [0.0, 0.0, 0.0] + out58
                out60 = [1.0, 1.0, -15.0] - arg3
                out61 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out60, out60)
                out62 = 9.070242993898894 + 25.11698063951824
                out63 = out62 + 95.08363955737157
                out64 = sqrt(out63)
                out65 = out60 / out64
                out66 = arg4 * arg5
                out67 = arg3 + out66
                out68 = map(function (arg1, arg2)
                            out1 = arg1 - arg2
                            out1
                        end, [0.0, -10004.0, -20.0], out67)
                out69 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out68, out65)
                out70 = 1.0626393693307206 + -4407.9117188011605
                out71 = out70 + 12.651048339375892
                out72 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out68, out68)
                out73 = 16.093612138580806 + 9.999976831190374e7
                out74 = out73 + 217.59448410529868
                out75 = out71 * out71
                out76 = out74 - out75
                out77 = 10000.0 * 10000.0
                out78 = isless(out71, 0)
                out79 = isless(out77, out76)
                out80 = vect(out76, 10000.0)
                out81 = vect(out76, out71, out77)
                out82 = cond(out79, function ()
                        end, function (arg1, arg2, arg3)
                            out1 = arg3 - arg1
                            out2 = sqrt(out1)
                            out3 = arg3 - arg1
                            out4 = arg2 - out2
                            out5 = arg2 + out2
                            out6 = tuple(out3, out4, out5)
                            out6
                        end, out80, out81)
                out83 = tuple(out71, 0.0, 0.0)
                out84 = ifelse(out78, out83, out82)
                out85 = isless(0, -4394.198031092454)
                out86 = true & out85
                out87 = ifelse(out86, 0.0, 1.0)
                out88 = arg4 * arg5
                out89 = arg3 + out88
                out90 = map(function (arg1, arg2)
                            out1 = arg1 - arg2
                            out1
                        end, [1.0, 1.0, -15.0], out89)
                out91 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out90, out65)
                out92 = 0.7977532891387332 + 2.2090647248022486
                out93 = out92 + 8.362872570038348
                out94 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out90, out90)
                out95 = 9.070243235537443 + 25.115978313807112
                out96 = out95 + 95.0836424341528
                out97 = out93 * out93
                out98 = out96 - out97
                out99 = 4.0 * 4.0
                out100 = isless(out93, 0)
                out101 = isless(out99, out98)
                out102 = vect(out98, 4.0)
                out103 = vect(out98, out93, out99)
                out104 = cond(out101, function ()
                        end, function (arg1, arg2, arg3)
                            out1 = arg3 - arg1
                            out2 = sqrt(out1)
                            out3 = arg3 - arg1
                            out4 = arg2 - out2
                            out5 = arg2 + out2
                            out6 = tuple(out3, out4, out5)
                            out6
                        end, out102, out103)
                out105 = tuple(out93, 0.0, 0.0)
                out106 = ifelse(out100, out105, out104)
                out107 = isless(0, 15.999999991930906)
                out108 = false & out107
                out109 = ifelse(out108, 0.0, out87)
                out110 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, arg4, out65)
                out111 = -0.00010626393587043269 + 0.4407911674722044
                out112 = out111 + -0.001265104821286541
                out113 = isless(out112, 0)
                out114 = ifelse(out113, 0, out112)
                out115 = [0.2, 0.2, 0.2] * out109
                out116 = out115 * out114
                out117 = map(function (arg1, arg2)
                            out1 = arg1 * arg2
                            out1
                        end, out116, [0.0, 0.0, 0.0])
                out118 = out59 + out117
                out118
            end, out295, out296)
    out298 = !out265
    out299 = out297 + [0.0, 0.0, 0.0]
    out300 = ifelse(out298, [1.0, 1.0, 1.0], out299)
    out301 = vect(out75, out150, out225, out300)
    out301
end

r(1., 1., -15.)