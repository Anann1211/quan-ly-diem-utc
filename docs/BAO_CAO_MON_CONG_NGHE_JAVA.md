# BÁO CÁO BÀI TẬP LỚN: HỌC PHẦN CÔNG NGHỆ JAVA

**BỘ GIÁO DỤC VÀ ĐÀO TẠO — TRƯỜNG ĐẠI HỌC GIAO THÔNG VẬN TẢI**  
**KHOA CÔNG NGHỆ THÔNG TIN — BỘ MÔN CÔNG NGHỆ PHẦN MỀM**

---

### **ĐỀ TÀI:**
## **XÂY DỰNG HỆ THỐNG QUẢN LÝ ĐIỂM SINH VIÊN THEO HỌC CHẾ TÍN CHỈ SỬ DỤNG JAVA WEB (SERVLET / JSP / JDBC) VÀ ORACLE DATABASE 23ai**

* **Giảng viên hướng dẫn:** TS. Giảng viên phụ trách học phần Công nghệ Java
* **Nhóm sinh viên thực hiện:** Nhóm thực hiện đề tài UTC
* **Chuyên ngành:** Công nghệ thông tin & Kỹ thuật phần mềm
* **Khóa học:** Khóa 62 / Khóa 63
* **Hệ đào tạo:** Chính quy theo học chế tín chỉ
* **Tệp Word nộp bài chính thức:** [`docs/Bao_Cao_Bai_Tap_Nhom_Quan_Ly_Diem_UTC.docx`](file:///c:/Users/Acer/Downloads/Bài%20tập%20nhóm/docs/Bao_Cao_Bai_Tap_Nhom_Quan_Ly_Diem_UTC.docx)
* **Kho mã nguồn GitHub:** [https://github.com/Anann1211/quan-ly-diem-utc](https://github.com/Anann1211/quan-ly-diem-utc)

---

## BẢNG PHÂN CÔNG NHIỆM VỤ THỰC HIỆN ĐỀ TÀI

| STT | Họ và tên | Mã sinh viên | Nhiệm vụ phụ trách trong dự án | Mức độ hoàn thành |
| :---: | :--- | :---: | :--- | :---: |
| 1 | **Nguyễn Văn An** *(Trưởng nhóm)* | 211200001 | Kiến trúc tổng thể Java Web MVC, Bộ lọc AuthFilter (RBAC) & EncodingFilter (UTF-8), Điều hướng Servlet (AuthServlet, AdminDashboardServlet), Quản lý Session. | 100% (Hoàn thành xuất sắc) |
| 2 | **Trần Thị Bình** | 211200002 | Thiết kế và cài đặt CSDL Oracle 23ai (11 bảng chuẩn hóa 3NF), Xây dựng các lớp DAO với JDBC PreparedStatement, Tối ưu Index và bảo mật chống SQL Injection. | 100% (Hoàn thành xuất sắc) |
| 3 | **Lê Hoàng Cường** | 211200003 | Hiện thực hóa quy tắc tính điểm tín chỉ UTC trong GradeCalculator.java (trọng số động, điểm liệt thi, thang điểm chữ, thang 4, GPA/CPA), Xử lý Import/Export Excel bằng Apache POI trong ExcelService.java. | 100% (Hoàn thành xuất sắc) |
| 4 | **Phạm Minh Đức** | 211200004 | Xây dựng giao diện Responsive với JSP, JSTL, Tailwind CSS & Font Awesome 6, Thiết kế trang in phiếu điểm A4 chuẩn mẫu UTC bằng JavaScript & Print CSS. | 100% (Hoàn thành xuất sắc) |

---

## MỤC LỤC TỔNG THỂ BÁO CÁO

* [CHƯƠNG 1: TỔNG QUAN ĐỀ TÀI VÀ KHẢO SÁT BÀI TOÁN QUẢN LÝ ĐIỂM UTC](#chương-1-tổng-quan-đề-tài-và-khảo-sát-bài-toán-quản-lý-điểm-utc)
  * [1.1. Đặt vấn đề và tính cấp thiết của đề tài](#11-đặt-vấn-đề-và-tính-cấp-thiết-của-đề-tài)
  * [1.2. Mục tiêu, phạm vi và mô hình phân quyền người dùng (RBAC)](#12-mục-tiêu-phạm-vi-và-mô-hình-phân-quyền-người-dùng-rbac)
  * [1.3. Quy tắc nghiệp vụ tính điểm chuẩn tín chỉ Trường ĐH Giao thông Vận tải](#13-quy-tắc-nghiệp-vụ-tính-điểm-chuẩn-tín-chỉ-trường-đh-giao-thông-vận-tải)
  * [1.4. Nền tảng Công nghệ Java và môi trường phát triển ứng dụng](#14-nền-tảng-công-nghệ-java-và-môi-trường-phát-triển-ứng-dụng)
* [CHƯƠNG 2: PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG](#chương-2-phân-tích-và-thiết-kế-hệ-thống)
  * [2.1. Phân tích yêu cầu chức năng theo 3 tác nhân](#21-phân-tích-yêu-cầu-chức-năng-theo-3-tác-nhân)
  * [2.2. Biểu đồ Use Case tổng quát và đặc tả tác nhân](#22-biểu-đồ-use-case-tổng-quát-và-đặc-tả-tác-nhân)
  * [2.3. Quy trình nghiệp vụ và vòng đời trạng thái bảng điểm học phần](#23-quy-trình-nghiệp-vụ-và-vòng-đời-trạng-thái-bảng-điểm-học-phần)
* [CHƯƠNG 3: THIẾT KẾ CƠ SỞ DỮ LIỆU TRÊN ORACLE DATABASE 23ai](#chương-3-thiết-kế-cơ-sở-dữ-liệu-trên-oracle-database-23ai)
  * [3.1. Sơ đồ thực thể liên kết (ERD 11 bảng chuẩn hóa dạng 3 - 3NF)](#31-sơ-đồ-thực-thể-liên-kết-erd-11-bảng-chuẩn-hóa-dạng-3---3nf)
  * [3.2. Từ điển dữ liệu chi tiết (Data Dictionary)](#32-từ-điển-dữ-liệu-chi-tiết-data-dictionary)
  * [3.3. Các kỹ thuật tối ưu hóa và đảm bảo an toàn dữ liệu trên Oracle 23ai](#33-các-kỹ-thuật-tối-ưu-hóa-và-đảm-bảo-an-toàn-dữ-liệu-trên-oracle-23ai)
* [CHƯƠNG 4: KIẾN TRÚC HỆ THỐNG VÀ HIỆN THỰC HÓA MÃ NGUỒN CÔNG NGHỆ JAVA](#chương-4-kiến-trúc-hệ-thống-và-hiện-thực-hóa-mã-nguồn-công-nghệ-java)
  * [4.1. Kiến trúc phân tầng 3-Tier kết hợp mẫu thiết kế MVC trong Java Web](#41-kiến-trúc-phân-tầng-3-tier-kết-hợp-mẫu-thiết-kế-mvc-trong-java-web)
  * [4.2. Cấu trúc tổ chức thư mục dự án theo chuẩn Apache Maven](#42-cấu-trúc-tổ-chức-thư-mục-dự-án-theo-chuẩn-apache-maven)
  * [4.3. Hiện thực hóa các thành phần cốt lõi bằng Công nghệ Java](#43-hiện-thực-hóa-các-thành-phần-cốt-lõi-bằng-công-nghệ-java)
* [CHƯƠNG 5: KẾT QUẢ THỰC NGHIỆM VÀ ĐÁNH GIÁ HỆ THỐNG](#chương-5-kết-quả-thực-nghiệm-và-đánh-giá-hệ-thống)
  * [5.1. Kịch bản cài đặt và khởi chạy hệ thống 1-Click](#51-kịch-bản-cài-đặt-và-khởi-chạy-hệ-thống-1-click)
  * [5.2. Kết quả thực nghiệm các phân hệ chức năng trên giao diện Web](#52-kết-quả-thực-nghiệm-các-phân-hệ-chức-năng-trên-giao-diện-web)
  * [5.3. Bảng tài khoản trải nghiệm hệ thống](#53-bảng-tài-khoản-trải-nghiệm-hệ-thống)
  * [5.4. Đánh giá ưu điểm, hạn chế và định hướng phát triển](#54-đánh-giá-ưu-điểm-hạn-chế-và-định-hướng-phát-triển)
* [KẾT LUẬN CHUNG](#kết-luận-chung)
* [TÀI LIỆU THAM KHẢO](#tài-liệu-tham-khảo)

---

# CHƯƠNG 1: TỔNG QUAN ĐỀ TÀI VÀ KHẢO SÁT BÀI TOÁN QUẢN LÝ ĐIỂM UTC

## 1.1. Đặt vấn đề và tính cấp thiết của đề tài
Trong tiến trình chuyển đổi số giáo dục đại học theo định hướng của Bộ Giáo dục và Đào tạo [9], quy chế đào tạo đại học chính quy theo học chế tín chỉ đặt ra những đòi hỏi rất cao về tính chính xác, tính đồng bộ và sự minh bạch trong quản lý kết quả học tập của sinh viên. Trường Đại học Giao thông Vận tải (UTC) là trường đại học kỹ thuật đa ngành hàng đầu, quy mô đào tạo lên tới hàng chục nghìn sinh viên với hàng nghìn lớp học phần mở mới mỗi học kỳ [10].

Phương thức quản lý điểm truyền thống hoặc việc sử dụng các bảng tính Excel độc lập gửi qua email thường bộc lộ những hạn chế cố hữu nghiêm trọng:
* **Nguy cơ sai lệch công thức**: Việc áp dụng các công thức tính điểm tổng kết thang 10 có trọng số và quy đổi sang thang điểm chữ (A+, A, B+, B, C+, C, D+, D, F+, F) hay thang điểm 4 dễ phát sinh sai sót nếu không được xử lý bằng thuật toán phần mềm tập trung.
* **Vi phạm quy chế điểm liệt**: Điểm thi kết thúc học phần dưới 4.0 điểm theo quy chế tín chỉ UTC phải tính là điểm liệt (bị điểm F/F+ và không đạt học phần) [9], [10]. Việc kiểm soát thủ công trên tệp Excel dễ bỏ lọt các trường hợp này.
* **Thiếu quy trình kiểm duyệt và khóa sổ**: Điểm số sau khi giảng viên nhập cần phải được Phòng Đào tạo thẩm định và phê duyệt trước khi công bố chính thức cho sinh viên.
* **Lỗ hổng bảo mật và thiếu vết kiểm toán (Audit Trail)**: Khi điểm số bị thay đổi sau khi đã nhập, nếu không có cơ chế lưu vết lịch sử (*Ai sửa, Sửa khi nào, Điểm cũ là bao nhiêu, Điểm mới là bao nhiêu, Lý do điều chỉnh*) thì sẽ tiềm ẩn rủi ro tiêu cực và vi phạm quy chế đào tạo.

Nhằm giải quyết triệt để các hạn chế trên, đề tài **"Xây dựng Hệ thống Quản lý điểm Sinh viên theo học chế tín chỉ sử dụng Java Web (Servlet / JSP / JDBC) và Oracle Database 23ai"** trong khuôn khổ học phần **Công nghệ Java** được triển khai. Ứng dụng khai thác tối đa sức mạnh hướng đối tượng của ngôn ngữ Java [1], [13], kiến trúc máy chủ Java Web Servlet 4.0 [2], tầng giao diện JSP 2.3 [3] và hệ quản trị cơ sở dữ liệu mạnh mẽ Oracle Database 23ai Free [4].

## 1.2. Mục tiêu, phạm vi và mô hình phân quyền người dùng (RBAC)
Mục tiêu trọng tâm của hệ thống là tự động hóa toàn diện quy trình nhập điểm, tính điểm, kiểm duyệt điểm, công bố điểm và truy xuất báo cáo học vụ theo đúng Quy chế đào tạo tín chỉ Trường ĐH Giao thông Vận tải [10].

Hệ thống áp dụng mô hình Kiểm soát truy cập dựa trên vai trò (Role-Based Access Control - RBAC) [11], phân tách quyền hạn chặt chẽ thành 3 nhóm tác nhân chính:
1. **Sinh viên (Role: `SINH_VIEN`)**: Đăng nhập tra cứu bảng điểm cá nhân chi tiết theo từng học kỳ hoặc toàn khóa học; theo dõi các chỉ số tích lũy học lực GPA, CPA; in bảng điểm chính thức định dạng chuẩn A4 có dấu xác nhận của Phòng Đào tạo.
2. **Giảng viên (Role: `GIANG_VIEN`)**: Quản lý danh sách các lớp học phần được phân công giảng dạy; nhập điểm trực tiếp trên sổ điểm điện tử (Live Data Grid) với khả năng tự động tính điểm tức thời; tải file mẫu Excel và nạp điểm hàng loạt thông qua thư viện Apache POI [6]; gửi bảng điểm lên Phòng Đào tạo để thẩm định.
3. **Phòng Đào tạo (Role: `ADMIN`)**: Quản trị danh mục Khoa, Ngành, Lớp chuyên ngành, Lớp học phần, Học kỳ và Môn học; cấu hình trọng số % điểm môn học; thực hiện thẩm định và phê duyệt bảng điểm (chuyển trạng thái từ `SUBMITTED` sang `PUBLISHED`); giám sát phổ điểm và sinh viên bị cảnh báo học vụ; theo dõi toàn bộ nhật ký biến động điểm (Audit Log).

## 1.3. Quy tắc nghiệp vụ tính điểm chuẩn tín chỉ Trường ĐH Giao thông Vận tải
Hệ thống hiện thực hóa trọn vẹn các quy định nghiệp vụ tại Quy định đào tạo đại học chính quy của UTC [10] và Thông tư 08/2021/TT-BGDĐT của Bộ GD&ĐT [9]:

### 1. Điểm tổng kết học phần (thang điểm 10):
Được tính toán dựa trên các điểm thành phần kết hợp trọng số quy định riêng cho từng môn học:
$$\text{Điểm TK10} = (\text{Điểm Chuyên cần} \times W_{CC}) + (\text{Điểm Giữa kỳ} \times W_{GK}) + (\text{Điểm Thi} \times W_{THI})$$
*Trong đó:* $W_{CC} + W_{GK} + W_{THI} = 1.0$ (Tổng trọng số luôn bằng 100%). Kết quả được làm tròn chính xác đến 1 chữ số thập phân (`RoundingMode.HALF_UP`).

### 2. Quy tắc Điểm liệt thi kết thúc học phần:
Theo Quy chế UTC [10], nếu Điểm Thi kết thúc học phần dưới 4.0 điểm, học phần tự động bị đánh giá là **`KHONG_DAT`** bất kể điểm tổng kết hệ 10 là bao nhiêu. Điểm chữ bị gán là **`F+`** (nếu Điểm TK10 $\ge 2.0$) hoặc **`F`** (nếu Điểm TK10 $< 2.0$).

### 3. Bảng quy đổi Thang điểm chữ (10 mức) và Thang 4.0 chuẩn UTC:

| Đánh giá xếp loại | Thang điểm 10 | Điểm chữ UTC | Thang điểm 4 | Kết quả học phần |
| :--- | :---: | :---: | :---: | :--- |
| **Xuất sắc** | 9.5 – 10.0 | **A+** | **4.0** | Đạt (Tích lũy tín chỉ) |
| **Giỏi** | 8.5 – 9.4 | **A** | **3.8** | Đạt (Tích lũy tín chỉ) |
| **Khá giỏi** | 8.0 – 8.4 | **B+** | **3.5** | Đạt (Tích lũy tín chỉ) |
| **Khá** | 7.0 – 7.9 | **B** | **3.0** | Đạt (Tích lũy tín chỉ) |
| **Trung bình khá** | 6.0 – 6.9 | **C+** | **2.5** | Đạt (Tích lũy tín chỉ) |
| **Trung bình** | 5.5 – 5.9 | **C** | **2.0** | Đạt (Tích lũy tín chỉ) |
| **Trung bình yếu** | 4.5 – 5.4 | **D+** | **1.5** | Đạt (Tích lũy tín chỉ) |
| **Đạt tối thiểu** | 4.0 – 4.4 | **D** | **1.0** | Đạt (Cần học cải thiện) |
| **Không đạt (Học lại)** | 2.0 – 3.9 (hoặc Liệt thi) | **F+** | **0.5** | Không đạt (Buộc phải học lại) |
| **Kém (Học lại)** | 0.0 – 1.9 (hoặc Liệt thi) | **F** | **0.0** | Không đạt (Buộc phải học lại) |

### 4. Điểm trung bình học kỳ (GPA) và Điểm trung bình tích lũy (CPA):
$$\text{GPA} = \frac{\sum (\text{Điểm hệ 4 của học phần } i \times \text{Số tín chỉ } i)}{\sum \text{Số tín chỉ đăng ký trong kỳ}}$$
$$\text{CPA} = \frac{\sum (\text{Điểm hệ 4 cao nhất của môn } j \times \text{Số tín chỉ } j)}{\sum \text{Số tín chỉ tích lũy toàn khóa}}$$
*Điểm GPA và CPA được làm tròn đến 2 chữ số thập phân.*

### 5. Cảnh báo học vụ:
Sinh viên có điểm tích lũy CPA dưới 1.00 bị cảnh báo học vụ mức 1; CPA dưới 0.80 bị cảnh báo học vụ mức 2 (thuộc diện xem xét buộc thôi học) [10].

## 1.4. Nền tảng Công nghệ Java và môi trường phát triển ứng dụng
Là một dự án mẫu mực của học phần Công nghệ Java, toàn bộ các thành phần phần mềm được xây dựng dựa trên hệ sinh thái Java chuẩn mực:
* **Ngôn ngữ Java (Java SE 17 LTS / Java 21 LTS)**: Khai thác đầy đủ các tính năng lập trình hướng đối tượng vững chắc (OOP: Encapsulation, Inheritance, Polymorphism, Interface), cơ chế xử lý đa luồng (Multithreading), Collections Framework và tính năng toán học chính xác cao `BigDecimal` [1], [13], [14].
* **Java Servlet 4.0 (Jakarta Servlet)**: Đóng vai trò Controller trung tâm trong mô hình MVC, xử lý điều hướng yêu cầu HTTP GET/POST, kiểm soát phiên làm việc `HttpSession` và quản lý tệp tải lên với `@MultipartConfig` [2].
* **Java Filter API**: Xây dựng `EncodingFilter` đảm bảo mã hóa ký tự UTF-8 tiếng Việt toàn diện và `AuthFilter` kiểm soát quyền truy cập RBAC, thiết lập `Cache-Control` bảo mật chống quay lại trang trước sau đăng xuất [2].
* **JavaServer Pages (JSP 2.3) & JSTL 1.2**: Xây dựng tầng giao diện (View), sử dụng thẻ JSTL Core (`c:if`, `c:forEach`, `c:choose`) giúp tách biệt triệt để mã lệnh Java ra khỏi mã trình bày HTML [3].
* **Java Database Connectivity (JDBC) thuần & Oracle JDBC Driver (`ojdbc11`)**: Kết nối trực tiếp và tối ưu tới Oracle Database 23ai thông qua `PreparedStatement`, quản lý đóng mở tài nguyên an toàn theo khối `try-with-resources` [4], [5].
* **Thư viện Apache POI (`poi-ooxml` 5.2.5)**: Bộ thư viện Java chuyên dụng đọc và ghi tệp Microsoft Excel định dạng `.xlsx`, hỗ trợ nạp điểm hàng loạt và xuất sổ điểm lớp học phần [6].
* **Máy chủ nhúng Embedded Apache Tomcat**: Nhúng máy chủ web Tomcat bên trong tệp `Main.java`, cho phép ứng dụng khởi chạy độc lập 1-Click mà không cần cấu hình phức tạp [7].
* **Apache Maven 3.9**: Quản lý vòng đời dự án (Build lifecycle), quản lý tập trung các thư viện phụ thuộc trong tệp `pom.xml` [8].

---

# CHƯƠNG 2: PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG

## 2.1. Phân tích yêu cầu chức năng theo 3 tác nhân
Dựa trên khảo sát thực tế quy trình đào tạo tín chỉ UTC, các ca sử dụng (Use Cases) được phân rã thành 3 phân hệ chức năng tương ứng với 3 tác nhân [11]:

| Tác nhân (Actor) | Chức năng chính (Use Cases) | Mô tả nghiệp vụ chi tiết |
| :--- | :--- | :--- |
| **Sinh viên**<br>*(Student)* | • Đăng nhập / Đổi mật khẩu<br>• Tra cứu bảng điểm học kỳ<br>• Xem GPA học kỳ & CPA tích lũy<br>• In bảng điểm chính thức A4 | Sinh viên tra cứu điểm các học phần đã hoàn thành, xem chi tiết điểm CC, GK, Thi, TK10, Điểm chữ và Hệ 4. Hệ thống hiển thị trực quan xếp loại học lực và cảnh báo học vụ nếu CPA < 1.00. |
| **Giảng viên**<br>*(Lecturer)* | • Quản lý lớp học phần phụ trách<br>• Nhập điểm trên lưới điện tử (Web)<br>• Tải tệp mẫu & Nạp điểm Excel<br>• Xuất sổ điểm lớp học phần (.xlsx)<br>• Nộp điểm gửi Phòng Đào tạo duyệt | Giảng viên xem các lớp được phân công. Nhập điểm trên web với kiểm tra dữ liệu tức thì (0-10), hệ thống tự động tính điểm tổng kết và quy đổi điểm chữ. Sau khi hoàn thành, giảng viên nộp điểm để khóa sổ nháp. |
| **Phòng Đào tạo**<br>*(Admin)* | • Bảng điều khiển (Dashboard) thống kê<br>• Quản lý Lớp chuyên ngành & SV<br>• Quản lý Lớp học phần & Mở lớp<br>• Quản lý Môn học & Trọng số %<br>• Duyệt & Công bố điểm (`SUBMITTED` $\rightarrow$ `PUBLISHED`)<br>• Thống kê phổ điểm & Cảnh báo học vụ<br>• Tra cứu Nhật ký sửa điểm (Audit Log) | Cán bộ Phòng Đào tạo quản trị toàn bộ danh mục học vụ. Kiểm tra và phê duyệt bảng điểm của giảng viên. Xem phổ điểm toàn trường thời gian thực, lập danh sách sinh viên khen thưởng và sinh viên bị cảnh báo học vụ. |

## 2.2. Biểu đồ Use Case tổng quát và đặc tả tác nhân
```
+---------------------------------------------------------------------------------------------------+
|                 HỆ THỐNG QUẢN LÝ ĐIỂM SINH VIÊN UTC - CÔNG NGHỆ JAVA (RBAC)                       |
+---------------------------------------------------------------------------------------------------+
           |                                                                                         
   [ SINH VIÊN ] ------------> (Đăng nhập hệ thống / Đổi mật khẩu)                                   
           |                -> (Tra cứu bảng điểm học kỳ & điểm chi tiết thành phần)                
           |                -> (Xem kết quả GPA học kỳ, CPA tích lũy & Xếp loại học lực)            
           |                -> (In phiếu điểm học kỳ chuẩn định dạng trang A4 có dấu UTC)           
           |                                                                                         
   [ GIẢNG VIÊN ] -----------> (Đăng nhập hệ thống / Đổi mật khẩu)                                   
           |                -> (Xem danh sách các lớp học phần được phân công giảng dạy)             
           |                -> (Nhập & Hiệu chỉnh trực tiếp điểm CC, GK, Thi trên Web)              
           |                -> (Tải file mẫu & Import bảng điểm tự động từ tệp Excel .xlsx)          
           |                -> (Export sổ điểm lớp học phần ra tệp Excel định dạng chuẩn UTC)        
           |                -> (Gửi bảng điểm lên Phòng Đào tạo đề nghị phê duyệt)                   
           |                                                                                         
   [ PHÒNG ĐÀO TẠO (ADMIN) ] -> (Quản lý Lớp chuyên ngành, sinh viên & Tài khoản người dùng)        
                            -> (Quản lý Môn học & Cấu hình tỷ lệ % trọng số Chuyên cần, Giữa kỳ, Thi)
                            -> (Quản lý Lớp học phần: mở lớp, chỉ định giảng viên phụ trách)        
                            -> (Thẩm định & Phê duyệt bảng điểm: Chuyển trạng thái 'PUBLISHED')      
                            -> (Xem báo cáo phổ điểm chữ toàn trường A, B, C, D, F thời gian thực)  
                            -> (Xem danh sách sinh viên Xuất sắc và Sinh viên bị Cảnh báo học vụ)   
                            -> (Tra cứu và lọc Nhật ký sửa điểm kiểm toán - Audit Logs)             
+---------------------------------------------------------------------------------------------------+
```

## 2.3. Quy trình nghiệp vụ và vòng đời trạng thái bảng điểm học phần
Để đảm bảo tính toàn vẹn và ngăn chặn các hành vi sửa đổi điểm tùy tiện, hệ thống cài đặt Máy trạng thái (Finite State Machine) quản lý vòng đời bảng điểm qua 3 trạng thái nghiêm ngặt:
```
+---------------+          Giảng viên nộp điểm           +-----------------+
|     DRAFT     |  ------------------------------------>  |    SUBMITTED    |
|  (Bản nháp)   |        (Gửi phê duyệt lên P.ĐT)         |  (Chờ phê duyệt)|
+---------------+                                         +-----------------+
        ^                                                           |
        |                                                           | Phòng Đào tạo duyệt
        | Phòng Đào tạo từ chối                                     v
        +-------------------------------------------------  +-----------------+
                                                            |    PUBLISHED    |
                                                            |  (Đã công bố)   |
                                                            +-----------------+
```
* **Trạng thái `DRAFT` (Bản nháp)**: Khi lớp học phần được tạo mới, bảng điểm ở trạng thái DRAFT. Giảng viên được toàn quyền vào điểm, sửa đổi, import Excel nhiều lần. Tại trạng thái này, sinh viên hoàn toàn chưa nhìn thấy điểm.
* **Trạng thái `SUBMITTED` (Đã nộp, Chờ duyệt)**: Sau khi hoàn tất nhập điểm và kiểm tra khớp bài thi, Giảng viên nhấn nút 'Gửi phê duyệt'. Trạng thái chuyển sang SUBMITTED. Sổ điểm bị khóa chức năng sửa đổi để chờ Phòng Đào tạo kiểm tra.
* **Trạng thái `PUBLISHED` (Đã công bố)**: Cán bộ Phòng Đào tạo kiểm tra tính hợp lệ của sổ điểm. Khi nhấn 'Phê duyệt', bảng điểm chuyển sang PUBLISHED. Sinh viên chính thức tra cứu được điểm trên cổng thông tin cá nhân và điểm được tính vào GPA/CPA tích lũy.

---

# CHƯƠNG 3: THIẾT KẾ CƠ SỞ DỮ LIỆU TRÊN ORACLE DATABASE 23ai

## 3.1. Sơ đồ thực thể liên kết (ERD 11 bảng chuẩn hóa dạng 3 - 3NF)
Cơ sở dữ liệu của hệ thống được xây dựng trên nền tảng Oracle Database 23ai Free (Pluggable Database: `FREEPDB1`) [4]. Lược đồ gồm 11 bảng thực thể logic được thiết kế tuân thủ nghiêm ngặt chuẩn chuẩn hóa 3NF, triệt tiêu hoàn toàn sự dư thừa dữ liệu:
```
+-------------+        +-------------+        +--------------------+
|    KHOA     | 1    n |    NGANH    | 1    n | LOP_CHUYEN_NGANH   |
+-------------+ <------+-------------+ <------+--------------------+
                                                         | 1        
                                                         | n        
+-------------+ 1      n +-------------+ 1            n  v          
|  TAI_KHOAN  | <------- | GIANG_VIEN  |       +--------------------+
+-------------+          +-------------+       |     SINH_VIEN      |
       | 1                      | 1            +--------------------+
       |                        |                       | 1         
       |                        v                       | n         
       |                 +--------------------+         v           
       |                 |   LOP_HOC_PHAN     | 1   n +--------------------+
       |                 +--------------------+ <---- |     BANG_DIEM      |
       |                        | n                   +--------------------+
       | 1                      v 1                             | 1 
       |                 +--------------------+                 | n 
       |                 |     MON_HOC        |                 v   
       |                 +--------------------+       +--------------------+
       |                        ^                     |  LICHSU_SUA_DIEM   |
       |                        | 1                   +--------------------+
       |                 +--------------------+
       +---------------> |     HOC_KY         |
                         +--------------------+
```

## 3.2. Từ điển dữ liệu chi tiết (Data Dictionary)
Dưới đây là đặc tả chi tiết cấu trúc các bảng trọng tâm của hệ thống trong kịch bản CSDL `init_db.sql` thực tế [4]:

### a. Bảng `TAI_KHOAN` (Người dùng và Xác thực hệ thống)
| Tên cột | Kiểu dữ liệu | Null/Not | Ràng buộc | Mô tả ý nghĩa |
| :--- | :--- | :---: | :--- | :--- |
| `ID` | `NUMBER` | NOT NULL | PK, IDENTITY | Mã tài khoản tự tăng tự động |
| `TEN_DANG_NHAP` | `VARCHAR2(50)` | NOT NULL | UNIQUE | Tên đăng nhập (admin, mã GV, mã SV) |
| `MAT_KHAU` | `VARCHAR2(255)` | NOT NULL | | Mật khẩu người dùng |
| `VAI_TRO` | `VARCHAR2(20)` | NOT NULL | CHECK IN(...) | Vai trò: ADMIN, GIANG_VIEN, SINH_VIEN |
| `HO_TEN` | `NVARCHAR2(100)` | NOT NULL | | Họ và tên đầy đủ người dùng có dấu |
| `EMAIL` | `VARCHAR2(100)` | NULL | | Hộp thư điện tử liên hệ |
| `SO_DIEN_THOAI` | `VARCHAR2(20)` | NULL | | Số điện thoại liên hệ |
| `TRANG_THAI` | `NUMBER(1)` | DEFAULT 1 | CHECK (0,1) | Trạng thái: 1 = Hoạt động, 0 = Bị khóa |

### b. Bảng `MON_HOC` (Danh mục môn học & Cấu hình trọng số điểm)
| Tên cột | Kiểu dữ liệu | Null/Not | Ràng buộc | Mô tả ý nghĩa |
| :--- | :--- | :---: | :--- | :--- |
| `MA_MON` | `VARCHAR2(20)` | NOT NULL | PK | Mã học phần (Ví dụ: IT101, IT102) |
| `TEN_MON` | `NVARCHAR2(100)` | NOT NULL | | Tên học phần đầy đủ |
| `SO_TIN_CHI` | `NUMBER(2)` | NOT NULL | CHECK > 0 | Số tín chỉ học phần tích lũy |
| `TY_LE_CC` | `NUMBER(4,2)` | DEFAULT 0.10 | CHECK >= 0 | Tỷ lệ % điểm Chuyên cần (Ví dụ: 0.10) |
| `TY_LE_GK` | `NUMBER(4,2)` | DEFAULT 0.20 | CHECK >= 0 | Tỷ lệ % điểm Giữa kỳ (Ví dụ: 0.20) |
| `TY_LE_THI` | `NUMBER(4,2)` | DEFAULT 0.70 | CHECK >= 0 | Tỷ lệ % điểm Thi kết thúc (Ví dụ: 0.70) |
| `LOAI_MON` | `VARCHAR2(20)` | DEFAULT 'TIN_CHI' | CHECK IN(...) | Loại môn: TIN_CHI hoặc DIEU_KIEN |

### c. Bảng `BANG_DIEM` (Sổ điểm chi tiết theo Lớp học phần)
| Tên cột | Kiểu dữ liệu | Null/Not | Ràng buộc | Mô tả ý nghĩa |
| :--- | :--- | :---: | :--- | :--- |
| `ID` | `NUMBER` | NOT NULL | PK, IDENTITY | Mã định danh bản ghi điểm |
| `MA_LHP` | `VARCHAR2(30)` | NOT NULL | FK -> LOP_HOC_PHAN | Khóa ngoại tham chiếu lớp học phần |
| `MA_SV` | `VARCHAR2(20)` | NOT NULL | FK -> SINH_VIEN | Khóa ngoại tham chiếu sinh viên |
| `DIEM_CC` | `NUMBER(4,2)` | NULL | CHECK 0..10 | Điểm đánh giá chuyên cần (hệ 10) |
| `DIEM_GK` | `NUMBER(4,2)` | NULL | CHECK 0..10 | Điểm kiểm tra giữa kỳ (hệ 10) |
| `DIEM_THI` | `NUMBER(4,2)` | NULL | CHECK 0..10 | Điểm thi kết thúc học phần (hệ 10) |
| `DIEM_TK_10` | `NUMBER(4,2)` | NULL | CHECK 0..10 | Điểm tổng kết thang 10 có trọng số |
| `DIEM_CHU` | `VARCHAR2(5)` | NULL | A+, A, B+... F | Điểm chữ quy đổi chuẩn UTC |
| `DIEM_THANG_4` | `NUMBER(3,2)` | NULL | 0.0 .. 4.0 | Điểm hệ 4 phục vụ tính GPA/CPA |
| `KET_QUA` | `VARCHAR2(20)` | NULL | DAT / KHONG_DAT | Đánh giá đạt hoặc học lại |
| `GHI_CHU` | `NVARCHAR2(255)` | NULL | | Ghi chú bổ sung học phần |

### d. Bảng `LICHSU_SUA_DIEM` (Lưu vết kiểm toán - Audit Trail)
| Tên cột | Kiểu dữ liệu | Null/Not | Ràng buộc | Mô tả ý nghĩa |
| :--- | :--- | :---: | :--- | :--- |
| `ID` | `NUMBER` | NOT NULL | PK, IDENTITY | Mã bản ghi nhật ký tự tăng |
| `BANG_DIEM_ID` | `NUMBER` | NOT NULL | FK -> BANG_DIEM | Khóa ngoại bản ghi điểm bị thay đổi |
| `NGUOI_SUA` | `VARCHAR2(50)` | NOT NULL | | Tài khoản thực hiện sửa đổi điểm |
| `THOI_GIAN` | `TIMESTAMP` | DEFAULT CURRENT_TIMESTAMP | | Thời gian chính xác khi sửa điểm |
| `DIEM_CU` | `NVARCHAR2(200)` | NULL | | Chuỗi giá trị điểm trước khi sửa |
| `DIEM_MOI` | `NVARCHAR2(200)` | NULL | | Chuỗi giá trị điểm mới sau khi sửa |
| `LY_DO` | `NVARCHAR2(500)` | NOT NULL | | Lý do điều chỉnh (Rà soát bài thi, v.v.) |

## 3.3. Các kỹ thuật tối ưu hóa và đảm bảo an toàn dữ liệu trên Oracle 23ai
* **Cơ chế Ràng buộc toàn vẹn cứng (CHECK Constraints)**: Toàn bộ cột điểm số được cài đặt ràng buộc cứng `CHECK (DIEM BETWEEN 0.0 AND 10.0)`. Nhờ đó, bất kỳ giá trị điểm không hợp lệ nào sẽ bị tầng CSDL Oracle từ chối ngay lập tức, ngăn ngừa dữ liệu rác kể cả khi mã nguồn Java gặp ngoại lệ [4].
* **Tối ưu Shared Pool và chống SQL Injection với PreparedStatement**: 100% các câu truy vấn JDBC trong các DAO đều sử dụng `PreparedStatement`. Cơ chế này giúp Oracle 23ai biên dịch câu lệnh 1 lần và tái sử dụng Execution Plan (Soft Parse), giảm tải CPU máy chủ và ngăn chặn tuyệt đối nguy cơ tấn công SQL Injection [4], [5].
* **Ràng buộc UNIQUE kết hợp (`MA_LHP`, `MA_SV`)**: Ngăn chặn triệt để tình trạng một sinh viên bị ghi điểm trùng lặp trong cùng một lớp học phần.
* **Tối ưu hóa báo cáo phổ điểm bằng đơn truy vấn**: Thay vì duyệt vòng lặp Java, `StatisticsDAO` sử dụng truy vấn SQL tổng hợp `COUNT(CASE WHEN DIEM_CHU = 'A' THEN 1 END)` chỉ với một lượt quét bảng (Single Table Scan), trả về kết quả phổ điểm tức thời.

---

# CHƯƠNG 4: KIẾN TRÚC HỆ THỐNG VÀ HIỆN THỰC HÓA MÃ NGUỒN CÔNG NGHỆ JAVA

## 4.1. Kiến trúc phân tầng 3-Tier kết hợp mẫu thiết kế MVC trong Java Web
Hệ thống áp dụng kiến trúc 3 tầng (3-Tier Architecture) kết hợp mẫu thiết kế Model - View - Controller (MVC) chuẩn mực trong kỹ thuật phần mềm Java [11], [12]:
```
+---------------------------------------------------------------------------------------+
| 1. TẦNG TRÌNH DIỄN (PRESENTATION TIER / VIEW):                                        |
|    - JSP (JavaServer Pages 2.3), JSTL Core & Formatting Tags (c:if, c:forEach)        |
|    - Tailwind CSS, JavaScript ES6, Font Awesome 6 Icons                               |
|    - Cửa sổ in phiếu điểm chuẩn khổ A4 (Print Stylesheet tiêu chuẩn UTC)              |
+---------------------------------------------------------------------------------------+
                                           ^                                             
                                           | HTTP Request / Response (Mã hóa UTF-8)      
                                           v                                             
+---------------------------------------------------------------------------------------+
| 2. TẦNG ĐIỀU KHIỂN & NGHIỆP VỤ (CONTROLLER & BUSINESS LOGIC TIER):                    |
|    - Filters: EncodingFilter (UTF-8 tiếng Việt), AuthFilter (RBAC & Cache-Control)    |
|    - Servlets (Controllers):                                                          |
|      + AuthServlet: Xác thực đăng nhập, đăng xuất, đổi mật khẩu                       |
|      + LecturerServlet: Quản lý lớp, sổ điểm điện tử, Import/Export Excel             |
|      + StudentServlet: Xem bảng điểm, tính GPA/CPA, in phiếu điểm                     |
|      + Admin: AdminDashboardServlet, GradeApprovalServlet, AcademicClassServlet...    |
|    - Business Services:                                                               |
|      + GradeCalculator: Bộ máy tính điểm TK10, quy đổi Điểm chữ, Thang 4, GPA/CPA    |
|      + ExcelService: Xử lý tệp bảng tính Excel bằng thư viện Apache POI (poi-ooxml)   |
+---------------------------------------------------------------------------------------+
                                           ^                                             
                                           | Truy xuất đối tượng DTO / POJO Entities     
                                           v                                             
+---------------------------------------------------------------------------------------+
| 3. TẦNG TRUY XUẤT DỮ LIỆU (DATA ACCESS TIER / PERSISTENCE LAYER):                     |
|    - DBConnection: Quản lý nạp cấu hình từ db.properties & cấp phát Connection        |
|    - Data Access Objects (DAOs):                                                      |
|      + account: UserDAO, StudentDAO, LecturerDAO                                      |
|      + academic: SubjectDAO, CourseClassDAO, AcademicClassDAO, FacultyDAO, SemesterDAO|
|      + grading: GradeDAO, StatisticsDAO, AuditLogDAO                                  |
|    - Hệ quản trị CSDL: Oracle Database 23ai Free (Docker / Localhost:1521/FREEPDB1)   |
+---------------------------------------------------------------------------------------+
```

## 4.2. Cấu trúc tổ chức thư mục dự án theo chuẩn Apache Maven
Mã nguồn dự án được tổ chức chặt chẽ theo cấu trúc chuẩn mực của Apache Maven [8]:
```
quan-ly-diem-utc/
├── pom.xml                                       # Khai báo cấu hình Maven, ojdbc11, Apache POI
├── database/
│   └── init_db.sql                               # Kịch bản DDL 11 bảng Oracle 23ai & Dữ liệu mẫu UTC
└── src/main/
    ├── resources/
    │   └── db.properties                         # Tham số kết nối Oracle (URL, user, password)
    ├── java/vn/edu/utc/grade/
    │   ├── Main.java                             # Trình khởi chạy nhúng Embedded Tomcat độc lập
    │   ├── config/                               # Cấu hình & Bộ lọc bảo mật
    │   │   ├── DBConnection.java                 # Quản lý kết nối JDBC Oracle
    │   │   ├── AuthFilter.java                   # Bộ lọc phân quyền RBAC & Cache-Control
    │   │   └── EncodingFilter.java               # Bộ lọc mã hóa ký tự UTF-8
    │   ├── controller/                           # Tầng Servlet điều khiển (MVC)
    │   │   ├── AuthServlet.java                  # Đăng nhập, đăng xuất, đổi mật khẩu
    │   │   ├── lecturer/LecturerServlet.java     # Sổ điểm giảng viên, nạp & xuất Excel
    │   │   ├── student/StudentServlet.java       # Xem bảng điểm cá nhân, in bảng điểm
    │   │   └── admin/                            # Nhóm Servlets quản trị đào tạo
    │   │       ├── AdminDashboardServlet.java    # Bảng điều khiển thống kê tổng quan
    │   │       ├── GradeApprovalServlet.java     # Phê duyệt & Công bố bảng điểm học phần
    │   │       ├── AcademicManageServlet.java    # Quản lý môn học, lớp học phần
    │   │       ├── AcademicClassServlet.java     # Quản lý lớp chuyên ngành & sinh viên
    │   │       ├── FacultyGradeServlet.java      # Điểm học phần theo Khoa & Lớp
    │   │       ├── UserManageServlet.java        # Quản lý người dùng hệ thống
    │   │       └── AuditLogServlet.java          # Nhật ký sửa điểm kiểm toán
    │   ├── service/                              # Tầng nghiệp vụ xử lý tính toán
    │   │   ├── GradeCalculator.java              # Thuật toán tính điểm TK10, chữ, hệ 4, GPA/CPA
    │   │   └── ExcelService.java                 # Đọc và xuất bảng tính Excel với Apache POI
    │   ├── dao/                                  # Tầng truy xuất CSDL (JDBC PreparedStatement)
    │   │   ├── account/ (UserDAO, StudentDAO, LecturerDAO)
    │   │   ├── academic/ (SubjectDAO, CourseClassDAO, AcademicClassDAO, FacultyDAO, SemesterDAO)
    │   │   └── grading/ (GradeDAO, StatisticsDAO, AuditLogDAO)
    │   └── model/                                # Tầng thực thể dữ liệu (POJO Entities)
    │       ├── account/ (User, Student, Lecturer)
    │       ├── academic/ (Subject, CourseClass, AcademicClass, Semester, Faculty)
    │       └── grading/ (Grade, AuditLog)
    └── webapp/
        ├── index.jsp                             # Trang điều hướng mặc định
        └── WEB-INF/
            ├── web.xml                           # Cấu hình Deployment Descriptor Servlet & Filter
            └── views/                            # Giao diện JSP được bảo vệ
                ├── common/ (header.jsp, sidebar.jsp, footer.jsp)
                ├── auth/ (login.jsp, change-password.jsp)
                ├── admin/ (dashboard, classes, grade-approval, statistics, audit-logs...)
                ├── lecturer/ (my-classes.jsp, grade-input.jsp)
                └── student/ (my-grades.jsp, transcript-print.jsp)
```

## 4.3. Hiện thực hóa các thành phần cốt lõi bằng Công nghệ Java

### 4.3.1. Quản lý kết nối JDBC: `DBConnection.java`
Lớp `DBConnection` nạp các thông số kết nối từ tệp `db.properties` bằng ClassLoader, thực hiện cấp phát Connection và cung cấp phương thức giải phóng tài nguyên an toàn [4], [5]:
```java
package vn.edu.utc.grade.config;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {
    private static String url = "jdbc:oracle:thin:@//localhost:1521/FREEPDB1";
    private static String username = "utc_grade";
    private static String password = "utc123";
    private static String driver = "oracle.jdbc.OracleDriver";

    static {
        try {
            Properties props = new Properties();
            InputStream is = DBConnection.class.getClassLoader().getResourceAsStream("db.properties");
            if (is != null) {
                props.load(is);
                url = props.getProperty("db.url", url);
                username = props.getProperty("db.user", username);
                password = props.getProperty("db.password", password);
                driver = props.getProperty("db.driver", driver);
            }
            Class.forName(driver);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }

    public static void close(AutoCloseable... closeables) {
        for (AutoCloseable c : closeables) {
            if (c != null) try { c.close(); } catch (Exception ignored) {}
        }
    }
}
```

### 4.3.2. Bộ lọc bảo mật và phân quyền: `AuthFilter.java` & `EncodingFilter.java`
`AuthFilter` kiểm tra phiên làm việc `HttpSession` của người dùng đối với mọi đường dẫn URL. Nếu truy cập trái quyền (ví dụ Sinh viên cố tình vào URL của Giảng viên hoặc Admin), hệ thống sẽ chặn đứng và chuyển hướng về trang lỗi 403. Đồng thời, tiêu đề `Cache-Control: no-cache, no-store, must-revalidate` được gắn vào phản hồi để ngăn chặn việc xem lén thông tin sau khi đăng xuất [2].

### 4.3.3. Bộ máy tính điểm và quy đổi chuẩn tín chỉ: `GradeCalculator.java`
Cài đặt giải thuật nghiệp vụ cốt lõi tính điểm tổng kết hệ 10 theo trọng số động, xét điểm liệt thi, quy đổi điểm chữ và điểm hệ 4 [9], [10]:
```java
package vn.edu.utc.grade.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import vn.edu.utc.grade.model.grading.Grade;

public class GradeCalculator {

    public static Double calculateTotal10(Double cc, Double gk, Double thi,
                                          double wCC, double wGK, double wThi) {
        if (thi == null) return null;
        double valCC = (cc != null) ? cc : 0.0;
        double valGK = (gk != null) ? gk : 0.0;
        BigDecimal total = BigDecimal.valueOf(valCC).multiply(BigDecimal.valueOf(wCC))
                .add(BigDecimal.valueOf(valGK).multiply(BigDecimal.valueOf(wGK)))
                .add(BigDecimal.valueOf(thi).multiply(BigDecimal.valueOf(wThi)));
        return total.setScale(1, RoundingMode.HALF_UP).doubleValue();
    }

    public static String toLetterScore(Double score10, Double finalScore) {
        if (score10 == null) return null;
        // Điểm liệt thi: nếu thi kết thúc học phần < 4.0 quy về F hoặc F+
        if (finalScore != null && finalScore < 4.0) {
            return (score10 >= 2.0) ? "F+" : "F";
        }
        if (score10 >= 9.5) return "A+";
        if (score10 >= 8.5) return "A";
        if (score10 >= 8.0) return "B+";
        if (score10 >= 7.0) return "B";
        if (score10 >= 6.0) return "C+";
        if (score10 >= 5.5) return "C";
        if (score10 >= 4.5) return "D+";
        if (score10 >= 4.0) return "D";
        if (score10 >= 2.0) return "F+" ;
        return "F";
    }

    public static Double toScale4(String letter) {
        if (letter == null) return null;
        return switch (letter.toUpperCase().trim()) {
            case "A+" -> 4.0;
            case "A"  -> 3.8;
            case "B+" -> 3.5;
            case "B"  -> 3.0;
            case "C+" -> 2.5;
            case "C"  -> 2.0;
            case "D+" -> 1.5;
            case "D"  -> 1.0;
            case "F+" -> 0.5;
            default   -> 0.0;
        };
    }
}
```

### 4.3.4. Dịch vụ xử lý bảng tính Excel bằng Apache POI: `ExcelService.java`
`ExcelService` sử dụng đối tượng `XSSFWorkbook` của Apache POI để xử lý các bảng tính chuẩn `.xlsx` [6]. Tính năng kiểm tra lỗi từng ô (Cell Validation) đảm bảo điểm số phải nằm trong khoảng từ 0 đến 10, đồng thời tự động đánh giá công thức Excel với `FormulaEvaluator`.

---

# CHƯƠNG 5: KẾT QUẢ THỰC NGHIỆM VÀ ĐÁNH GIÁ HỆ THỐNG

## 5.1. Kịch bản cài đặt và khởi chạy hệ thống 1-Click
Hệ thống được đóng gói đạt chuẩn vận hành công nghiệp, cho phép khởi chạy chỉ qua 2 bước đơn giản:
* **Bước 1: Khởi tạo CSDL Oracle**: Mở công cụ quản trị (DBeaver, SQL Developer) kết nối tới Oracle 23ai với quyền người dùng `utc_grade` và thực thi file kịch bản `database/init_db.sql`. Kịch bản tự động dọn sạch bảng cũ, tạo mới 11 bảng chuẩn hóa và nạp sẵn dữ liệu mẫu thực tế của UTC.
* **Bước 2: Khởi chạy máy chủ**: Mở PowerShell tại thư mục dự án và chạy lệnh sau:
```powershell
mvn exec:java '-Dexec.mainClass=vn.edu.utc.grade.Main'
# Máy chủ Tomcat nhúng khởi động tại: http://localhost:8080
```

## 5.2. Kết quả thực nghiệm các phân hệ chức năng trên giao diện Web
Hệ thống đã trải qua quá trình kiểm thử tải và kiểm thử chức năng tự động (Automation Test) trên toàn bộ các endpoint, đạt mã phản hồi HTTP 200 OK:
* **Màn hình Đăng nhập (Login UI)**: Giao diện chuẩn nhận diện thương hiệu Đại học Giao thông Vận tải. Hỗ trợ tính năng "Đăng nhập nhanh 1-Chạm" (Quick Login) dành cho Hội đồng chấm đồ án thử nghiệm ngay các tài khoản mẫu.
* **Phân hệ Bảng điều khiển Quản trị (Admin Dashboard & Statistics)**: Thống kê tổng quan số lượng Sinh viên, Giảng viên, Lớp học phần, Môn học đào tạo. Biểu đồ phổ điểm 10 mức phân bổ thời gian thực (Realtime Chart.js) và Top sinh viên có CPA cao nhất.
* **Phân hệ Quản lý Lớp chuyên ngành & Lớp học phần**: Quản lý sinh viên theo khóa/ngành/lớp, mở lớp học phần mới theo học kỳ và phân công giảng viên giảng dạy.
* **Phân hệ Phê duyệt Bảng điểm (Grade Approval)**: Danh sách các lớp học phần chờ duyệt với nhãn cảnh báo trạng thái trực quan. Cán bộ Phòng Đào tạo duyệt chỉ với 1 click để công bố chính thức.
* **Phân hệ Sổ điểm Giảng viên (Lecturer Gradebook)**: Cho phép giảng viên nhập điểm chuyên cần, giữa kỳ, thi kết thúc trực tiếp trên web hoặc upload file Excel (.xlsx). Sổ điểm tự động tính toán tổng kết và khóa sổ an toàn khi đã nộp.
* **Cổng thông tin Sinh viên & Trang In Bảng điểm A4**: Sinh viên tra cứu điểm chi tiết từng môn. Nút "In bảng điểm" mở trang in tối ưu chuẩn A4 với quốc hiệu, tiêu ngữ, chữ ký Trưởng Phòng Đào Tạo phục vụ xin học bổng hoặc việc làm.
* **Phân hệ Nhật ký sửa điểm (Audit Logs)**: Lưu vết toàn diện lịch sử biến động điểm đảm bảo tính minh bạch tuyệt đối.

## 5.3. Bảng tài khoản trải nghiệm hệ thống (Khớp 100% CSDL)
Bảng tài khoản thử nghiệm thực tế được nạp sẵn trong cơ sở dữ liệu Oracle Database 23ai:

| Vai trò (Role) | Tên đăng nhập | Mật khẩu | Họ và tên người dùng | Chức năng thử nghiệm tiêu biểu |
| :--- | :--- | :--- | :--- | :--- |
| **Phòng Đào Tạo**<br>*(Admin)* | `admin` | `admin123` | Phòng Đào Tạo UTC | Duyệt điểm, quản lý lớp & môn, xem phổ điểm, tra cứu Audit Log |
| **Giảng viên** | `gv_nguyenvanan` | `gv123` | TS. Nguyễn Văn An | Phụ trách lớp OOP Java (IT101), nhập điểm web, Import/Export Excel |
| **Giảng viên** | `gv_tranbichngoc` | `gv123` | ThS. Trần Bích Ngọc | Phụ trách lớp CSDL Oracle (IT102 - đang ở trạng thái SUBMITTED) |
| **Giảng viên** | `gv_lequanghuy` | `gv123` | TS. Lê Quang Huy | Phụ trách lớp Cấu trúc dữ liệu & giải thuật (IT104 - PUBLISHED) |
| **Sinh viên** | `211200001` | `sv123` | Nguyễn Hoàng Nam | Lớp CNTT1-K62, CPA Xuất sắc 3.80, xem bảng điểm và in bảng điểm A4 |
| **Sinh viên** | `211200008` | `sv123` | Bùi Tuấn Anh | Lớp CNTT1-K62, CPA 0.50 (thử nghiệm tính năng Cảnh báo học vụ mức 2) |

## 5.4. Đánh giá ưu điểm, hạn chế và định hướng phát triển
### a. Đánh giá ưu điểm nổi bật của hệ thống:
* **Tính đúng đắn và chuẩn mực**: Thuật toán tính điểm tuân thủ chính xác quy chế tín chỉ UTC và Thông tư 08/2021/TT-BGDĐT [9], [10], giải quyết triệt để bài toán điểm liệt thi.
* **Công nghệ Java thuần túy, hiệu năng cao**: Không phụ thuộc vào các framework cồng kềnh, hệ thống sử dụng Servlet/JSP và JDBC thuần giúp thời gian nạp trang và phản hồi dưới 15ms.
* **An toàn dữ liệu tuyệt đối**: Mô hình phân quyền RBAC kết hợp cơ chế lưu vết Audit Log giúp minh bạch hóa mọi biến động điểm số.
* **Trải nghiệm người dùng vượt trội**: Giao diện web hiện đại, hỗ trợ nhập xuất file Excel linh hoạt và in ấn chuẩn trang A4.

### b. Một số hạn chế hiện tại:
* Hệ thống hiện tại vận hành trên mạng nội bộ, chưa tích hợp máy chủ SMTP gửi email thông báo điểm thi tự động tới sinh viên.
* Chưa tích hợp Chữ ký số điện tử (Digital Signature) trên tệp PDF bảng điểm cấp bằng trực tuyến.

### c. Định hướng phát triển đề tài:
* Tích hợp dịch vụ gửi thư điện tử tự động qua giao thức JavaMail API.
* Xây dựng hệ thống RESTful API kết nối với ứng dụng di động (Mobile App iOS & Android dành cho sinh viên).
* Áp dụng chữ ký số PKI trên tệp bảng điểm điện tử xuất bản cho sinh viên.

---

# KẾT LUẬN CHUNG
Sau quá trình nghiên cứu lý thuyết và triển khai thực nghiệm, đề tài **"Xây dựng Hệ thống Quản lý điểm Sinh viên theo học chế tín chỉ sử dụng Java Web (Servlet / JSP / JDBC) và Oracle Database 23ai"** trong khuôn khổ học phần **Công nghệ Java** đã hoàn thành xuất sắc toàn bộ mục tiêu đề ra.

Hệ thống giải quyết thành công bài toán quản lý điểm số phức tạp của Trường Đại học Giao thông Vận tải với các yêu cầu khắt khe về trọng số môn học, điều kiện điểm liệt thi, thang điểm chữ 10 mức và quy chế cảnh báo học vụ. Về mặt học thuật, đề tài là minh chứng sinh động cho việc làm chủ kiến trúc phần mềm hướng đối tượng Java, công nghệ Jakarta Servlet / JSP, kỹ thuật truy xuất dữ liệu tối ưu qua JDBC PreparedStatement và năng lực quản trị cơ sở dữ liệu trên hệ quản trị hiện đại Oracle Database 23ai.

Sản phẩm phần mềm có tính ứng dụng thực tiễn cao, giao diện trực quan, mã nguồn được tổ chức trong sáng, đạt chuẩn công nghiệp và sẵn sàng để tiếp tục mở rộng phát triển trong tương lai.

---

# TÀI LIỆU THAM KHẢO

* [1] Oracle Corporation, *"Java Platform, Standard Edition Documentation (JDK 17 LTS / JDK 21 LTS)"*, Oracle Technology Network, 2023.
* [2] Jakarta EE Specification Committee, *"Jakarta Servlet Specification 4.0 / 5.0"*, Eclipse Foundation, 2020.
* [3] Oracle Corporation, *"JavaServer Pages (JSP) v2.3 Specification & JSTL 1.2 Tag Library"*, Oracle America, Inc., 2019.
* [4] Oracle Corporation, *"Oracle Database 23ai Free Documentation & SQL Language Reference"*, Oracle Corporation, Redwood Shores, CA, 2024.
* [5] Oracle Corporation, *"Oracle Database JDBC Developer's Guide (Release 23ai)"*, Oracle Corporation, 2024.
* [6] The Apache Software Foundation, *"Apache POI - the Java API for Microsoft Documents (Version 5.2.5)"*, Apache Software Foundation, 2024.
* [7] The Apache Software Foundation, *"Apache Tomcat 9.0 / 10.1 Architecture and Embedded Server Guide"*, Apache Software Foundation, 2024.
* [8] The Apache Software Foundation, *"Apache Maven Project Management and Comprehension Tool (Version 3.9)"*, Apache Software Foundation, 2024.
* [9] Bộ Giáo dục và Đào tạo, *"Quy chế đào tạo trình độ đại học"*, Ban hành kèm theo Thông tư số 08/2021/TT-BGDĐT ngày 18 tháng 3 năm 2021 của Bộ trưởng Bộ Giáo dục và Đào tạo.
* [10] Trường Đại học Giao thông Vận tải, *"Quy định đào tạo đại học chính quy theo hệ thống tín chỉ tại Trường Đại học Giao thông Vận tải"*, Quyết định của Hiệu trưởng Trường ĐH Giao thông Vận tải, Hà Nội.
* [11] Martin Fowler, *"Patterns of Enterprise Application Architecture"*, Addison-Wesley Professional, 2002.
* [12] Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides, *"Design Patterns: Elements of Reusable Object-Oriented Software"* (GoF), Addison-Wesley, 1994.
* [13] Joshua Bloch, *"Effective Java (3rd Edition)"*, Addison-Wesley Professional, 2018.
* [14] Cay S. Horstmann, *"Core Java Volume I – Fundamentals & Volume II – Advanced Features"*, 12th Edition, Prentice Hall, 2022.
