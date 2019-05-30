import http.server
import socketserver

PORT = 8000

class PrintHeadersHTTPRequestHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        print(self.headers)
        self.send_response(200)
        self.end_headers()
        self.wfile.write(bytes(str(self.headers), 'ascii'))

with http.server.HTTPServer(('', PORT), PrintHeadersHTTPRequestHandler) as httpd:
    print("serving at port", PORT)
    httpd.serve_forever()
