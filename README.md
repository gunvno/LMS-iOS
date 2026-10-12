# FirstApp

Bộ khung SwiftUI + MVVM. Giao diện khởi chạy vẫn là “Hello, world!”.

## Hướng sản phẩm hiện tại: MoneyFlow

App quản lý chi tiêu cá nhân: ghi thu/chi theo tài khoản, hỗ trợ mở MB để người dùng tự thanh toán, sau đó quay lại xác nhận ghi khoản chi. Số dư là số dư theo ghi chép; chưa kết nối hoặc tự xác minh giao dịch ngân hàng.

- [Thiết kế database và nghiệp vụ](docs/MoneyFlow-Database-Business.md)
- [Prompt dựng giao diện SwiftUI](docs/MoneyFlow-UI-Prompt.md)

Hai tài liệu này thay thế hướng TaskFlow quản lý công việc trước đây. Source hiện vẫn là bộ khung, chưa triển khai tính năng MoneyFlow.

## Cấu trúc

```text
FirstApp/
├── App/                         # Điểm khởi chạy ứng dụng
├── Models/                      # Kiểu dữ liệu dùng trong ứng dụng
├── Views/
│   ├── Screens/
│   │   ├── Home/
│   │   │   ├── HomeView.swift
│   │   │   └── Components/        # Thành phần chỉ dùng ở Home
│   │   ├── Reading/
│   │   └── Settings/
│   └── Components/              # Giao diện dùng chung
├── ViewModels/                  # Trạng thái và logic từng màn
│   └── HomeViewModel.swift
├── Data/
│   ├── Network/                 # API client, endpoint, DTO
│   ├── Repositories/            # Điều phối API và cache
│   └── Storage/                 # Lưu dữ liệu trên thiết bị
├── Services/                    # Audio, thông báo, thanh toán…
├── Navigation/                  # Route, coordinator, điều hướng
├── Shared/
│   ├── Extensions/
│   ├── Constants/
│   └── Utilities/
├── Resources/
│   ├── Assets.xcassets/
│   └── Fonts/
└── Configuration/               # Cấu hình môi trường, entitlement

FirstAppTests/                   # Dự phòng cho unit test
FirstAppUITests/                 # Dự phòng cho UI test
FirstApp.xcodeproj/
```

## Quy ước

- `View` hiển thị giao diện; `ViewModel` quản lí trạng thái của màn.
- Khi có dữ liệu thật: `View → ViewModel → Repository → API / Storage`.
- Các thư mục trống chứa `.gitkeep` để Git lưu được cấu trúc; không có logic giả.
- `.gitkeep` được loại khỏi build bằng `EXCLUDED_SOURCE_FILE_NAMES` ở cả Debug và Release để không bị sao chép trùng vào app bundle.
- Thư mục nguồn được Xcode đồng bộ tự động nên file Swift mới trong `FirstApp/` được nhận vào target.
- Giữ nguyên signing, Bundle ID, deployment target và các nền tảng của project gốc.
- Chưa cần `AppDelegate` với app SwiftUI thuần. Khi tích hợp SDK cần delegate, thêm vào `App/` và đăng kí với app theo nền tảng tương ứng.
- Khi cần đa ngôn ngữ, tạo String Catalog `Localizable.xcstrings` trong `Resources/`.
- Chưa tạo hay cấu hình test target. Hai thư mục test chỉ là chỗ dự phòng; thêm target Unit Testing / UI Testing trong Xcode trước khi viết và chạy test.
- `Configuration/` hiện chưa được gắn với cấu hình build. Không đặt khóa bí mật vào source code.
