import random

def baloes(height_baloes, width, balao, screen):
    screen.blit(balao, (width/6.8, height_baloes))
    screen.blit(balao, (width/2.8, height_baloes))
    screen.blit(balao, (width/2, height_baloes))
    screen.blit(balao, (width/1.5, height_baloes))

def animacao_raio(lightning, raio_time, last_raio_time, pygame_time, screen):
    if(raio_time == 0):
        last_raio_time = int(pygame_time/1000)
        lightning_x = 2000
    raio_time = int(pygame_time/1000)
    if(raio_time - last_raio_time > 0.5):
        lightning_x = random.randint(-500, 2000)
        raio_time = 0
    screen.blit(lightning, (lightning_x, -50))
    return [lightning_x, raio_time, last_raio_time]

def animacao_barco(index, barco_menu):
    barco_menu_index = index
    barco_menu_index += 0.1
    if barco_menu_index >= len(barco_menu): 
        barco_menu_index = 0
    barco_surface = barco_menu[int(barco_menu_index)]
    return [barco_surface, barco_menu_index]

def update_screens_game_active(screen, sea, barco_jogo, buraco1, buraco1_x, buraco_y, buraco2, buraco2_x, buraco3, buraco3_x, buraco4, buraco4_x, tapa_buraco1, tapa_buraco1_x, tapa_buraco_y, tapa_buraco2, tapa_buraco2_x, tapa_buraco3, tapa_buraco3_x, tapa_buraco4, tapa_buraco4_x, landscape, height):
    screen.blit(sea, (0, 0))
    screen.blit(barco_jogo, (0, height/5.4))
    screen.blit(buraco1, (buraco1_x, buraco_y))
    screen.blit(buraco2, (buraco2_x, buraco_y))
    screen.blit(buraco3, (buraco3_x, buraco_y))
    screen.blit(buraco4, (buraco4_x, buraco_y))
    screen.blit(tapa_buraco1, (tapa_buraco1_x, tapa_buraco_y))
    screen.blit(tapa_buraco2, (tapa_buraco2_x, tapa_buraco_y))
    screen.blit(tapa_buraco3, (tapa_buraco3_x, tapa_buraco_y))
    screen.blit(tapa_buraco4, (tapa_buraco4_x, tapa_buraco_y))
    screen.blit(landscape, (0, 0))