# pitch measurements
OffEdge = 264/2
LegEdge = -OffEdge
OffWide= OffEdge-43.18
LegWide = -OffWide
Crease = 122
Popping = 0
PitchLength = 2012
PitchWidth = 2*OffEdge
OffStump = 22.86/2
LegStump = -OffStump
OffPA = 30.48/2
LegPA = -OffPA

function plotPitch!(p::Plots.Plot{Plots.GRBackend})
    p = pitchProportions!(p)
    p = begin
        plot!([OffEdge, OffEdge],[0,PitchLength], label = nothing, color = :black) # left edge
        plot!([LegEdge, LegEdge],[0,PitchLength], label = nothing, color = :black) # right edge
        plot!([LegEdge, OffEdge],[PitchLength/2,PitchLength/2], label = nothing, color = :black) # halfway

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
    end
    return p
end
function plotPitch()
    p = plot()
    plotPitch!(p)
    return p
end
function pitchProportions!(p)
    theylims = (-0.15*PitchLength/2,1.15*PitchLength/2)
    thexlims = (-1.15*PitchWidth/2,1.15*PitchWidth/2)
    p = plot!(
        windowsize = (PitchWidth, PitchLength/2),
        ylims = theylims,
        xlims = thexlims,
        )
    plot!(left_margin = 4mm)
    plot!(right_margin = 4mm)
    plot!(bottom_margin = 4mm)
    plot!(top_margin = (PitchLength/PitchWidth*4-4)mm)
    plot!(legend = false)
    return p
end

function plotStumps!(p::Plots.Plot{Plots.GRBackend})
    p = begin
        plot!([OffWide, OffWide],[0,100], label = nothing, color = :black) # off wide
        plot!([LegWide, LegWide],[0,100], label = nothing, color = :black) # leg wide
        plot!([OffPA,OffPA],[0,25], label = nothing, color = :black) # protected area
        plot!([LegPA,LegPA],[0,25], label = nothing, color = :black) # protected area
        plot!([LegStump,OffStump],[71.1, 71.1], linewidth=4, label = nothing, color = :black) # stumps
        plot!([LegStump,LegStump],[0, 71.1], linewidth=4, label = nothing, color = :black) # stumps
        plot!([OffStump,OffStump],[0, 71.1], linewidth=4, label = nothing, color = :black) # stumps
        plot!([0,0],[0, 71.1], linewidth=4, label = nothing, color = :black) # stumps
    end
    return p
end
function plotStumps()
    p = plot()
    plotStumps!(p)
    return p
end
