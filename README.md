# hotel_booking_app
# Giai đoạn Giao diện
- A new Flutter project.
-  Màu chủ đạo: Color(0xFF0077FF)
- Cấu trúc:
  -  Core/widgets: chứa các widget dùng chung toàn ứng dụng.
  -  Models: chứa các class cơ sở dữ liệu
  -  Screens: các màn hình
  -  Services:  nơi viết tất cả các logic nghiệp vụ (business logic) và thao tác với dữ liệu, thay vì để logic đó nằm trực tiếp trong màn hình (screen).
  -  Lib/widgets: chứa các UI dùng lại của các chức năng.
  -  (ví dụ: room_card_widget.dart # Hiển thị thông tin phòng)

# Giai đoạn Kết nối cơ sở dữ liệu
- 1. 🎯 Mục tiêu hệ thống

-  Ứng dụng đặt phòng khách sạn (1 khách sạn) gồm:

- 👤 Khách hàng
-  Xem danh sách phòng
-  Đặt phòng
-  Nhận thông báo
-  Đánh giá (có upload ảnh)
- 🛠️ Admin
-  Quản lý phòng (CRUD, số phòng trống)
-  Quản lý đơn đặt
-  Quản lý khách hàng
-  Quản lý đánh giá
-  Gửi thông báo

- 2. Kiến trúc tổng thể

-  UI → Controller → Service → Model → Firebase (Firestore / Cloudinary)
-  Luồng đọc dữ liệu:

-    Firebase → Service → Model → Controller → UI

-  Giải thích:
-    UI: hiển thị, nhận input
-    Controller: xử lý logic, điều phối
-    Service: làm việc với Firebase(CRUD, truy vấn) / Cloudinary 
-    Model: định nghĩa dữ liệu (toJson, fromJson)

- 3. Firebase & Cloudinary

-  Firebase dùng:
-    Authentication → đăng nhập/đăng ký
-    Cloud Firestore → lưu dữ liệu
-  Cloudinary:
-    Upload ảnh → trả URL → lưu vào Firestore

- 4. Cách chạy project
-  Clone repo
-  Chạy: flutter pub get
-  Thêm file Firebase: google-services.json
-  Run: flutter run