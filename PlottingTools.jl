using Plots

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

function plotPitch!(
    p::Plots.Plot{Plots.GRBackend};
    proportions::Bool = true,
    subplot::Int = 1,
    )
    if proportions
        p = pitchProportions!(p, subplot = subplot)
    end
    p = begin
        plot!([OffEdge, OffEdge],[0,PitchLength], label = nothing, color = :black, subplot = subplot) # left edge
        plot!([LegEdge, LegEdge],[0,PitchLength], label = nothing, color = :black, subplot = subplot) # right edge
        plot!([LegEdge, OffEdge],[PitchLength/2,PitchLength/2], label = nothing, color = :black, subplot = subplot) # halfway

        # strikers end
        plot!([OffWide, OffWide],[0,Crease], label = nothing, color = :black, subplot = subplot) # off wide
        plot!([LegWide, LegWide],[0,Crease], label = nothing, color = :black, subplot = subplot) # leg wide
        plot!([LegEdge,OffEdge],[Popping, Popping], label = nothing, color = :black, subplot = subplot) # popping crease
        plot!([LegEdge,OffEdge],[Crease, Crease], label = nothing, color = :black, subplot = subplot) # crease
        plot!([OffPA,OffPA],[0,25], label = nothing, color = :black, subplot = subplot) # protected area
        plot!([LegPA,LegPA],[0,25], label = nothing, color = :black, subplot = subplot) # protected area
        plot!([LegStump,OffStump],[Popping, Popping], linewidth=10, label = nothing, color = :black, subplot = subplot) # stumps

        # non-strikers end
        plot!([OffWide, OffWide],PitchLength.-[0,Crease], label = nothing, color = :black, subplot = subplot) # off wide
        plot!([LegWide, LegWide],PitchLength.-[0,Crease], label = nothing, color = :black, subplot = subplot) # leg wide
        plot!([LegEdge,OffEdge],PitchLength.-[Popping, Popping], label = nothing, color = :black, subplot = subplot) # popping crease
        plot!([LegEdge,OffEdge],PitchLength.-[Crease, Crease], label = nothing, color = :black, subplot = subplot) # crease
        plot!([OffPA,OffPA],PitchLength.-[0,25], label = nothing, color = :black, subplot = subplot) # protected area
        plot!([LegPA,LegPA],PitchLength.-[0,25], label = nothing, color = :black, subplot = subplot) # protected area
        plot!([LegStump,OffStump],PitchLength.-[Popping, Popping], linewidth=10, label = nothing, color = :black, subplot = subplot) # stumps
    end
    return p
end
function plotPitch(;proportions::Bool = true, subplot::Int = 1)
    p = plot()
    plotPitch!(p; proprtions = proportions, subplot = subplot)
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

function plotStumps!(
    p::Plots.Plot{Plots.GRBackend};
    proportions::Bool = false,
    subplot::Int = 1
    )
    p = begin
        plot!([OffWide, OffWide],[0,100], label = nothing, color = :black, subplot = subplot) # off wide
        plot!([LegWide, LegWide],[0,100], label = nothing, color = :black, subplot = subplot) # leg wide
        plot!([OffEdge, OffEdge],[0,100], label = nothing, color = :black, subplot = subplot) # off edge
        plot!([LegEdge, LegEdge],[0,100], label = nothing, color = :black, subplot = subplot) # leg edge
        plot!([OffPA,OffPA],[0,25], label = nothing, color = :black, subplot = subplot) # protected area
        plot!([LegPA,LegPA],[0,25], label = nothing, color = :black, subplot = subplot) # protected area
        plot!([LegStump,OffStump],[71.1, 71.1], linewidth=4, label = nothing, color = :black, subplot = subplot) # stumps
        plot!([LegStump,LegStump],[0, 71.1], linewidth=4, label = nothing, color = :black, subplot = subplot) # stumps
        plot!([OffStump,OffStump],[0, 71.1], linewidth=4, label = nothing, color = :black, subplot = subplot) # stumps
        plot!([0,0],[0, 71.1], linewidth=4, label = nothing, color = :black, subplot = subplot) # stumps
        if proportions
            plot!(
            windowsize = (600, 400),
            ylims = (0,200),
            xlims = (-150, 150),
            subplot = subplot,
            )
        end
    end
    return p
end
function plotStumps(; proportions::Bool = false, subplot::Int = 1)
    p = plot()
    plotStumps!(p; proportions = proportions, subplot = subplot)
    return p
end

function plotOval!(p)
    circx = 100*cos.(-π:0.01:π)
    circy = 100*sin.(-π:0.01:π)
    p = plot!(legend = :outertopright)
    p = plot!(circx, circy, label = "Boundary")
    p = annotate!(-90,80,"Leg")
    p = annotate!(80,80,"Off")
    return p
end
function plotOval()
    p = plot()
    p = plotOval!(p)
    return p
end
