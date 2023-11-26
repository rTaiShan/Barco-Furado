from time import sleep
import pygame

def nivel_agua(data):
    nivel_da_agua = int(data[23:25], 16)  
    return nivel_da_agua   
    
def display_score(nivel_da_agua, screen, pygame_time, current_score, game_active, last_score, current_time, last_result, start_score, mode, game_font, width, height, data):
    percentage = min([int(nivel_da_agua*10000/(255*35)), 100])
    if percentage < 50:
        percentage_color = 'green'
    elif percentage < 75:
        percentage_color = 'yellow'
    elif percentage < 90:
        percentage_color = 'orange'
    else:
        percentage_color = 'red'

    current_time = int(data[19:22], 16) * 32 / 1000
    if(current_time < 10):
        current_score += int((2-percentage/100)*(int(pygame_time/13)*mode - start_score)/100)
        time_surface = game_font.render(f'00:0{current_time}', True, '#ffffff')
        nivel_agua_surface = game_font.render(f'{percentage}%', True, percentage_color)
    elif(current_time < 60):
        current_score += int((2-percentage/100)*(int(pygame_time/13)*mode - start_score)/100)
        time_surface = game_font.render(f'00:{current_time}', True, '#ffffff')
        nivel_agua_surface = game_font.render(f'{percentage}%', True, percentage_color)
    else:
        time_surface = game_font.render('01:00', True, '#ffffff')
        current_score = current_score
        nivel_agua_surface = game_font.render(f'{percentage}%', True, percentage_color)
        last_score = current_score
        if data[3] == '1':
            game_active = False
            last_result = 'v'
        elif data[5] == '1':
            game_active = False
            last_result = 'd'
        else:
            game_active = False
            last_result = ''
    score_surface = game_font.render(f'{current_score} pts', True, '#ffffff')
    screen.blit(time_surface, (width/9.6, height/108))
    screen.blit(score_surface, (width/1.48, height/108))
    screen.blit(nivel_agua_surface, (width/1.48, height/27))

    return [current_score, game_active, last_score, current_time, last_result]

def countdown(screen, pygame_time, start_count, game_active, countdown_start, game_font_big, width, height):
    current_count = start_count - int(pygame_time/1000)
    if (current_count > 0):
        count_surface = game_font_big.render(f'{current_count}', True, '#ffffff')
    else:
        count_surface = game_font_big.render('Começou!', True, '#ffffff')
        game_active = True
        countdown_start = False
        sleep(0.077)
    count_rect = count_surface.get_rect(center = (width/2.4, height/1.89))
    screen.blit(count_surface, count_rect)
    start_time_game = int(pygame_time/1000) 
    return [start_time_game, game_active, countdown_start]

def show_leaderboard(screen, clock, leaderboard, serial_data):
    '''
    Shows leaderboard on screen
    '''
    screen.fill((30, 30, 30))
    font = pygame.font.Font(None, 32)
    for i, entry in enumerate(leaderboard):
        text_surface = font.render(f"{entry['name']} - {entry['score']:.2f}", True, '#ffffff')
        screen.blit(text_surface, (550, 300 + i*50))
    pygame.display.flip()
    clock.tick(30)
    
    while True:
        # Atualiza a tela para verificar eventos
        pygame.display.flip()
        clock.tick(30)
        
        # Obtém os eventos
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                exit()
            if event.type == pygame.KEYDOWN:
                return True  # Retorna True quando uma tecla for pressionada

        # Verifica se o bit data[1] é 1
        if serial_data[1] == '1':
            return True  # Retorna True quando o bit data[1] for 1