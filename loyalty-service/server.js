const http = require('http');

const server = http.createServer((req, res) => {
    const orderId = Math.floor(1000 + Math.random() * 9000);
    console.log(`[${new Date().toISOString()}] [SUCCESS] Order ${orderId} processed. Calculated 50 loyalty points added to User account.`);
    res.writeHead(200);
    res.end("Loyalty points updated\n");
});

// Lệnh này giữ cho ứng dụng không bao giờ bị tắt (Completed)
server.listen(8080, '0.0.0.0', () => {
    console.log("Loyalty Service Backend started on port 8080...");
});
