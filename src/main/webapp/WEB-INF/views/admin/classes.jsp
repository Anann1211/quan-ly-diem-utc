<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Quản Lý Lớp Học Phần" />
<c:set var="activeMenu" value="classes" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Header & Action -->
    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
            <h1 class="text-xl font-bold text-slate-800 flex items-center">
                <i class="fa-solid fa-chalkboard text-indigo-600 mr-2.5"></i>Danh Sách Lớp Học Phần & Phân Công Giảng Dạy
            </h1>
            <p class="text-xs text-slate-500 mt-1">Mở lớp học phần theo học kỳ, chỉ định giảng viên phụ trách chấm điểm và theo dõi trạng thái sổ điểm</p>
        </div>

        <div class="flex flex-wrap items-center gap-2 w-full md:w-auto">
            <!-- Semester filter -->
            <form action="${pageContext.request.contextPath}/admin/classes" method="GET" class="flex-1 sm:flex-initial">
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

            <button type="button" onclick="openAddClassModal()"
                    class="w-full sm:w-auto px-4 py-2 bg-utc-blue hover:bg-utc-dark text-white rounded-xl text-xs font-bold shadow-xs flex items-center justify-center space-x-1.5 transition">
                <i class="fa-solid fa-plus"></i>
                <span>Mở Lớp Học Phần</span>
            </button>
        </div>
    </div>

    <!-- Alert Messages -->
    <c:if test="${not empty param.msg}">
        <div class="p-3.5 bg-emerald-50 border border-emerald-200 text-emerald-700 rounded-xl text-xs font-semibold flex items-center">
            <i class="fa-solid fa-circle-check mr-2 text-sm text-emerald-500"></i>
            <c:choose>
                <c:when test="${param.msg == 'class_added'}">Mở lớp học phần mới thành công!</c:when>
                <c:when test="${param.msg == 'class_updated'}">Cập nhật thông tin lớp học phần thành công!</c:when>
                <c:when test="${param.msg == 'class_deleted'}">Đã xóa lớp học phần thành công!</c:when>
                <c:otherwise>Thao tác thực hiện thành công!</c:otherwise>
            </c:choose>
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="p-3.5 bg-rose-50 border border-rose-200 text-rose-700 rounded-xl text-xs font-semibold flex items-center">
            <i class="fa-solid fa-triangle-exclamation mr-2 text-sm text-rose-500"></i>
            <c:choose>
                <c:when test="${param.error == 'empty_fields'}">Vui lòng điền đầy đủ các thông tin bắt buộc!</c:when>
                <c:when test="${param.error == 'not_found'}">Không tìm thấy thông tin lớp học phần yêu cầu!</c:when>
                <c:when test="${param.error == 'class_published'}">Lớp học phần đã công bố điểm chính thức (PUBLISHED), không thể thực hiện thao tác!</c:when>
                <c:when test="${param.error == 'operation_failed'}">Thao tác thất bại! Không thể xóa lớp học phần vì đã có sinh viên hoặc đã có điểm số.</c:when>
                <c:otherwise>${param.error}</c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <!-- Classes Table -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs text-slate-600">
                <thead class="bg-slate-50 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                    <tr>
                        <th class="px-4 py-3.5">Mã Lớp HP</th>
                        <th class="px-4 py-3.5">Tên Lớp Học Phần</th>
                        <th class="px-4 py-3.5">Môn học</th>
                        <th class="px-4 py-3.5">Học kỳ</th>
                        <th class="px-4 py-3.5">Giảng viên giảng dạy</th>
                        <th class="px-4 py-3.5 text-center">Phòng học</th>
                        <th class="px-4 py-3.5 text-center">Sĩ số</th>
                        <th class="px-4 py-3.5 text-center whitespace-nowrap">Trạng thái điểm</th>
                        <th class="px-4 py-3.5 text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="c" items="${classes}">
                        <tr class="hover:bg-slate-50/80">
                            <td class="px-4 py-3 font-bold text-slate-800">${c.classId}</td>
                            <td class="px-4 py-3 font-medium text-slate-800">${c.className}</td>
                            <td class="px-4 py-3">
                                <div class="font-semibold text-utc-blue">${c.subjectName}</div>
                                <div class="text-[10px] text-slate-400">${c.subjectId} (${c.credits} TC)</div>
                            </td>
                            <td class="px-4 py-3 text-slate-600">${c.semesterName} (${c.academicYear})</td>
                            <td class="px-4 py-3 font-medium text-slate-700">
                                <i class="fa-solid fa-chalkboard-user mr-1 text-slate-400"></i>${c.lecturerName}
                            </td>
                            <td class="px-4 py-3 text-center text-slate-600">${c.room}</td>
                            <td class="px-4 py-3 text-center font-bold text-slate-800">${c.enrolledCount}</td>
                            <td class="px-4 py-3 text-center whitespace-nowrap">${c.statusBadge}</td>
                            <td class="px-4 py-3 text-center space-x-1.5 whitespace-nowrap">
                                <a href="${pageContext.request.contextPath}/admin/classes?action=students&classId=${c.classId}"
                                   class="px-2.5 py-1.5 rounded-lg bg-emerald-50 text-emerald-700 hover:bg-emerald-100 font-semibold text-[11px] transition inline-flex items-center"
                                   title="Danh sách sinh viên & Rút học phần">
                                    <i class="fa-solid fa-users mr-1"></i>DS Sinh viên
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/grade-approval?classId=${c.classId}"
                                   class="px-2.5 py-1.5 rounded-lg bg-blue-50 text-utc-blue hover:bg-blue-100 font-semibold text-[11px] transition inline-flex items-center">
                                    <i class="fa-solid fa-eye mr-1"></i>Xem điểm
                                </a>
                                <button type="button" 
                                        onclick="openEditCourseClassModal('${c.classId}', '${c.className}', '${c.subjectId}', '${c.semesterId}', '${c.lecturerId}', '${c.room}', '${c.enrolledCount}')"
                                        class="px-2.5 py-1.5 rounded-lg bg-amber-50 text-amber-700 hover:bg-amber-100 font-semibold text-[11px] transition inline-flex items-center">
                                    <i class="fa-solid fa-pen-to-square mr-1"></i>Sửa
                                </button>
                                <c:choose>
                                    <c:when test="${c.gradeStatus == 'PUBLISHED'}">
                                        <button type="button" disabled title="Không thể xóa lớp đã công bố điểm"
                                                class="px-2.5 py-1.5 rounded-lg bg-slate-100 text-slate-400 cursor-not-allowed font-semibold text-[11px] inline-flex items-center">
                                            <i class="fa-solid fa-lock"></i>
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/admin/classes" method="POST" class="inline"
                                              onsubmit="return confirm('CẢNH BÁO: Bạn có chắc muốn xóa lớp học phần ${c.classId}? Toàn bộ điểm nháp (nếu có) sẽ bị xóa kèm!');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="classId" value="${c.classId}">
                                            <button type="submit" title="Xóa lớp học phần"
                                                    class="px-2.5 py-1.5 rounded-lg bg-slate-100 text-slate-600 hover:bg-rose-100 hover:text-rose-700 font-semibold text-[11px] transition inline-flex items-center">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty classes}">
                        <tr>
                            <td colspan="9" class="px-4 py-10 text-center text-slate-400">Không tìm thấy lớp học phần nào.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- Modal Mở Lớp Học Phần -->
<div id="classModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl max-w-md w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
        <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
            <h3 class="font-bold text-slate-800 text-xs sm:text-sm flex items-center">
                <i class="fa-solid fa-plus text-utc-blue mr-2 text-base"></i>Mở Lớp Học Phần Mới
            </h3>
            <button type="button" onclick="closeAddClassModal()" class="text-slate-400 hover:text-slate-600 p-1">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/classes" method="POST" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
            <input type="hidden" name="action" value="add">

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Mã Lớp Học Phần</label>
                <input type="text" name="classId" required
                       class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue"
                       placeholder="Ví dụ: LHP_IT103_02">
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Tên Lớp Học Phần</label>
                <input type="text" name="className" required
                       class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue"
                       placeholder="Ví dụ: Lập trình Web - Nhóm 2">
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Môn học</label>
                <select name="subjectId" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                    <c:forEach var="s" items="${subjects}">
                        <option value="${s.subjectId}">${s.subjectId} - ${s.subjectName} (${s.credits} TC)</option>
                    </c:forEach>
                </select>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Học kỳ</label>
                    <select name="semesterId" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                        <c:forEach var="sem" items="${semesters}">
                            <option value="${sem.semesterId}">${sem.displayName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Phòng học</label>
                    <input type="text" name="room" value="A8-301" required
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue font-mono uppercase">
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Giảng viên phụ trách</label>
                    <select name="lecturerId" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                        <c:forEach var="gv" items="${lecturers}">
                            <option value="${gv.lecturerId}">${gv.academicRank} ${gv.fullName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Sĩ số dự kiến</label>
                    <input type="number" name="enrolledCount" min="1" max="150" value="40" required
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                </div>
            </div>

            <div class="flex flex-wrap items-center justify-end gap-2 pt-2 border-t border-slate-200">
                <button type="button" onclick="closeAddClassModal()"
                        class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-slate-700 text-xs font-semibold hover:bg-slate-100 transition text-center">
                    Hủy bỏ
                </button>
                <button type="submit"
                        class="flex-1 sm:flex-initial px-5 py-2 rounded-xl bg-utc-blue hover:bg-utc-dark text-white text-xs font-bold shadow-xs transition text-center">
                    Khởi Tạo Lớp
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Sửa Lớp Học Phần -->
<div id="editCourseClassModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl max-w-md w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
        <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
            <h3 class="font-bold text-slate-800 text-xs sm:text-sm flex items-center">
                <i class="fa-solid fa-pen-to-square text-amber-500 mr-2 text-base"></i>Cập Nhật Lớp Học Phần
            </h3>
            <button type="button" onclick="closeEditCourseClassModal()" class="text-slate-400 hover:text-slate-600 p-1">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/classes" method="POST" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
            <input type="hidden" name="action" value="edit">

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Mã Lớp Học Phần (Không đổi)</label>
                <input type="text" id="editLhpId" name="classId" readonly
                       class="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 bg-slate-100 text-slate-500 text-xs font-mono">
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Tên Lớp Học Phần (*)</label>
                <input type="text" id="editLhpName" name="className" required
                       class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Môn học</label>
                <select id="editLhpSubjectId" name="subjectId" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                    <c:forEach var="s" items="${subjects}">
                        <option value="${s.subjectId}">${s.subjectId} - ${s.subjectName} (${s.credits} TC)</option>
                    </c:forEach>
                </select>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Học kỳ</label>
                    <select id="editLhpSemesterId" name="semesterId" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                        <c:forEach var="sem" items="${semesters}">
                            <option value="${sem.semesterId}">${sem.displayName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Phòng học</label>
                    <input type="text" id="editLhpRoom" name="room" required
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue font-mono uppercase">
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Giảng viên phụ trách</label>
                    <select id="editLhpLecturerId" name="lecturerId" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                        <c:forEach var="gv" items="${lecturers}">
                            <option value="${gv.lecturerId}">${gv.academicRank} ${gv.fullName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Sĩ số</label>
                    <input type="number" id="editLhpEnrolledCount" name="enrolledCount" min="1" max="150" required
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                </div>
            </div>

            <div class="flex flex-wrap items-center justify-end gap-2 pt-2 border-t border-slate-200">
                <button type="button" onclick="closeEditCourseClassModal()"
                        class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-slate-700 text-xs font-semibold hover:bg-slate-100 transition text-center">
                    Hủy bỏ
                </button>
                <button type="submit"
                        class="flex-1 sm:flex-initial px-5 py-2 rounded-xl bg-amber-600 hover:bg-amber-700 text-white text-xs font-bold shadow-xs transition text-center">
                    Lưu Thay Đổi
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openAddClassModal() {
        document.getElementById('classModal').classList.remove('hidden');
    }
    function closeAddClassModal() {
        document.getElementById('classModal').classList.add('hidden');
    }
    function openEditCourseClassModal(id, name, subjectId, semesterId, lecturerId, room, enrolled) {
        document.getElementById('editLhpId').value = id;
        document.getElementById('editLhpName').value = name;
        document.getElementById('editLhpSubjectId').value = subjectId;
        document.getElementById('editLhpSemesterId').value = semesterId;
        document.getElementById('editLhpLecturerId').value = lecturerId;
        document.getElementById('editLhpRoom').value = room;
        document.getElementById('editLhpEnrolledCount').value = enrolled;
        document.getElementById('editCourseClassModal').classList.remove('hidden');
    }
    function closeEditCourseClassModal() {
        document.getElementById('editCourseClassModal').classList.add('hidden');
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
