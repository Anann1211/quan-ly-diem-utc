<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Tổng quan Phòng Đào Tạo" />
<c:set var="activeMenu" value="dashboard" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Welcome Banner -->
    <div class="bg-gradient-to-r from-utc-blue via-utc-dark to-slate-900 rounded-2xl p-6 text-white shadow-md flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
            <div class="text-xs uppercase tracking-widest text-slate-300 font-semibold mb-1">Cổng thông tin đào tạo tín chỉ</div>
            <h1 class="text-2xl font-bold">Xin chào, ${sessionScope.currentUser.fullName}!</h1>
            <p class="text-sm text-slate-300 mt-1">Giám sát tiến độ chấm điểm, phê duyệt bảng điểm và phân tích kết quả học tập trường ĐH GTVT.</p>
        </div>
        <div class="flex flex-wrap items-center gap-2 w-full md:w-auto">
            <a href="${pageContext.request.contextPath}/admin/grade-approval" 
               class="flex-1 sm:flex-initial px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs sm:text-sm font-semibold shadow-xs transition flex items-center justify-center space-x-1.5">
                <i class="fa-solid fa-clipboard-check"></i>
                <span>Duyệt điểm (${summary.submittedClasses != null ? summary.submittedClasses : 0})</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/appeals" 
               class="flex-1 sm:flex-initial px-4 py-2 bg-amber-500 hover:bg-amber-600 text-white rounded-xl text-xs sm:text-sm font-semibold shadow-xs transition flex items-center justify-center space-x-1.5">
                <i class="fa-solid fa-file-pen"></i>
                <span>Phúc khảo (${summary.pendingAppeals != null ? summary.pendingAppeals : 0})</span>
            </a>
        </div>
    </div>

    <!-- Alert Đơn Xin Nghỉ Cần Xử Lý -->
    <c:if test="${pendingLeavesCount > 0}">
        <div class="p-4 bg-amber-50 border-2 border-amber-300 rounded-xl flex flex-col sm:flex-row sm:items-center justify-between gap-3 shadow-xs">
            <div class="flex items-start sm:items-center space-x-3">
                <div class="w-9 h-9 rounded-lg bg-amber-500 text-white flex items-center justify-center font-bold text-base flex-shrink-0 animate-pulse">
                    <i class="fa-solid fa-bell"></i>
                </div>
                <div>
                    <h4 class="text-xs font-bold text-amber-900 uppercase">Thông Báo Thời Khóa Biểu & Giảng Đường</h4>
                    <p class="text-xs text-amber-800 mt-0.5">
                        Có <span class="px-1.5 py-0.5 rounded bg-amber-200 text-amber-900 font-bold">${pendingLeavesCount}</span> đơn xin báo nghỉ & kế hoạch dạy bù của Giảng viên đang chờ Phòng Đào tạo duyệt!
                    </p>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/admin/schedules?tab=leaves" 
               class="w-full sm:w-auto px-4 py-2 bg-amber-600 hover:bg-amber-700 text-white rounded-xl text-xs font-bold transition flex items-center justify-center space-x-1.5 shadow-xs whitespace-nowrap">
                <span>Xem & Duyệt Ngay</span>
                <i class="fa-solid fa-arrow-right"></i>
            </a>
        </div>
    </c:if>

    <!-- Quick Stat Cards -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <!-- Sinh viên -->
        <div class="bg-white rounded-xl p-5 border border-slate-200 shadow-sm flex items-center space-x-4">
            <div class="w-12 h-12 rounded-xl bg-blue-50 text-utc-blue flex items-center justify-center text-xl flex-shrink-0">
                <i class="fa-solid fa-user-graduate"></i>
            </div>
            <div>
                <div class="text-xs text-slate-500 font-medium uppercase tracking-wider">Tổng Sinh Viên</div>
                <div class="text-2xl font-bold text-slate-800">${summary.totalStudents}</div>
            </div>
        </div>

        <!-- Giảng viên -->
        <div class="bg-white rounded-xl p-5 border border-slate-200 shadow-sm flex items-center space-x-4">
            <div class="w-12 h-12 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center text-xl flex-shrink-0">
                <i class="fa-solid fa-chalkboard-user"></i>
            </div>
            <div>
                <div class="text-xs text-slate-500 font-medium uppercase tracking-wider">Tổng Giảng Viên</div>
                <div class="text-2xl font-bold text-slate-800">${summary.totalLecturers}</div>
            </div>
        </div>

        <!-- Lớp học phần -->
        <div class="bg-white rounded-xl p-5 border border-slate-200 shadow-sm flex items-center space-x-4">
            <div class="w-12 h-12 rounded-xl bg-purple-50 text-purple-600 flex items-center justify-center text-xl flex-shrink-0">
                <i class="fa-solid fa-book-open"></i>
            </div>
            <div>
                <div class="text-xs text-slate-500 font-medium uppercase tracking-wider">Lớp Học Phần</div>
                <div class="text-2xl font-bold text-slate-800">${summary.totalClasses}</div>
            </div>
        </div>

        <!-- Đơn phúc khảo chờ xử lý -->
        <div class="bg-white rounded-xl p-5 border border-slate-200 shadow-sm flex items-center space-x-4">
            <div class="w-12 h-12 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center text-xl flex-shrink-0">
                <i class="fa-solid fa-hourglass-half"></i>
            </div>
            <div>
                <div class="text-xs text-slate-500 font-medium uppercase tracking-wider">Đơn Phúc Khảo Chờ</div>
                <div class="text-2xl font-bold text-amber-600">${summary.pendingAppeals}</div>
            </div>
        </div>
    </div>

    <!-- Charts & Analytics Row -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Grade Distribution Chart -->
        <div class="lg:col-span-2 bg-white rounded-xl border border-slate-200 p-6 shadow-sm">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <h2 class="text-base font-bold text-slate-800 flex items-center">
                        <i class="fa-solid fa-chart-column text-utc-blue mr-2"></i>Phổ Điểm Toàn Trường (Thang Điểm Chữ UTC)
                    </h2>
                    <p class="text-xs text-slate-500">Phân bố điểm theo các mức: A+, A, B+, B, C+, C, D+, D, F+, F</p>
                </div>
                <span class="text-xs font-semibold px-2.5 py-1 bg-blue-50 text-utc-blue rounded-lg">Realtime DB</span>
            </div>
            <div class="h-64">
                <canvas id="gradeDistChart"></canvas>
            </div>
        </div>

        <!-- Top Students Card -->
        <div class="bg-white rounded-xl border border-slate-200 p-6 shadow-sm flex flex-col">
            <div class="flex items-center justify-between mb-4">
                <h2 class="text-base font-bold text-slate-800 flex items-center">
                    <i class="fa-solid fa-award text-amber-500 mr-2"></i>Top Sinh Viên Điểm CPA Cao
                </h2>
                <a href="${pageContext.request.contextPath}/admin/statistics" class="text-xs text-utc-blue hover:underline font-medium">Xem tất cả</a>
            </div>
            <div class="space-y-3 flex-1">
                <c:forEach var="st" items="${topStudents}" varStatus="loop">
                    <div class="flex items-center justify-between p-2.5 rounded-lg bg-slate-50 border border-slate-100 text-xs">
                        <div class="flex items-center space-x-3">
                            <span class="w-6 h-6 rounded-full ${loop.index == 0 ? 'bg-amber-400 text-white' : (loop.index == 1 ? 'bg-slate-300 text-slate-700' : 'bg-amber-100 text-amber-800')} flex items-center justify-center font-bold text-[11px]">
                                ${loop.index + 1}
                            </span>
                            <div>
                                <div class="font-bold text-slate-800">${st.fullName}</div>
                                <div class="text-[10px] text-slate-500">${st.studentId} • ${st.className}</div>
                            </div>
                        </div>
                        <div class="text-right">
                            <div class="font-bold text-emerald-600 text-sm">${st.cpa}</div>
                            <div class="text-[10px] text-slate-400">${st.totalCredits} TC tích lũy</div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Recent Appeals Table -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-5 border-b border-slate-200 flex items-center justify-between">
            <h2 class="text-base font-bold text-slate-800 flex items-center">
                <i class="fa-solid fa-clock-rotate-left text-utc-blue mr-2"></i>Đơn Phúc Khảo Gần Đây
            </h2>
            <a href="${pageContext.request.contextPath}/admin/appeals" class="text-xs text-utc-blue hover:underline font-semibold">
                Quản lý tất cả đơn <i class="fa-solid fa-arrow-right ml-1"></i>
            </a>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs text-slate-600">
                <thead class="bg-slate-50 text-slate-700 uppercase font-semibold text-[11px] border-b border-slate-200">
                    <tr>
                        <th class="px-4 py-3">Mã SV</th>
                        <th class="px-4 py-3">Họ và tên</th>
                        <th class="px-4 py-3">Lớp học phần</th>
                        <th class="px-4 py-3">Điểm thi cũ</th>
                        <th class="px-4 py-3">Lý do phúc khảo</th>
                        <th class="px-4 py-3">Trạng thái</th>
                        <th class="px-4 py-3 text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="ap" items="${recentAppeals}">
                        <tr class="hover:bg-slate-50">
                            <td class="px-4 py-3 font-semibold text-slate-800">${ap.studentId}</td>
                            <td class="px-4 py-3">${ap.studentName}</td>
                            <td class="px-4 py-3">${ap.courseClassName}</td>
                            <td class="px-4 py-3 font-bold text-amber-600">${ap.oldFinalScore}</td>
                            <td class="px-4 py-3 max-w-xs truncate" title="${ap.reason}">${ap.reason}</td>
                            <td class="px-4 py-3">${ap.statusBadge}</td>
                            <td class="px-4 py-3 text-center">
                                <a href="${pageContext.request.contextPath}/admin/appeals" class="text-utc-blue hover:underline font-medium">Xử lý</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentAppeals}">
                        <tr>
                            <td colspan="7" class="px-4 py-8 text-center text-slate-400">Không có đơn phúc khảo nào cần xử lý.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- Chart.js Script for Grade Distribution -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const ctx = document.getElementById('gradeDistChart').getContext('2d');
        const labels = ['A+', 'A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F+', 'F'];
        const dataValues = [
            ${gradeDist['A+'] != null ? gradeDist['A+'] : 0},
            ${gradeDist['A'] != null ? gradeDist['A'] : 0},
            ${gradeDist['B+'] != null ? gradeDist['B+'] : 0},
            ${gradeDist['B'] != null ? gradeDist['B'] : 0},
            ${gradeDist['C+'] != null ? gradeDist['C+'] : 0},
            ${gradeDist['C'] != null ? gradeDist['C'] : 0},
            ${gradeDist['D+'] != null ? gradeDist['D+'] : 0},
            ${gradeDist['D'] != null ? gradeDist['D'] : 0},
            ${gradeDist['F+'] != null ? gradeDist['F+'] : 0},
            ${gradeDist['F'] != null ? gradeDist['F'] : 0}
        ];

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Số lượng sinh viên',
                    data: dataValues,
                    backgroundColor: [
                        '#10b981', '#059669', '#3b82f6', '#2563eb',
                        '#f59e0b', '#d97706', '#f97316', '#ea580c',
                        '#ef4444', '#dc2626'
                    ],
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { stepSize: 1 }
                    }
                }
            }
        });
    });
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
