# Self-healing Microservices Infrastructure with Terraform & GitOps

## 📝 Giới thiệu
Đề tài đồ án chuyên ngành tập trung vào việc xây dựng hạ tầng phân tán có khả năng tự phục hồi và bảo mật trên nền tảng Cloud (AWS).

## 🛠 Tech Stack (Công nghệ sử dụng)
- **Cloud Platform:** AWS (EKS, VPC, ECR, S3)
- **Infrastructure as Code (IaC):** Terraform
- **CI/CD & Security:** GitHub Actions, Checkov
- **GitOps:** ArgoCD
- **Demo Application:** Google Online Boutique (Microservices)

## 🏗 Kiến trúc hệ thống
Hệ thống được thiết kế theo nguyên lý Hệ tính toán phân bố với khả năng chịu lỗi và tự phục hồi (Self-healing).

> *Gợi ý: Tâm hãy chèn link ảnh sơ đồ kiến trúc mà mình đã gửi bạn ở đây.*

## 🎯 Mục tiêu đồ án
* **Tự động hóa:** Triển khai hạ tầng và ứng dụng 100% bằng mã nguồn.
* **Tính sẵn sàng cao:** Chạy phân tán trên nhiều Availability Zones.
* **Bảo mật:** Quét lỗi cấu hình hạ tầng tự động ngay từ khâu CI.
* **Khả năng tự hồi phục:** Tự động phát hiện và khởi động lại các dịch vụ gặp sự cố (Liveness/Readiness Probes).

## 👥 Thành viên nhóm
1. Nguyễn Đinh Công Thành
2. Lê Đình Thiện Tâm
