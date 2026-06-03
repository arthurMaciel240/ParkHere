import os
import sys
import subprocess
import time
import threading
from http.server import HTTPServer, SimpleHTTPRequestHandler

# Determina a pasta dos arquivos web
if getattr(sys, 'frozen', False):
    base_dir = os.path.dirname(sys.executable)
else:
    base_dir = os.path.dirname(os.path.abspath(__file__))

web_dir = os.path.join(base_dir, 'web')

if not os.path.isdir(web_dir):
    # Se nao achou, tenta a pasta atual
    web_dir = os.path.join(os.getcwd(), 'web')

if not os.path.isdir(web_dir):
    print("ERRO: Pasta 'web' nao encontrada.")
    print("Certifique-se de que a pasta 'web' esta junto com este executavel.")
    input("Pressione Enter para sair...")
    sys.exit(1)

os.chdir(web_dir)

PORT = 8080

class Handler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()

    def log_message(self, format, *args):
        pass

def start_server():
    server = HTTPServer(("127.0.0.1", PORT), Handler)
    server.serve_forever()

if __name__ == "__main__":
    thread = threading.Thread(target=start_server, daemon=True)
    thread.start()
    time.sleep(1)

    url = f"http://127.0.0.1:{PORT}"
    subprocess.run(["start", url], shell=True)

    # Mantem o programa rodando silenciosamente
    while True:
        time.sleep(1)
