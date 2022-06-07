extends Control



onready var startButton = $StartButton
onready var tutorialButton = $TutorialButton
onready var quitButton = $QuitButton
onready var tutorialBackButton = $TutorialBackButton
onready var tutorialRect = $TutorialRect


func _ready():
	tutorialBackButton.visible = false
	tutorialRect.visible = false

func _on_StartButton_pressed():
	get_tree().change_scene("res://World.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_TutorialButton_pressed():
	# hide buttons
	startButton.visible = false
	tutorialButton.visible = false
	quitButton.visible = false
	
	# show tutorial img
	tutorialRect.visible = true
	
	# show back button
	tutorialBackButton.visible = true


func _on_TutorialBackButton_pressed():
	# hide back button
	tutorialBackButton.visible = false
	
	# hide tutorial img
	tutorialRect.visible = false
	
	# show other buttons
	startButton.visible = true
	tutorialButton.visible = true
	quitButton.visible = true
