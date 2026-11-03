<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Thời Khóa Biểu & Lịch Thi Cá Nhân" />
<c:set var="activeMenu" value="schedule" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Header & Student Info -->
    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
            <h1 class="text-xl font-bold text-slate-800 flex items-center">
                <i class="fa-solid fa-calendar-days text-utc-blue mr-2.5"></i>Thời Khóa Biểu Học Tập & Lịch Thi Cá Nhân
            </h1>
            <p class="text-xs text-slate-500 mt-1">
                Sinh viên: <span class="font-bold text-slate-700">${sessionScope.currentStudent.fullName}</span> 
                (MSV: <span class="font-mono font-bold text-utc-blue">${sessionScope.currentStudent.studentId}</span>) | 
                Lớp: <span class="font-semibold text-slate-700">${sessionScope.currentStudent.className}</span> - Chỉ xem (Read-only)
            </p>
        </div>

        <div class="w-full sm:w-auto">
            <form action="${pageContext.request.contextPath}/student/schedule" method="GET" class="w-full sm:w-auto">
                <select name="semesterId" onchange="this.form.submit()" 
                        class="w-full sm:w-auto px-3 py-2 rounded-xl border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-utc-blue bg-slate-50">
                    <option value="">Tất cả học kỳ</option>
                    <c:forEach var="sem" items="${semesters}">
                        <option value="${sem.semesterId}" ${selectedSemester == sem.semesterId ? 'selected' : ''}>
                            ${sem.displayName}
                        </option>
                    </c:forEach>
                </select>
            </form>
        </div>
    </div>

    <!-- Quick Cards: Tách biệt Lịch Học & Lịch Thi -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div class="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center space-x-3">
            <div class="w-10 h-10 rounded-lg bg-blue-50 text-utc-blue flex items-center justify-center font-bold">
                <i class="fa-solid fa-graduation-cap text-lg"></i>
            </div>
            <div>
                <p class="text-[11px] text-slate-500 font-medium uppercase">Ca Học Trong Tuần</p>
                <p class="text-xs font-semibold text-slate-700">Đi học đúng giờ và tuân thủ nội quy giảng đường UTC</p>
            </div>
        </div>

        <div class="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center space-x-3">
            <div class="w-10 h-10 rounded-lg bg-rose-50 text-rose-600 flex items-center justify-center font-bold">
                <i class="fa-solid fa-pen-nib text-lg"></i>
            </div>
            <div>
                <p class="text-[11px] text-slate-500 font-medium uppercase">Lịch Thi Kết Thúc Học Phần</p>
                <p class="text-xs font-semibold text-slate-700">Mang theo Thẻ sinh viên hoặc CCCD khi vào phòng thi</p>
            </div>
        </div>
    </div>

    <!-- Schedule Table -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-4 border-b border-slate-200 bg-slate-50 flex flex-col sm:flex-row sm:items-center justify-between gap-2">
            <h2 class="text-xs font-bold uppercase tracking-wider text-slate-700 flex items-center">
                <i class="fa-solid fa-table-list text-slate-500 mr-2"></i>
                Chi Tiết Lịch Học & Lịch Thi Các Học Phần Đã Đăng Ký
            </h2>
            <span class="text-[11px] text-slate-400">Cập nhật thời gian thực từ Phòng Đào tạo UTC</span>
        </div>

        <!-- Thanh Lọc Nhanh Theo Thứ (Instant Day Filter) -->
        <div class="px-4 py-2.5 bg-slate-50/70 border-b border-slate-200 flex flex-wrap items-center gap-1.5 text-xs">
            <span class="text-slate-400 font-semibold mr-1 text-[11px] uppercase tracking-wider flex items-center">
                <i class="fa-solid fa-filter mr-1 text-slate-400"></i>Lọc theo thứ:
            </span>
            <button type="button" onclick="filterScheduleByDay('all', this)" class="day-filter-btn px-2.5 py-1 rounded-lg font-bold text-xs bg-utc-blue text-white shadow-xs transition">Tất cả</button>
            <button type="button" onclick="filterScheduleByDay('2', this)" class="day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 2</button>
            <button type="button" onclick="filterScheduleByDay('3', this)" class="day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 3</button>
            <button type="button" onclick="filterScheduleByDay('4', this)" class="day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 4</button>
            <button type="button" onclick="filterScheduleByDay('5', this)" class="day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 5</button>
            <button type="button" onclick="filterScheduleByDay('6', this)" class="day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 6</button>
            <button type="button" onclick="filterScheduleByDay('7', this)" class="day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 7</button>
            <button type="button" onclick="filterScheduleByDay('8', this)" class="day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Chủ Nhật</button>
        </div>

        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs text-slate-600">
                <thead class="bg-slate-50 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                    <tr>
                        <th class="px-3 py-3.5 text-center whitespace-nowrap w-10">STT</th>
                        <th class="px-3.5 py-3.5 whitespace-nowrap">Thời Gian & Ca Học</th>
                        <th class="px-4 py-3.5">Học Phần & Lớp Học</th>
                        <th class="px-3 py-3.5 text-center whitespace-nowrap">Phòng Học</th>
                        <th class="px-3.5 py-3.5 whitespace-nowrap">Giảng Viên</th>
                        <th class="px-3.5 py-3.5 text-center whitespace-nowrap">Phân Loại & Trạng Thái</th>
                        <th class="px-3 py-3.5">Ghi Chú</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="s" items="${schedules}" varStatus="loop">
                        <tr class="schedule-row hover:bg-slate-50/80 transition" data-day="${s.dayOfWeek}">
                            <td class="px-3 py-3 text-center text-slate-400 font-medium">${loop.index + 1}</td>
                            
                            <!-- Thời Gian & Ca Học (Gộp Thứ, Tiết & Khung Giờ) -->
                            <td class="px-3.5 py-3 whitespace-nowrap">
                                <div class="flex items-center">
                                    <span class="inline-flex items-center whitespace-nowrap px-2 py-0.5 rounded-md bg-blue-50 text-utc-blue font-bold text-[11px] border border-blue-200 shadow-2xs">
                                        <i class="fa-regular fa-calendar mr-1.5 text-utc-blue"></i>${s.dayOfWeekText}
                                    </span>
                                </div>
                                <div class="text-[11px] text-slate-600 mt-1 flex items-center gap-1.5 font-medium">
                                    <span class="text-slate-800 font-bold">${s.periodText}</span>
                                    <span class="text-slate-300">•</span>
                                    <span class="font-mono text-slate-500">${s.timeRangeText}</span>
                                </div>
                            </td>

                            <!-- Học Phần & Lớp (Gộp Mã HP + Tên Môn + Lớp) -->
                            <td class="px-4 py-3">
                                <div class="flex items-baseline gap-1.5 flex-wrap">
                                    <span class="font-mono font-bold text-utc-blue text-[11px] bg-blue-50 px-1.5 py-0.5 rounded border border-blue-200 whitespace-nowrap">${s.courseClassId}</span>
                                    <span class="font-bold text-slate-900 leading-snug">${s.subjectName}</span>
                                </div>
                                <div class="text-[11px] text-slate-500 mt-0.5 flex items-center">
                                    <i class="fa-solid fa-users text-[10px] mr-1 text-slate-400"></i>${s.courseClassName}
                                </div>
                            </td>

                            <!-- Phòng Học -->
                            <td class="px-3 py-3 text-center whitespace-nowrap">
                                <span class="inline-flex items-center whitespace-nowrap px-2.5 py-1 bg-indigo-50 text-indigo-700 border border-indigo-200 rounded-lg font-mono font-bold text-xs shadow-xs">
                                    <i class="fa-solid fa-door-open mr-1.5 text-indigo-500"></i>${s.room}
                                </span>
                            </td>

                            <!-- Giảng Viên -->
                            <td class="px-3.5 py-3 whitespace-nowrap">
                                <div class="font-medium text-slate-800 flex items-center">
                                    <i class="fa-solid fa-chalkboard-user mr-1.5 text-slate-400 text-xs"></i>${s.lecturerName}
                                </div>
                                <c:if test="${s.hasApprovedLeave && s.leaveType == 'DAY_THAY'}">
                                    <div class="text-[10px] text-purple-700 font-bold mt-1 inline-flex items-center px-1.5 py-0.5 bg-purple-50 rounded border border-purple-200 whitespace-nowrap">
                                        <i class="fa-solid fa-user-clock mr-1 text-purple-500"></i>Dạy thay: ${s.substituteLecturerName}
                                    </div>
                                </c:if>
                            </td>

                            <!-- Phân Loại & Trạng Thái -->
                            <td class="px-3.5 py-3 text-center whitespace-nowrap">
                                <div class="inline-flex flex-col items-center gap-1">
                                    ${s.scheduleTypeBadge}
                                    ${s.liveStatusBadge}
                                </div>
                            </td>

                            <!-- Ghi Chú -->
                            <td class="px-3 py-3 text-slate-400 italic text-[11px] max-w-[140px] truncate" title="${s.note != null ? s.note : ''}">
                                ${s.note != null && !s.note.isEmpty() ? s.note : '-'}
                            </td>
                        </tr>
                    </c:forEach>
                    <tr id="filterEmptyRow" style="display: none;">
                        <td colspan="7" class="px-4 py-8 text-center text-slate-400 text-xs italic">
                            Không có ca học nào trong ngày đã chọn.
                        </td>
                    </tr>
                    <c:if test="${empty schedules}">
                        <tr>
                            <td colspan="7" class="px-4 py-8 text-center text-slate-400 text-xs italic">
                                Bạn chưa có lịch học hoặc lịch thi nào trong học kỳ này.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
function filterScheduleByDay(day, btn) {
    document.querySelectorAll('.day-filter-btn').forEach(b => {
        b.className = 'day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition';
    });
    btn.className = 'day-filter-btn px-2.5 py-1 rounded-lg font-bold text-xs bg-utc-blue text-white shadow-xs transition';

    const rows = document.querySelectorAll('.schedule-row');
    let visibleCount = 0;
    rows.forEach(r => {
        if (day === 'all' || r.getAttribute('data-day') === day) {
            r.style.display = '';
            visibleCount++;
        } else {
            r.style.display = 'none';
        }
    });

    const emptyRow = document.getElementById('filterEmptyRow');
    if (emptyRow) {
        emptyRow.style.display = visibleCount === 0 ? '' : 'none';
    }
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
