import pygame
from sys import exit
import random
from time import sleep
import serial
import serial.tools.list_ports
import threading

def baloes(height_baloes):
    screen.blit(balao, (width/6.8, height_baloes))
    screen.blit(balao, (width/2.8, height_baloes))
    screen.blit(balao, (width/2, height_baloes))
    screen.blit(balao, (width/1.5, height_baloes))

def nivel_agua():
    # nivel_da_agua = data[23:24] (hex)
    # 0x00 = 0% (0)
    # 0xFF = 100% (255)
    #####################################
    # nivel_da_agua = int(data[23:24], 16)
    global nivel_da_agua
    buracos_abertos = 0
    for i in range(9, 13):
        if(data[i + 5] == '1' and data[i] == '1'):
            buracos_abertos += 1

    if buracos_abertos:
        nivel_da_agua += buracos_abertos * (1)
    else:
        if(nivel_da_agua > 0):
            nivel_da_agua -= (1)
            if(nivel_da_agua <= 0):
                nivel_da_agua == 0           


def display_score():
    global current_score, game_active, nivel_da_agua, last_score, current_time, last_result

    percentage = min([int(nivel_da_agua*10000/(255*35)), 100])
    if percentage < 50:
        percentage_color = 'green'
    elif percentage < 75:
        percentage_color = 'yellow'
    elif percentage < 90:
        percentage_color = 'orange'
    else:
        percentage_color = 'red'

    # current_time = data[19:21] (hex)
    #####################################
    # current_time = int(data[19:21], 16)
    current_time = int(pygame.time.get_ticks()/1000) - start_time
    if(current_time < 10):
        current_score += int((2-percentage/100)*(int(pygame.time.get_ticks()/13)*mode - start_score)/100)
        time_surface = game_font.render(f'00:0{current_time}', True, '#ffffff')
        nivel_agua_surface = game_font.render(f'{percentage}%', True, percentage_color)
    elif(current_time < 60):
        current_score += int((2-percentage/100)*(int(pygame.time.get_ticks()/13)*mode - start_score)/100)
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

def countdown():
    global game_active, countdown_start
    current_count = start_count - int(pygame.time.get_ticks()/1000)
    if (current_count > 0):
        count_surface = game_font_big.render(f'{current_count}', True, '#ffffff')
    else:
        count_surface = game_font_big.render('Começou!', True, '#ffffff')
        game_active = True
        countdown_start = False
        sleep(0.077)
    count_rect = count_surface.get_rect(center = (width/2.4, height/1.89))
    screen.blit(count_surface, count_rect)
    return int(pygame.time.get_ticks()/1000)

def animacao_barco():
    global barco_surface, barco_menu_index

    barco_menu_index += 0.1
    if barco_menu_index >= len(barco_menu): 
        barco_menu_index = 0
    barco_surface = barco_menu[int(barco_menu_index)]

def animacao_raio():
    global lightning_x, lightning, raio_time, last_raio_time
    
    if(raio_time == 0):
        last_raio_time = int(pygame.time.get_ticks()/1000)
        lightning_x = 2000
    raio_time = int(pygame.time.get_ticks()/1000)
    if(raio_time - last_raio_time > 0.5):
        lightning_x = random.randint(-500, 2000)
        raio_time = 0
    screen.blit(lightning, (lightning_x, -50))

# J.V.D.d.b....B....T...A..\0
def read_serial(serial_conn):
    global game_end, data
    ## Update condition
    while True:
        if game_end:
            break

        if serial_conn.is_open:
            try:  
                data = serial_conn.readline().decode().strip()
            except BaseException as e:
                print(e)

####################
## Serial treatment
####################

global data
baudrate = 115200

def search_for_ports():
    ports = list(serial.tools.list_ports.comports())
    return ports


if(len(search_for_ports()) != 1):
    print('Available ports')
    for index, port in enumerate(search_for_ports()):
        print('[{}] {}'.format(index, port.description))

    print('\nSelect port to connect (use index number), or use exit to quit')
    ser_device = ""
    while ser_device != "exit":
        try:
            ser_device = input('> ')
            port = search_for_ports()[int(ser_device)].device
            break
        except:
            print('Not a valid port')
else:
    port = search_for_ports()[0].device

try:
    serial_conn = serial.Serial(port, baudrate)
except:
    print('\nCant connect to port {}'.format(port))
    exit(0)

count = 0
while not serial_conn.is_open:
    sleep(0.1)
    if count == 10:
        print('\nTimed out')
        exit(0)

print('\nConnection established') 

if serial_conn.is_open:
    try:
        data = serial_conn.readline().decode().strip()
    except BaseException as e:
        print(e)

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

serial_thread = threading.Thread(target=read_serial, args=(serial_conn,))
serial_thread.start()

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

        nivel_agua()
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
        if mode == 3:
            animacao_raio()
        display_score()

    else:
        screen.blit(sea, (0, 0))
        if last_result == 'v':
            screen.blit(barcoVitoria, (width/4.8, height/10.8))
            screen.blit(textoVitoria, (width/2.6, height/108))
            baloes(height/9 - 5*i)
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
        current_score = 0
        animacao_barco()
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
            landscape = pygame.image.load(f'graphics/Landscape{mode - 1}.png')
            start_time_game = countdown()

    pygame.display.update()
    clock.tick(60)
