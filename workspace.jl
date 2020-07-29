using DataFrames, Plots, CSV, KernelDensity, Statistics, Interact
include("PlottingTools.jl")
function myprint(Obj)
    show(stdout, "text/plain", Obj)
end
## read data
try
    cd("/Users/angus2/Documents/Cricket")
    @warn "changed directory to: /Users/angus2/Documents/Cricket"
catch
end
try
    cd("/Users/a1627293/Documents/Cricket")
    @warn "changed directory to: /Users/a1627293/Documents/Cricket"
catch
end

df = DataFrame!(CSV.File("data/DeliveriesProcessed_all.txt", normalizenames = true))

## pitch maps

# filtereddata = filter(row -> isequal(row[:Striker_Hand],"Right"), df)
filtereddata = filter(row -> isequal(row[:Striker_Hand],"Right"), df)
# filtereddata = filter(row -> isequal(row[:Pitch_X],round(row[:Pitch_X],digits=0)), filtereddata)
# filtereddata = filter(row -> row[:Bowler_Hand]=="Left", filtereddata)
# filtereddata = filter(row -> isequal(row[:Data_Source],"HawkEye"), df)
pitchxdata = filtereddata.Pitch_X
pitchydata = filtereddata.Pitch_Y

p = plotPitch()
lengths = unique(df.Pitch_Y_Description)
lengths = lengths[.!isequal.(lengths, missing)]
lengths = lengths[[3;5;2;1;4;6]]

let c = 0
        for len in lengths
            idx = isequal.(filtereddata.Pitch_Y_Description,len)
            c = c + 1
            colours = 1 .+ c
            npoints = sum(
                    isequal.(filtereddata.Pitch_Y_Description,len)
                    )
            if npoints > 0
                scatter!(
                    pitchxdata[idx],
                    pitchydata[idx],
                    color = colours,
                    label = len*", ",
                )
            end
        end
end
plot!()


## plot beehive at stumps
filtereddata = filter(row -> isequal(row[:Striker_Hand],"Left"), df)
atstumpsxdata = filtereddata.At_Stumps_X
atstumpsydata = filtereddata.At_Stumps_Y

# strikers end
p = plotStumps()
scatter!(atstumpsxdata, atstumpsydata, color = 1, alpha=0.5)

## plot beehive at batter
filtereddata = filter(row -> isequal(row[:Striker_Hand],"Left"), df)
atbatterxdata = filtereddata.At_Batter_X
atbatterydata = filtereddata.At_Batter_Y

# strikers end
p = plotStumps()
scatter!(atbatterxdata, atbatterydata, color = 1, alpha=0.5)

## wagon wheels

# filtereddata = filter(row -> isequal(row[:Pitch_Y_Description], "Yorker") | isequal(row[:Pitch_Y_Description], "Half Volley") | isequal(row[:Pitch_Y_Description], "Full Toss"), filtereddata)
# filtereddata = filter(row -> !isless(row[:At_Batter_X], 80), filtereddata)
strikerhanddict = Dict{String, String}()
hands = unique(df[:,:Striker_Hand])
for hand in hands
    strikerhanddict[hand] = hand
end
handchoice = dropdown(strikerhanddict;
         label = "Striker Hand",
         multiple = true)

selecteddata = filter(row -> isequal(row[:Striker_Hand], observe(handchoice)[][1]), df)


hittox = filtereddata.Hit_To_Len.*cos.(filtereddata.Hit_To_Angle)
hittoy = filtereddata.Hit_To_Len.*sin.(filtereddata.Hit_To_Angle)

p = plotOval()
scatter!(hittox, hittoy, label = "Sweep")
