using DataFrames, Plots, CSV, KernelDensity, Statistics, Interact
include("PlottingTools.jl")
## read data
# cd("/Users/angus2/Documents/Cricket")
cd("/Users/a1627293/Documents/Cricket")
df = DataFrame!(CSV.File("DeliveriesProcessed.txt", normalizenames = true))
function myprint(Obj)
    show(stdout, "text/plain", Obj)
end

"Pitch_X"
"At_Batter_X"
"At_Stumps_X"
"Hit_To_Len"
"Hit_To_Angle"

# filtereddata = filter(row -> isequal(row[:Striker_Hand],"Right"), df)
filtereddata = filter(row -> isequal(row[:Striker_Hand],"Left"), df)
# filtereddata = filter(row -> isequal(row[:Pitch_X],round(row[:Pitch_X],digits=0)), filtereddata)
# filtereddata = filter(row -> row[:Bowler_Hand]=="Left", filtereddata)
# filtereddata = filter(row -> isequal(row[:Data_Source],"HawkEye"), df)
pitchxdata = filtereddata.Pitch_X./10
pitchydata = filtereddata.Pitch_Y./10

p = plotPitch()
lengths = unique(df.Pitch_Y_Description)
lengths = lengths[.!isequal.(lengths, missing)]
lengths = lengths[[3;5;2;1;4;6]]
lines = unique(df.Pitch_X_Description)

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
                    color = colours .+ 6 .*(filtereddata.Pitch_X_Description[idx].=="Middle Stump"),
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


## plot beehive at stumps
filtereddata = filter(row -> isequal(row[:How_Out],"B"), df)
filtereddata = filter(row -> isequal(row[:Play_and_Miss],"Y"), filtereddata)
filtereddata = filter(row -> isequal(row[:Inside_Edge],"N"), filtereddata)
filtereddata = filter(row -> isequal(row[:Outside_Edge],"N"), filtereddata)
filtereddata = filter(row -> isequal(row[:Contact_Error],"N"), filtereddata)
filtereddata = filter(row -> isequal(row[:Hit_on_Pads],"N"), filtereddata)
filtereddata = filter(row -> isequal(row[:Hit_on_Head],"N"), filtereddata)
filtereddata = filter(row -> isequal(row[:Hit_on_Body],"N"), filtereddata)
# filtereddata = filter(row -> isequal(row[:Data_Source],"HawkEye"), filtereddata)
# filtereddata = filter(row -> true, df)
atbatterxdata = filtereddata.At_Stumps_X
atbatterydata = filtereddata.At_Stumps_Y

# strikers end
p = plotStumps()
scatter!(atbatterxdata, atbatterydata, color = 1, alpha=0.5)
scatter!([0],[-0.1], color = 4)
