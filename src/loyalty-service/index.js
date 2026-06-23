const express = require('express');
const app = express();
const port = 8080;

app.use(express.json());

app.post('/api/loyalty/add', (req, res) => {
    // Giả lập nhận ID user và cộng 100 điểm
    const userId = req.body.userId || "anonymous";
    console.log(`[Loyalty Service] Thêm 100 điểm cho user: ${userId}`);
    
    res.json({
        status: "success",
        userId: userId,
        pointsAdded: 100,
        message: "Cộng điểm thành công!"
    });
});

app.listen(port, () => {
    console.log(`Loyalty Service đang chạy ở cổng ${port}`);
});