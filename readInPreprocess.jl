using DataFrames, CSV

## read data
cd("/Users/angus2/Documents/Cricket")
df = DataFrame!(CSV.File("Deliveries.txt", normalizenames = true))
## remove useless columns
for i in 2:5
    select!(df, Not(findall(occursin.("Fielder"*string(i), names(df)))))
end
uselessvariables = String[]
for name in names(df)
        firstvalue = df[1,name]
        for row in 2:size(df,1)
                if !isequal(df[row,name], firstvalue)
                        break
                end
                if row == size(df,1)
                        display(row)
                        push!(uselessvariables,name)
                end
        end
end
select(df, Not(uselessvariables))
select!(df, Not([
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
        ]))

## subset data as needed
# df = df[df.Striker_Hand.=="Left",:]
#df = df[df.Bowler_Hand.=="Right",:]
#df = df[df.Over_The_Wicket.=="Y",:]
# df = df[:,:]

## convert units where useful
df.Hit_To_Angle = df.Hit_To_Angle.*π./180 # degrees to radians
xshift = (17-5.5)/2
df.Pitch_Y = df.Pitch_Y./10 # mm to cm
df.Pitch_X = df.Pitch_X./10 .- xshift # mm to cm
df.At_Batter_Y = df.At_Batter_Y./10 # mm to cm
df.At_Batter_X = df.At_Batter_X./10 .- xshift# mm to cm
df.At_Stumps_Y = df.At_Stumps_Y./10 # mm to cm

## remove some rubbish data
allowmissing!(df)
df.Pitch_X[df.Pitch_X.<-10000] .= missing
df.Pitch_Y[df.Pitch_Y.<-10000] .= missing
