extends Node

# Bruitages "chiptune" synthetises au demarrage (pas de fichiers audio) :
# ondes carrees, triangle et bruit avec une enveloppe qui decroit.

enum {CURSOR, CONFIRM, CANCEL, TEXT, HIT, CRITICAL, HEAL, GEM, PERFECT, BATTLE, VICTORY, MISS, SWING}

const MIX_RATE=22050
const VOLUME=0.22
const VOICES=6

# chaque son : liste de notes [forme, frequence debut, frequence fin, duree, volume]
const SOUNDS={
	CURSOR:[["square", 1320, 1320, 0.035, 0.5]],
	CONFIRM:[["square", 880, 880, 0.04, 0.6], ["square", 1320, 1320, 0.07, 0.6]],
	CANCEL:[["square", 660, 440, 0.09, 0.6]],
	TEXT:[["square", 1760, 1760, 0.012, 0.25]],
	HIT:[["noise", 900, 120, 0.14, 1.0]],
	CRITICAL:[["noise", 1400, 80, 0.08, 1.0], ["square", 220, 110, 0.16, 0.8]],
	HEAL:[["triangle", 523, 523, 0.06, 0.9], ["triangle", 659, 659, 0.06, 0.9], ["triangle", 784, 784, 0.06, 0.9], ["triangle", 1047, 1047, 0.12, 0.9]],
	GEM:[["square", 1568, 1568, 0.05, 0.5], ["square", 2093, 2093, 0.12, 0.5]],
	PERFECT:[["square", 784, 784, 0.04, 0.6], ["square", 1175, 1175, 0.04, 0.6], ["square", 1568, 1568, 0.1, 0.6]],
	BATTLE:[["square", 1200, 200, 0.35, 0.6]],
	VICTORY:[["square", 523, 523, 0.1, 0.6], ["square", 659, 659, 0.1, 0.6], ["square", 784, 784, 0.1, 0.6], ["square", 1047, 1047, 0.3, 0.6]],
	MISS:[["triangle", 400, 250, 0.12, 0.8]],
	# coup d'epee qui fend l'air
	SWING:[["noise", 3000, 700, 0.08, 0.45]],
}

var _streams={}
var _players=[]
var _next=0

func _ready():
	process_mode=Node.PROCESS_MODE_ALWAYS
	for id in SOUNDS:
		_streams[id]=_build(SOUNDS[id])
	for i in VOICES:
		var player=AudioStreamPlayer.new()
		player.volume_db=linear_to_db(VOLUME)
		add_child(player)
		_players.append(player)

func play(id_):
	if !GlobalPlayer.isSoundEnabled() or !_streams.has(id_):
		return
	# les voix tournent : un nouveau son ne coupe pas le precedent
	var player=_players[_next]
	_next=(_next+1)%VOICES
	player.stream=_streams[id_]
	player.play()

func _build(notes_):
	var data=PackedByteArray()
	var rng=RandomNumberGenerator.new()
	rng.seed=1
	var noise=0.0
	for note in notes_:
		var shape=note[0]
		var samples=int(note[3]*MIX_RATE)
		var phase=0.0
		for i in samples:
			var t=float(i)/samples
			var freq=lerp(float(note[1]), float(note[2]), t)
			phase=fmod(phase+freq/MIX_RATE, 1.0)
			var value=0.0
			match shape:
				"square":
					value=1.0 if phase < 0.5 else -1.0
				"triangle":
					value=4.0*abs(phase-0.5)-1.0
				"noise":
					# bruit "echantillonne" a la frequence de la note (son de NES/SNES)
					if phase < freq/MIX_RATE:
						noise=rng.randf_range(-1.0, 1.0)
					value=noise
			var envelope=(1.0-t)*note[4]
			var sample=int(clamp(value*envelope, -1.0, 1.0)*32767)
			data.append(sample & 0xff)
			data.append((sample >> 8) & 0xff)
	var stream=AudioStreamWAV.new()
	stream.format=AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate=MIX_RATE
	stream.data=data
	return stream
