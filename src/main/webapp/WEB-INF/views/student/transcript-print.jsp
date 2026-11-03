<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bảng Điểm Học Tập - ${student.studentId} - ${student.fullName}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Times+New+Roman&family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Times New Roman', serif; }
        @media print {
            .no-print { display: none !important; }
            body { background: white !important; padding: 0 !important; }
            .print-page { box-shadow: none !important; border: none !important; width: 100% !important; margin: 0 !important; padding: 0 !important; }
        }
    </style>
</head>
<body class="bg-slate-100 py-8 text-slate-900">

    <!-- Floating Print Control Bar (Screen only) -->
    <div class="max-w-4xl mx-auto mb-4 no-print flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 bg-white p-4 rounded-xl shadow-sm border border-slate-200">
        <div class="text-xs text-slate-500">
            <i class="fa-solid fa-circle-info text-blue-600 mr-1"></i>
            Định dạng chuẩn trang A4 Đại học Giao thông Vận tải. Bấm nút bên phải để in hoặc lưu thành file PDF.
        </div>
        <div class="flex items-center gap-2 w-full sm:w-auto justify-end">
            <button onclick="window.close()" class="px-3.5 py-1.5 rounded-lg border border-slate-300 text-xs font-semibold text-slate-600 hover:bg-slate-50 transition flex-1 sm:flex-initial text-center">
                Đóng
            </button>
            <button onclick="window.print()" class="px-4 py-1.5 rounded-lg bg-blue-800 hover:bg-blue-900 text-white text-xs font-bold shadow flex items-center justify-center gap-1.5 transition flex-1 sm:flex-initial text-center">
                <i class="fa-solid fa-print"></i>
                <span>In / Xuất PDF</span>
            </button>
        </div>
    </div>

    <!-- Official A4 Paper Layout -->
    <div class="print-page max-w-4xl mx-auto bg-white p-4 sm:p-8 md:p-12 shadow-xl border border-slate-200 min-h-[1050px] flex flex-col justify-between">
        <div>
            <!-- Official Header -->
            <div class="flex justify-between items-start text-center pb-6 border-b-2 border-slate-900">
                <div class="w-1/2 text-center">
                    <div class="text-xs uppercase tracking-wider">BỘ GIÁO DỤC VÀ ĐÀO TẠO</div>
                    <div class="text-sm font-bold uppercase tracking-wide text-blue-900">TRƯỜNG ĐẠI HỌC GIAO THÔNG VẬN TẢI</div>
                    <div class="w-24 h-0.5 bg-blue-900 mx-auto mt-1"></div>
                </div>
                <div class="w-1/2 text-center">
                    <div class="text-xs font-bold uppercase">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</div>
                    <div class="text-xs font-bold italic">Độc lập - Tự do - Hạnh phúc</div>
                    <div class="w-32 h-0.5 bg-slate-800 mx-auto mt-1"></div>
                </div>
            </div>

            <!-- Title -->
            <div class="text-center my-6">
                <h1 class="text-xl font-bold uppercase tracking-wider text-slate-900">BẢNG KẾT QUẢ HỌC TẬP TÍCH LŨY</h1>
                <p class="text-xs italic text-slate-600">(Theo hệ thống đào tạo tín chỉ - Chuẩn quy chế UTC)</p>
            </div>

            <!-- Student Personal Information Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-y-2 gap-x-8 text-xs mb-6 p-4 bg-slate-50/50 rounded-lg border border-slate-200">
                <div>Họ và tên: <strong class="text-sm uppercase">${student.fullName}</strong></div>
                <div>Mã số sinh viên: <strong>${student.studentId}</strong></div>
                <div>Ngày sinh: <strong>${student.dateOfBirth}</strong></div>
                <div>Giới tính: <strong>${student.gender}</strong></div>
                <div>Quê quán: <strong>${student.hometown}</strong></div>
                <div>Lớp chuyên ngành: <strong>${student.className}</strong></div>
                <div>Ngành đào tạo: <strong>${student.majorName}</strong></div>
                <div>Khoa / Viện: <strong>${student.facultyName}</strong></div>
            </div>

            <!-- Academic Transcript Table -->
            <div class="overflow-x-auto mb-6">
                <table class="w-full text-left text-xs border border-slate-900 border-collapse">
                    <thead>
                        <tr class="bg-slate-100 text-center font-bold">
                            <th class="border border-slate-900 p-2 w-10">STT</th>
                            <th class="border border-slate-900 p-2 w-20">Mã HP</th>
                            <th class="border border-slate-900 p-2">Tên Học Phần</th>
                            <th class="border border-slate-900 p-2 w-14">Số TC</th>
                            <th class="border border-slate-900 p-2 w-16">Điểm 10</th>
                            <th class="border border-slate-900 p-2 w-16">Điểm Chữ</th>
                            <th class="border border-slate-900 p-2 w-16">Thang 4</th>
                            <th class="border border-slate-900 p-2 w-20">Đánh giá</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="g" items="${allGrades}" varStatus="loop">
                            <tr>
                                <td class="border border-slate-900 p-1.5 text-center">${loop.index + 1}</td>
                                <td class="border border-slate-900 p-1.5 font-bold text-center">${g.subjectId}</td>
                                <td class="border border-slate-900 p-1.5">${g.subjectName}</td>
                                <td class="border border-slate-900 p-1.5 text-center font-bold">${g.credits}</td>
                                <td class="border border-slate-900 p-1.5 text-center font-semibold">${g.scoreTotal10 != null ? g.scoreTotal10 : '-'}</td>
                                <td class="border border-slate-900 p-1.5 text-center font-bold">${g.scoreLetter != null ? g.scoreLetter : '-'}</td>
                                <td class="border border-slate-900 p-1.5 text-center font-bold">${g.scoreScale4 != null ? g.scoreScale4 : '-'}</td>
                                <td class="border border-slate-900 p-1.5 text-center font-medium">
                                    ${"DAT".equalsIgnoreCase(g.result) ? "Đạt" : ("KHONG_DAT".equalsIgnoreCase(g.result) ? "Học lại" : "-")}
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty allGrades}">
                            <tr>
                                <td colspan="8" class="border border-slate-900 p-6 text-center text-slate-400">
                                    Chưa có học phần nào được công bố điểm chính thức.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <!-- Summary Box -->
            <div class="p-3 bg-slate-50 border border-slate-900 text-xs flex flex-col sm:flex-row justify-between items-start sm:items-center gap-2 mb-8">
                <div>
                    <div>Tổng số tín chỉ đã tích lũy: <strong class="text-sm font-bold text-blue-900">${student.totalCredits} tín chỉ</strong></div>
                    <div>Điểm trung bình chung tích lũy (CPA): <strong class="text-sm font-bold text-blue-900">${student.cpa}</strong> (Thang điểm 4.0)</div>
                </div>
                <div class="text-left sm:text-right">
                    <div>Xếp loại học lực: <strong class="text-sm font-bold uppercase text-blue-900">${academicRank}</strong></div>
                    <div class="text-[11px] text-slate-500">Tình trạng học vụ: Bình thường</div>
                </div>
            </div>
        </div>

        <!-- Signature Section -->
        <div class="flex justify-between items-start text-xs pt-4">
            <div class="w-1/3 text-center">
                <div class="font-bold uppercase">NGƯỜI LẬP BẢNG</div>
                <div class="text-slate-400 italic text-[11px] mt-1">(Ký và ghi rõ họ tên)</div>
                <div class="h-20"></div>
                <div class="font-bold">Ban Quản lý Điểm UTC</div>
            </div>

            <div class="w-1/3 text-center">
            </div>

            <div class="w-1/3 text-center">
                <div class="italic text-[11px]">Hà Nội, ngày 15 tháng 10 năm 2026</div>
                <div class="font-bold uppercase mt-1">TRƯỞNG PHÒNG ĐÀO TẠO</div>
                <div class="text-slate-400 italic text-[11px] mt-1">(Ký tên và đóng dấu)</div>
                <div class="h-20"></div>
                <div class="font-bold uppercase text-blue-900">PGS.TS. NGUYỄN VĂN HÙNG</div>
            </div>
        </div>
    </div>

</body>
</html>
