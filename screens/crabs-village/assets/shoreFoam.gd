extends Sprite2D

# Ecume du rivage : la vague monte sur le sable mouille, reste un instant,
# puis se retire en laissant une trace sombre (4 images de shoreFoam.png)

# duree de chaque image : repos, montee, haut de la vague, retrait
const STEPS=[[0, 1.6], [1, 0.25], [2, 0.6], [3, 0.5]]

var step=0
var elapsed=0.0

func _ready():
	hframes=4
	frame=0
	# depart decale pour ne pas etre cale sur le chargement de la scene
	elapsed=randf() * STEPS[0][1]

func _process(delta_):
	elapsed+=delta_
	while elapsed >= STEPS[step][1]:
		elapsed-=STEPS[step][1]
		step=(step + 1) % STEPS.size()
		frame=STEPS[step][0]
