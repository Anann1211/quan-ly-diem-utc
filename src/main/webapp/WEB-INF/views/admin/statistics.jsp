<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Báo Cáo & Thống Kê Học Vụ" />
<c:set var="activeMenu" value="statistics" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Header -->
    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
            <h1 class="text-xl font-bold text-slate-800 flex items-center">
                <i class="fa-solid fa-chart-column text-purple-600 mr-2.5"></i>Báo Cáo Phân Tích & Cảnh Báo Học Vụ
            </h1>
            <p class="text-xs text-slate-500 mt-1">Theo dõi chất lượng học tập toàn trường, danh sách sinh viên xuất sắc xét học bổng và sinh viên bị cảnh báo học tập</p>
        </div>
        <button type="button" onclick="window.print()"
                class="w-full sm:w-auto px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-bold border border-slate-300 flex items-center justify-center space-x-1.5 transition no-print shadow-2xs">
            <i class="fa-solid fa-print"></i>
            <span>In Báo Cáo</span>
        </button>
    </div>

    <!-- Analytics Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <!-- Grade Distribution Bar Chart -->
        <div class="bg-white rounded-xl border border-slate-200 p-6 shadow-sm">
            <h2 class="text-base font-bold text-slate-800 mb-2 flex items-center">
                <i class="fa-solid fa-chart-simple text-utc-blue mr-2"></i>Phổ Điểm Thang Chữ UTC
            </h2>
            <div class="h-64">
                <canvas id="detailedChart"></canvas>
            </div>
        </div>

        <!-- Grade Percentages Pie Chart -->
        <div class="bg-white rounded-xl border border-slate-200 p-6 shadow-sm flex flex-col">
            <h2 class="text-base font-bold text-slate-800 mb-2 flex items-center">
                <i class="fa-solid fa-chart-pie text-emerald-600 mr-2"></i>Tỷ Lệ Đạt / Học Lại Toàn Trường
            </h2>
            <div class="h-64 flex items-center justify-center">
                <canvas id="passFailChart"></canvas>
            </div>
        </div>
    </div>

    <!-- Top Students for Scholarship Card -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-4 sm:p-5 border-b border-slate-200 flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-amber-50/50">
            <div>
                <h2 class="text-base font-bold text-slate-800 flex items-center">
                    <i class="fa-solid fa-trophy text-amber-500 mr-2"></i>Danh Sách Sinh Viên Xuất Sắc (Xét Học Bổng Khuyến Khích UTC)
                </h2>
                <p class="text-xs text-slate-500">Tiêu chuẩn: Điểm CPA $\ge$ 3.20 (Khá/Giỏi/Xuất sắc) và tích lũy đủ tín chỉ</p>
            </div>
            <span class="px-2.5 py-1 bg-amber-100 text-amber-800 font-bold rounded-lg text-xs self-start sm:self-auto">
                Top ${topStudents.size()} Sinh viên
            </span>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs text-slate-600">
                <thead class="bg-slate-50 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                    <tr>
                        <th class="px-4 py-3 text-center whitespace-nowrap">Xếp hạng</th>
                        <th class="px-4 py-3 whitespace-nowrap">Mã SV</th>
                        <th class="px-4 py-3 whitespace-nowrap">Họ và tên</th>
                        <th class="px-4 py-3 whitespace-nowrap">Lớp & Ngành</th>
                        <th class="px-4 py-3 text-center whitespace-nowrap">Số TC Tích lũy</th>
                        <th class="px-4 py-3 text-center whitespace-nowrap">Điểm CPA Thang 4</th>
                        <th class="px-4 py-3 text-center whitespace-nowrap">Xếp loại học lực</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="st" items="${topStudents}" varStatus="loop">
                        <tr class="hover:bg-slate-50/80">
                            <td class="px-4 py-3 text-center font-bold whitespace-nowrap">
                                <span class="w-6 h-6 inline-flex items-center justify-center rounded-full ${loop.index == 0 ? 'bg-amber-400 text-white' : (loop.index == 1 ? 'bg-slate-300 text-slate-700' : 'bg-slate-100 text-slate-700')}">
                                    ${loop.index + 1}
                                </span>
                            </td>
                            <td class="px-4 py-3 font-bold text-slate-800 whitespace-nowrap">${st.studentId}</td>
                            <td class="px-4 py-3 font-semibold text-slate-900 whitespace-nowrap">${st.fullName}</td>
                            <td class="px-4 py-3 text-slate-500 whitespace-nowrap">${st.className} • ${st.majorName}</td>
                            <td class="px-4 py-3 text-center font-bold text-utc-blue whitespace-nowrap">${st.totalCredits} TC</td>
                            <td class="px-4 py-3 text-center font-bold text-emerald-600 text-sm whitespace-nowrap">${st.cpa}</td>
                            <td class="px-4 py-3 text-center whitespace-nowrap">
                                <span class="inline-flex items-center whitespace-nowrap px-3 py-1 rounded-full text-xs font-bold ${st.cpa >= 3.6 ? 'bg-purple-100 text-purple-800 border border-purple-200' : (st.cpa >= 3.2 ? 'bg-emerald-100 text-emerald-800 border border-emerald-200' : 'bg-blue-100 text-blue-800 border border-blue-200')} shadow-sm">
                                    ${st.cpa >= 3.6 ? 'Xuất sắc' : (st.cpa >= 3.2 ? 'Giỏi' : 'Khá')}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Academic Warning Card (Cảnh báo học tập) -->
    <div class="bg-white rounded-xl border border-rose-200 shadow-sm overflow-hidden">
        <div class="p-5 border-b border-rose-200 flex items-center justify-between bg-rose-50/50">
            <div>
                <h2 class="text-base font-bold text-rose-800 flex items-center">
                    <i class="fa-solid fa-triangle-exclamation text-rose-600 mr-2"></i>Danh Sách Sinh Viên Bị Cảnh Báo Học Vụ (CPA &lt; 1.00)
                </h2>
                <p class="text-xs text-rose-600">Quy chế đào tạo UTC: Điểm tích lũy CPA dưới 1.00 bị cảnh báo học tập mức 1, dưới 0.80 xem xét buộc thôi học</p>
            </div>
            <span class="px-2.5 py-1 bg-rose-100 text-rose-800 font-bold rounded-lg text-xs">
                ${warningStudents.size()} Sinh viên
            </span>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs text-slate-600">
                <thead class="bg-rose-50/30 text-slate-700 uppercase font-bold text-[11px] border-b border-rose-100">
                    <tr>
                        <th class="px-4 py-3 whitespace-nowrap">Mã SV</th>
                        <th class="px-4 py-3 whitespace-nowrap">Họ và tên</th>
                        <th class="px-4 py-3 whitespace-nowrap">Lớp quản lý</th>
                        <th class="px-4 py-3 text-center whitespace-nowrap">Số TC Tích lũy</th>
                        <th class="px-4 py-3 text-center whitespace-nowrap">Điểm CPA Thang 4</th>
                        <th class="px-4 py-3 text-center whitespace-nowrap">Mức cảnh báo</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-rose-100">
                    <c:forEach var="ws" items="${warningStudents}">
                        <tr class="hover:bg-rose-50/20">
                            <td class="px-4 py-3 font-bold text-rose-700 whitespace-nowrap">${ws.studentId}</td>
                            <td class="px-4 py-3 font-semibold text-slate-800 whitespace-nowrap">${ws.fullName}</td>
                            <td class="px-4 py-3 text-slate-500 whitespace-nowrap">${ws.className}</td>
                            <td class="px-4 py-3 text-center font-bold text-slate-700 whitespace-nowrap">${ws.totalCredits} TC</td>
                            <td class="px-4 py-3 text-center font-bold text-rose-600 text-sm whitespace-nowrap">${ws.cpa}</td>
                            <td class="px-4 py-3 text-center whitespace-nowrap">
                                <span class="inline-flex items-center whitespace-nowrap px-3 py-1 rounded-full text-xs font-bold bg-rose-100 text-rose-800 border border-rose-300 shadow-sm">
                                    <i class="fa-solid fa-circle-exclamation mr-1.5 text-rose-600"></i>${ws.cpa < 0.8 ? 'Cảnh báo mức 2 (Nguy cơ buộc thôi học)' : 'Cảnh báo mức 1'}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty warningStudents}">
                        <tr>
                            <td colspan="6" class="px-4 py-8 text-center text-slate-400">Hiện không có sinh viên nào bị cảnh báo học tập.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- Scripts for Charts -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Detailed Bar Chart
        const ctxBar = document.getElementById('detailedChart').getContext('2d');
        new Chart(ctxBar, {
            type: 'bar',
            data: {
                labels: ['A+', 'A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F+', 'F'],
                datasets: [{
                    label: 'Số lượng sinh viên',
                    data: [
                        ${dist['A+'] != null ? dist['A+'] : 0},
                        ${dist['A'] != null ? dist['A'] : 0},
                        ${dist['B+'] != null ? dist['B+'] : 0},
                        ${dist['B'] != null ? dist['B'] : 0},
                        ${dist['C+'] != null ? dist['C+'] : 0},
                        ${dist['C'] != null ? dist['C'] : 0},
                        ${dist['D+'] != null ? dist['D+'] : 0},
                        ${dist['D'] != null ? dist['D'] : 0},
                        ${dist['F+'] != null ? dist['F+'] : 0},
                        ${dist['F'] != null ? dist['F'] : 0}
                    ],
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
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
            }
        });

        // Pass / Fail Donut Chart
        const passCount = ${
            (dist['A+'] != null ? dist['A+'] : 0) +
            (dist['A'] != null ? dist['A'] : 0) +
            (dist['B+'] != null ? dist['B+'] : 0) +
            (dist['B'] != null ? dist['B'] : 0) +
            (dist['C+'] != null ? dist['C+'] : 0) +
            (dist['C'] != null ? dist['C'] : 0) +
            (dist['D+'] != null ? dist['D+'] : 0) +
            (dist['D'] != null ? dist['D'] : 0)
        };
        const failCount = ${
            (dist['F+'] != null ? dist['F+'] : 0) +
            (dist['F'] != null ? dist['F'] : 0)
        };

        const ctxPie = document.getElementById('passFailChart').getContext('2d');
        new Chart(ctxPie, {
            type: 'doughnut',
            data: {
                labels: ['Đạt (A+ đến D)', 'Học lại (F, F+)'],
                datasets: [{
                    data: [passCount, failCount],
                    backgroundColor: ['#10b981', '#ef4444'],
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });
    });
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
