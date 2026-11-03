<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Quản Lý Lịch Học & Lịch Thi" />
<c:set var="activeMenu" value="schedules" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Header & Action -->
    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
            <h1 class="text-xl font-bold text-slate-800 flex items-center">
                <i class="fa-solid fa-calendar-days text-indigo-600 mr-2.5"></i>Thời Khóa Biểu & Quản Lý Lịch Học / Lịch Thi
            </h1>
            <p class="text-xs text-slate-500 mt-1">Xếp phòng học, ca học cho lớp học phần, phân công giảng viên và phê duyệt đơn báo nghỉ / dạy bù</p>
        </div>

        <div class="flex flex-wrap items-center gap-2 w-full md:w-auto">
            <c:choose>
                <c:when test="${currentTab == 'leaves'}">
                    <!-- Filter for Leave Requests -->
                    <form action="${pageContext.request.contextPath}/admin/schedules" method="GET" class="w-full sm:w-auto">
                        <input type="hidden" name="tab" value="leaves">
                        <select name="leaveStatus" onchange="this.form.submit()" 
                                class="w-full sm:w-auto px-3 py-2 rounded-xl border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-utc-blue bg-slate-50">
                            <option value="">Tất cả trạng thái đơn</option>
                            <option value="PENDING" ${leaveStatus == 'PENDING' ? 'selected' : ''}>Chờ duyệt (PENDING)</option>
                            <option value="APPROVED" ${leaveStatus == 'APPROVED' ? 'selected' : ''}>Đã duyệt (APPROVED)</option>
                            <option value="REJECTED" ${leaveStatus == 'REJECTED' ? 'selected' : ''}>Từ chối (REJECTED)</option>
                        </select>
                    </form>
                </c:when>
                <c:otherwise>
                    <!-- Filter for Schedules -->
                    <form action="${pageContext.request.contextPath}/admin/schedules" method="GET" class="flex flex-wrap items-center gap-2 w-full sm:w-auto flex-1">
                        <input type="hidden" name="tab" value="schedules">
                        <select name="semesterId" onchange="this.form.submit()" 
                                class="flex-1 sm:flex-initial w-full sm:w-auto px-3 py-2 rounded-xl border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-utc-blue bg-slate-50">
                            <option value="">Tất cả học kỳ</option>
                            <c:forEach var="sem" items="${semesters}">
                                <option value="${sem.semesterId}" ${selectedSemester == sem.semesterId ? 'selected' : ''}>
                                    ${sem.displayName}
                                </option>
                            </c:forEach>
                        </select>

                        <select name="dayOfWeek" onchange="this.form.submit()" 
                                class="flex-1 sm:flex-initial w-full sm:w-auto px-3 py-2 rounded-xl border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-utc-blue bg-slate-50">
                            <option value="">Tất cả các thứ</option>
                            <option value="2" ${selectedDay == 2 ? 'selected' : ''}>Thứ Hai</option>
                            <option value="3" ${selectedDay == 3 ? 'selected' : ''}>Thứ Ba</option>
                            <option value="4" ${selectedDay == 4 ? 'selected' : ''}>Thứ Tư</option>
                            <option value="5" ${selectedDay == 5 ? 'selected' : ''}>Thứ Năm</option>
                            <option value="6" ${selectedDay == 6 ? 'selected' : ''}>Thứ Sáu</option>
                            <option value="7" ${selectedDay == 7 ? 'selected' : ''}>Thứ Bảy</option>
                            <option value="8" ${selectedDay == 8 ? 'selected' : ''}>Chủ Nhật</option>
                        </select>
                    </form>

                    <button type="button" onclick="openAddScheduleModal()"
                            class="w-full sm:w-auto px-4 py-2 bg-utc-blue hover:bg-utc-dark text-white rounded-xl text-xs font-bold shadow-xs flex items-center justify-center space-x-1.5 transition">
                        <i class="fa-solid fa-plus"></i>
                        <span>Xếp Lịch Mới</span>
                    </button>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Navigation Tabs (Tách biệt: Thời Khóa Biểu & Duyệt Đơn Báo Nghỉ) -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm p-1.5 flex items-center gap-2 overflow-x-auto whitespace-nowrap scrollbar-none">
        <a href="${pageContext.request.contextPath}/admin/schedules?tab=schedules"
           class="flex-1 sm:flex-initial px-4 py-2 rounded-lg text-xs font-bold transition flex items-center justify-center space-x-2 ${currentTab != 'leaves' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-600 hover:bg-slate-100'}">
            <i class="fa-solid fa-calendar-days"></i>
            <span>Thời Khóa Biểu Giảng Dạy (${schedules.size()} ca)</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/schedules?tab=leaves"
           class="flex-1 sm:flex-initial px-4 py-2 rounded-lg text-xs font-bold transition flex items-center justify-center space-x-2 relative ${currentTab == 'leaves' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-600 hover:bg-slate-100'}">
            <i class="fa-solid fa-envelope-open-text text-amber-500"></i>
            <span>Duyệt Đơn Báo Nghỉ & Dạy Bù</span>
            <c:if test="${pendingLeavesCount > 0}">
                <span class="px-2 py-0.5 rounded-full text-[10px] font-extrabold bg-rose-500 text-white animate-pulse ml-1">
                    ${pendingLeavesCount} mới
                </span>
            </c:if>
        </a>
    </div>

    <!-- Alert Messages (Cảnh Báo Xung Đột Trùng Lịch / Thành Công) -->
    <c:if test="${not empty param.error}">
        <div class="p-4 bg-rose-50 border-2 border-rose-400 rounded-xl text-xs text-rose-800 font-bold flex items-start shadow-sm">
            <i class="fa-solid fa-triangle-exclamation text-rose-600 text-lg mr-2.5 mt-0.5"></i>
            <div>
                <p class="uppercase text-[11px] tracking-wide text-rose-700 font-extrabold mb-0.5">Phát hiện xung đột tài nguyên đào tạo!</p>
                <p class="font-medium text-rose-900">${param.error}</p>
            </div>
        </div>
    </c:if>

    <c:if test="${param.msg == 'schedule_added'}">
        <div class="p-4 bg-emerald-50 border border-emerald-200 rounded-xl text-xs text-emerald-800 font-medium flex items-center">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base mr-2"></i>
            Đã thêm ca học / ca thi mới thành công vào thời khóa biểu!
        </div>
    </c:if>
    <c:if test="${param.msg == 'schedule_updated'}">
        <div class="p-4 bg-emerald-50 border border-emerald-200 rounded-xl text-xs text-emerald-800 font-medium flex items-center">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base mr-2"></i>
            Đã cập nhật lịch học / ca thi thành công!
        </div>
    </c:if>
    <c:if test="${param.msg == 'schedule_deleted'}">
        <div class="p-4 bg-emerald-50 border border-emerald-200 rounded-xl text-xs text-emerald-800 font-medium flex items-center">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base mr-2"></i>
            Đã xóa ca học khỏi thời khóa biểu thành công!
        </div>
    </c:if>
    <c:if test="${param.msg == 'leave_approved'}">
        <div class="p-4 bg-emerald-50 border border-emerald-200 rounded-xl text-xs text-emerald-800 font-medium flex items-center">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base mr-2"></i>
            Đã phê duyệt đơn xin báo nghỉ & kế hoạch dạy bù của giảng viên thành công!
        </div>
    </c:if>
    <c:if test="${param.msg == 'leave_rejected'}">
        <div class="p-4 bg-rose-50 border border-rose-200 rounded-xl text-xs text-rose-800 font-medium flex items-center">
            <i class="fa-solid fa-circle-xmark text-rose-600 text-base mr-2"></i>
            Đã từ chối đơn xin báo nghỉ của giảng viên!
        </div>
    </c:if>

    <c:choose>
        <%-- ========================================================= --%>
        <%-- TAB 2: DUYỆT ĐƠN BÁO NGHỈ & DẠY BÙ CỦA GIẢNG VIÊN         --%>
        <%-- ========================================================= --%>
        <c:when test="${currentTab == 'leaves'}">
            <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
                <div class="p-4 border-b border-slate-200 bg-slate-50 flex items-center justify-between">
                    <h2 class="text-xs font-bold uppercase tracking-wider text-slate-700 flex items-center">
                        <i class="fa-solid fa-inbox text-amber-500 mr-2"></i>
                        Danh Sách Đơn Xin Báo Nghỉ & Kế Hoạch Dạy Bù (${leaveRequests.size()} đơn)
                    </h2>
                    <span class="text-[11px] text-slate-500">
                        <i class="fa-solid fa-circle-info text-utc-blue mr-1"></i>
                        Phê duyệt hoặc từ chối đơn xin nghỉ để cập nhật thông báo cho sinh viên của lớp học phần.
                    </span>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full text-left text-xs text-slate-600">
                        <thead class="bg-slate-50/80 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                            <tr>
                                <th class="px-3 py-3.5 text-center whitespace-nowrap w-10">STT</th>
                                <th class="px-3.5 py-3.5 whitespace-nowrap">Giảng Viên</th>
                                <th class="px-3.5 py-3.5">Ca Dạy & Ngày Nghỉ</th>
                                <th class="px-3.5 py-3.5 text-center whitespace-nowrap">Hình Thức & Trạng Thái</th>
                                <th class="px-4 py-3.5">Lý Do & Kế Hoạch Bố Trí</th>
                                <th class="px-3.5 py-3.5">Phản Hồi Đào Tạo</th>
                                <th class="px-3.5 py-3.5 text-center whitespace-nowrap">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-200">
                            <c:forEach var="lr" items="${leaveRequests}" varStatus="loop">
                                <tr class="hover:bg-slate-50/80 transition">
                                    <td class="px-3 py-3 text-center text-slate-400 font-medium">${loop.index + 1}</td>
                                    
                                    <!-- Giảng Viên -->
                                    <td class="px-3.5 py-3 whitespace-nowrap">
                                        <div class="font-bold text-slate-800">${lr.academicRank} ${lr.lecturerName}</div>
                                        <div class="text-[10px] text-slate-400 font-mono mt-0.5">${lr.lecturerId} | ${lr.facultyName}</div>
                                    </td>

                                    <!-- Ca Dạy & Ngày Nghỉ -->
                                    <td class="px-3.5 py-3">
                                        <div class="font-bold text-utc-blue leading-snug">${lr.subjectName}</div>
                                        <div class="text-[11px] text-slate-600 font-medium mt-0.5">${lr.scheduleInfo}</div>
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

                                    <!-- Lý Do & Kế Hoạch Bố Trí -->
                                    <td class="px-4 py-3 text-xs">
                                        <div class="text-slate-700 leading-snug"><span class="font-semibold text-slate-500">Lý do:</span> ${lr.reason}</div>
                                        <div class="mt-1 font-medium text-slate-800 bg-slate-50 p-1.5 rounded-lg border border-slate-200 leading-snug">
                                            <span class="text-slate-500 font-semibold">Kế hoạch:</span> ${lr.planDetailText}
                                        </div>
                                    </td>

                                    <!-- Phản Hồi Đào Tạo -->
                                    <td class="px-3.5 py-3 text-slate-600 text-[11px]">
                                        <c:choose>
                                            <c:when test="${not empty lr.feedback}">
                                                <div class="text-slate-800 font-medium">${lr.feedback}</div>
                                                <div class="text-[10px] text-slate-400 mt-0.5">Duyệt bởi: ${lr.reviewedBy}</div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-slate-400 italic">Chưa phản hồi</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- Thao Tác -->
                                    <td class="px-3.5 py-3 text-center whitespace-nowrap">
                                        <c:choose>
                                            <c:when test="${lr.status == 'PENDING'}">
                                                <div class="flex items-center justify-center space-x-1.5">
                                                    <button type="button" 
                                                            onclick="openApproveLeaveModal('${lr.id}', '${lr.lecturerName}', '${lr.subjectName}', '${lr.leaveDateFormatted}', '${lr.planDetailText}')"
                                                            class="px-2.5 py-1.5 rounded-lg bg-emerald-50 text-emerald-700 hover:bg-emerald-100 font-semibold text-[11px] transition inline-flex items-center shadow-2xs">
                                                        <i class="fa-solid fa-check mr-1"></i>Duyệt
                                                    </button>
                                                    <button type="button" 
                                                            onclick="openRejectLeaveModal('${lr.id}', '${lr.lecturerName}')"
                                                            class="px-2.5 py-1.5 rounded-lg bg-rose-50 text-rose-700 hover:bg-rose-100 font-semibold text-[11px] transition inline-flex items-center shadow-2xs">
                                                        <i class="fa-solid fa-xmark mr-1"></i>Từ chối
                                                    </button>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-[11px] text-slate-400 font-semibold">Đã đóng</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty leaveRequests}">
                                <tr>
                                    <td colspan="7" class="px-4 py-10 text-center text-slate-400 italic">
                                        Không có đơn xin báo nghỉ hoặc dạy bù nào trong danh sách.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:when>

        <%-- ========================================================= --%>
        <%-- TAB 1: THỜI KHÓA BIỂU CÁC LỚP HỌC PHẦN                    --%>
        <%-- ========================================================= --%>
        <c:otherwise>
            <!-- Schedule Table -->
            <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
                <!-- Thanh Lọc Nhanh Theo Thứ (Instant Day Filter) -->
                <div class="px-4 py-2.5 bg-slate-50 border-b border-slate-200 flex flex-wrap items-center gap-1.5 text-xs">
                    <span class="text-slate-400 font-semibold mr-1 text-[11px] uppercase tracking-wider flex items-center">
                        <i class="fa-solid fa-filter mr-1 text-slate-400"></i>Lọc theo thứ:
                    </span>
                    <button type="button" onclick="filterAdminScheduleByDay('all', this)" class="adm-day-filter-btn px-2.5 py-1 rounded-lg font-bold text-xs bg-utc-blue text-white shadow-xs transition">Tất cả</button>
                    <button type="button" onclick="filterAdminScheduleByDay('2', this)" class="adm-day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 2</button>
                    <button type="button" onclick="filterAdminScheduleByDay('3', this)" class="adm-day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 3</button>
                    <button type="button" onclick="filterAdminScheduleByDay('4', this)" class="adm-day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 4</button>
                    <button type="button" onclick="filterAdminScheduleByDay('5', this)" class="adm-day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 5</button>
                    <button type="button" onclick="filterAdminScheduleByDay('6', this)" class="adm-day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 6</button>
                    <button type="button" onclick="filterAdminScheduleByDay('7', this)" class="adm-day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Thứ 7</button>
                    <button type="button" onclick="filterAdminScheduleByDay('8', this)" class="adm-day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition">Chủ Nhật</button>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full text-left text-xs text-slate-600">
                        <thead class="bg-slate-50 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                            <tr>
                                <th class="px-3 py-3.5 text-center whitespace-nowrap w-10">STT</th>
                                <th class="px-3.5 py-3.5 whitespace-nowrap">Thời Gian & Ca Học</th>
                                <th class="px-4 py-3.5">Học Phần & Lớp Học</th>
                                <th class="px-3 py-3.5 text-center whitespace-nowrap">Phòng Học</th>
                                <th class="px-3.5 py-3.5 whitespace-nowrap">Giảng Viên Phụ Trách</th>
                                <th class="px-3.5 py-3.5 text-center whitespace-nowrap">Phân Loại & Trạng Thái</th>
                                <th class="px-3.5 py-3.5">Ghi Chú</th>
                                <th class="px-3.5 py-3.5 text-center whitespace-nowrap">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-200">
                            <c:forEach var="s" items="${schedules}" varStatus="loop">
                                <tr class="adm-schedule-row hover:bg-slate-50/80 transition" data-day="${s.dayOfWeek}">
                                    <td class="px-3 py-3 text-center text-slate-400 font-medium">${loop.index + 1}</td>
                                    
                                    <!-- Thời Gian & Ca Học -->
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

                                    <!-- Học Phần & Lớp -->
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

                                    <!-- Giảng Viên Phụ Trách -->
                                    <td class="px-3.5 py-3 whitespace-nowrap">
                                        <div class="flex items-center font-medium text-slate-800">
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
                                    <td class="px-3.5 py-3 text-slate-400 italic text-[11px] max-w-[140px] truncate" title="${s.note != null ? s.note : ''}">
                                        ${s.note != null && !s.note.isEmpty() ? s.note : '-'}
                                    </td>

                                    <!-- Thao Tác -->
                                    <td class="px-3.5 py-3 text-center space-x-1.5 whitespace-nowrap">
                                        <button type="button" 
                                                onclick="openEditScheduleModal('${s.id}', '${s.courseClassId}', '${s.dayOfWeek}', '${s.startPeriod}', '${s.periodCount}', '${s.room}', '${s.lecturerId}', '${s.scheduleType}', '${s.note}')"
                                                class="px-2.5 py-1.5 rounded-lg bg-amber-50 text-amber-700 hover:bg-amber-100 font-semibold text-[11px] transition inline-flex items-center shadow-2xs">
                                            <i class="fa-solid fa-pen-to-square mr-1"></i>Sửa
                                        </button>
                                        <form action="${pageContext.request.contextPath}/admin/schedules" method="POST" class="inline"
                                              onsubmit="return confirm('Bạn có chắc chắn muốn xóa ca học này khỏi thời khóa biểu?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${s.id}">
                                            <button type="submit" 
                                                    class="px-2.5 py-1.5 rounded-lg bg-slate-100 text-slate-600 hover:bg-rose-100 hover:text-rose-700 font-semibold text-[11px] transition inline-flex items-center shadow-2xs">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <tr id="admFilterEmptyRow" style="display: none;">
                                <td colspan="8" class="px-4 py-8 text-center text-slate-400 text-xs italic">
                                    Không có ca học nào trong ngày đã chọn.
                                </td>
                            </tr>
                            <c:if test="${empty schedules}">
                                <tr>
                                    <td colspan="8" class="px-4 py-8 text-center text-slate-400 text-xs italic">
                                        Chưa có ca học hoặc lịch thi nào được xếp cho tiêu chí lọc này.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<!-- Modal Phê Duyệt Đơn Báo Nghỉ & Dạy Bù -->
<div id="approveLeaveModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl max-w-md w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
        <div class="p-4 sm:p-5 bg-emerald-50 border-b border-emerald-100 flex items-center justify-between flex-shrink-0">
            <h3 class="font-bold text-emerald-900 text-xs sm:text-sm flex items-center">
                <i class="fa-solid fa-clipboard-check text-emerald-600 mr-2 text-base"></i>Phê Duyệt Đơn Báo Nghỉ & Kế Hoạch Bù / Dạy Thay
            </h3>
            <button type="button" onclick="closeApproveLeaveModal()" class="text-slate-400 hover:text-slate-600 p-1">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/schedules" method="POST" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
            <input type="hidden" name="action" value="approve_leave">
            <input type="hidden" name="requestId" id="approve_requestId">

            <div class="p-3 bg-slate-50 border border-slate-200 rounded-xl text-xs space-y-1.5">
                <div><span class="text-slate-500">Giảng viên:</span> <b class="text-slate-800" id="approve_lecturerName"></b></div>
                <div><span class="text-slate-500">Môn học:</span> <b class="text-slate-800" id="approve_subjectName"></b></div>
                <div><span class="text-slate-500">Ngày nghỉ:</span> <b class="text-rose-600" id="approve_leaveDate"></b></div>
                <div><span class="text-slate-500">Phương án:</span> <b class="text-emerald-700" id="approve_makeupSchedule"></b></div>
            </div>

            <div class="p-3 bg-emerald-50 border border-emerald-200 rounded-xl text-[11px] text-emerald-800 leading-relaxed">
                <i class="fa-solid fa-magic mr-1 text-emerald-600"></i>
                <b>Lưu ý tự động hóa:</b> Nếu đơn có hình thức <b>Dạy bù</b>, hệ thống sẽ <b>tự động thêm ca học bù mới vào Thời khóa biểu</b> để GV và SV đều xem được.
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Ý Kiến Phê Duyệt / Ghi Chú Phản Hồi</label>
                <textarea name="feedback" rows="2" placeholder="Ví dụ: Đồng ý với kế hoạch dạy bù của giảng viên..."
                          class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500">Đồng ý phê duyệt theo đề xuất của giảng viên</textarea>
            </div>

            <div class="flex flex-wrap items-center justify-end gap-2 pt-3 border-t border-slate-200">
                <button type="button" onclick="closeApproveLeaveModal()"
                        class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-xs font-semibold text-slate-600 hover:bg-slate-50 transition text-center">
                    Hủy bỏ
                </button>
                <button type="submit"
                        class="flex-1 sm:flex-initial px-5 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold shadow-xs transition flex items-center justify-center space-x-1.5">
                    <i class="fa-solid fa-check"></i>
                    <span>Xác Nhận Phê Duyệt</span>
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Từ Chối Đơn Báo Nghỉ -->
<div id="rejectLeaveModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl max-w-md w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
        <div class="p-4 sm:p-5 bg-rose-50 border-b border-rose-100 flex items-center justify-between flex-shrink-0">
            <h3 class="font-bold text-rose-900 text-xs sm:text-sm flex items-center">
                <i class="fa-solid fa-triangle-exclamation text-rose-600 mr-2 text-base"></i>Từ Chối Đơn Báo Nghỉ
            </h3>
            <button type="button" onclick="closeRejectLeaveModal()" class="text-slate-400 hover:text-slate-600 p-1">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/schedules" method="POST" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
            <input type="hidden" name="action" value="reject_leave">
            <input type="hidden" name="requestId" id="reject_requestId">

            <div class="p-3 bg-rose-50/50 border border-rose-200 rounded-xl text-xs">
                Từ chối đơn xin nghỉ của giảng viên: <b class="text-slate-800" id="reject_lecturerName"></b>.
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Lý Do Từ Chối (*)</label>
                <textarea name="feedback" rows="3" required placeholder="Nêu rõ lý do không duyệt (ví dụ: Trùng lịch thi, không đủ phòng học bù...)"
                          class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-rose-500"></textarea>
            </div>

            <div class="flex flex-wrap items-center justify-end gap-2 pt-3 border-t border-slate-200">
                <button type="button" onclick="closeRejectLeaveModal()"
                        class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-xs font-semibold text-slate-600 hover:bg-slate-50 transition text-center">
                    Hủy bỏ
                </button>
                <button type="submit"
                        class="flex-1 sm:flex-initial px-5 py-2 bg-rose-600 hover:bg-rose-700 text-white rounded-xl text-xs font-bold shadow-xs transition flex items-center justify-center space-x-1.5">
                    <i class="fa-solid fa-ban"></i>
                    <span>Xác Nhận Từ Chối</span>
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Xếp Lịch Mới -->
<div id="addScheduleModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl max-w-lg w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
        <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
            <h3 class="font-bold text-slate-800 text-xs sm:text-sm flex items-center">
                <i class="fa-solid fa-calendar-plus text-utc-blue mr-2 text-base"></i>Xếp Lịch Học / Ca Thi Mới
            </h3>
            <button type="button" onclick="closeAddScheduleModal()" class="text-slate-400 hover:text-slate-600 p-1">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/schedules" method="POST" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
            <input type="hidden" name="action" value="add">

            <div class="p-3 bg-blue-50 border border-blue-200 rounded-xl text-[11px] text-blue-800 leading-relaxed">
                <i class="fa-solid fa-shield-halved mr-1 text-utc-blue"></i>
                Hệ thống tự động phát hiện và <b>cảnh báo đỏ</b> nếu ca học bị <b>trùng phòng</b> hoặc <b>trùng giảng viên</b> vào cùng một khung giờ.
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Lớp Học Phần (*)</label>
                <select name="courseClassId" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                    <c:forEach var="c" items="${classes}">
                        <option value="${c.classId}">[${c.classId}] ${c.className} (${c.subjectName})</option>
                    </c:forEach>
                </select>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Thứ (*)</label>
                    <select name="dayOfWeek" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                        <option value="2">Thứ Hai</option>
                        <option value="3">Thứ Ba</option>
                        <option value="4">Thứ Tư</option>
                        <option value="5">Thứ Năm</option>
                        <option value="6">Thứ Sáu</option>
                        <option value="7">Thứ Bảy</option>
                        <option value="8">Chủ Nhật</option>
                    </select>
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Tiết Bắt Đầu (*)</label>
                    <input type="number" name="startPeriod" min="1" max="12" value="1" required
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Số Tiết (*)</label>
                    <input type="number" name="periodCount" min="1" max="6" value="3" required
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Phòng Học (*)</label>
                    <input type="text" name="room" required placeholder="Ví dụ: A8-301, LAB-201..."
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs font-mono uppercase focus:ring-2 focus:ring-utc-blue">
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Loại Lịch</label>
                    <select name="scheduleType" class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                        <option value="LY_THUYET">Lý Thuyết</option>
                        <option value="THUC_HANH">Thực Hành</option>
                        <option value="THI">Lịch Thi</option>
                    </select>
                </div>
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Giảng Viên Phụ Trách (*)</label>
                <select name="lecturerId" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                    <c:forEach var="gv" items="${lecturers}">
                        <option value="${gv.lecturerId}">${gv.academicRank} ${gv.fullName} (${gv.facultyName})</option>
                    </c:forEach>
                </select>
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Ghi Chú</label>
                <input type="text" name="note" placeholder="Nội dung bài học, phòng thi..."
                       class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
            </div>

            <div class="flex flex-wrap items-center justify-end gap-2 pt-3 border-t border-slate-200">
                <button type="button" onclick="closeAddScheduleModal()"
                        class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-xs font-semibold text-slate-600 hover:bg-slate-50 transition text-center">
                    Hủy bỏ
                </button>
                <button type="submit"
                        class="flex-1 sm:flex-initial px-5 py-2 bg-utc-blue hover:bg-utc-dark text-white rounded-xl text-xs font-bold shadow-xs transition text-center">
                    Xác Nhận Xếp Lịch
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Sửa Lịch -->
<div id="editScheduleModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl max-w-lg w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
        <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
            <h3 class="font-bold text-slate-800 text-xs sm:text-sm flex items-center">
                <i class="fa-solid fa-pen-to-square text-amber-600 mr-2 text-base"></i>Cập Nhật Lịch Học / Ca Thi
            </h3>
            <button type="button" onclick="closeEditScheduleModal()" class="text-slate-400 hover:text-slate-600 p-1">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/schedules" method="POST" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="id" id="edit_id">

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Lớp Học Phần (*)</label>
                <select name="courseClassId" id="edit_courseClassId" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                    <c:forEach var="c" items="${classes}">
                        <option value="${c.classId}">[${c.classId}] ${c.className}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Thứ (*)</label>
                    <select name="dayOfWeek" id="edit_dayOfWeek" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                        <option value="2">Thứ Hai</option>
                        <option value="3">Thứ Ba</option>
                        <option value="4">Thứ Tư</option>
                        <option value="5">Thứ Năm</option>
                        <option value="6">Thứ Sáu</option>
                        <option value="7">Thứ Bảy</option>
                        <option value="8">Chủ Nhật</option>
                    </select>
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Tiết Bắt Đầu (*)</label>
                    <input type="number" name="startPeriod" id="edit_startPeriod" min="1" max="12" required
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Số Tiết (*)</label>
                    <input type="number" name="periodCount" id="edit_periodCount" min="1" max="6" required
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Phòng Học (*)</label>
                    <input type="text" name="room" id="edit_room" required
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs font-mono uppercase focus:ring-2 focus:ring-utc-blue">
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Loại Lịch</label>
                    <select name="scheduleType" id="edit_scheduleType" class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                        <option value="LY_THUYET">Lý Thuyết</option>
                        <option value="THUC_HANH">Thực Hành</option>
                        <option value="THI">Lịch Thi</option>
                    </select>
                </div>
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Giảng Viên Phụ Trách (*)</label>
                <select name="lecturerId" id="edit_lecturerId" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                    <c:forEach var="gv" items="${lecturers}">
                        <option value="${gv.lecturerId}">${gv.academicRank} ${gv.fullName}</option>
                    </c:forEach>
                </select>
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Ghi Chú</label>
                <input type="text" name="note" id="edit_note"
                       class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
            </div>

            <div class="flex flex-wrap items-center justify-end gap-2 pt-3 border-t border-slate-200">
                <button type="button" onclick="closeEditScheduleModal()"
                        class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-xs font-semibold text-slate-600 hover:bg-slate-50 transition text-center">
                    Hủy bỏ
                </button>
                <button type="submit"
                        class="flex-1 sm:flex-initial px-5 py-2 bg-amber-600 hover:bg-amber-700 text-white rounded-xl text-xs font-bold shadow-xs transition text-center">
                    Lưu Thay Đổi
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openAddScheduleModal() { document.getElementById('addScheduleModal').classList.remove('hidden'); }
    function closeAddScheduleModal() { document.getElementById('addScheduleModal').classList.add('hidden'); }
    
    function openEditScheduleModal(id, classId, day, start, count, room, lecturerId, type, note) {
        document.getElementById('edit_id').value = id;
        document.getElementById('edit_courseClassId').value = classId;
        document.getElementById('edit_dayOfWeek').value = day;
        document.getElementById('edit_startPeriod').value = start;
        document.getElementById('edit_periodCount').value = count;
        document.getElementById('edit_room').value = room;
        document.getElementById('edit_lecturerId').value = lecturerId;
        document.getElementById('edit_scheduleType').value = type;
        document.getElementById('edit_note').value = note ? note : '';
        document.getElementById('editScheduleModal').classList.remove('hidden');
    }
    function closeEditScheduleModal() { document.getElementById('editScheduleModal').classList.add('hidden'); }

    function openApproveLeaveModal(id, lecturer, subject, date, makeup) {
        document.getElementById('approve_requestId').value = id;
        document.getElementById('approve_lecturerName').textContent = lecturer;
        document.getElementById('approve_subjectName').textContent = subject;
        document.getElementById('approve_leaveDate').textContent = date;
        document.getElementById('approve_makeupSchedule').textContent = makeup ? makeup : 'Không có';
        document.getElementById('approveLeaveModal').classList.remove('hidden');
    }
    function closeApproveLeaveModal() { document.getElementById('approveLeaveModal').classList.add('hidden'); }

    function openRejectLeaveModal(id, lecturer) {
        document.getElementById('reject_requestId').value = id;
        document.getElementById('reject_lecturerName').textContent = lecturer;
        document.getElementById('rejectLeaveModal').classList.remove('hidden');
    }
    function closeRejectLeaveModal() { document.getElementById('rejectLeaveModal').classList.add('hidden'); }

    function filterAdminScheduleByDay(day, btn) {
        document.querySelectorAll('.adm-day-filter-btn').forEach(b => {
            b.className = 'adm-day-filter-btn px-2.5 py-1 rounded-lg font-medium text-xs bg-white text-slate-700 border border-slate-200 hover:bg-slate-100 transition';
        });
        btn.className = 'adm-day-filter-btn px-2.5 py-1 rounded-lg font-bold text-xs bg-utc-blue text-white shadow-xs transition';

        const rows = document.querySelectorAll('.adm-schedule-row');
        let visibleCount = 0;
        rows.forEach(r => {
            if (day === 'all' || r.getAttribute('data-day') === day) {
                r.style.display = '';
                visibleCount++;
            } else {
                r.style.display = 'none';
            }
        });

        const emptyRow = document.getElementById('admFilterEmptyRow');
        if (emptyRow) {
            emptyRow.style.display = visibleCount === 0 ? '' : 'none';
        }
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
