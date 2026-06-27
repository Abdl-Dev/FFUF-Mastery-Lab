from http.server import HTTPServer, BaseHTTPRequestHandler

class MockWebHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        secret_paths = ["/admin", "/backup.bak", "/secret", "/uploads"]
        
        if self.path in secret_paths:
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write(f"<h1>Success: Found {self.path}</h1>".encode())
        else:
            self.send_response(404)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write(b"<h1>404 Error: Page Not Found</h1>")
    
    def log_message(self, format, *args):
        # Suppress default logging
        pass

if __name__ == "__main__":
    server_address = ('', 8000)
    httpd = HTTPServer(server_address, MockWebHandler)
    print("Mock Target Server running on http://localhost:8000 ... Press Ctrl+C to stop.")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer shutting down.")
