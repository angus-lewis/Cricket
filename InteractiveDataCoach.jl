using DataFrames, Plots, CSV, KernelDensity, Statistics, Interact
include("readInPreprocess.jl")
function myprint(Obj)
    show(stdout, "text/plain", Obj)
end

"Pitch_X"
"At_Batter_X"
"At_Stumps_X"
"Hit_To_Len"
"Hit_To_Angle"


pitchxdata = df.Pitch_X
pitchydata = df.Pitch_Y
#pitchxdataS = tocm(df.Pitch_X[df.Northern_End.=="S"]).-xshift
#pitchydataS = tocm(df.Pitch_Y[df.Northern_End.=="S"]).+yshift

OffEdge = 264/2
LegEdge = -OffEdge
OffWide= OffEdge-43.18
LegWide = -OffWide
Crease = 122
Popping = 0
PitchLength = 2012
OffStump = 22.86/2
LegStump = -OffStump
OffPA = 30.48/2
LegPA = -OffPA

plot(legend = :topleft)
plot!([OffEdge, OffEdge],[0,PitchLength], label = nothing, color = :black) # left edge
plot!([LegEdge, LegEdge],[0,PitchLength], label = nothing, color = :black) # right edge

# strikers end
plot!([OffWide, OffWide],[0,Crease], label = nothing, color = :black) # off wide
plot!([LegWide, LegWide],[0,Crease], label = nothing, color = :black) # leg wide
plot!([LegEdge,OffEdge],[Popping, Popping], label = nothing, color = :black) # popping crease
plot!([LegEdge,OffEdge],[Crease, Crease], label = nothing, color = :black) # crease
plot!([OffPA,OffPA],[0,25], label = nothing, color = :black) # protected area
plot!([LegPA,LegPA],[0,25], label = nothing, color = :black) # protected area
plot!([LegStump,OffStump],[Popping, Popping], linewidth=10, label = nothing, color = :black) # stumps

# non-strikers end
plot!([OffWide, OffWide],PitchLength.-[0,Crease], label = nothing, color = :black) # off wide
plot!([LegWide, LegWide],PitchLength.-[0,Crease], label = nothing, color = :black) # leg wide
plot!([LegEdge,OffEdge],PitchLength.-[Popping, Popping], label = nothing, color = :black) # popping crease
plot!([LegEdge,OffEdge],PitchLength.-[Crease, Crease], label = nothing, color = :black) # crease
plot!([OffPA,OffPA],PitchLength.-[0,25], label = nothing, color = :black) # protected area
plot!([LegPA,LegPA],PitchLength.-[0,25], label = nothing, color = :black) # protected area
plot!([LegStump,OffStump],PitchLength.-[Popping, Popping], linewidth=10, label = nothing, color = :black) # stumps

lengths = unique(df.Pitch_Y_Description)
lengths = lengths[.!isequal.(lengths, missing)]
lengths = lengths[[3;5;2;1;4;6]]
lines = unique(df.Pitch_X_Description)

let c = 0
        for len in lengths
            c = c + 1
            colours = 1 .+ c
            npoints = sum(
                    isequal.(df.Pitch_Y_Description,len)
                    )
                    display(npoints)
            if npoints > 0
                scatter!(
                    pitchxdata[
                        isequal.(df.Pitch_Y_Description,len)
                        ],
                    pitchydata[
                        isequal.(df.Pitch_Y_Description,len)
                        ],
                    color = colours,
                    label = len*", ",
                    alpha = 1,
                        # 0.1 .+
                        # 0.8*(
                        #     df.Wides[
                        #         isequal.(df.Pitch_Y_Description,len) .&
                        #         isequal.(df.Pitch_X_Description,line)
                        #         ] .> 0
                        # ),
                )
            end
        end
end
annotate!(-50,-500,text("Leg"))
annotate!(50,-500,text("Off"))


## plot beehive at batter
atbatterxdata = df.At_Batter_X[df.Wides.>0]
atbatterydata = df.At_Batter_Y[df.Wides.>0]

plot(legend = :topleft)

# strikers end
plot!([OffWide, OffWide],[0,100], label = nothing, color = :black) # off wide
plot!([LegWide, LegWide],[0,100], label = nothing, color = :black) # leg wide
plot!([OffPA,OffPA],[0,25], label = nothing, color = :black) # protected area
plot!([LegPA,LegPA],[0,25], label = nothing, color = :black) # protected area
plot!([LegStump,OffStump],[71.1, 71.1], linewidth=4, label = nothing, color = :black) # stumps
plot!([LegStump,LegStump],[0, 71.1], linewidth=4, label = nothing, color = :black) # stumps
plot!([OffStump,OffStump],[0, 71.1], linewidth=4, label = nothing, color = :black) # stumps
plot!([0,0],[0, 71.1], linewidth=4, label = nothing, color = :black) # stumps

scatter!(atbatterxdata, atbatterydata, color = df.Wides, alpha=0.5)
