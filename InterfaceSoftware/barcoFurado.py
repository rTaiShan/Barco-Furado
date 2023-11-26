import pygame
from sys import exit
from leaderboard import fetch_leaderboard, append_leaderboard, print_leaderboard, DEFAULT_LEADERBOARD_PATH
from gameCalculations import nivel_agua, display_score, countdown, show_leaderboard
from animations import baloes, animacao_raio, animacao_barco, update_screens_game_active
from serial_communication import connect_to_serial
from playerInput import input_player_name
from music import play_music, stop_music, load_music

data = "J0V0D0dfb0000B0000T000A00"
baudrate = 115200

connect_to_serial(baudrate, data)

pygame.init()
# sizes =  pygame.display.get_desktop_sizes()
width = 1920
height = 1080
game_active = False
game_end = False
screen = pygame.display.set_mode((width/1.2, height/1.35))
pygame.display.set_caption('Barco Furado')
clock = pygame.time.Clock()
game_font = pygame.font.Font('fonts/PressStart2P-Regular.ttf', 20)
game_font_big = pygame.font.Font('fonts/PressStart2P-Regular.ttf', 50)
start_time = 0
current_score = 0 
raio_time = 0
last_raio_time = 0
start_score = 0
start_count = 3
nivel_da_agua = 0
countdown_start = False
last_score = 0
last_result = ''
mode = 1

sea = pygame.image.load('graphics/Mar.png')
landscape = pygame.image.load(f'graphics/Landscape{mode - 1}.png')

#####################################################
## Elementos indicadores de vitória/derrota
#####################################################
balao = pygame.image.load('graphics/balao.png')
textoVitoria = pygame.image.load('graphics/textoVitoria.png')
textoDerrota = pygame.image.load('graphics/textoDerrota.png')
barcoVitoria = pygame.image.load('graphics/vitoria.png')
barcoDerrota = pygame.image.load('graphics/derrota.png')

#####################################################
## Raios adicionais no modo díficil
#####################################################
lightning = pygame.image.load('graphics/Raio.png')
lightning = pygame.transform.scale(lightning, (width/3.4, height/2.7))

#####################################################
## Barco da tela de Menu
#####################################################
barco_menu_1 = pygame.image.load('graphics/Menu1.png')
barco_menu_2 = pygame.image.load('graphics/Menu2.png')
barco_menu_3 = pygame.image.load('graphics/Menu3.png')
barco_menu_4 = pygame.image.load('graphics/Menu4.png')
barco_menu = [barco_menu_1, barco_menu_2, barco_menu_3, barco_menu_4]
barco_menu_index = 0 
barco_surface = barco_menu[barco_menu_index]


#####################################################
## Barco da tela do jogo
#####################################################
barco_jogo = pygame.image.load('graphics/Jogo.png')
barco_jogo = pygame.transform.scale(barco_jogo, (width/1.2, height/1.8))


#####################################################
## Buracos
#####################################################
buraco = pygame.image.load('graphics/buraco.png')
buraco_size_x = width/6
buraco_size_y = height/3.375 
buraco1 = pygame.transform.scale(buraco, (buraco_size_x, buraco_size_y))
buraco2 = pygame.transform.scale(buraco, (buraco_size_x, buraco_size_y))
buraco3 = pygame.transform.scale(buraco, (buraco_size_x, buraco_size_y))
buraco4 = pygame.transform.scale(buraco, (buraco_size_x, buraco_size_y))

buracos_x = [width/1.42, width/2.2, width/3.8, width/1920, width + 2 * buraco_size_x]
buraco_index = [0, 1, 2, 3]

for i in range(14, 18):
    if(data[i] == '1'):
        buraco_index[i - 14] = i - 14
    else:
        buraco_index[i - 14] = 4    
    
    
buraco1_x = buracos_x[buraco_index[0]]
buraco2_x = buracos_x[buraco_index[1]]
buraco3_x = buracos_x[buraco_index[2]]
buraco4_x = buracos_x[buraco_index[3]]
buraco_y = height/1.9

tapa_buraco = pygame.image.load('graphics/tapaBuraco.png')
tapa_buraco1 = pygame.transform.scale(tapa_buraco, (buraco_size_x, buraco_size_y))
tapa_buraco2 = pygame.transform.scale(tapa_buraco, (buraco_size_x, buraco_size_y))
tapa_buraco3 = pygame.transform.scale(tapa_buraco, (buraco_size_x, buraco_size_y))
tapa_buraco4 = pygame.transform.scale(tapa_buraco, (buraco_size_x, buraco_size_y))

tapa_buraco_index = [0, 1, 2, 3]

for i in range(9, 13):
    if(data[i] == '0'):
        tapa_buraco_index[i - 9] = i - 9
    else:
        tapa_buraco_index[i - 9] = 4  

tapa_buraco1_x = buracos_x[tapa_buraco_index[0]]
tapa_buraco2_x = buracos_x[tapa_buraco_index[1]]
tapa_buraco3_x = buracos_x[tapa_buraco_index[2]]
tapa_buraco4_x = buracos_x[tapa_buraco_index[3]]
tapa_buraco_y = height/1.9

#####################################################
while True:
    ## Leave game
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            game_end= True
            pygame.quit()
            exit()
    
    if game_active: 
        data_list = list(data)
        data_list[1] = '0'
        data = ''.join(data_list)
        for i in range(14, 18):
            if(data[i] == '1'):
                buraco_index[i - 14] = i - 14
            else:
                buraco_index[i - 14] = 4    
        buraco1_x = buracos_x[buraco_index[0]]
        buraco2_x = buracos_x[buraco_index[1]]
        buraco3_x = buracos_x[buraco_index[2]]
        buraco4_x = buracos_x[buraco_index[3]]

        for i in range(9, 13):
            if(data[i] == '0'):
                tapa_buraco_index[i - 9] = i - 9
            else:
                tapa_buraco_index[i - 9] = 4  
        tapa_buraco1_x = buracos_x[tapa_buraco_index[0]]
        tapa_buraco2_x = buracos_x[tapa_buraco_index[1]]
        tapa_buraco3_x = buracos_x[tapa_buraco_index[2]]
        tapa_buraco4_x = buracos_x[tapa_buraco_index[3]]

        nivel_da_agua = nivel_agua(data)
        if (nivel_da_agua >= 255):
            game_active = False
            last_score = current_score
            if(data[3] == '1'):
                last_result = 'v'
            elif(data[5] == '1'):
                last_result = 'd'  
            else:
                last_result = '' 
            
        
        if ((data[3] == '1' or data[5] == '1') and  (int(pygame.time.get_ticks()/1000) - start_time_game) >= 0.1):
            game_active = False
            last_score = current_score
            if(data[3] == '1'):
                last_result = 'v'
            elif(data[5] == '1'):
                last_result = 'd'  
            else:
                last_result = ''

        ## Screens
        update_screens_game_active(screen, sea, barco_jogo, buraco1, buraco1_x, buraco_y, buraco2, buraco2_x, buraco3, buraco3_x, buraco4, buraco4_x, tapa_buraco1, tapa_buraco1_x, tapa_buraco_y, tapa_buraco2, tapa_buraco2_x, tapa_buraco3, tapa_buraco3_x, tapa_buraco4, tapa_buraco4_x, landscape, height)
        if mode == 3:
            lightning_x, raio_time, last_raio_time = animacao_raio(lightning, raio_time, last_raio_time, pygame.time.get_ticks(), screen)
        current_score, game_active, last_score, current_time, last_result = display_score(nivel_da_agua, screen, pygame.time.get_ticks(), current_score, game_active, last_score, current_time, last_result, start_score, mode, game_font, width, height, data)

    else:
        stop_music()
        screen.blit(sea, (0, 0))
        if last_result == 'v':
            screen.blit(barcoVitoria, (width/4.8, height/10.8))
            screen.blit(textoVitoria, (width/2.6, height/108))
            baloes(height/9 - 5*i, width, balao, screen)
            if i < height/2:
                i += 1
            else:
                i = 0
        elif last_result == 'd':
            screen.blit(barcoDerrota, (width/3.2, height/10.8))
            screen.blit(textoDerrota, (width/2.6, height/108))
        else:
            screen.blit(barco_surface, (width/4.8, height/10.8))
        
        if last_score:
            score_surface = game_font.render(f'{last_score} pts', True, '#ffffff')
            screen.blit(score_surface, (1300, 10))

            # Se houver um resultado e a pontuação for maior que zero, pergunte ao jogador pelo nome
            if last_result and last_score > 0:
                player_name = input_player_name(screen, clock)
                if player_name:
                    # Adicione nome e pontuação ao leaderboard
                    append_leaderboard(player_name, last_score, DEFAULT_LEADERBOARD_PATH)
                    print("Pontuação adicionada ao leaderboard!")
                    leaderboard = fetch_leaderboard(DEFAULT_LEADERBOARD_PATH)
                    print_leaderboard(leaderboard)
                    exit_leaderboard = show_leaderboard(screen, clock, leaderboard, data)
                    
                    if exit_leaderboard:
                        continue

        current_score = 0
        barco_surface, barco_menu_index = animacao_barco(barco_menu_index, barco_menu)
        start_time = int(pygame.time.get_ticks()/1000)
        start_score = int(pygame.time.get_ticks()/13)*mode
        nivel_da_agua = 0
        if countdown_start == False:
            start_count = 3 + int(pygame.time.get_ticks()/1000)
            if data[1] == '1':
                countdown_start = True
        else:
            ## Modo de dificuldade
            if data[7] == 'd':
                mode = 3
            elif data[7] == 'n':
                mode = 2
            else: # data [7] == 'f'
                mode = 1
            load_music(mode)
            play_music()
            landscape = pygame.image.load(f'graphics/Landscape{mode - 1}.png')
            start_time_game, game_active, countdown_start = countdown(screen)

    pygame.display.update()
    clock.tick(60)
