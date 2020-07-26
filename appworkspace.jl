using Genie, SearchLight, SQLite

Genie.newapp("DataCoach")

Genie.Generator.db_support()

SearchLight.Configuration.load_db_connection() |> SearchLight.Database.connect!

SearchLight.init()
