<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Lịch Giảng Dạy & Coi Thi Cá Nhân" />
<c:set var="activeMenu" value="schedule" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Header & Action -->
    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
            <h1 class="text-xl font-bold text-slate-800 flex items-center">
                <i class="fa-solid fa-calendar-check text-utc-blue mr-2.5"></i>Lịch Giảng Dạy & Coi Thi Cá Nhân
            </h1>
            <p class="text-xs text-slate-500 mt-1">
                Giảng viên: <span class="font-bold text-slate-700">${sessionScope.currentLecturer.academicRank} ${sessionScope.currentLecturer.fullName}</span> 
                (${sessionScope.currentLecturer.facultyName}) - Chỉ xem (Read-only)
            </p>
        </div>

        <div class="flex flex-wrap items-center gap-2 w-full md:w-auto">
            <form action="${pageContext.request.contextPath}/lecturer/schedule" method="GET" class="flex-1 sm:flex-initial">
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

            <button type="button" onclick="openLeaveModal()"
                    class="w-full sm:w-auto px-4 py-2 bg-amber-50 text-amber-700 hover:bg-amber-100 border border-amber-200 rounded-xl text-xs font-bold shadow-2xs transition flex items-center justify-center space-x-1.5">
                <i class="fa-solid fa-envelope-open-text"></i>
                <span>Gửi Đơn Xin Nghỉ / Dạy Bù</span>
            </button>
        </div>
    </div>

    <!-- Alert Messages -->
    <c:if test="${param.msg == 'leave_submitted'}">
        <div class="p-4 bg-emerald-50 border border-emerald-200 rounded-xl text-xs text-emerald-800 font-medium flex items-center shadow-sm">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base mr-2"></i>
            Đơn xin báo nghỉ / lịch dạy bù của thầy/cô đã được gửi thành công tới Phòng Đào tạo để phê duyệt!
        </div>
    </c:if>

    <div class="p-3 bg-blue-50 border border-blue-200 rounded-xl text-xs text-blue-800 flex items-center">
        <i class="fa-solid fa-lightbulb text-utc-blue mr-2 text-base"></i>
        <span><b>Mẹo thao tác nhanh:</b> Nhấp chuột trực tiếp vào bất kỳ ca dạy nào dưới đây để <b>chuyển thẳng tới trang Sổ Điểm / Điểm danh</b> của lớp học phần tương ứng!</span>
    </div>

    <!-- Schedule Table -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-4 border-b border-slate-200 bg-slate-50 flex flex-col sm:flex-row sm:items-center justify-between gap-2">
            <h2 class="text-xs font-bold uppercase tracking-wider text-slate-700 flex items-center">
                <i class="fa-solid fa-calendar-week text-slate-500 mr-2"></i>
                Chi Tiết Lịch Giảng Dạy & Lịch Coi Thi
            </h2>
            <span class="text-[11px] text-slate-400">Dữ liệu phân công giảng dạy từ Phòng Đào tạo UTC</span>
        </div>

        <!-- Thanh Lọc Nhanh Theo Thứ (Instant Day Filter) -->
        <div class="px-4 py-2.5 bg-slate-50/70 border-b border-slate-200 flex flex-wrap items-center gap-1.5 text-xs">
            <span class="text-slate-400 font-semibold mr-1 text-[11px] uppercase tracking-wider flex items-center">
                <i class="fa-solid fa-filter mr-1 text-slate-400"></i>Lọc theo thứ:
            </span>
            <button type="button" onclick="filterLecturerScheduleByDay('all', this)" class="lec-day-filter-btn px-2.5 py-1 rounded-lg font-bold text-xs bg-utc-blue text-white shadow-xs transition">Tất cả</button>
            <button type="button" onclick="filterLecturerScheduleByDay('2', this)" class="lec-day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 2</button>
            <button type="button" onclick="filterLecturerScheduleByDay('3', this)" class="lec-day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 3</button>
            <button type="button" onclick="filterLecturerScheduleByDay('4', this)" class="lec-day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 4</button>
            <button type="button" onclick="filterLecturerScheduleByDay('5', this)" class="lec-day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 5</button>
            <button type="button" onclick="filterLecturerScheduleByDay('6', this)" class="lec-day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 6</button>
            <button type="button" onclick="filterLecturerScheduleByDay('7', this)" class="lec-day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 7</button>
            <button type="button" onclick="filterLecturerScheduleByDay('8', this)" class="lec-day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Chủ Nhật</button>
        </div>

        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs text-slate-600">
                <thead class="bg-slate-50 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                    <tr>
                        <th class="px-3 py-3.5 text-center whitespace-nowrap w-10">STT</th>
                        <th class="px-3.5 py-3.5 whitespace-nowrap">Thời Gian & Ca Dạy</th>
                        <th class="px-4 py-3.5">Học Phần & Lớp Giảng Dạy</th>
                        <th class="px-3 py-3.5 text-center whitespace-nowrap">Phòng Học</th>
                        <th class="px-3.5 py-3.5 text-center whitespace-nowrap">Phân Loại & Trạng Thái</th>
                        <th class="px-3.5 py-3.5">Ghi Chú & Phân Công</th>
                        <th class="px-3.5 py-3.5 text-center whitespace-nowrap">Thao Tác</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="s" items="${schedules}" varStatus="loop">
                        <tr class="lec-schedule-row hover:bg-blue-50/60 transition cursor-pointer"
                            data-day="${s.dayOfWeek}"
                            onclick="window.location.href='${pageContext.request.contextPath}/lecturer/grade-input?classId=${s.courseClassId}'"
                            title="Bấm để vào sổ điểm lớp ${s.courseClassId}">
                            <td class="px-3 py-3 text-center text-slate-400 font-medium">${loop.index + 1}</td>
                            
                            <!-- Thời Gian & Ca Dạy (Gộp Thứ, Tiết & Khung Giờ) -->
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

                            <!-- Phân Loại & Trạng Thái -->
                            <td class="px-3.5 py-3 text-center whitespace-nowrap">
                                <div class="inline-flex flex-col items-center gap-1">
                                    ${s.scheduleTypeBadge}
                                    ${s.liveStatusBadge}
                                </div>
                            </td>

                            <!-- Ghi Chú & Phân Công -->
                            <td class="px-3.5 py-3 text-slate-600 text-xs">
                                <c:choose>
                                    <c:when test="${s.hasApprovedLeave && s.leaveType == 'DAY_THAY'}">
                                        <div class="text-[11px] text-purple-700 font-bold inline-flex items-center px-1.5 py-0.5 bg-purple-50 rounded border border-purple-200 whitespace-nowrap">
                                            <i class="fa-solid fa-user-clock mr-1 text-purple-500"></i>Dạy thay: ${s.substituteLecturerName}
                                        </div>
                                    </c:when>
                                    <c:when test="${not empty s.note}">
                                        <span class="text-slate-500 text-[11px] italic">${s.note}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-slate-300">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- Thao Tác Nhanh -->
                            <td class="px-3.5 py-3 text-center whitespace-nowrap" onclick="event.stopPropagation()">
                                <a href="${pageContext.request.contextPath}/lecturer/grade-input?classId=${s.courseClassId}"
                                   class="px-2.5 py-1.5 rounded-lg bg-utc-blue text-white hover:bg-utc-dark font-semibold text-[11px] transition inline-flex items-center space-x-1 shadow-sm">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                    <span>Vào Sổ Điểm</span>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <tr id="lecFilterEmptyRow" style="display: none;">
                        <td colspan="7" class="px-4 py-8 text-center text-slate-400 text-xs italic">
                            Thầy/cô không có ca dạy nào trong ngày đã chọn.
                        </td>
                    </tr>
                    <c:if test="${empty schedules}">
                        <tr>
                            <td colspan="7" class="px-4 py-8 text-center text-slate-400 text-xs italic">
                                Thầy/cô chưa có ca giảng dạy hoặc lịch coi thi nào trong tiêu chí lọc này.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Leave Request History Table -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-4 border-b border-slate-200 bg-slate-50 flex items-center justify-between">
            <h2 class="text-xs font-bold uppercase tracking-wider text-slate-700 flex items-center">
                <i class="fa-solid fa-clock-rotate-left text-amber-500 mr-2"></i>
                Lịch Sử Đơn Báo Nghỉ & Kế Hoạch Dạy Bù / Dạy Thay Đã Gửi (${myLeaveRequests.size()} đơn)
            </h2>
            <span class="text-[11px] text-slate-400">Trạng thái phê duyệt từ Phòng Đào tạo UTC</span>
        </div>

        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs text-slate-600">
                <thead class="bg-slate-50/80 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                    <tr>
                        <th class="px-3 py-3.5 text-center whitespace-nowrap w-10">STT</th>
                        <th class="px-3.5 py-3.5">Ca Dạy & Ngày Nghỉ</th>
                        <th class="px-3.5 py-3.5 text-center whitespace-nowrap">Hình Thức & Trạng Thái</th>
                        <th class="px-4 py-3.5">Lý Do Xin Nghỉ</th>
                        <th class="px-4 py-3.5">Kế Hoạch Bố Trí Cụ Thể</th>
                        <th class="px-3.5 py-3.5">Phản Hồi Từ Phòng Đào Tạo</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="lr" items="${myLeaveRequests}" varStatus="loop">
                        <tr class="hover:bg-slate-50/80 transition">
                            <td class="px-3 py-3 text-center text-slate-400 font-medium">${loop.index + 1}</td>
                            
                            <!-- Ca Dạy & Ngày Nghỉ -->
                            <td class="px-3.5 py-3">
                                <div class="font-bold text-slate-800 leading-snug">${lr.subjectName}</div>
                                <div class="text-[11px] text-slate-500 font-medium mt-0.5">${lr.scheduleInfo}</div>
                                <div class="text-[11px] font-bold text-rose-600 mt-1 flex items-center">
                                    <i class="fa-regular fa-calendar-xmark mr-1"></i>Nghỉ ngày: ${lr.leaveDateFormatted}
                                </div>
                            </td>

                            <!-- Hình Thức & Trạng Thái -->
                            <td class="px-3.5 py-3 text-center whitespace-nowrap">
                                <div class="inline-flex flex-col items-center gap-1">
                                    ${lr.formOfWorkBadge}
                                    ${lr.statusBadge}
                                </div>
                            </td>

                            <!-- Lý Do Xin Nghỉ -->
                            <td class="px-4 py-3 text-slate-700 leading-snug text-xs">
                                ${lr.reason}
                            </td>

                            <!-- Kế Hoạch Bố Trí Cụ Thể -->
                            <td class="px-4 py-3 font-medium text-slate-800 leading-snug text-xs">
                                ${lr.planDetailText}
                            </td>

                            <!-- Phản Hồi Từ Phòng Đào Tạo -->
                            <td class="px-3.5 py-3 text-slate-600 text-[11px]">
                                <c:choose>
                                    <c:when test="${not empty lr.feedback}">
                                        <div class="text-slate-800 font-medium">${lr.feedback}</div>
                                        <div class="text-[10px] text-slate-400 mt-0.5">Người duyệt: ${lr.reviewedBy}</div>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-slate-400 italic">Đang chờ xem xét</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty myLeaveRequests}">
                        <tr>
                            <td colspan="6" class="px-4 py-8 text-center text-slate-400 italic">
                                Thầy/cô chưa gửi đơn xin báo nghỉ hoặc dạy bù nào.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- Modal Xin Nghỉ / Dạy Bù / Dạy Thay -->
<div id="leaveModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl max-w-lg w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
        <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
            <h3 class="font-bold text-slate-800 text-xs sm:text-sm flex items-center">
                <i class="fa-solid fa-envelope-open-text text-amber-600 mr-2 text-base"></i>Gửi Đơn Báo Nghỉ / Lịch Dạy Bù & Dạy Thay
            </h3>
            <button type="button" onclick="closeLeaveModal()" class="text-slate-400 hover:text-slate-600 p-1">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/lecturer/request-leave" method="POST" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
            <div class="p-3 bg-amber-50 border border-amber-200 rounded-xl text-[11px] text-amber-800 leading-relaxed">
                <i class="fa-solid fa-circle-info mr-1 text-amber-600"></i>
                Sau khi Phòng Đào tạo phê duyệt:
                <b>Dạy thay</b> sẽ hiển thị tên GV dạy thay trên TKB; <b>Dạy bù</b> sẽ được <b>tự động thêm ca học mới vào TKB</b> của thầy/cô và sinh viên.
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Chọn Ca Dạy Cần Báo Nghỉ (*)</label>
                <select name="scheduleId" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                    <c:forEach var="s" items="${schedules}">
                        <option value="${s.id}">[${s.dayOfWeekText} - ${s.periodText}] ${s.subjectName} (${s.room})</option>
                    </c:forEach>
                </select>
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Ngày Xin Nghỉ Cụ Thể (*)</label>
                <input type="date" name="leaveDate" required
                       class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue bg-white">
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Lý Do Báo Nghỉ (*)</label>
                <textarea name="reason" rows="2" required placeholder="Lý do công tác, việc cá nhân, hội thảo chuyên môn..."
                          class="w-full px-3.5 py-2 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue"></textarea>
            </div>

            <!-- Chọn Hình Thức: Dạy Bù vs Dạy Thay -->
            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Hình Thức Bố Trí (*)</label>
                <div class="grid grid-cols-2 gap-2">
                    <label class="flex items-center p-2.5 border border-slate-200 rounded-xl cursor-pointer hover:bg-slate-50 transition has-[:checked]:border-teal-500 has-[:checked]:bg-teal-50/50">
                        <input type="radio" name="leaveType" value="DAY_BU" checked onchange="toggleLeaveTypeFields()" class="text-teal-600 focus:ring-teal-500 mr-2">
                        <span class="text-xs font-bold text-slate-700 flex items-center">
                            <i class="fa-solid fa-calendar-plus text-teal-600 mr-1.5"></i>Dạy Bù
                        </span>
                    </label>
                    <label class="flex items-center p-2.5 border border-slate-200 rounded-xl cursor-pointer hover:bg-slate-50 transition has-[:checked]:border-purple-500 has-[:checked]:bg-purple-50/50">
                        <input type="radio" name="leaveType" value="DAY_THAY" onchange="toggleLeaveTypeFields()" class="text-purple-600 focus:ring-purple-500 mr-2">
                        <span class="text-xs font-bold text-slate-700 flex items-center">
                            <i class="fa-solid fa-user-clock text-purple-600 mr-1.5"></i>Dạy Thay
                        </span>
                    </label>
                </div>
            </div>

            <!-- Khối thông tin DẠY THAY -->
            <div id="substituteSection" class="hidden p-3.5 bg-purple-50/70 border border-purple-200 rounded-xl space-y-2">
                <label class="block text-xs font-bold text-purple-900 mb-1 flex items-center">
                    <i class="fa-solid fa-user-check text-purple-600 mr-1.5"></i>Chọn Giảng Viên Dạy Thay (*)
                </label>
                <select name="substituteLecturerId" id="substituteLecturerSelect" class="w-full px-3 py-2 rounded-xl border border-purple-300 text-xs focus:ring-2 focus:ring-purple-500 bg-white">
                    <option value="">-- Chọn đồng nghiệp dạy thay --</option>
                    <c:forEach var="gv" items="${lecturers}">
                        <c:if test="${gv.lecturerId != sessionScope.currentLecturer.lecturerId}">
                            <option value="${gv.lecturerId}">${gv.academicRank} ${gv.fullName} (${gv.facultyName})</option>
                        </c:if>
                    </c:forEach>
                </select>
                <p class="text-[11px] text-purple-700 italic">Sau khi duyệt, ca học này sẽ tự động hiển thị trên lịch giảng dạy của giảng viên dạy thay.</p>
            </div>

            <!-- Khối thông tin DẠY BÙ -->
            <div id="makeupSection" class="p-3.5 bg-teal-50/70 border border-teal-200 rounded-xl space-y-3">
                <p class="text-xs font-bold text-teal-900 flex items-center">
                    <i class="fa-solid fa-calendar-check text-teal-600 mr-1.5"></i>Kế Hoạch Dạy Bù Đề Xuất
                </p>

                <div>
                    <label class="block text-[11px] font-semibold text-slate-600 mb-1">Ngày Bù (*)</label>
                    <input type="date" name="makeupDate" id="makeupDateInput"
                           class="w-full px-3 py-2 rounded-xl border border-teal-300 text-xs focus:ring-2 focus:ring-teal-500 bg-white">
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-3 gap-2">
                    <div>
                        <label class="block text-[11px] font-semibold text-slate-600 mb-1">Tiết Bắt Đầu</label>
                        <select name="makeupStartPeriod" class="w-full px-2.5 py-2 rounded-xl border border-teal-300 text-xs bg-white">
                            <option value="1">Tiết 1 (07:00)</option>
                            <option value="2">Tiết 2 (07:50)</option>
                            <option value="3">Tiết 3 (08:40)</option>
                            <option value="4">Tiết 4 (09:35)</option>
                            <option value="5">Tiết 5 (10:25)</option>
                            <option value="7" selected>Tiết 7 (13:00)</option>
                            <option value="8">Tiết 8 (13:50)</option>
                            <option value="9">Tiết 9 (14:40)</option>
                            <option value="10">Tiết 10 (15:35)</option>
                        </select>
                    </div>

                    <div>
                        <label class="block text-[11px] font-semibold text-slate-600 mb-1">Số Tiết</label>
                        <select name="makeupPeriodCount" class="w-full px-2.5 py-2 rounded-xl border border-teal-300 text-xs bg-white">
                            <option value="2">2 tiết</option>
                            <option value="3" selected>3 tiết</option>
                            <option value="4">4 tiết</option>
                        </select>
                    </div>

                    <div>
                        <label class="block text-[11px] font-semibold text-slate-600 mb-1">Phòng Học Bù</label>
                        <input type="text" name="makeupRoom" placeholder="P.201-A1"
                               class="w-full px-2.5 py-2 rounded-xl border border-teal-300 text-xs uppercase bg-white font-mono">
                    </div>
                </div>
                <p class="text-[11px] text-teal-800 italic">Khi Phòng Đào tạo duyệt, hệ thống sẽ tự động xếp ca học bù này lên Thời khóa biểu của cả thầy/cô và sinh viên.</p>
            </div>

            <div class="flex flex-wrap items-center justify-end gap-2 pt-3 border-t border-slate-200">
                <button type="button" onclick="closeLeaveModal()"
                        class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-xs font-semibold text-slate-600 hover:bg-slate-50 transition text-center">
                    Hủy bỏ
                </button>
                <button type="submit"
                        class="flex-1 sm:flex-initial px-5 py-2 bg-amber-600 hover:bg-amber-700 text-white rounded-xl text-xs font-bold shadow-xs transition text-center">
                    Gửi Đơn Cho Phòng Đào Tạo
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openLeaveModal() { 
        document.getElementById('leaveModal').classList.remove('hidden'); 
        toggleLeaveTypeFields();
    }
    function closeLeaveModal() { 
        document.getElementById('leaveModal').classList.add('hidden'); 
    }

    function toggleLeaveTypeFields() {
        var selectedType = document.querySelector('input[name="leaveType"]:checked').value;
        var subSec = document.getElementById('substituteSection');
        var makeSec = document.getElementById('makeupSection');
        var subSelect = document.getElementById('substituteLecturerSelect');
        var makeupDateInput = document.getElementById('makeupDateInput');

        if (selectedType === 'DAY_THAY') {
            subSec.classList.remove('hidden');
            makeSec.classList.add('hidden');
            subSelect.required = true;
            makeupDateInput.required = false;
        } else if (selectedType === 'DAY_BU') {
            subSec.classList.add('hidden');
            makeSec.classList.remove('hidden');
            subSelect.required = false;
            makeupDateInput.required = true;
        } else {
            subSec.classList.add('hidden');
            makeSec.classList.add('hidden');
            subSelect.required = false;
            makeupDateInput.required = false;
        }
    }

    function filterLecturerScheduleByDay(day, btn) {
        document.querySelectorAll('.lec-day-filter-btn').forEach(b => {
            b.className = 'lec-day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition';
        });
        btn.className = 'lec-day-filter-btn px-2.5 py-1 rounded-lg font-bold text-xs bg-utc-blue text-white shadow-xs transition';

        const rows = document.querySelectorAll('.lec-schedule-row');
        let visibleCount = 0;
        rows.forEach(r => {
            if (day === 'all' || r.getAttribute('data-day') === day) {
                r.style.display = '';
                visibleCount++;
            } else {
                r.style.display = 'none';
            }
        });

        const emptyRow = document.getElementById('lecFilterEmptyRow');
        if (emptyRow) {
            emptyRow.style.display = visibleCount === 0 ? '' : 'none';
        }
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
