<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Quản Lý Tài Khoản Người Dùng" />
<c:set var="activeMenu" value="users" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Header & Action -->
    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
            <h1 class="text-xl font-bold text-slate-800 flex items-center">
                <i class="fa-solid fa-users-gear text-utc-blue mr-2.5"></i>Quản Lý Tài Khoản & Người Dùng
            </h1>
            <p class="text-xs text-slate-500 mt-1">Quản lý hồ sơ định danh, cấp phát tài khoản Sinh viên, Giảng viên, phân quyền và bảo mật truy cập</p>
        </div>

        <div class="flex flex-wrap items-center gap-2 w-full md:w-auto">
            <c:choose>
                <c:when test="${currentTab == 'lecturer'}">
                    <button type="button" onclick="openAddLecturerModal()"
                            class="w-full sm:w-auto px-4 py-2 bg-utc-blue hover:bg-utc-dark text-white rounded-xl text-xs font-bold shadow-xs flex items-center justify-center space-x-1.5 transition">
                        <i class="fa-solid fa-user-plus"></i>
                        <span>Thêm Giảng Viên</span>
                    </button>
                </c:when>
                <c:when test="${currentTab == 'admin'}">
                    <!-- Admin tab actions -->
                </c:when>
                <c:otherwise>
                    <button type="button" onclick="openExportFacultyModal()"
                            class="flex-1 sm:flex-initial px-3.5 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold shadow-xs flex items-center justify-center space-x-1.5 transition">
                        <i class="fa-solid fa-file-excel"></i>
                        <span>Xuất Excel Theo Khoa</span>
                    </button>
                    <button type="button" onclick="openAddStudentModal()"
                            class="flex-1 sm:flex-initial px-4 py-2 bg-utc-blue hover:bg-utc-dark text-white rounded-xl text-xs font-bold shadow-xs flex items-center justify-center space-x-1.5 transition">
                        <i class="fa-solid fa-user-plus"></i>
                        <span>Thêm Sinh Viên Mới</span>
                    </button>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Alert Messages -->
    <c:if test="${not empty param.msg}">
        <div class="p-3.5 bg-emerald-50 border border-emerald-200 text-emerald-700 rounded-xl text-xs font-semibold flex items-center">
            <i class="fa-solid fa-circle-check mr-2 text-sm text-emerald-500"></i>
            <c:choose>
                <c:when test="${param.msg == 'student_added'}">Thêm sinh viên và cấp tài khoản thành công!</c:when>
                <c:when test="${param.msg == 'lecturer_added'}">Thêm giảng viên và cấp tài khoản thành công!</c:when>
                <c:when test="${param.msg == 'pwd_reset'}">Mật khẩu đã được thiết lập lại thành công (Mặc định: 123456)!</c:when>
                <c:when test="${param.msg == 'status_updated'}">Cập nhật trạng thái tài khoản thành công!</c:when>
                <c:when test="${param.msg == 'user_deleted'}">Đã xóa tài khoản thành công!</c:when>
                <c:otherwise>Thao tác thực hiện thành công!</c:otherwise>
            </c:choose>
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="p-3.5 bg-rose-50 border border-rose-200 text-rose-700 rounded-xl text-xs font-semibold flex items-center">
            <i class="fa-solid fa-triangle-exclamation mr-2 text-sm text-rose-500"></i>
            <c:choose>
                <c:when test="${param.error == 'user_exists'}">Tên đăng nhập / Mã định danh đã tồn tại trong hệ thống!</c:when>
                <c:when test="${param.error == 'empty_fields'}">Vui lòng điền đầy đủ các thông tin bắt buộc!</c:when>
                <c:otherwise>${param.error}</c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <!-- Tabs & Filter Bar -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm p-4 space-y-4">
        <!-- Navigation Tabs -->
        <div class="flex border-b border-slate-200 overflow-x-auto whitespace-nowrap scrollbar-none">
            <a href="${pageContext.request.contextPath}/admin/users?tab=student" 
               class="px-4 sm:px-5 py-2.5 text-xs font-bold border-b-2 transition flex items-center space-x-2 ${currentTab == 'student' ? 'border-utc-blue text-utc-blue' : 'border-transparent text-slate-500 hover:text-slate-700'}">
                <i class="fa-solid fa-user-graduate"></i>
                <span>Sinh Viên</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/users?tab=lecturer" 
               class="px-4 sm:px-5 py-2.5 text-xs font-bold border-b-2 transition flex items-center space-x-2 ${currentTab == 'lecturer' ? 'border-utc-blue text-utc-blue' : 'border-transparent text-slate-500 hover:text-slate-700'}">
                <i class="fa-solid fa-chalkboard-user"></i>
                <span>Giảng Viên</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/users?tab=admin" 
               class="px-4 sm:px-5 py-2.5 text-xs font-bold border-b-2 transition flex items-center space-x-2 ${currentTab == 'admin' ? 'border-utc-blue text-utc-blue' : 'border-transparent text-slate-500 hover:text-slate-700'}">
                <i class="fa-solid fa-shield-halved"></i>
                <span>Quản Trị Viên (Phòng Đào Tạo)</span>
            </a>
        </div>

        <!-- Filter Form -->
        <form action="${pageContext.request.contextPath}/admin/users" method="GET" class="flex flex-wrap items-center gap-2.5">
            <input type="hidden" name="tab" value="${currentTab}">
            
            <div class="w-full sm:w-auto sm:min-w-[200px] flex-1">
                <div class="relative">
                    <i class="fa-solid fa-magnifying-glass absolute left-3.5 top-3 text-slate-400 text-xs"></i>
                    <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo Mã SV/GV, Họ tên, Email..."
                           class="w-full pl-9 pr-3.5 py-2 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue bg-slate-50">
                </div>
            </div>

            <div class="w-full sm:w-auto sm:min-w-[160px] flex-1">
                <select name="status" onchange="this.form.submit()" 
                        class="w-full px-3 py-2 rounded-xl border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-utc-blue bg-slate-50">
                    <option value="">Tất cả trạng thái</option>
                    <option value="1" ${status == '1' ? 'selected' : ''}>Đang hoạt động</option>
                    <option value="0" ${status == '0' ? 'selected' : ''}>Đang bị khóa</option>
                </select>
            </div>

            <button type="submit" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-bold transition flex items-center justify-center">
                <i class="fa-solid fa-filter mr-1"></i>Lọc
            </button>
            <c:if test="${not empty keyword || not empty status}">
                <a href="${pageContext.request.contextPath}/admin/users?tab=${currentTab}" class="text-xs text-rose-600 hover:underline px-2 py-1">
                    Xóa lọc
                </a>
            </c:if>
        </form>
    </div>

    <!-- Users Table -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs text-slate-600">
                <thead class="bg-slate-50 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                    <tr>
                        <th class="px-4 py-3.5">ID</th>
                        <th class="px-4 py-3.5">Tên đăng nhập</th>
                        <th class="px-4 py-3.5">Họ và tên</th>
                        <th class="px-4 py-3.5">Email</th>
                        <th class="px-4 py-3.5">Số điện thoại</th>
                        <th class="px-4 py-3.5 text-center">Trạng thái</th>
                        <th class="px-4 py-3.5 text-center">Thao tác quản trị</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="u" items="${users}">
                        <tr class="hover:bg-slate-50/80">
                            <td class="px-4 py-3 text-slate-400 font-mono">#${u.id}</td>
                            <td class="px-4 py-3 font-bold text-slate-800">
                                <span class="px-2 py-0.5 rounded bg-slate-100 text-slate-700 font-mono">${u.username}</span>
                            </td>
                            <td class="px-4 py-3 font-semibold text-slate-800">${u.fullName}</td>
                            <td class="px-4 py-3 text-slate-600">${u.email}</td>
                            <td class="px-4 py-3 text-slate-600 font-mono">${not empty u.phone ? u.phone : '-'}</td>
                            <td class="px-4 py-3 text-center">
                                <c:choose>
                                    <c:when test="${u.status == 1}">
                                        <span class="inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800">
                                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 mr-1.5"></span>Hoạt động
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-bold bg-rose-100 text-rose-800">
                                            <span class="w-1.5 h-1.5 rounded-full bg-rose-500 mr-1.5"></span>Bị khóa
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-4 py-3 text-center space-x-1.5 whitespace-nowrap">
                                <!-- Reset Password Form -->
                                <form action="${pageContext.request.contextPath}/admin/users" method="POST" class="inline"
                                      onsubmit="return confirm('Bạn có chắc chắn muốn đặt lại mật khẩu cho tài khoản ${u.username} về mặc định (123456)?');">
                                    <input type="hidden" name="action" value="reset_password">
                                    <input type="hidden" name="userId" value="${u.id}">
                                    <input type="hidden" name="tab" value="${currentTab}">
                                    <button type="submit" title="Reset Mật khẩu về 123456"
                                            class="px-2.5 py-1.5 rounded-lg bg-amber-50 text-amber-700 hover:bg-amber-100 font-semibold text-[11px] transition">
                                        <i class="fa-solid fa-key mr-1"></i>Reset MK
                                    </button>
                                </form>

                                <!-- Toggle Status Form -->
                                <form action="${pageContext.request.contextPath}/admin/users" method="POST" class="inline">
                                    <input type="hidden" name="action" value="toggle_status">
                                    <input type="hidden" name="userId" value="${u.id}">
                                    <input type="hidden" name="currentStatus" value="${u.status}">
                                    <input type="hidden" name="tab" value="${currentTab}">
                                    <button type="submit" 
                                            class="px-2.5 py-1.5 rounded-lg font-semibold text-[11px] transition ${u.status == 1 ? 'bg-rose-50 text-rose-700 hover:bg-rose-100' : 'bg-emerald-50 text-emerald-700 hover:bg-emerald-100'}">
                                        <i class="fa-solid ${u.status == 1 ? 'fa-lock' : 'fa-lock-open'} mr-1"></i>
                                        ${u.status == 1 ? 'Khóa' : 'Mở'}
                                    </button>
                                </form>

                                <!-- Delete Form -->
                                <form action="${pageContext.request.contextPath}/admin/users" method="POST" class="inline"
                                      onsubmit="return confirm('CẢNH BÁO: Bạn có chắc chắn muốn xóa tài khoản ${u.username}?');">
                                    <input type="hidden" name="action" value="delete_user">
                                    <input type="hidden" name="userId" value="${u.id}">
                                    <input type="hidden" name="tab" value="${currentTab}">
                                    <button type="submit" title="Xóa tài khoản"
                                            class="px-2.5 py-1.5 rounded-lg bg-slate-100 text-slate-600 hover:bg-rose-100 hover:text-rose-700 font-semibold text-[11px] transition">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="7" class="px-4 py-10 text-center text-slate-400">Không tìm thấy tài khoản nào phù hợp.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- Modal Thêm Sinh Viên Mới -->
<div id="addStudentModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl max-w-lg w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
        <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
            <h3 class="font-bold text-slate-800 text-xs sm:text-sm flex items-center">
                <i class="fa-solid fa-user-graduate text-utc-blue mr-2 text-base"></i>Thêm Mới Sinh Viên & Cấp Tài Khoản
            </h3>
            <button type="button" onclick="closeAddStudentModal()" class="text-slate-400 hover:text-slate-600 p-1">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/users" method="POST" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
            <input type="hidden" name="action" value="add_student">
            <input type="hidden" name="tab" value="student">

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Lớp chuyên ngành (*)</label>
                    <select id="addStudentClassSelect" name="classId" onchange="autoGenerateMSV()" required
                            class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs font-semibold focus:ring-2 focus:ring-utc-blue">
                        <c:forEach var="cl" items="${classRooms}">
                            <option value="${cl.classId}" ${param.classId == cl.classId ? 'selected' : ''}>${cl.classId} - ${cl.className}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <div class="flex items-center justify-between mb-1.5">
                        <label class="block text-xs font-semibold uppercase text-slate-600">Mã Sinh Viên (*)</label>
                        <button type="button" onclick="autoGenerateMSV()" class="text-[10px] text-utc-blue font-bold hover:underline flex items-center">
                            <i class="fa-solid fa-wand-magic-sparkles mr-1"></i>Tự sinh
                        </button>
                    </div>
                    <input type="text" id="addStudentIdInput" name="studentId" required placeholder="Hệ thống tự sinh..."
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs font-mono font-bold text-utc-blue focus:ring-2 focus:ring-utc-blue bg-blue-50/40">
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Họ và tên (*)</label>
                    <input type="text" name="fullName" required placeholder="Ví dụ: Hoàng Văn Nam"
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Quê quán</label>
                    <input type="text" name="hometown" placeholder="Hà Nội, Hải Phòng..."
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Ngày sinh</label>
                    <input type="date" name="dateOfBirth" value="2003-01-01"
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Giới tính</label>
                    <select name="gender" class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                        <option value="Nam">Nam</option>
                        <option value="Nữ">Nữ</option>
                    </select>
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Email liên hệ</label>
                    <input type="email" name="email" placeholder="sv@utc.edu.vn"
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Số điện thoại</label>
                    <input type="text" name="phone" placeholder="0912..."
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                </div>
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Mật khẩu ban đầu</label>
                <input type="text" name="password" value="123456" required
                       class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs font-mono focus:ring-2 focus:ring-utc-blue">
                <span class="text-[10px] text-slate-400 mt-1 block">Sinh viên có thể đổi mật khẩu này sau khi đăng nhập</span>
            </div>

            <div class="flex flex-wrap items-center justify-end gap-2 pt-3 border-t border-slate-200">
                <button type="button" onclick="closeAddStudentModal()"
                        class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-xs font-semibold text-slate-600 hover:bg-slate-50 transition text-center">
                    Hủy bỏ
                </button>
                <button type="submit"
                        class="flex-1 sm:flex-initial px-5 py-2 bg-utc-blue hover:bg-utc-dark text-white rounded-xl text-xs font-bold shadow-xs transition text-center">
                    Lưu & Cấp Tài Khoản
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Thêm Giảng Viên Mới -->
<div id="addLecturerModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl max-w-lg w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
        <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
            <h3 class="font-bold text-slate-800 text-xs sm:text-sm flex items-center">
                <i class="fa-solid fa-chalkboard-user text-utc-blue mr-2 text-base"></i>Thêm Mới Giảng Viên & Cấp Tài Khoản
            </h3>
            <button type="button" onclick="closeAddLecturerModal()" class="text-slate-400 hover:text-slate-600 p-1">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/users" method="POST" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
            <input type="hidden" name="action" value="add_lecturer">
            <input type="hidden" name="tab" value="lecturer">

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Mã Giảng Viên (*)</label>
                    <input type="text" name="lecturerId" required placeholder="Ví dụ: GV010"
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Họ và tên (*)</label>
                    <input type="text" name="fullName" required placeholder="Ví dụ: TS. Trần Văn Minh"
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Học hàm / Học vị</label>
                    <select name="academicRank" class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                        <option value="Tiến sĩ">Tiến sĩ</option>
                        <option value="Thạc sĩ">Thạc sĩ</option>
                        <option value="Phó Giáo sư, Tiến sĩ">Phó Giáo sư, Tiến sĩ</option>
                        <option value="Giáo sư, Tiến sĩ">Giáo sư, Tiến sĩ</option>
                        <option value="Kỹ sư">Kỹ sư</option>
                    </select>
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Khoa / Viện trực thuộc</label>
                    <select name="facultyId" class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                        <c:forEach var="f" items="${faculties}">
                            <option value="${f.facultyId}">${f.facultyName}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Email công tác</label>
                    <input type="email" name="email" placeholder="gv@utc.edu.vn"
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Số điện thoại</label>
                    <input type="text" name="phone" placeholder="0988..."
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                </div>
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Mật khẩu ban đầu</label>
                <input type="text" name="password" value="123456" required
                       class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs font-mono focus:ring-2 focus:ring-utc-blue">
            </div>

            <div class="flex flex-wrap items-center justify-end gap-2 pt-3 border-t border-slate-200">
                <button type="button" onclick="closeAddLecturerModal()"
                        class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-xs font-semibold text-slate-600 hover:bg-slate-50 transition text-center">
                    Hủy bỏ
                </button>
                <button type="submit"
                        class="flex-1 sm:flex-initial px-5 py-2 bg-utc-blue hover:bg-utc-dark text-white rounded-xl text-xs font-bold shadow-xs transition text-center">
                    Lưu & Cấp Tài Khoản
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Xuất Excel Theo Khoa -->
<div id="exportFacultyModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl max-w-md w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
        <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
            <h3 class="font-bold text-slate-800 text-xs sm:text-sm flex items-center">
                <i class="fa-solid fa-file-excel text-emerald-600 mr-2 text-base"></i>Xuất Danh Sách Sinh Viên Theo Khoa
            </h3>
            <button type="button" onclick="closeExportFacultyModal()" class="text-slate-400 hover:text-slate-600 p-1">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>
        <form action="${pageContext.request.contextPath}/admin/users" method="GET" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
            <input type="hidden" name="action" value="export_faculty">
            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Chọn Khoa / Viện</label>
                <select name="facultyId" class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500">
                    <option value="">-- Toàn bộ các Khoa (Toàn trường) --</option>
                    <c:forEach var="f" items="${faculties}">
                        <option value="${f.facultyId}">[${f.facultyId}] ${f.facultyName}</option>
                    </c:forEach>
                </select>
                <div class="p-3 bg-blue-50 border border-blue-100 rounded-xl mt-3 text-[11px] text-blue-700 leading-relaxed">
                    <i class="fa-solid fa-circle-info text-blue-500 mr-1"></i>File Excel xuất ra có khung cột chuẩn: <b>STT, Mã SV, Họ và tên, Ngày sinh, Giới tính, Lớp, Khoa, Email, SĐT</b>. Khung này hoàn toàn tương thích để import vào các Lớp học phần.
                </div>
            </div>
            <div class="flex flex-wrap items-center justify-end gap-2 pt-3 border-t border-slate-200">
                <button type="button" onclick="closeExportFacultyModal()"
                        class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-xs font-semibold text-slate-600 hover:bg-slate-50 transition text-center">
                    Đóng
                </button>
                <button type="submit"
                        class="flex-1 sm:flex-initial px-5 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold shadow-xs flex items-center justify-center space-x-1.5 transition">
                    <i class="fa-solid fa-download"></i>
                    <span>Tải Về Excel</span>
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openAddStudentModal() {
        document.getElementById('addStudentModal').classList.remove('hidden');
        const idInput = document.getElementById('addStudentIdInput');
        if (!idInput.value || idInput.value.trim() === '') {
            autoGenerateMSV();
        }
    }
    function closeAddStudentModal() {
        document.getElementById('addStudentModal').classList.add('hidden');
    }
    function autoGenerateMSV() {
        const select = document.getElementById('addStudentClassSelect');
        const classId = select ? select.value : '';
        fetch('${pageContext.request.contextPath}/admin/users?action=generate_msv&classId=' + encodeURIComponent(classId))
            .then(res => res.json())
            .then(data => {
                if (data && data.nextId) {
                    document.getElementById('addStudentIdInput').value = data.nextId;
                }
            })
            .catch(err => console.error('Error generating MSV:', err));
    }
    function openExportFacultyModal() {
        document.getElementById('exportFacultyModal').classList.remove('hidden');
    }
    function closeExportFacultyModal() {
        document.getElementById('exportFacultyModal').classList.add('hidden');
    }
    function openAddLecturerModal() {
        document.getElementById('addLecturerModal').classList.remove('hidden');
    }
    function closeAddLecturerModal() {
        document.getElementById('addLecturerModal').classList.add('hidden');
    }

    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('openModal') === 'add_student') {
            openAddStudentModal();
        }
    });
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
