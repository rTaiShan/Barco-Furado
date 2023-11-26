import pygame

pygame.mixer.init()

DEFAULT_EASY_MUSIC_PATH = "music/easy.mp3"
DEFAULT_NORMAL_MUSIC_PATH = "music/normal.mp3"
DEFAULT_HARD_MUSIC_PATH = "music/hard.mp3"

def load_music(difficulty):
    if difficulty == 1:
        pygame.mixer.music.load(DEFAULT_EASY_MUSIC_PATH)
    elif difficulty == 2:
        pygame.mixer.music.load(DEFAULT_NORMAL_MUSIC_PATH)
    elif difficulty == 3:
        pygame.mixer.music.load(DEFAULT_HARD_MUSIC_PATH)

def play_music():
    pygame.mixer.music.play(-1)  # -1 significa loop infinito

def stop_music():
    pygame.mixer.music.stop()
