import re
import serial
import serial.tools.list_ports
from time import sleep
import threading

# J.V.D.d.b....B....T...A..\0
def read_serial(serial_conn, game_end, data):
    ## Update condition
    while True:
        if game_end:
            break

        if serial_conn.is_open:
            read_data = serial_conn.read_all()
            try:
                data = re.findall(b'J[01]V[01]D[01]d[nfd]b[01]{4}B[01]{4}T[0-9, A-F]{3}A[0-9, A-F]{2}\x00', read_data)[-1].decode()
                print(data)
            except IndexError:
                pass

####################
## Serial treatment
####################

def search_for_ports():
    ports = list(serial.tools.list_ports.comports())
    return ports

def connect_to_serial(baudrate, data):
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
        serial_conn = serial.Serial(
        port,
        baudrate, 
        parity=serial.PARITY_ODD, 
        stopbits=serial.STOPBITS_ONE, 
        bytesize=serial.SEVENBITS, 
        timeout=0
    )
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
            data = "J0V0D0dfb0000B0000T000A00"
            data_list = list(data)
            data = ''.join(data_list)
        except Exception as e:
            print(e)

    serial_thread = threading.Thread(target=read_serial, args=(serial_conn,))
    serial_thread.start()
