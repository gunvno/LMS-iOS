# MoneyFlow — Prompt dựng giao diện SwiftUI

## Cách sử dụng

Dùng nội dung từ “Yêu cầu” trở xuống làm prompt cho công cụ dựng giao diện/coding agent. Đọc cùng [thiết kế dữ liệu và nghiệp vụ](MoneyFlow-Database-Business.md). Tài liệu này thay thế prompt TaskFlow cũ; không dựng giao diện quản lý công việc.

Đây là đặc tả, chưa phải giao diện thực thi. Tên MoneyFlow là tên tạm cho app quản lý chi tiêu.

## Yêu cầu

Thiết kế và dựng app **MoneyFlow** bằng SwiftUI trong dự án hiện có, giao diện tiếng Việt. App giúp ghi thu/chi nhanh, xem dòng tiền theo tài khoản và hỗ trợ mở MBBank để người dùng tự thanh toán. Sau khi thanh toán, người dùng quay lại chủ động xác nhận ghi khoản chi.

Giữ cấu trúc MVVM, signing, Bundle ID và deployment target hiện tại. Nếu chỉ render UI, dùng repository trong bộ nhớ và fixture riêng, ghi rõ đây là dữ liệu mẫu. Preview không mở MB, không tạo giao dịch tiền thật. Khi triển khai thật mới nối SwiftData và adapter mở app ngân hàng.

Không có đăng nhập, liên kết ngân hàng thật, tự xác minh thanh toán hoặc số dư đồng bộ. Không thêm task/checklist/lịch/báo thức từ thiết kế cũ.

## 1. Trải nghiệm cần ưu tiên

- Nhập `20k` và thấy ngay **20.000đ**, chọn danh mục/tài khoản rồi lưu nhanh.
- Tách rõ **ghi khoản đã chi** và **mở MB để thanh toán trước**.
- Giữ bản nháp khi chuyển sang MB, app bị đóng, hoặc người dùng chọn Để sau.
- Khi quay lại, hỏi bằng ngôn ngữ đơn giản, không tự suy ra thanh toán thành công.
- Sửa được số tiền, nguồn tiền, ngày giờ trước khi ghi nhận, vì giao dịch thực tế có thể khác dự định.
- Một lần xác nhận chỉ tạo ảnh hưởng tiền một lần; nút khóa khi lưu.
- Xem rõ “Tài khoản nào · Ngày nào · Bao nhiêu tiền · Chi cho việc gì”.
- Luôn ghi **Số dư theo ghi chép**; không trình bày như số dư ngân hàng trực tiếp.
- Giảm lỗi bằng hoàn tác và bản nháp; xóa ghi chép không được diễn đạt là hoàn tiền.
- Không bắt cấp quyền hay nhập thông tin đăng nhập ngân hàng để sử dụng app.

## 2. Phong cách thị giác

Phong cách native Apple, rõ số tiền, dễ thao tác bằng một tay. Dùng font hệ thống, Dynamic Type, dark mode và Reduce Motion.

| Thành phần | Hướng thiết kế |
|---|---|
| Màu nhấn | Teal `#0F766E`, dùng sắc độ phù hợp dark mode |
| Nền sáng | `#F6F8FA`, surface trắng; nền tối dùng semantic colors |
| Số dư | Chữ lớn, số dễ đọc, phân tách hàng nghìn |
| Thu | Dấu `+`, nhãn Thu, màu xanh phù hợp độ tương phản |
| Chi | Dấu `−`, nhãn Chi, màu đỏ dịu |
| Chuyển nội bộ | Icon hai mũi tên, nhãn Chuyển tiền, màu xanh dương |
| Điều chỉnh | Nhãn Điều chỉnh, màu trung tính |
| Bản nháp | Nhãn Chưa ghi nhận, không dùng dấu trừ như khoản chi đã ghi |
| Card | Góc 16 pt, ít shadow, ưu tiên khoảng trắng và separator |

Nhịp khoảng cách 4/8/12/16/24/32 pt, lề ngang 20 pt. Vùng chạm tối thiểu 44 × 44 pt. Màu luôn đi kèm chữ/icon. Số tiền lớn/tiêu đề dài không tràn khi chữ lớn. Tên tài khoản không dùng logo ngân hàng làm bằng chứng đã kết nối; ưu tiên tên và icon đơn giản.

## 3. Điều hướng

iPhone có bốn tab:

| Tab | Nội dung |
|---|---|
| Tổng quan | Số dư theo ghi chép, thu/chi trong kỳ, nháp và giao dịch gần đây |
| Giao dịch | Lịch sử theo ngày, tìm kiếm và bộ lọc |
| Tài khoản | Tiền mặt/MB/MoMo và chi tiết dòng tiền từng tài khoản |
| Báo cáo | Thu/chi theo kỳ và danh mục |

Cài đặt truy cập bằng nút gear ở Tổng quan. Mỗi tab có NavigationStack; giữ vị trí cuộn/bộ lọc khi quay lại. Bộ lọc đang áp dụng luôn có chỉ báo.

Nút **Thêm giao dịch** ở toolbar dưới trong safe area, không che tab bar/hàng cuối. Trong màn tài khoản điền sẵn tài khoản đó. iPad/macOS dùng NavigationSplitView sidebar → danh sách → chi tiết khi đủ rộng; nút mở MB chỉ có khi nền tảng hỗ trợ thực tế.

## 4. Lần đầu sử dụng

Mở thẳng Tổng quan với lời mời **Tạo tài khoản đầu tiên**. Sheet gồm:
- Tên: Tiền mặt / MB cá nhân / tên tự nhập.
- Loại: Tiền mặt / Ngân hàng / Ví điện tử.
- Ngân hàng nếu chọn loại Ngân hàng; MB có adapter mở app đầu tiên.
- Số dư ban đầu: bắt buộc xác nhận, có thể 0đ; giải thích “Số tiền bạn bắt đầu theo dõi trong app”.
- Mốc bắt đầu: mặc định đầu ngày hôm nay, có thể chỉnh nếu nhập lịch sử.

Không yêu cầu số tài khoản đầy đủ, mật khẩu hoặc OTP. Với tài khoản ngân hàng, có thể nhập bốn ký tự cuối để phân biệt. Sau tạo, CTA **Ghi khoản chi đầu tiên**. Bộ danh mục mẫu được tạo một lần, không nhân đôi sau mỗi lần mở app.

## 5. Tổng quan

Từ trên xuống:
1. Title **Tổng quan**, chọn kỳ **Tháng này** và nút Cài đặt.
2. Card **Tổng số dư theo ghi chép**, số tiền lớn; nút ẩn/hiện số tiền cho riêng tư. Ghi chú “Từ các giao dịch bạn đã ghi nhận”; tổng bao gồm tài khoản lưu trữ còn số dư.
3. Hai chỉ số **Thu trong tháng** và **Chi trong tháng**. Chuyển nội bộ/điều chỉnh không tính vào hai số này.
4. Banner có điều kiện **“Bạn có N khoản nháp chưa ghi nhận”**, nút **Xem bản nháp**. Không gọi nháp là khoản nợ hoặc thanh toán thất bại.
5. Hàng tài khoản: tên, icon, số dư theo ghi chép; card MB có chữ **Ghi chép thủ công**.
6. **Giao dịch gần đây**, tối đa năm khoản recorded chưa xóa, nút Xem tất cả.
7. CTA **Thêm giao dịch**.

Không đưa quá nhiều biểu đồ lên màn đầu. Thu/chi theo kỳ và tổng số dư hiện tại là hai khái niệm khác nhau, phải ghi nhãn riêng.

## 6. Thêm giao dịch — ghi nhanh

Sheet mở được toàn chiều cao, nội dung cuộn và nút không bị bàn phím che. Toolbar Hủy / Thêm giao dịch. Chọn loại **Chi / Thu / Chuyển tiền**, mặc định Chi. Điều chỉnh chỉ tạo từ Đối soát số dư để tránh dùng nhầm.

Form Chi:
1. Ô số tiền lớn, bàn phím phù hợp; chấp nhận `20k` khi nhập/dán bằng phương thức có ký tự. Bàn phím số vẫn cho nhập `20000`. Bên dưới luôn hiện giá trị chuẩn **20.000đ**.
2. Chọn danh mục bằng icon + tên; nhớ lựa chọn gần nhất nhưng cho sửa rõ ràng.
3. Chọn **Nguồn tiền** bằng tên tài khoản và số dư theo ghi chép.
4. Nội dung một dòng, ví dụ Mua rau; bỏ trống thì dùng tên danh mục.
5. Ngày giờ mặc định hiện tại; có thể chỉnh.
6. **Thêm chi tiết** mở ghi chú và thông tin người nhận.

Cuối form có hai hành động phân biệt:
- **Đã thanh toán — Ghi khoản chi**: lưu khoản chi thủ công trực tiếp, không yêu cầu mở ngân hàng.
- **Mở MB để thanh toán**: chỉ hiện khi nguồn tiền MB và adapter khả dụng; lưu nháp trước rồi mở MB. Người dùng tự kiểm tra tài khoản nguồn trong MB, vì app không tự chọn đúng tài khoản MB bên ngoài.

Có nút phụ **Lưu nháp** trong menu khi muốn ghi dở. Nếu thiếu danh mục nhưng có số tiền hợp lệ, vẫn có thể lưu nháp; ghi sổ thì yêu cầu đủ danh mục/tài khoản. Nếu đóng form có thay đổi, cho Lưu nháp / Bỏ thay đổi / Tiếp tục sửa; Lưu nháp giải thích lỗi nếu số tiền chưa hợp lệ.

Form Thu dùng **Nhận vào tài khoản**, danh mục Thu và CTA **Ghi khoản thu**; không có nút mở MB để chi tiền. Form Chuyển tiền có Từ tài khoản / Đến tài khoản / Số tiền / Ngày giờ / Ghi chú, hai tài khoản phải khác nhau. CTA **Đã chuyển — Ghi chuyển nội bộ**, không tính thành chi tiêu.

Validation sát trường: amount > 0, định dạng tiền hợp lệ, đúng danh mục và tài khoản; ngày không ở tương lai/không trước mốc tài khoản. Số dư âm cho cảnh báo thông tin, không chặn lưu vì số dư chỉ là ghi chép.

## 7. Mở MB và quay lại xác nhận

Trước chuyển app, hiển thị tóm tắt **20.000đ · Mua rau · MB cá nhân**. Nếu muốn điền sẵn chuyển khoản, cho **Quét QR người nhận** hoặc nhập ngân hàng nhận + tài khoản nhận + tên nếu có. Không dùng tài khoản MB của người dùng làm người nhận mặc định.

Hai mức hỗ trợ phải rõ:
- **Mở MB**: chỉ chuyển ứng dụng, người dùng nhập/quét thông tin trong MB.
- **Mở MB với thông tin chuyển khoản**: chỉ dùng khi adapter autofill đã được kiểm thử; người dùng vẫn kiểm tra thông tin và xác nhận trong MB.

Nếu sử dụng link bên thứ ba, có giải thích ngắn trong thông tin tính năng rằng dữ liệu chuyển khoản cần thiết được chuyển qua nhà cung cấp link. Không gửi ghi chú chi tiêu riêng.

Khi quay lại, show sheet không tự ghi sổ:

```text
Bạn đã thanh toán khoản này chưa?

20.000đ
Mua rau · Thực phẩm
Nguồn tiền: MB cá nhân       [Đổi]
Thời gian: Hôm nay, 18:30    [Sửa]
Số tiền thực tế              [Sửa]

[Đã thanh toán — Ghi khoản chi]
[Chưa thanh toán]   [Để sau]

Khoản chi được ghi theo xác nhận của bạn.
App không kiểm tra giao dịch ngân hàng.
```

Thời gian là đề xuất tại lúc xác nhận, phải cho người dùng sửa theo giao dịch thực tế. Nếu nguồn tiền thực tế khác, đổi tài khoản ngay tại sheet. Sau lưu thành công, toast **Đã ghi khoản chi 20.000đ vào MB cá nhân**, cập nhật số dư, loại entry khỏi Nháp.

Nếu mở MB lỗi, hiển thị **Không mở được MB**, hành động Thử lại / Thanh toán thủ công / Để sau; giữ nháp. Nếu app bị đóng, lần sau có lối vào nháp. Không bắt người dùng xác nhận ngay mỗi lần foreground; khi Để sau thì banner nháp là đường quay lại. Nhiều nháp cần danh sách để chọn đúng khoản.

Chặn double tap khi save; không tạo giao dịch mới từ mỗi lần bấm xác nhận. Không dùng animation/nhãn “MB xác nhận thành công” vì không có kiểm tra ngân hàng.

## 8. Giao dịch và chi tiết

Màn Giao dịch có tìm kiếm theo nội dung/ghi chú, chọn thời gian và filter tài khoản/danh mục/loại. Tách **Đã ghi nhận** và **Bản nháp** bằng segmented control; không trộn nháp vào tổng chi.

Danh sách recorded nhóm theo ngày, mới nhất trước. Header mỗi ngày có Thu / Chi riêng; nếu có transfer/adjustment thì không cộng nhầm vào hai tổng này. Mỗi row gồm icon danh mục, nội dung, tên tài khoản, giờ, số tiền có dấu và nhãn loại.

Chuyển nội bộ trong màn toàn app chỉ một row **MB cá nhân → Tiền mặt · 100.000đ**, không render thành hai khoản thu/chi. Trong chi tiết tài khoản, dấu tiền thể hiện chiều vào/ra của tài khoản đang xem.

Chi tiết khoản ghi nhận: số tiền, loại, danh mục, tài khoản, thời điểm giao dịch, thời điểm ghi nhận, ghi chú, người nhận nếu có, nhãn **Bạn xác nhận thủ công**. Menu Sửa / Xóa ghi chép. Không có nút thanh toán lại trên khoản đã recorded để tránh trả tiền lần hai.

Chi tiết nháp: nhãn **Chưa ghi nhận**, CTA **Đã thanh toán — Ghi khoản chi**, nút mở MB và sửa/xóa nháp. Đã mở MB chỉ là metadata điều hướng, không đổi nhãn thành đã thanh toán.

## 9. Tài khoản và đối soát

Màn Tài khoản có card theo nguồn tiền. Tài khoản lưu trữ nằm trong phần riêng, vẫn tính trong tổng số dư nếu còn được theo dõi. Có nút **Thêm tài khoản ghi chép**, không dùng “Liên kết ngân hàng”.

Chi tiết MB:
- Title **MB cá nhân**, số dư lớn với nhãn **Số dư theo ghi chép**.
- Bộ chọn kỳ, tóm tắt Thu / Chi / Chuyển vào / Chuyển ra / Điều chỉnh.
- Lịch sử theo ngày; mỗi khoản có số tiền và thời gian rõ ràng.
- CTA **Thêm giao dịch** điền sẵn tài khoản này.
- Nút phụ **Đối soát số dư**, menu Sửa tài khoản / Lưu trữ.

Sheet đối soát: số dư theo ghi chép → nhập số dư vừa kiểm tra trong ngân hàng → hiện chênh lệch. Gợi ý kiểm tra khoản thiếu/trùng trước; có Hủy hoặc **Ghi điều chỉnh** kèm lý do. Chênh lệch bằng 0 hiện **Số dư đã khớp theo thông tin bạn nhập**, không tạo khoản 0đ. Nêu rõ điều chỉnh không tính vào thu/chi tiêu và không thay đổi tiền trong ngân hàng.

## 10. Báo cáo

Chọn Tháng này / Tháng trước / Khoảng tùy chọn, lọc tài khoản nếu cần. Hiển thị tổng Thu, tổng Chi, **Thu − Chi trong kỳ**, rồi biểu đồ chi theo danh mục và danh sách số tiền/tỷ trọng.

Không gọi Thu − Chi là số dư tài khoản hoặc lợi nhuận. Không tính transfer/adjustment vào thu/chi; nếu cần giải thích biến động số dư thì có bảng riêng hiển thị chuyển vào/ra và điều chỉnh. Biểu đồ có text thay thế, legend rõ; không yêu cầu phân biệt chỉ bằng màu. Khi chi = 0, không vẽ donut giả hoặc tính tỷ lệ chia cho 0.

## 11. Cài đặt, xóa và trạng thái lỗi

Cài đặt: giao diện Theo hệ thống/Sáng/Tối; quản lý danh mục; tài khoản lưu trữ; Thùng rác; thông tin app; giải thích số dư ghi chép và mở MB. Không có mục cloud/đã kết nối ngân hàng giả.

Xóa entry recorded: xác nhận **Xóa ghi chép này sẽ cập nhật số dư và báo cáo trong app. Tiền đã chuyển trong ngân hàng không thay đổi.** Có Hoàn tác; Thùng rác có Khôi phục / Xóa vĩnh viễn. Không tự dọn thùng rác trong MVP. Entry trong thùng rác chỉ xem, khôi phục trước khi sửa.

| Trạng thái | Hiển thị |
|---|---|
| Chưa có tài khoản | Tạo tài khoản đầu tiên |
| Chưa có giao dịch | “Bắt đầu từ một khoản chi nhỏ” — Thêm giao dịch |
| Chưa có nháp | “Không có khoản nháp” |
| Bộ lọc không có kết quả | “Không tìm thấy giao dịch phù hợp” — Xóa bộ lọc |
| Không mở được MB | Nháp được giữ, cho thử lại hoặc thanh toán thủ công |
| Ghi nhận thất bại | Giữ dữ liệu, cho thử lại; không đổi số dư trên UI |
| Lỗi store/migration | Báo không tải được dữ liệu, không reset database |
| Thùng rác trống | “Không có ghi chép đã xóa” |

Thông báo lỗi phải nói rõ bước nào thất bại. Không tạo loading giả, không báo Đã lưu trước khi persistence thành công.

## 12. Fixture để render và kiểm tra số liệu

Tạo ngày hiện tại D và đầu tháng M theo Calendar. Tất cả tài khoản có mốc bắt đầu M, opening balance như bảng dưới. Các entry mẫu thuộc D, không nằm trong tương lai so với thời điểm preview. Phân bố thời điểm giao dịch trong khoảng từ đầu ngày D tới now bằng tỷ lệ của khoảng; không trừ giờ cố định làm giao dịch lệch sang ngày/tháng trước.

| Tài khoản | Số dư ban đầu |
|---|---|
| MB cá nhân | 5.000.000đ |
| Tiền mặt | 500.000đ |
| MoMo | 200.000đ |

| Entry đã ghi nhận | Nguồn → Đích | Số tiền | Danh mục |
|---|---|---|---|
| Nhận lương | → MB | 10.000.000đ | Lương |
| Mua rau | MB → | 20.000đ | Thực phẩm |
| Ăn trưa | Tiền mặt → | 45.000đ | Ăn ngoài |
| Đi xe | MoMo → | 30.000đ | Di chuyển |
| Rút tiền mặt | MB → Tiền mặt | 1.000.000đ | Không có, transfer |

Thêm fixture riêng cho nhiều ngày/tháng để thử phân nhóm, với mốc bắt đầu tài khoản không sau giao dịch mẫu đầu tiên.

Kết quả fixture chính:
- MB: **13.980.000đ**; Tiền mặt: **1.455.000đ**; MoMo: **170.000đ**.
- Tổng số dư: **15.605.000đ**.
- Thu trong tháng: **10.000.000đ**; chi: **95.000đ**; Thu − Chi: **9.905.000đ**.
- Nháp “Mua rau buổi tối · 20.000đ · MB” không đổi các tổng trên. Khi người dùng xác nhận nháp này, MB còn 13.960.000đ, tổng chi lên 115.000đ.

Không gán account suffix, QR hoặc số tài khoản người nhận thật trong fixture. Mock BankAppLauncher chỉ mô phỏng đã mở/lỗi trong bản preview có nhãn Dữ liệu mẫu. Render thêm dark mode, chữ lớn, màn rỗng, form thêm, sheet quay lại MB, chi tiết tài khoản và đối soát.

## 13. Đầu ra và tiêu chí nghiệm thu UI

Component gợi ý: `MoneyAmountField`, `AccountPicker`, `CategoryPicker`, `MoneyEntryRow`, `AccountBalanceCard`, `DraftBanner`, `PaymentConfirmationSheet`, `CashFlowSummary`, `ExpenseCategoryChart`, `ReconciliationSheet`, `EmptyStateView`.

- Các nút thêm/sửa/ghi nhận/lọc/xóa/khôi phục phải cập nhật nhất quán trong kho mẫu nếu chưa có SwiftData; không chỉ là hình tĩnh có nút vô tác dụng.
- Tạo khoản chi 20k, mở MB mô phỏng rồi xác nhận: chỉ một entry chuyển từ draft sang recorded, số dư thay đổi đúng một lần.
- Có thể tạo khoản chi đã thanh toán trực tiếp mà không mở MB.
- Đổi số tiền hoặc tài khoản khi xác nhận phải cập nhật đúng dòng tiền.
- Thu/chi/chuyển nội bộ/điều chỉnh có nhãn và cách tính rõ ràng.
- Bản nháp không cộng vào báo cáo; xóa ghi chép không được gọi là hoàn tiền.
- Hoạt động với bàn phím, safe area, dark mode, Dynamic Type và VoiceOver.
- Khi bàn giao, nêu rõ đã dựng UI mẫu, đã nối SwiftData hay đã kiểm thử mở MB; không suy ra các bước còn lại đã hoàn thành.

Nguồn tham khảo cho khả năng mở MB: [VietQR.io — changelog](https://www.vietqr.io/changelog/), [deeplink ngân hàng](https://www.vietqr.io/danh-sach-api/deeplink-app-ngan-hang/). Không cần webhook/xác minh thanh toán trong phiên bản này.
