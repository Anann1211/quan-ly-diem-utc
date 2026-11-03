# HỆ THỐNG QUẢN LÝ ĐIỂM SINH VIÊN - ĐẠI HỌC GIAO THÔNG VẬN TẢI (UTC GRADE PORTAL)

Dự án Web Quản lý điểm sinh viên theo học chế tín chỉ cho **Trường Đại học Giao thông Vận tải (UTC)**, phát triển trên nền tảng **Java Web (Servlet / JSP + JDBC thuần)** và **Cơ sở dữ liệu Oracle Database 23ai Free**, kiến trúc theo mô hình **MVC (Model - View - Controller)** kết hợp với **Mô hình 3 tầng (3-Tier Architecture)** chuẩn mực của Apache Maven.

---

## 1. CÔNG NGHỆ SỬ DỤNG
- **Ngôn ngữ & Nền tảng**: Java 17+ (Tương thích Java 21, Java 25), Apache Maven.
- **Kiến trúc Phân tầng (3-Tier Architecture) & MVC**:
  - **Tầng Giao diện (Presentation Layer / View)**: JSP 2.3 + JSTL (`c:forEach`, `c:if`, `c:choose`), Tailwind CSS, Font Awesome 6 Icons, Chart.js.
  - **Tầng Điều khiển (Controller Layer)**: Java Servlet 4.0 (`@WebServlet`, `@MultipartConfig`, Session Management).
  - **Tầng Bộ lọc Bảo mật (Filter Layer)**: `AuthFilter` (Kiểm soát RBAC, tiêu đề chống Cache-Control), `EncodingFilter` (UTF-8 tiếng Việt toàn diện).
  - **Tầng Nghiệp vụ (Business Logic Layer / Service)**: `GradeCalculator` (Tính điểm chữ, thang 4, GPA/CPA, điểm liệt thi), `ExcelService` (Apache POI 5.x đọc ghi .xlsx & .xls).
  - **Tầng Truy xuất Dữ liệu (Data Access Layer / DAO)**: JDBC thuần với `PreparedStatement` chống SQL Injection, quản lý kết nối an toàn.
  - **Tầng Thực thể Dữ liệu (Domain Model Layer / Entities)**: Các POJO Java Serializable chia nhỏ theo miền nghiệp vụ (`account`, `academic`, `grading`).
- **Cơ sở dữ liệu**: Oracle Database 23ai Free (`FREEPDB1`).
- **Thư viện tích hợp**:
  - `com.oracle.database.jdbc:ojdbc11`: Driver kết nối Oracle 23ai chính thức.
  - `org.apache.poi:poi` & `poi-ooxml`: Xử lý Xuất & Nhập bảng điểm qua file Excel (.xlsx & .xls).
  - `com.google.code.gson:gson`: Hỗ trợ serialize định dạng dữ liệu JSON.
  - `org.apache.tomcat.embed:tomcat-embed-core`: Nhúng Embedded Tomcat 9 chạy độc lập 1 click.

---

## 2. CÁC PHÂN HỆ VÀ TÍNH NĂNG CHẮT LỌC VƯỢT TRỘI

### 2.1. Phân hệ Phòng Đào Tạo (Role: `ADMIN`)
- **Dashboard Tổng quan**: Thống kê số lượng sinh viên, giảng viên, lớp học phần, đơn phúc khảo; biểu đồ phổ điểm toàn trường thời gian thực.
- **Duyệt & Công bố Bảng điểm**: Quy trình kiểm duyệt bảng điểm do giảng viên nộp; chuyển trạng thái từ `SUBMITTED` $\rightarrow$ `PUBLISHED` để sinh viên tra cứu chính thức.
- **Tiếp nhận & Xử lý Phúc khảo**: Hội đồng chấm lại xem xét đơn đề nghị, cập nhật điểm thi mới, tự động tính lại toàn bộ điểm tổng kết, điểm chữ, thang 4 và CPA; tự động ghi vết Audit Log.
- **Nhật ký sửa điểm (Audit Log)**: Lưu vết toàn bộ lịch sử biến động điểm (*Người sửa, Thời gian, Điểm cũ, Điểm mới, Lý do*) đảm bảo tính minh bạch tuyệt đối.
- **Quản lý Môn học & Cấu hình Trọng số**: Thêm, sửa tỷ lệ % Chuyên cần, % Giữa kỳ, % Thi (kiểm tra chặt chẽ tổng phải bằng 100%).
- **Quản lý Lớp học phần**: Mở lớp theo từng học kỳ, chỉ định giảng viên giảng dạy.
- **Báo cáo & Cảnh báo học vụ**: Xếp hạng sinh viên xuất sắc xét học bổng khuyến khích và danh sách sinh viên bị cảnh báo học tập (CPA < 1.00) tối ưu với 1 truy vấn SQL tổng hợp.

### 2.2. Phân hệ Giảng Viên (Role: `GIANG_VIEN`)
- **Quản lý Lớp phụ trách**: Xem danh sách lớp học phần được phân công theo từng học kỳ.
- **Sổ điểm điện tử tương tác (Live Data Grid)**: Nhập điểm trực tiếp trên web với cơ chế tự động tính điểm ngay khi gõ.
- **Import / Export Excel thông minh (Apache POI)**:
  - Tải file Excel danh sách bảng điểm mẫu có sẵn thông tin sinh viên và môn học.
  - Upload file Excel điểm với bộ kiểm tra lỗi chi tiết từng ô; hỗ trợ cả định dạng `.xlsx`, `.xls` và ô tính chứa công thức Excel (`FormulaEvaluator`).
- **Quy trình Khóa sổ an toàn**: Tự động khóa sổ điểm khi lớp ở trạng thái `SUBMITTED` hoặc `PUBLISHED` để bảo vệ dữ liệu.

### 2.3. Phân hệ Sinh Viên (Role: `SINH_VIEN`)
- **Tra cứu Bảng điểm**: Xem chi tiết điểm chuyên cần, giữa kỳ, thi kết thúc, tổng kết 10, điểm chữ và thang 4 theo từng học kỳ hoặc toàn khóa.
- **Theo dõi Tiến độ & Học lực**: Thẻ KPI tổng kết GPA học kỳ, CPA tích lũy chuẩn quy chế tín chỉ UTC.
- **Đơn Phúc khảo trực tuyến**: Nộp đơn khiếu nại điểm thi ngay trên web; cơ chế chống nộp trùng đơn khi đơn cũ đang ở trạng thái `PENDING`.
- **In Bảng điểm chuẩn A4**: Trang in bảng điểm định dạng chuẩn trang A4 của Trường ĐH Giao thông Vận tải với quốc hiệu, tiêu ngữ, chữ ký Trưởng Phòng Đào Tạo.

---

## 3. QUY TẮC TÍNH ĐIỂM CHUẨN ĐẠI HỌC GIAO THÔNG VẬN TẢI (UTC)

### 3.1. Điểm tổng kết học phần (Thang 10, làm tròn 1 số thập phân)
$$D_{TK10} = D_{CC} \times W_{CC} + D_{GK} \times W_{GK} + D_{THI} \times W_{THI}$$

### 3.2. Quy tắc Điểm liệt thi kết thúc học phần
Theo Quy chế đào tạo UTC và Thông tư 08/2021/TT-BGDĐT:
- Điểm thi kết thúc học phần phải đạt từ **$4.0$** trở lên mới đủ điều kiện xét Đạt.
- Nếu điểm thi $< 4.0$, học phần tự động nhận điểm chữ **$F+$** (nếu $D_{TK10} \ge 2.0$) hoặc **$F$** (nếu $D_{TK10} < 2.0$) và kết quả là **`KHONG_DAT`** (buộc phải học lại).

### 3.3. Bảng quy đổi Thang điểm Chữ & Thang 4.0
| Đánh giá xếp loại | Thang 10 | Điểm chữ | Thang 4 | Kết quả |
| :--- | :--- | :---: | :---: | :---: |
| **Xuất sắc** | 9.5 - 10.0 | **A+** | **4.0** | Đạt |
| **Giỏi** | 8.5 - 9.4 | **A** | **3.8** | Đạt |
| **Khá giỏi** | 8.0 - 8.4 | **B+** | **3.5** | Đạt |
| **Khá** | 7.0 - 7.9 | **B** | **3.0** | Đạt |
| **Trung bình khá** | 6.0 - 6.9 | **C+** | **2.5** | Đạt |
| **Trung bình** | 5.5 - 5.9 | **C** | **2.0** | Đạt |
| **Trung bình yếu** | 4.5 - 5.4 | **D+** | **1.5** | Đạt |
| **Đạt tối thiểu** | 4.0 - 4.4 | **D** | **1.0** | Đạt |
| **Không đạt (Học lại)** | 2.0 - 3.9 | **F+** | **0.5** | Học lại |
| **Kém (Học lại)** | 0.0 - 1.9 | **F** | **0.0** | Học lại |

---

## 4. TÀI KHOẢN TRẢI NGHIỆM HỆ THỐNG

*(Hệ thống đã tích hợp sẵn tính năng Đăng nhập nhanh 1-Click ngay tại màn hình Login)*

| Vai trò | Tên đăng nhập | Mật khẩu | Họ và tên | Chức năng tiêu biểu |
| :--- | :--- | :--- | :--- | :--- |
| **Admin** | `admin` | `admin123` | Phòng Đào Tạo UTC | Duyệt điểm, xử lý phúc khảo, xem Audit Log, cấu hình môn học |
| **Giảng viên** | `gv_nguyenvanan` | `gv123` | TS. Nguyễn Văn An | Nhập điểm lớp OOP Java, Import/Export Excel, nộp điểm |
| **Giảng viên** | `gv_tranbichngoc` | `gv123` | ThS. Trần Bích Ngọc | Quản lý lớp Cơ sở dữ liệu Oracle |
| **Giảng viên** | `gv_lequanghuy` | `gv123` | TS. Lê Quang Huy | Quản lý lớp Mạng máy tính |
| **Sinh viên** | `211200001` | `sv123` | Nguyễn Hoàng Nam (CNTT1-K62) | Xem bảng điểm cá nhân, CPA 3.8, in bảng điểm A4 |
| **Sinh viên** | `211200007` | `sv123` | Hoàng Thị Lan (CNTT1-K62) | Xem điểm môn Cấu trúc dữ liệu và theo dõi đơn phúc khảo |

---

## 5. HƯỚNG DẪN CÀI ĐẶT & KHỞI CHẠY (DÀNH CHO NGƯỜI MỚI TẢI TỪ GITHUB)

> [!IMPORTANT]
> **Dự án sử dụng Oracle Database 23ai làm cốt lõi lưu trữ dữ liệu.**  
> Trước khi khởi chạy ứng dụng, bạn **bắt buộc phải thực hiện Bước 1** để khởi tạo các bảng và tài khoản thử nghiệm trên Oracle Database. Nếu chưa chạy CSDL, chức năng Đăng nhập 1-Click sẽ báo lỗi không kết nối được CSDL.

### Bước 1: Khởi tạo Cơ sở dữ liệu Oracle Database 23ai
1. Mở công cụ quản trị Oracle (như **DBeaver**, **Oracle SQL Developer**, hoặc **SQL*Plus**).
2. Kết nối vào Oracle Database với quyền `SYS` hoặc `SYSTEM` (Pluggable Database: `FREEPDB1` hoặc service tương ứng trên máy bạn).
3. Mở và thực thi toàn bộ kịch bản SQL tại:
   👉 **`database/init_db.sql`**
   *(Kịch bản này tự động tạo 12 bảng chuẩn hóa, ràng buộc khóa ngoại, bảng mã hóa tiếng Việt và nạp sẵn toàn bộ tài khoản mẫu Admin, Giảng viên, Sinh viên, Điểm học phần thực tế)*.

### Bước 2: Kiểm tra cấu hình kết nối CSDL
Mở file **`src/main/resources/db.properties`** và điều chỉnh nếu thông số Oracle trên máy bạn khác với mặc định:
```properties
db.driver=oracle.jdbc.OracleDriver
db.url=jdbc:oracle:thin:@//localhost:1521/FREEPDB1
db.user=utc_grade
db.password=utc123
```
*(Nếu dùng Oracle XE/19c/21c, bạn chỉ cần đổi `FREEPDB1` thành `XE`, `XEPDB1` hoặc `ORCL` tương ứng)*.

### Bước 3: Khởi chạy hệ thống (1-Click)

#### Cách 1: Khởi chạy bằng PowerShell (Khuyến nghị)
Mở PowerShell tại thư mục dự án và chạy:
```powershell
.\scripts\run.ps1
```

#### Cách 2: Khởi chạy bằng Command Prompt (CMD)
Nhấp đúp chuột vào file `scripts\run.bat` hoặc gõ trong terminal:
```cmd
scripts\run.bat
```

#### Cách 3: Khởi chạy trực tiếp qua lệnh Maven
```bash
mvn compile exec:java
```

### Bước 4: Truy cập và Đăng nhập
Sau khi server hiển thị thông báo khởi động thành công, mở trình duyệt web và truy cập:
👉 **`http://localhost:8080`**

Tại màn hình Đăng nhập, bấm vào một trong các nút **1-Click** (Admin / Giảng viên / Sinh viên) để tự động đăng nhập và trải nghiệm toàn bộ tính năng!

---

## 6. CẤU TRÚC THƯ MỤC CHUẨN MÔ HÌNH PHÂN TẦNG (3-TIER) & MVC

```text
Bài tập nhóm/
├── pom.xml                                       # Cấu hình Maven dependencies (ojdbc11, POI, Tomcat) & plugins
├── scripts/                                      # Kịch bản tự động hóa khởi chạy ứng dụng
│   ├── run.ps1                                   # Script chạy nhanh trên môi trường PowerShell
│   └── run.bat                                   # Script chạy nhanh trên môi trường Windows CMD
├── database/
│   └── init_db.sql                               # Kịch bản DDL khởi tạo 12 bảng Oracle 23ai & Mock Data UTC
│
└── src/
    ├── main/
    │   ├── resources/
    │   │   └── db.properties                     # Cấu hình tham số kết nối Oracle Database 23ai
    │   │
    │   ├── java/vn/edu/utc/grade/                # Mã nguồn xử lý phía máy chủ (Backend Java)
    │   │   ├── Main.java                         # Trình khởi chạy Embedded Tomcat (Chạy độc lập 1-click)
    │   │   │
    │   │   ├── config/                           # Tầng cấu hình hệ thống & Bảo mật (Configuration & Filter)
    │   │   │   ├── DBConnection.java             # Quản lý kết nối JDBC tới Oracle Database
    │   │   │   ├── AuthFilter.java               # Bộ lọc xác thực và phân quyền RBAC (3 vai trò, Cache-Control)
    │   │   │   └── EncodingFilter.java           # Bộ lọc chuẩn hóa bảng mã UTF-8 (hỗ trợ tiếng Việt)
    │   │   │
    │   │   ├── controller/                       # Tầng Điều khiển (Controller - Web MVC Servlets)
    │   │   │   ├── AuthServlet.java              # Xử lý đăng nhập, đăng xuất và đổi mật khẩu
    │   │   │   ├── lecturer/
    │   │   │   │   └── LecturerServlet.java      # Điều hướng nghiệp vụ Giảng viên (Lớp dạy, Nhập điểm, Excel)
    │   │   │   ├── student/
    │   │   │   │   └── StudentServlet.java       # Điều hướng nghiệp vụ Sinh viên (Xem điểm, Phúc khảo)
    │   │   │   └── admin/                        # Nhóm Servlet quản trị đào tạo (Chia nhỏ theo nghiệp vụ)
    │   │   │       ├── AdminDashboardServlet.java# Bảng điều khiển và thống kê tổng quan
    │   │   │       ├── GradeApprovalServlet.java # Phê duyệt bảng điểm và xử lý đơn phúc khảo
    │   │   │       ├── AcademicManageServlet.java# Quản lý học phần, lớp học phần, học kỳ
    │   │   │       └── AuditLogServlet.java      # Tra cứu nhật ký hoạt động và bảo mật hệ thống
    │   │   │
    │   │   ├── service/                          # Tầng Nghiệp vụ (Business Logic Layer)
    │   │   │   ├── GradeCalculator.java          # Thuật toán quy đổi điểm chữ, hệ 4 và tính GPA/CPA chuẩn UTC
    │   │   │   └── ExcelService.java             # Xử lý đọc/xuất bảng điểm định dạng Excel (Apache POI)
    │   │   │
    │   │   ├── dao/                              # Tầng Truy xuất dữ liệu (Data Access Object - JDBC)
    │   │   │   ├── account/                      # Nhóm DAO quản lý người dùng
    │   │   │   │   ├── UserDAO.java
    │   │   │   │   ├── StudentDAO.java
    │   │   │   │   └── LecturerDAO.java
    │   │   │   ├── academic/                     # Nhóm DAO quản lý đào tạo
    │   │   │   │   ├── SubjectDAO.java
    │   │   │   │   ├── CourseClassDAO.java
    │   │   │   │   └── SemesterDAO.java
    │   │   │   └── grading/                      # Nhóm DAO quản lý điểm số, phúc khảo & thống kê
    │   │   │       ├── GradeDAO.java
    │   │   │       ├── AppealDAO.java
    │   │   │       ├── StatisticsDAO.java
    │   │   │       └── AuditLogDAO.java
    │   │   │
    │   │   └── model/                            # Tầng Thực thể dữ liệu (Domain Model / POJO Entities)
    │   │       ├── account/                      # User.java, Student.java, Lecturer.java
    │   │       ├── academic/                     # Subject.java, CourseClass.java, Semester.java, Faculty.java,...
    │   │       └── grading/                      # Grade.java, Appeal.java, AuditLog.java
    │   │
    │   └── webapp/                               # Tầng Giao diện người dùng (Frontend & JSP Views)
    │       ├── index.jsp                         # Trang điều hướng mặc định
    │       ├── assets/                           # Tài nguyên tĩnh (CSS, JavaScript, Logo UTC, Fonts)
    │       └── WEB-INF/
    │           ├── web.xml                       # File cấu hình Deployment Descriptor của ứng dụng
    │           └── views/                        # Các trang giao diện JSP (bảo vệ bên trong WEB-INF)
    │               ├── common/                   # Thành phần dùng chung: header.jsp, sidebar.jsp, footer.jsp
    │               ├── auth/                     # Giao diện xác thực: login.jsp, change-password.jsp
    │               ├── admin/                    # dashboard, grade-approval, appeals, subjects, classes, statistics
    │               ├── lecturer/                 # my-classes.jsp, grade-input.jsp
    │               └── student/                  # my-grades.jsp, appeals.jsp, transcript-print.jsp
    │
    └── test/                                     # Tầng Kiểm thử tự động (Unit & Integration Tests)
        └── java/vn/edu/utc/grade/
            └── OfflineAndOnlineTest.java         # Bộ kiểm thử toàn diện Offline (DB, logic) & Online (HTTP web)
```
