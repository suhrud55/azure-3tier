from http.server import SimpleHTTPRequestHandler, HTTPServer

HTTPServer(("", 3000), SimpleHTTPRequestHandler).serve_forever()