extends Node

signal trocar_musica_solicitado(id_do_clip: int)
signal fogo_sfx_play(id_do_clip: int)
signal papel_sfx_play(id_do_clip: int)
signal sfx_ambience_play(id_do_clip: int)
signal ost_ambience_play(id_do_clip: int)
signal sfx_carimbo_play(id_do_clip: int)

@onready var menu_music: AudioStreamPlayer2D = $menu_music
@onready var fogo_sfx: AudioStreamPlayer2D = $sfx_fogo
@onready var papel_sfx: AudioStreamPlayer2D = $sfx_papel
@onready var sfx_ambience: AudioStreamPlayer2D = $sfx_ambience
@onready var ost_ingame: AudioStreamPlayer2D = $ost_ingame
@onready var sfx_carimbo: AudioStreamPlayer2D = $sfx_carimbo

var Mplayback: AudioStreamPlaybackInteractive
var Fplayback: AudioStreamPlaybackInteractive
var Aplayback: AudioStreamPlaybackPlaylist
var Oplayback: AudioStreamPlaybackPlaylist

func _ready() -> void :

	trocar_musica_solicitado.connect(_ao_receber_pedido_de_troca)
	fogo_sfx_play.connect(_fogo_sfx_play)
	papel_sfx_play.connect(_ao_receber_papel_sfx)
	sfx_ambience_play.connect(_ao_receber_ambience)
	ost_ambience_play.connect(_ao_receber_ost)
	sfx_carimbo_play.connect(_ao_receber_sfx_carimbo)


	if menu_music and menu_music.stream is AudioStreamInteractive:
		menu_music.play()
		Mplayback = menu_music.get_stream_playback() as AudioStreamPlaybackInteractive


	if fogo_sfx and fogo_sfx.stream is AudioStreamInteractive:
		fogo_sfx.play()
		Fplayback = fogo_sfx.get_stream_playback() as AudioStreamPlaybackInteractive
		fogo_sfx.stop()


	if sfx_ambience and sfx_ambience.stream is AudioStreamPlaylist:
		sfx_ambience.play()
		Aplayback = sfx_ambience.get_stream_playback() as AudioStreamPlaybackPlaylist
		sfx_ambience.stop()




func _ao_receber_pedido_de_troca(id: int) -> void :
	if Mplayback:
		Mplayback.switch_to_clip(id)
		print("Música trocada para o índice: ", id)

func _fogo_sfx_play(id: int) -> void :
	if Fplayback:
		fogo_sfx.play()
		Fplayback.switch_to_clip(id)
		print("Fogo trocado para o índice: ", id)

func _ao_receber_papel_sfx(_id: int) -> void :
	if papel_sfx:
		papel_sfx.play()
		print("Papel tocado via sinal!")

func _ao_receber_ost(_id: int) -> void :
	if ost_ingame:
		ost_ingame.stop()
		await get_tree().process_frame
		ost_ingame.play()
		print("Playlist OST: Reiniciada com sucesso (Próxima Faixa).")

func _ao_receber_ambience(_id: int) -> void :
	if sfx_ambience:
		if not sfx_ambience.playing:
			sfx_ambience.play()
			print("Playlist Ambiência: Iniciada")

func _ao_receber_sfx_carimbo(_id: int) -> void :
	if sfx_carimbo:
		sfx_carimbo.play()
		print("SFX Carimbo: Tocado (Randomizer)")
