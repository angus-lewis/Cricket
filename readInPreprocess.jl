using DataFrames, CSV

## read data
# cd("/Users/angus2/Documents/Cricket")
cd("/Users/a1627293/Documents/Cricket")
df = DataFrame!(CSV.File("Deliveries.txt", normalizenames = true))
## remove useless columns
for i = 2:5
    select!(df, Not(findall(occursin.("Fielder" * string(i), names(df)))))
end
uselessvariables = String[]
for name in names(df)
    u = unique(df[:,name])
    if length(u) == 1
        push!(uselessvariables,name)
    end
end
select!(df, Not(uselessvariables))
select!(
    df,
    Not([
        "Match_YYMMDD",
        "TeamA_At_Home",
        "Toss_Won_By_Id",
        "TeamA_ResultId",
        "Team_Batting_Id",
        "Time_of_Day_Hour_",
        "Time_of_Day_Min_",
        "Striker_Id",
        "Striker_Hand_Id",
        "Non_Striker_Id",
        "Bowler_Id",
        "Bowler_Hand_Id",
        "Batter_Out_Id",
        "Fielder1_Id",
        "TeamA_Id",
        "TeamB_Result",
        "Team_Bowling_Result",
        "Individual_100",
        "Partnership_50",
        "Partnership_100",
        "Partnership_150",
        "Event_Grade",
        "Event_Infield",
        "TeamB_Id",
        "TeamBattingIdMatchInnings1",
        "TeamBattingIdMatchInnings2",
        "TeamBattingIdMatchInnings3",
        "TeamBattingIdMatchInnings4",
        "TeamB_ResultId",
        "Team_Batting_ResultId",
        "Team_Bowling_ResultId",
        "Individual_50",
        "Injury_Striker_Other",
        "Injury_Bowler_Other_1",
        "Injury_Fielder_Other",
        "Cum_Inning_Noball_Runs",
        "Cum_Inning_Wides",
        "Cum_Inning_Wide_Runs",
        "Cum_Inning_Byes",
        "Cum_Inning_Legbyes",
        "Cum_Inning_Extras",
        "Cum_Inning_Wickets",
        "At_Batter_X_Coded",
        "At_Batter_Y_Coded",
        "Time_of_Day_Sec_",
        "Video_Start_Time_UTC",
        "Video_Stop_Time_UTC",
        "Video_UTC_Offset_Minutes",
        "Video_Start_Time_Local",
        "Video_Stop_Time_Local",
        "Fielder1_Catch_Assist",
        "Fielder1_Extra_Effort",
        "Fielder1_Pressure_Field",
        "Fielder1_Assist",
        "Fielder1_Fumble",
        "Fielder1_Misfield",
        "Fielder1_Dive_Stop",
        "Fielder1_Dive_Misfield",
        "Fielder1_Slide_Stop",
        "Fielder1_Slide_Miss",
        "Fielder1_Throw_Backed_Up",
        "Fielder1_Throw_Not_Backed_Up",
        "Fielder1_Keeper_Dive_Stop",
        "Fielder1_Event_Grade",
        "Fielder1_Event_Infield",
    ]),
)

## convert units where useful
df.Hit_To_Angle = df.Hit_To_Angle .* π ./ 180 # degrees to radians
# xshift = (17 - 5.5) / 2
df.Pitch_Y = df.Pitch_Y ./ 10 # mm to cm
df.Pitch_X = df.Pitch_X ./ 10 # mm to cm
df.At_Batter_Y = df.At_Batter_Y ./ 10 # mm to cm
# df.At_Batter_X = df.At_Batter_X .- xshift# mm to cm
df.At_Stumps_Y = df.At_Stumps_Y ./ 10 # mm to cm
df.At_Stumps_X = df.At_Stumps_X ./ 10 # mm to cm

## remove some rubbish data
allowmissing!(df)
df.Pitch_X[isless.(df.Pitch_X,-1000)] .= missing
df.Pitch_Y[isless.(df.Pitch_Y,-1000)] .= missing
df.At_Stumps_X[isless.(df.At_Stumps_X,-1000)] .= missing
df.At_Stumps_Y[.!isless.(df.At_Stumps_X,1000)] .= missing

CSV.write("DeliveriesProcessed.txt", df, delim = "\t")
