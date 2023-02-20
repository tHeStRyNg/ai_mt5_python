import socket

PORT = 8680
ADDR = "localhost"

def socket_ini():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    
    server_socket.bind((ADDR, PORT))
    server_socket.listen(10)
    
    connection, addr = server_socket.accept()
    print("[INFO]\t", addr, "CONNECTED")
    
    return connection, server_socket
    

def thread_data(stop_event, data):
    msg = ""
    
    connection, server_socket = socket_ini()
    
    while not stop_event.is_set() and "END CONNECTION" not in msg:
        msg = connection.recv(1024).decode()
        
        if "END CONNECTION" in msg:
            break
            
        msg_splitted = msg.split(',')
        
        msg_splitted = [ float(elem) for elem in msg_splitted if elem ]
        data['data'] = msg_splitted
        data['macd'] = msg_splitted[20:29]
        data['signal'] = msg_splitted[30:39]
        
    connection.close()
    server_socket.close()    
     