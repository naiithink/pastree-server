import socket
import os

HOST = "0.0.0.0"
PORT = 63740


def send_response(socket, status, data):
    socket.sendall(f"""\
{status}
{data}""".encode())


def walk_dir(socket, root_dir, topdown=True, followlinks=False, onerror=None):
    res = ""

    for root, dirs, files in os.walk(root_dir, topdown=topdown, followlinks=followlinks, onerror=onerror):
        send_response(socket, 0, root)

        for file in files:
            send_response(socket, 0, f"- File: {os.path.join(root, file)}")

        if not topdown:
            for dir in dirs:
                send_response(
                    socket, 0, f"- Subdirectory: {os.path.join(root, dir)}")


server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

server_socket.bind((HOST, PORT))

server_socket.listen()

while True:
    client_socket, client_address = server_socket.accept()
    print("Incomming connection: ", client_address)

    request = client_socket.recv(1024).decode()
    request_lines = request.split("\n")

    walk_dir(client_socket, request_lines[2])

    client_socket.close()
