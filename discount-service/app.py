from http.server import BaseHTTPRequestHandler, HTTPServer
import time
import random

class MockHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        order_id = random.randint(1000, 9999)
        # Flush=True cực kỳ quan trọng để log đẩy thẳng ra Docker ngay lập tức
        print(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] [INFO] Received gRPC request for Order ID: {order_id}. Applying 20% discount code...", flush=True)
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Discount applied successfully\n")

if __name__ == "__main__":
    print("Discount Service Backend started on port 8000...", flush=True)
    server = HTTPServer(('0.0.0.0', 8000), MockHandler)
    server.serve_forever()
