from fastapi import FastAPI

app = FastAPI(title="Discount Service")

@app.get("/api/discount/{code}")
def get_discount(code: str):
    # Trả về 15% nếu đúng mã, ngược lại là 0%
    if code.upper() == "UIT2026":
        return {"code": code, "discount_percent": 15, "valid": True}
    return {"code": code, "discount_percent": 0, "valid": False}
