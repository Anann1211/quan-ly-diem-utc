<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Duyệt & Công Bố Điểm" />
<c:set var="activeMenu" value="approval" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Header & Filter -->
    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
            <h1 class="text-xl font-bold text-slate-800 flex items-center">
                <i class="fa-solid fa-clipboard-check text-emerald-600 mr-2.5"></i>Phê Duyệt & Công Bố Bảng Điểm
            </h1>
            <p class="text-xs text-slate-500 mt-1">Kiểm tra bảng điểm do Giảng viên nộp và công bố chính thức cho sinh viên tra cứu</p>
        </div>

        <!-- Class Selector Form -->
        <form action="${pageContext.request.contextPath}/admin/grade-approval" method="GET" class="w-full sm:w-auto">
            <select name="classId" onchange="this.form.submit()" 
                    class="w-full sm:w-auto px-3.5 py-2 rounded-xl border border-slate-300 text-xs sm:text-sm font-medium focus:ring-2 focus:ring-utc-blue bg-slate-50">
                <option value="">-- Chọn Lớp Học Phần để xem điểm --</option>
                <c:forEach var="c" items="${classes}">
                    <option value="${c.classId}" ${targetClass != null && targetClass.classId == c.classId ? 'selected' : ''}>
                        ${c.classId} - ${c.className} [${c.gradeStatus}]
                    </option>
                </c:forEach>
            </select>
        </form>
    </div>

    <!-- Feedback Alerts -->
    <c:if test="${param.msg == 'PUBLISHED'}">
        <div class="p-4 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-sm flex items-center space-x-2">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base"></i>
            <span>Bảng điểm đã được <strong>Phê duyệt & Công bố chính thức</strong>! Sinh viên hiện đã có thể tra cứu và tính CPA.</span>
        </div>
    </c:if>

    <c:if test="${param.msg == 'DRAFT'}">
        <div class="p-4 rounded-xl bg-amber-50 border border-amber-200 text-amber-800 text-sm flex items-center space-x-2">
            <i class="fa-solid fa-arrow-rotate-left text-amber-600 text-base"></i>
            <span>Bảng điểm đã được chuyển về trạng thái <strong>Bản nháp (DRAFT)</strong> để Giảng viên kiểm tra và điều chỉnh.</span>
        </div>
    </c:if>

    <c:if test="${param.msg == 'student_withdrawn'}">
        <div class="p-4 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-sm flex items-center space-x-2">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base"></i>
            <span>Đã xóa sinh viên khỏi danh sách lớp học phần thành công!</span>
        </div>
    </c:if>

    <c:if test="${param.error == 'cannot_withdraw_published'}">
        <div class="p-4 rounded-xl bg-rose-50 border border-rose-200 text-rose-800 text-sm flex items-center space-x-2">
            <i class="fa-solid fa-triangle-exclamation text-rose-600 text-base"></i>
            <span>Không thể xóa sinh viên khi bảng điểm lớp học phần đã được <strong>Công bố chính thức (PUBLISHED)</strong>!</span>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty targetClass}">
            <!-- Class Details & Action Toolbar -->
            <div class="bg-white rounded-xl border border-slate-200 p-6 shadow-sm">
                <div class="flex flex-col lg:flex-row lg:items-center justify-between pb-4 border-b border-slate-200 gap-4">
                    <div>
                        <div class="flex items-center space-x-2">
                            <span class="text-xs font-bold px-2 py-0.5 rounded bg-blue-100 text-utc-blue">${targetClass.classId}</span>
                            <h2 class="text-lg font-bold text-slate-800">${targetClass.className}</h2>
                            <div>${targetClass.statusBadge}</div>
                        </div>
                        <div class="text-xs text-slate-500 mt-1 flex flex-wrap gap-x-4 gap-y-1">
                            <span><i class="fa-solid fa-user-tie mr-1 text-slate-400"></i>GV: <strong>${targetClass.lecturerName}</strong></span>
                            <span><i class="fa-solid fa-graduation-cap mr-1 text-slate-400"></i>Số TC: <strong>${targetClass.credits}</strong></span>
                            <span><i class="fa-solid fa-percent mr-1 text-slate-400"></i>Trọng số: CC <strong>${targetClass.weightAttendance * 100}%</strong> - GK <strong>${targetClass.weightMidterm * 100}%</strong> - Thi <strong>${targetClass.weightFinal * 100}%</strong></span>
                            <span><i class="fa-solid fa-users mr-1 text-slate-400"></i>Sĩ số: <strong>${targetClass.enrolledCount}</strong></span>
                        </div>
                    </div>

                    <!-- Approval Action Buttons -->
                    <div class="flex flex-wrap items-center gap-2 w-full lg:w-auto">
                        <c:if test="${targetClass.gradeStatus != 'PUBLISHED'}">
                            <form action="${pageContext.request.contextPath}/admin/grade-approval" method="POST" 
                                  class="flex-1 sm:flex-initial"
                                  onsubmit="return confirm('Bạn có chắc chắn muốn PHÊ DUYỆT và CÔNG BỐ bảng điểm này không?');">
                                <input type="hidden" name="classId" value="${targetClass.classId}">
                                <input type="hidden" name="status" value="PUBLISHED">
                                <button type="submit" 
                                        class="w-full sm:w-auto px-4 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs sm:text-sm font-bold shadow-xs flex items-center justify-center space-x-1.5 transition">
                                    <i class="fa-solid fa-check-double"></i>
                                    <span>Phê Duyệt & Công Bố</span>
                                </button>
                            </form>
                        </c:if>

                        <c:if test="${targetClass.gradeStatus != 'DRAFT'}">
                            <form action="${pageContext.request.contextPath}/admin/grade-approval" method="POST" 
                                  class="flex-1 sm:flex-initial"
                                  onsubmit="return confirm('Trả lại bảng điểm cho Giảng viên chỉnh sửa?');">
                                <input type="hidden" name="classId" value="${targetClass.classId}">
                                <input type="hidden" name="status" value="DRAFT">
                                <button type="submit" 
                                        class="w-full sm:w-auto px-4 py-2.5 bg-amber-500 hover:bg-amber-600 text-white rounded-xl text-xs sm:text-sm font-semibold shadow-xs flex items-center justify-center space-x-1.5 transition">
                                    <i class="fa-solid fa-rotate-left"></i>
                                    <span>Mở khóa / Trả về GV</span>
                                </button>
                            </form>
                        </c:if>
                    </div>
                </div>

                <!-- Histogram Chart of this Class -->
                <div class="mt-4 p-4 bg-slate-50 rounded-xl border border-slate-100">
                    <div class="text-xs font-bold text-slate-700 uppercase tracking-wider mb-2 flex items-center">
                        <i class="fa-solid fa-chart-column mr-1.5 text-utc-blue"></i>Phổ điểm học phần này (A+ đến F)
                    </div>
                    <div class="h-32">
                        <canvas id="classDistChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Grade Table -->
            <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-xs text-slate-600">
                        <thead class="bg-slate-50 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                            <tr>
                                <th class="px-4 py-3 text-center">STT</th>
                                <th class="px-4 py-3">Mã SV</th>
                                <th class="px-4 py-3">Họ và tên</th>
                                <th class="px-4 py-3">Lớp</th>
                                <th class="px-4 py-3 text-center">CC (${targetClass.weightAttendance * 100}%)</th>
                                <th class="px-4 py-3 text-center">GK (${targetClass.weightMidterm * 100}%)</th>
                                <th class="px-4 py-3 text-center">Thi (${targetClass.weightFinal * 100}%)</th>
                                <th class="px-4 py-3 text-center bg-slate-100/70 text-slate-800">Tổng kết 10</th>
                                <th class="px-4 py-3 text-center">Điểm chữ</th>
                                <th class="px-4 py-3 text-center">Thang 4</th>
                                <th class="px-4 py-3 text-center">Kết quả</th>
                                <th class="px-4 py-3">Ghi chú</th>
                                <th class="px-4 py-3 text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-200">
                            <c:forEach var="g" items="${grades}" varStatus="loop">
                                <tr class="hover:bg-slate-50/80">
                                    <td class="px-4 py-3 text-center text-slate-400 font-medium">${loop.index + 1}</td>
                                    <td class="px-4 py-3 font-bold text-slate-800">${g.studentId}</td>
                                    <td class="px-4 py-3 font-medium">${g.studentName}</td>
                                    <td class="px-4 py-3 text-slate-500">${g.className}</td>
                                    <td class="px-4 py-3 text-center">${g.scoreAttendance != null ? g.scoreAttendance : '-'}</td>
                                    <td class="px-4 py-3 text-center">${g.scoreMidterm != null ? g.scoreMidterm : '-'}</td>
                                    <td class="px-4 py-3 text-center font-bold ${g.scoreFinal != null && g.scoreFinal < 4.0 ? 'text-rose-600' : 'text-slate-800'}">
                                        ${g.scoreFinal != null ? g.scoreFinal : '-'}
                                    </td>
                                    <td class="px-4 py-3 text-center font-bold text-slate-900 bg-slate-50">
                                        ${g.scoreTotal10 != null ? g.scoreTotal10 : '-'}
                                    </td>
                                    <td class="px-4 py-3 text-center text-sm">${g.letterBadge}</td>
                                    <td class="px-4 py-3 text-center font-semibold text-slate-700">${g.scoreScale4 != null ? g.scoreScale4 : '-'}</td>
                                    <td class="px-4 py-3 text-center">${g.resultBadge}</td>
                                    <td class="px-4 py-3 text-slate-400 italic">${g.note}</td>
                                    <td class="px-4 py-3 text-center whitespace-nowrap">
                                        <c:choose>
                                            <c:when test="${targetClass.gradeStatus != 'PUBLISHED'}">
                                                <form action="${pageContext.request.contextPath}/admin/grade-approval" method="POST" class="inline"
                                                      onsubmit="return confirm('Xác nhận cho sinh viên ${g.studentName} (${g.studentId}) rút khỏi môn học này? Bảng điểm của sinh viên sẽ bị hủy.');">
                                                    <input type="hidden" name="action" value="remove_student">
                                                    <input type="hidden" name="classId" value="${targetClass.classId}">
                                                    <input type="hidden" name="studentId" value="${g.studentId}">
                                                    <button type="submit" title="Rút học phần"
                                                            class="px-2 py-1 rounded-lg bg-rose-50 text-rose-600 hover:bg-rose-100 font-semibold text-[11px] transition inline-flex items-center">
                                                        <i class="fa-solid fa-user-minus mr-1"></i>Rút môn
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-slate-400 text-[11px] italic" title="Điểm đã công bố không thể rút"><i class="fa-solid fa-lock"></i> Đã khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Chart Script -->
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    const ctx = document.getElementById('classDistChart').getContext('2d');
                    new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: ['A+', 'A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F+', 'F'],
                            datasets: [{
                                label: 'Sinh viên',
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
                                backgroundColor: '#003366',
                                borderRadius: 4
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: { legend: { display: false } },
                            scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
                        }
                    });
                });
            </script>
        </c:when>

        <c:otherwise>
            <!-- Empty State / Guide -->
            <div class="bg-white rounded-xl border border-slate-200 p-12 text-center shadow-sm">
                <div class="w-16 h-16 rounded-full bg-blue-50 text-utc-blue flex items-center justify-center text-2xl mx-auto mb-4">
                    <i class="fa-solid fa-hand-pointer"></i>
                </div>
                <h3 class="text-base font-bold text-slate-800">Vui lòng chọn một Lớp học phần ở danh sách trên</h3>
                <p class="text-xs text-slate-500 max-w-sm mx-auto mt-1">
                    Bạn có thể kiểm tra danh sách bảng điểm, đánh giá phổ điểm lớp và bấm "Phê duyệt & Công bố" để đưa điểm vào hệ thống chính thức.
                </p>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
