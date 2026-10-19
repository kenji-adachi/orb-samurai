extends Node

#Changing level maps
signal level_change(currentLevel: String)

#Level Complete
signal level_complete

#Start the game
signal start_game

#Spawn Ball
signal spawn_ball

#Go to Main Menu (End Game)
signal reset_game

#Retry Level
signal retry_level(currentLevel: String)

#Player Dead
signal player_died

#Player Health Changed
signal player_health_changed(newPlayerHealth: float)

#End of Game
signal endGame

#Button Press SFX
signal buttonPress

#Challenge Level
signal challenge
