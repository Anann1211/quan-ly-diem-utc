<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Danh Sách Sinh Viên & Rút Môn - ${targetClass.className}" />
<c:set var="activeMenu" value="classes" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Header & Navigation -->
    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
            <div class="flex items-center space-x-2 text-xs text-slate-500 mb-1">
                <a href="${pageContext.request.contextPath}/admin/classes" class="hover:text-utc-blue transition flex items-center">
                    <i class="fa-solid fa-arrow-left mr-1"></i> Quay lại Lớp Học Phần
                </a>
                <span>/</span>
                <span class="text-slate-800 font-semibold">${targetClass.classId}</span>
            </div>
            <h1 class="text-xl font-bold text-slate-800 flex items-center">
                <i class="fa-solid fa-users-line text-emerald-600 mr-2.5"></i>Danh Sách Sinh Viên & Rút Học Phần
            </h1>
            <p class="text-xs text-slate-500 mt-1">
                Lớp: <span class="font-bold text-slate-700">${targetClass.className}</span> | 
                Môn: <span class="font-bold text-utc-blue">${targetClass.subjectName} (${targetClass.credits} TC)</span> | 
                GV: <span class="font-bold text-slate-700">${targetClass.lecturerName}</span>
            </p>
        </div>

        <div class="flex flex-wrap items-center gap-2 w-full md:w-auto">
            <c:if test="${targetClass.gradeStatus != 'PUBLISHED'}">
                <button type="button" onclick="document.getElementById('batchEnrollModal').classList.remove('hidden')"
                        class="flex-1 sm:flex-initial px-3.5 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold shadow-xs flex items-center justify-center space-x-1.5 transition">
                    <i class="fa-solid fa-users-rectangle"></i>
                    <span>Nạp Cả Lớp Chuyên Ngành</span>
                </button>
                <button type="button" onclick="document.getElementById('addStudentModal').classList.remove('hidden')"
                        class="flex-1 sm:flex-initial px-3.5 py-2 bg-utc-blue hover:bg-utc-dark text-white rounded-xl text-xs font-bold shadow-xs flex items-center justify-center space-x-1.5 transition">
                    <i class="fa-solid fa-user-plus"></i>
                    <span>Thêm SV Học Ghép</span>
                </button>
            </c:if>
            <a href="${pageContext.request.contextPath}/admin/grade-approval?classId=${targetClass.classId}"
               class="w-full sm:w-auto px-4 py-2 bg-indigo-50 text-indigo-700 hover:bg-indigo-100 rounded-xl text-xs font-bold transition flex items-center justify-center space-x-1.5">
                <i class="fa-solid fa-eye"></i>
                <span>Xem Bảng Điểm</span>
            </a>
        </div>
    </div>

    <!-- Alert Messages -->
    <c:if test="${param.msg == 'batch_enrolled'}">
        <div class="p-4 bg-emerald-50 border border-emerald-200 rounded-xl text-xs text-emerald-800 font-medium flex items-center">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base mr-2"></i>
            Đã nạp thành công <b>${param.count}</b> sinh viên từ lớp chuyên ngành vào lớp học phần!
        </div>
    </c:if>
    <c:if test="${param.msg == 'student_withdrawn'}">
        <div class="p-4 bg-emerald-50 border border-emerald-200 rounded-xl text-xs text-emerald-800 font-medium flex items-center">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base mr-2"></i>
            Đã cho sinh viên rút khỏi lớp học phần thành công! Điểm học phần của sinh viên đã được hủy và cập nhật lại sĩ số lớp.
        </div>
    </c:if>
    <c:if test="${param.msg == 'student_enrolled'}">
        <div class="p-4 bg-emerald-50 border border-emerald-200 rounded-xl text-xs text-emerald-800 font-medium flex items-center">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base mr-2"></i>
            Đã thêm sinh viên vào lớp học phần thành công!
        </div>
    </c:if>
    <c:if test="${param.error == 'class_published'}">
        <div class="p-4 bg-rose-50 border border-rose-200 rounded-xl text-xs text-rose-800 font-medium flex items-center">
            <i class="fa-solid fa-circle-xmark text-rose-600 text-base mr-2"></i>
            Lớp học phần đã công bố điểm chính thức (PUBLISHED), không thể rút môn!
        </div>
    </c:if>
    <c:if test="${param.error == 'student_not_found'}">
        <div class="p-4 bg-rose-50 border border-rose-200 rounded-xl text-xs text-rose-800 font-medium flex items-center">
            <i class="fa-solid fa-circle-xmark text-rose-600 text-base mr-2"></i>
            Không tìm thấy thông tin sinh viên với Mã SV vừa nhập!
        </div>
    </c:if>
    <c:if test="${param.error == 'student_already_enrolled'}">
        <div class="p-4 bg-amber-50 border border-amber-200 rounded-xl text-xs text-amber-800 font-medium flex items-center">
            <i class="fa-solid fa-triangle-exclamation text-amber-600 text-base mr-2"></i>
            Sinh viên này đã có tên trong lớp học phần rồi!
        </div>
    </c:if>

    <!-- Info Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div class="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center space-x-3">
            <div class="w-10 h-10 rounded-lg bg-blue-50 text-utc-blue flex items-center justify-center font-bold">
                <i class="fa-solid fa-id-badge text-lg"></i>
            </div>
            <div>
                <p class="text-[11px] text-slate-500 font-medium uppercase">Mã Lớp Học Phần</p>
                <p class="text-sm font-bold text-slate-800 font-mono">${targetClass.classId}</p>
            </div>
        </div>

        <div class="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center space-x-3">
            <div class="w-10 h-10 rounded-lg bg-emerald-50 text-emerald-600 flex items-center justify-center font-bold">
                <i class="fa-solid fa-users text-lg"></i>
            </div>
            <div>
                <p class="text-[11px] text-slate-500 font-medium uppercase">Sĩ Số Đang Học</p>
                <p class="text-sm font-bold text-slate-800">${roster.size()} Sinh viên</p>
            </div>
        </div>

        <div class="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center space-x-3">
            <div class="w-10 h-10 rounded-lg bg-amber-50 text-amber-600 flex items-center justify-center font-bold">
                <i class="fa-solid fa-percent text-lg"></i>
            </div>
            <div>
                <p class="text-[11px] text-slate-500 font-medium uppercase">Tỷ Lệ Điểm</p>
                <p class="text-xs font-bold text-slate-800">
                    CC ${(targetClass.weightAttendance * 100).intValue()}% - 
                    GK ${(targetClass.weightMidterm * 100).intValue()}% - 
                    Thi ${(targetClass.weightFinal * 100).intValue()}%
                </p>
            </div>
        </div>

        <div class="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center space-x-3">
            <div class="w-10 h-10 rounded-lg bg-purple-50 text-purple-600 flex items-center justify-center font-bold">
                <i class="fa-solid fa-shield-halved text-lg"></i>
            </div>
            <div>
                <p class="text-[11px] text-slate-500 font-medium uppercase">Trạng Thái Sổ Điểm</p>
                <div class="mt-0.5">${targetClass.statusBadge}</div>
            </div>
        </div>
    </div>

    <!-- Student Table -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-4 border-b border-slate-200 flex items-center justify-between bg-slate-50">
            <h2 class="text-xs font-bold uppercase tracking-wider text-slate-700 flex items-center">
                <i class="fa-solid fa-list-check text-slate-500 mr-2"></i>
                Danh Sách Sinh Viên Trong Lớp (${roster.size()} sinh viên)
            </h2>
            <span class="text-[11px] text-slate-500">
                <i class="fa-solid fa-circle-info mr-1 text-utc-blue"></i>
                Rút môn sẽ hủy bảng điểm môn học này của sinh viên và trừ sĩ số lớp.
            </span>
        </div>

        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs text-slate-600">
                <thead class="bg-slate-50/80 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                    <tr>
                        <th class="px-4 py-3.5 text-center">STT</th>
                        <th class="px-4 py-3.5">Mã Sinh Viên</th>
                        <th class="px-4 py-3.5">Họ và Tên</th>
                        <th class="px-4 py-3.5">Lớp Chuyên Ngành</th>
                        <th class="px-4 py-3.5 text-center">Điểm CC</th>
                        <th class="px-4 py-3.5 text-center">Điểm GK</th>
                        <th class="px-4 py-3.5 text-center">Điểm Thi</th>
                        <th class="px-4 py-3.5 text-center bg-slate-100/60">Tổng Kết 10</th>
                        <th class="px-4 py-3.5 text-center">Điểm Chữ</th>
                        <th class="px-4 py-3.5 text-center">Kết Quả</th>
                        <th class="px-4 py-3.5 text-center">Thao Tác</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="g" items="${roster}" varStatus="loop">
                        <tr class="hover:bg-slate-50/80 transition">
                            <td class="px-4 py-3 text-center text-slate-400 font-medium">${loop.index + 1}</td>
                            <td class="px-4 py-3 font-mono font-bold text-slate-800">${g.studentId}</td>
                            <td class="px-4 py-3 font-medium text-slate-800">${g.studentName}</td>
                            <td class="px-4 py-3 text-slate-500">${g.className != null ? g.className : '-'}</td>
                            <td class="px-4 py-3 text-center">${g.scoreAttendance != null ? g.scoreAttendance : '-'}</td>
                            <td class="px-4 py-3 text-center">${g.scoreMidterm != null ? g.scoreMidterm : '-'}</td>
                            <td class="px-4 py-3 text-center font-bold ${g.scoreFinal != null && g.scoreFinal < 4.0 ? 'text-rose-600' : 'text-slate-800'}">
                                ${g.scoreFinal != null ? g.scoreFinal : '-'}
                            </td>
                            <td class="px-4 py-3 text-center font-bold text-slate-900 bg-slate-50/50">
                                ${g.scoreTotal10 != null ? g.scoreTotal10 : '-'}
                            </td>
                            <td class="px-4 py-3 text-center">${g.letterBadge}</td>
                            <td class="px-4 py-3 text-center">${g.resultBadge}</td>
                            <td class="px-4 py-3 text-center whitespace-nowrap">
                                <c:choose>
                                    <c:when test="${targetClass.gradeStatus != 'PUBLISHED'}">
                                        <form action="${pageContext.request.contextPath}/admin/classes" method="POST" class="inline"
                                              onsubmit="return confirm('CẢNH BÁO RÚT MÔN:\nBạn có chắc chắn muốn cho sinh viên ${g.studentName} (${g.studentId}) rút khỏi lớp học phần này?\n\n- Điểm học phần của sinh viên sẽ bị hủy.\n- Sĩ số lớp học phần sẽ giảm đi 1.');">
                                            <input type="hidden" name="action" value="remove_student">
                                            <input type="hidden" name="classId" value="${targetClass.classId}">
                                            <input type="hidden" name="studentId" value="${g.studentId}">
                                            <button type="submit" 
                                                    class="px-2.5 py-1.5 rounded-lg bg-rose-50 text-rose-600 hover:bg-rose-100 font-semibold text-[11px] transition inline-flex items-center space-x-1"
                                                    title="Cho sinh viên rút khỏi học phần">
                                                <i class="fa-solid fa-user-minus"></i>
                                                <span>Rút môn học</span>
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-2 py-1 bg-slate-100 text-slate-400 rounded-lg text-[11px] font-medium inline-flex items-center" title="Điểm đã công bố chính thức, không thể rút môn">
                                            <i class="fa-solid fa-lock mr-1"></i>Đã khóa
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty roster}">
                        <tr>
                            <td colspan="11" class="px-4 py-8 text-center text-slate-400 text-xs italic">
                                Lớp học phần hiện chưa có sinh viên nào đăng ký.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal Nạp Cả Lớp Chuyên Ngành Vào LHP -->
<div id="batchEnrollModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl max-w-md w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
        <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
            <h3 class="font-bold text-slate-800 text-xs sm:text-sm flex items-center">
                <i class="fa-solid fa-users-rectangle text-emerald-600 mr-2 text-base"></i>Nạp Cả Lớp Chuyên Ngành Vào LHP
            </h3>
            <button type="button" onclick="document.getElementById('batchEnrollModal').classList.add('hidden')" class="text-slate-400 hover:text-slate-600 p-1">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/classes" method="POST" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
            <input type="hidden" name="action" value="batch_enroll_class">
            <input type="hidden" name="classId" value="${targetClass.classId}">

            <div class="p-3 bg-emerald-50 border border-emerald-200 rounded-xl text-[11px] text-emerald-800 leading-relaxed">
                <i class="fa-solid fa-circle-info mr-1 text-emerald-600"></i>
                Hệ thống sẽ quét toàn bộ sinh viên thuộc Lớp chuyên ngành được chọn và nạp vào Lớp học phần <b>${targetClass.className}</b> (bỏ qua những sinh viên đã có tên).
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Chọn Lớp Chuyên Ngành (*)</label>
                <select name="classRoomId" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs font-semibold focus:ring-2 focus:ring-emerald-500">
                    <option value="">-- Chọn một lớp chuyên ngành --</option>
                    <c:forEach var="cr" items="${classRooms}">
                        <option value="${cr.classId}">[${cr.classId}] ${cr.className} (K${cr.intakeYear})</option>
                    </c:forEach>
                </select>
            </div>

            <div class="flex flex-wrap items-center justify-end gap-2 pt-3 border-t border-slate-200">
                <button type="button" onclick="document.getElementById('batchEnrollModal').classList.add('hidden')"
                        class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-xs font-semibold text-slate-600 hover:bg-slate-50 transition text-center">
                    Hủy bỏ
                </button>
                <button type="submit"
                        class="flex-1 sm:flex-initial px-5 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold shadow-xs transition flex items-center justify-center space-x-1.5">
                    <i class="fa-solid fa-cloud-arrow-down"></i>
                    <span>Bắt Đầu Nạp</span>
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Thêm Sinh Viên (Học Ghép / Đăng Ký Bổ Sung) -->
<div id="addStudentModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl max-w-md w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
        <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
            <h3 class="font-bold text-slate-800 text-xs sm:text-sm flex items-center">
                <i class="fa-solid fa-user-plus text-utc-blue mr-2 text-base"></i>Thêm Sinh Viên Vào Lớp Học Phần
            </h3>
            <button type="button" onclick="document.getElementById('addStudentModal').classList.add('hidden')" class="text-slate-400 hover:text-slate-600 p-1">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/classes" method="POST" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
            <input type="hidden" name="action" value="add_student_to_class">
            <input type="hidden" name="classId" value="${targetClass.classId}">

            <div class="p-3 bg-blue-50 border border-blue-200 rounded-xl text-[11px] text-blue-800 leading-relaxed">
                <i class="fa-solid fa-circle-info mr-1 text-utc-blue"></i>
                Nhập <b>Mã Sinh Viên</b> cần thêm vào lớp học phần này (áp dụng cho trường hợp sinh viên đăng ký học ghép, học bù hoặc bổ sung tín chỉ).
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Mã Sinh Viên (*)</label>
                <input type="text" name="studentId" required placeholder="Ví dụ: 211200001, 231200001..."
                       class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs font-mono focus:ring-2 focus:ring-utc-blue">
            </div>

            <div class="flex flex-wrap items-center justify-end gap-2 pt-3 border-t border-slate-200">
                <button type="button" onclick="document.getElementById('addStudentModal').classList.add('hidden')"
                        class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-xs font-semibold text-slate-600 hover:bg-slate-50 transition text-center">
                    Hủy bỏ
                </button>
                <button type="submit"
                        class="flex-1 sm:flex-initial px-5 py-2 bg-utc-blue hover:bg-utc-dark text-white rounded-xl text-xs font-bold shadow-xs transition flex items-center justify-center space-x-1.5">
                    <i class="fa-solid fa-check"></i>
                    <span>Thêm Vào Lớp</span>
                </button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
