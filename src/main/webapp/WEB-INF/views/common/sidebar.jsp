<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ========================================================= -->
<!-- 1. DESKTOP SIDEBAR (Visible on md+ screens)               -->
<!-- ========================================================= -->
<aside class="w-64 flex-shrink-0 hidden md:block no-print">
    <div class="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden sticky top-20">
        <!-- Sidebar Header / Role Summary -->
        <div class="p-4 bg-slate-50 border-b border-slate-200">
            <div class="text-xs font-semibold uppercase text-slate-400 tracking-wider">Phân Hệ Làm Việc</div>
            <div class="font-bold text-slate-800 text-sm mt-0.5">
                <c:choose>
                    <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">
                        <span class="text-utc-blue"><i class="fa-solid fa-crown mr-1.5 text-amber-500"></i>Phòng Đào Tạo</span>
                    </c:when>
                    <c:when test="${sessionScope.currentUser.role == 'GIANG_VIEN'}">
                        <span class="text-utc-blue"><i class="fa-solid fa-chalkboard-user mr-1.5 text-sky-500"></i>Cổng Giảng Viên</span>
                    </c:when>
                    <c:otherwise>
                        <span class="text-utc-blue"><i class="fa-solid fa-user-graduate mr-1.5 text-emerald-500"></i>Cổng Sinh Viên</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Navigation Links -->
        <nav class="p-3 space-y-1 text-sm font-medium">
            <!-- ADMIN MENU -->
            <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/admin/dashboard" 
                   class="flex items-center px-3 py-2 rounded-lg transition ${activeMenu == 'dashboard' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-700 hover:bg-slate-100'}">
                    <i class="fa-solid fa-chart-pie w-5 mr-2"></i>
                    <span>Tổng quan</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" 
                   class="flex items-center px-3 py-2 rounded-lg transition ${activeMenu == 'users' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-700 hover:bg-slate-100'}">
                    <i class="fa-solid fa-users-gear w-5 mr-2 text-cyan-600"></i>
                    <span>Quản lý Tài khoản</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/academic-classes" 
                   class="flex items-center px-3 py-2 rounded-lg transition ${activeMenu == 'academic-classes' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-700 hover:bg-slate-100'}">
                    <i class="fa-solid fa-school w-5 mr-2 text-teal-600"></i>
                    <span>Lớp chuyên ngành & SV</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/classes" 
                   class="flex items-center px-3 py-2 rounded-lg transition ${activeMenu == 'classes' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-700 hover:bg-slate-100'}">
                    <i class="fa-solid fa-chalkboard w-5 mr-2 text-indigo-500"></i>
                    <span>Lớp học phần</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/schedules" 
                   class="flex items-center justify-between px-3 py-2 rounded-lg transition ${activeMenu == 'schedules' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-700 hover:bg-slate-100'}">
                    <div class="flex items-center">
                        <i class="fa-solid fa-calendar-days w-5 mr-2 text-rose-500"></i>
                        <span>Thời Khóa Biểu & Lịch Học</span>
                    </div>
                    <c:if test="${pendingLeavesCount > 0}">
                        <span class="px-1.5 py-0.5 rounded-full text-[10px] font-bold bg-rose-500 text-white animate-pulse">
                            ${pendingLeavesCount}
                        </span>
                    </c:if>
                </a>
                <a href="${pageContext.request.contextPath}/admin/grade-approval" 
                   class="flex items-center px-3 py-2 rounded-lg transition ${activeMenu == 'approval' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-700 hover:bg-slate-100'}">
                    <i class="fa-solid fa-clipboard-check w-5 mr-2 text-emerald-500"></i>
                    <span>Duyệt & Công bố điểm</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/faculty-grades" 
                   class="flex items-center px-3 py-2 rounded-lg transition ${activeMenu == 'faculty-grades' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-700 hover:bg-slate-100'}">
                    <i class="fa-solid fa-layer-group w-5 mr-2 text-blue-600"></i>
                    <span>Điểm theo Khoa & Lớp</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/appeals" 
                   class="flex items-center px-3 py-2 rounded-lg transition ${activeMenu == 'appeals' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-700 hover:bg-slate-100'}">
                    <i class="fa-solid fa-file-pen w-5 mr-2 text-amber-500"></i>
                    <span>Xử lý Phúc khảo</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/subjects" 
                   class="flex items-center px-3 py-2 rounded-lg transition ${activeMenu == 'subjects' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-700 hover:bg-slate-100'}">
                    <i class="fa-solid fa-book-bookmark w-5 mr-2 text-sky-500"></i>
                    <span>Quản lý Môn học</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/statistics" 
                   class="flex items-center px-3 py-2 rounded-lg transition ${activeMenu == 'statistics' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-700 hover:bg-slate-100'}">
                    <i class="fa-solid fa-chart-column w-5 mr-2 text-purple-500"></i>
                    <span>Báo cáo & Phổ điểm</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/audit-logs" 
                   class="flex items-center px-3 py-2 rounded-lg transition ${activeMenu == 'audit' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-700 hover:bg-slate-100'}">
                    <i class="fa-solid fa-clock-rotate-left w-5 mr-2 text-rose-500"></i>
                    <span>Nhật ký sửa điểm</span>
                </a>
            </c:if>

            <!-- LECTURER MENU -->
            <c:if test="${sessionScope.currentUser.role == 'GIANG_VIEN'}">
                <a href="${pageContext.request.contextPath}/lecturer/classes" 
                   class="flex items-center px-3 py-2.5 rounded-lg transition ${activeMenu == 'classes' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-700 hover:bg-slate-100'}">
                    <i class="fa-solid fa-folder-open w-5 mr-2 text-sky-500"></i>
                    <span>Lớp học phần phụ trách</span>
                </a>
                <a href="${pageContext.request.contextPath}/lecturer/schedule" 
                   class="flex items-center px-3 py-2.5 rounded-lg transition ${activeMenu == 'schedule' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-700 hover:bg-slate-100'}">
                    <i class="fa-solid fa-calendar-check w-5 mr-2 text-emerald-500"></i>
                    <span>Lịch Dạy & Giảng Đường</span>
                </a>
            </c:if>

            <!-- STUDENT MENU -->
            <c:if test="${sessionScope.currentUser.role == 'SINH_VIEN'}">
                <a href="${pageContext.request.contextPath}/student/schedule" 
                   class="flex items-center px-3 py-2.5 rounded-lg transition ${activeMenu == 'schedule' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-700 hover:bg-slate-100'}">
                    <i class="fa-solid fa-calendar-days w-5 mr-2 text-indigo-500"></i>
                    <span>Thời Khóa Biểu & Lịch Thi</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/grades" 
                   class="flex items-center px-3 py-2.5 rounded-lg transition ${activeMenu == 'grades' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-700 hover:bg-slate-100'}">
                    <i class="fa-solid fa-table-list w-5 mr-2 text-emerald-500"></i>
                    <span>Bảng điểm học tập</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/appeals" 
                   class="flex items-center px-3 py-2.5 rounded-lg transition ${activeMenu == 'appeals' ? 'bg-utc-blue text-white shadow-sm' : 'text-slate-700 hover:bg-slate-100'}">
                    <i class="fa-solid fa-file-pen w-5 mr-2 text-amber-500"></i>
                    <span>Đơn phúc khảo điểm</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/print-transcript" 
                   target="_blank"
                   class="flex items-center px-3 py-2.5 rounded-lg text-slate-700 hover:bg-slate-100 transition">
                    <i class="fa-solid fa-print w-5 mr-2 text-blue-500"></i>
                    <span>In bảng điểm chính thức</span>
                </a>
            </c:if>
        </nav>

        <!-- Quick Help UTC Box -->
        <div class="m-3 p-3 bg-slate-50 rounded-lg border border-slate-200 text-xs text-slate-600">
            <div class="font-semibold text-slate-800 mb-1 flex items-center">
                <i class="fa-solid fa-circle-info text-utc-blue mr-1.5"></i>Quy chế tín chỉ UTC
            </div>
            <p class="leading-relaxed">
                Đạt từ điểm <strong>D (1.0)</strong> hoặc <strong>4.0/10</strong> trở lên. Điểm tích lũy CPA tính theo thang 4.0.
            </p>
        </div>
    </div>
</aside>

<!-- ========================================================= -->
<!-- 2. MOBILE OFF-CANVAS DRAWER MENU (Visible on < md)        -->
<!-- ========================================================= -->
<div id="mobileDrawerBackdrop" onclick="closeMobileMenu()" 
     class="fixed inset-0 bg-slate-900/60 backdrop-blur-xs z-50 hidden transition-opacity md:hidden"></div>

<div id="mobileDrawer" 
     class="fixed top-0 left-0 bottom-0 w-80 max-w-[85vw] bg-white shadow-2xl z-50 transform -translate-x-full transition-transform duration-300 ease-in-out md:hidden flex flex-col">
    <!-- Drawer Header -->
    <div class="p-4 bg-utc-blue text-white flex items-center justify-between border-b border-utc-dark">
        <div class="flex items-center space-x-2.5">
            <img src="${pageContext.request.contextPath}/assets/images/utc-logo.webp" 
                 alt="UTC Logo" 
                 class="w-9 h-9 object-contain rounded-full bg-white p-0.5 border border-utc-gold flex-shrink-0">
            <div>
                <div class="text-[10px] uppercase tracking-wider text-slate-300 font-semibold">Cổng Đào Tạo UTC</div>
                <div class="text-sm font-bold tracking-tight">MENU CHỨC NĂNG</div>
            </div>
        </div>
        <button type="button" onclick="closeMobileMenu()" 
                class="text-white/80 hover:text-white p-1.5 rounded-lg hover:bg-white/10 transition"
                aria-label="Đóng menu">
            <i class="fa-solid fa-xmark text-lg"></i>
        </button>
    </div>

    <!-- User Information Header in Mobile Drawer -->
    <div class="p-4 bg-slate-50 border-b border-slate-200 flex items-center space-x-3">
        <div class="w-10 h-10 rounded-xl bg-utc-blue/10 text-utc-blue flex items-center justify-center font-bold text-lg flex-shrink-0">
            <c:choose>
                <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">
                    <i class="fa-solid fa-crown text-amber-500"></i>
                </c:when>
                <c:when test="${sessionScope.currentUser.role == 'GIANG_VIEN'}">
                    <i class="fa-solid fa-chalkboard-user text-sky-600"></i>
                </c:when>
                <c:otherwise>
                    <i class="fa-solid fa-user-graduate text-emerald-600"></i>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="min-w-0 flex-1">
            <div class="font-bold text-slate-800 text-sm truncate">${sessionScope.currentUser.fullName}</div>
            <div class="text-xs text-slate-500 truncate">
                <c:choose>
                    <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">
                        Phòng Đào Tạo (Admin)
                    </c:when>
                    <c:when test="${sessionScope.currentUser.role == 'GIANG_VIEN'}">
                        Giảng Viên (${sessionScope.currentLecturer.lecturerId})
                    </c:when>
                    <c:otherwise>
                        Sinh Viên (${sessionScope.currentStudent.studentId})
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Scrollable Navigation Links -->
    <div class="flex-1 overflow-y-auto p-3 space-y-1 text-sm font-medium">
        <!-- ADMIN MENU -->
        <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/admin/dashboard" 
               class="flex items-center px-3.5 py-2.5 rounded-xl transition ${activeMenu == 'dashboard' ? 'bg-utc-blue text-white shadow-sm font-bold' : 'text-slate-700 hover:bg-slate-100'}">
                <i class="fa-solid fa-chart-pie w-5 mr-2.5"></i>
                <span>Tổng quan</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" 
               class="flex items-center px-3.5 py-2.5 rounded-xl transition ${activeMenu == 'users' ? 'bg-utc-blue text-white shadow-sm font-bold' : 'text-slate-700 hover:bg-slate-100'}">
                <i class="fa-solid fa-users-gear w-5 mr-2.5 text-cyan-600"></i>
                <span>Quản lý Tài khoản</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/academic-classes" 
               class="flex items-center px-3.5 py-2.5 rounded-xl transition ${activeMenu == 'academic-classes' ? 'bg-utc-blue text-white shadow-sm font-bold' : 'text-slate-700 hover:bg-slate-100'}">
                <i class="fa-solid fa-school w-5 mr-2.5 text-teal-600"></i>
                <span>Lớp chuyên ngành & SV</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/classes" 
               class="flex items-center px-3.5 py-2.5 rounded-xl transition ${activeMenu == 'classes' ? 'bg-utc-blue text-white shadow-sm font-bold' : 'text-slate-700 hover:bg-slate-100'}">
                <i class="fa-solid fa-chalkboard w-5 mr-2.5 text-indigo-500"></i>
                <span>Lớp học phần</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/schedules" 
               class="flex items-center justify-between px-3.5 py-2.5 rounded-xl transition ${activeMenu == 'schedules' ? 'bg-utc-blue text-white shadow-sm font-bold' : 'text-slate-700 hover:bg-slate-100'}">
                <div class="flex items-center">
                    <i class="fa-solid fa-calendar-days w-5 mr-2.5 text-rose-500"></i>
                    <span>Thời Khóa Biểu & Lịch Học</span>
                </div>
                <c:if test="${pendingLeavesCount > 0}">
                    <span class="px-2 py-0.5 rounded-full text-[10px] font-bold bg-rose-500 text-white animate-pulse">
                        ${pendingLeavesCount}
                    </span>
                </c:if>
            </a>
            <a href="${pageContext.request.contextPath}/admin/grade-approval" 
               class="flex items-center px-3.5 py-2.5 rounded-xl transition ${activeMenu == 'approval' ? 'bg-utc-blue text-white shadow-sm font-bold' : 'text-slate-700 hover:bg-slate-100'}">
                <i class="fa-solid fa-clipboard-check w-5 mr-2.5 text-emerald-500"></i>
                <span>Duyệt & Công bố điểm</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/faculty-grades" 
               class="flex items-center px-3.5 py-2.5 rounded-xl transition ${activeMenu == 'faculty-grades' ? 'bg-utc-blue text-white shadow-sm font-bold' : 'text-slate-700 hover:bg-slate-100'}">
                <i class="fa-solid fa-layer-group w-5 mr-2.5 text-blue-600"></i>
                <span>Điểm theo Khoa & Lớp</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/appeals" 
               class="flex items-center px-3.5 py-2.5 rounded-xl transition ${activeMenu == 'appeals' ? 'bg-utc-blue text-white shadow-sm font-bold' : 'text-slate-700 hover:bg-slate-100'}">
                <i class="fa-solid fa-file-pen w-5 mr-2.5 text-amber-500"></i>
                <span>Xử lý Phúc khảo</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/subjects" 
               class="flex items-center px-3.5 py-2.5 rounded-xl transition ${activeMenu == 'subjects' ? 'bg-utc-blue text-white shadow-sm font-bold' : 'text-slate-700 hover:bg-slate-100'}">
                <i class="fa-solid fa-book-bookmark w-5 mr-2.5 text-sky-500"></i>
                <span>Quản lý Môn học</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/statistics" 
               class="flex items-center px-3.5 py-2.5 rounded-xl transition ${activeMenu == 'statistics' ? 'bg-utc-blue text-white shadow-sm font-bold' : 'text-slate-700 hover:bg-slate-100'}">
                <i class="fa-solid fa-chart-column w-5 mr-2.5 text-purple-500"></i>
                <span>Báo cáo & Phổ điểm</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/audit-logs" 
               class="flex items-center px-3.5 py-2.5 rounded-xl transition ${activeMenu == 'audit' ? 'bg-utc-blue text-white shadow-sm font-bold' : 'text-slate-700 hover:bg-slate-100'}">
                <i class="fa-solid fa-clock-rotate-left w-5 mr-2.5 text-rose-500"></i>
                <span>Nhật ký sửa điểm</span>
            </a>
        </c:if>

        <!-- LECTURER MENU -->
        <c:if test="${sessionScope.currentUser.role == 'GIANG_VIEN'}">
            <a href="${pageContext.request.contextPath}/lecturer/classes" 
               class="flex items-center px-3.5 py-2.5 rounded-xl transition ${activeMenu == 'classes' ? 'bg-utc-blue text-white shadow-sm font-bold' : 'text-slate-700 hover:bg-slate-100'}">
                <i class="fa-solid fa-folder-open w-5 mr-2.5 text-sky-500"></i>
                <span>Lớp học phần phụ trách</span>
            </a>
            <a href="${pageContext.request.contextPath}/lecturer/schedule" 
               class="flex items-center px-3.5 py-2.5 rounded-xl transition ${activeMenu == 'schedule' ? 'bg-utc-blue text-white shadow-sm font-bold' : 'text-slate-700 hover:bg-slate-100'}">
                <i class="fa-solid fa-calendar-check w-5 mr-2.5 text-emerald-500"></i>
                <span>Lịch Dạy & Giảng Đường</span>
            </a>
        </c:if>

        <!-- STUDENT MENU -->
        <c:if test="${sessionScope.currentUser.role == 'SINH_VIEN'}">
            <a href="${pageContext.request.contextPath}/student/schedule" 
               class="flex items-center px-3.5 py-2.5 rounded-xl transition ${activeMenu == 'schedule' ? 'bg-utc-blue text-white shadow-sm font-bold' : 'text-slate-700 hover:bg-slate-100'}">
                <i class="fa-solid fa-calendar-days w-5 mr-2.5 text-indigo-500"></i>
                <span>Thời Khóa Biểu & Lịch Thi</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/grades" 
               class="flex items-center px-3.5 py-2.5 rounded-xl transition ${activeMenu == 'grades' ? 'bg-utc-blue text-white shadow-sm font-bold' : 'text-slate-700 hover:bg-slate-100'}">
                <i class="fa-solid fa-table-list w-5 mr-2.5 text-emerald-500"></i>
                <span>Bảng điểm học tập</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/appeals" 
               class="flex items-center px-3.5 py-2.5 rounded-xl transition ${activeMenu == 'appeals' ? 'bg-utc-blue text-white shadow-sm font-bold' : 'text-slate-700 hover:bg-slate-100'}">
                <i class="fa-solid fa-file-pen w-5 mr-2.5 text-amber-500"></i>
                <span>Đơn phúc khảo điểm</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/print-transcript" 
               target="_blank"
               class="flex items-center px-3.5 py-2.5 rounded-xl text-slate-700 hover:bg-slate-100 transition">
                <i class="fa-solid fa-print w-5 mr-2.5 text-blue-500"></i>
                <span>In bảng điểm chính thức</span>
            </a>
        </c:if>

        <!-- Quick Help UTC Box in Drawer -->
        <div class="mt-4 p-3 bg-slate-50 rounded-xl border border-slate-200 text-xs text-slate-600">
            <div class="font-semibold text-slate-800 mb-1 flex items-center">
                <i class="fa-solid fa-circle-info text-utc-blue mr-1.5"></i>Quy chế tín chỉ UTC
            </div>
            <p class="leading-relaxed text-[11px]">
                Đạt từ điểm <strong>D (1.0)</strong> hoặc <strong>4.0/10</strong> trở lên. Điểm CPA tính thang 4.0.
            </p>
        </div>
    </div>

    <!-- Drawer Footer Actions -->
    <div class="p-3 bg-slate-50 border-t border-slate-200 flex items-center gap-2">
        <a href="${pageContext.request.contextPath}/change-password" 
           class="flex-1 py-2 px-3 rounded-xl bg-slate-200/80 hover:bg-slate-300 text-slate-700 text-xs font-bold text-center transition flex items-center justify-center space-x-1">
            <i class="fa-solid fa-key text-slate-500"></i>
            <span>Đổi MK</span>
        </a>
        <a href="${pageContext.request.contextPath}/logout" 
           class="flex-1 py-2 px-3 rounded-xl bg-rose-600 hover:bg-rose-700 text-white text-xs font-bold text-center transition flex items-center justify-center space-x-1 shadow-xs">
            <i class="fa-solid fa-right-from-bracket"></i>
            <span>Đăng xuất</span>
        </a>
    </div>
</div>

<script>
    function toggleMobileMenu() {
        const drawer = document.getElementById('mobileDrawer');
        const backdrop = document.getElementById('mobileDrawerBackdrop');
        if (!drawer || !backdrop) return;
        const isClosed = drawer.classList.contains('-translate-x-full');
        if (isClosed) {
            drawer.classList.remove('-translate-x-full');
            backdrop.classList.remove('hidden');
            document.body.classList.add('overflow-hidden');
        } else {
            closeMobileMenu();
        }
    }

    function closeMobileMenu() {
        const drawer = document.getElementById('mobileDrawer');
        const backdrop = document.getElementById('mobileDrawerBackdrop');
        if (!drawer || !backdrop) return;
        drawer.classList.add('-translate-x-full');
        backdrop.classList.add('hidden');
        document.body.classList.remove('overflow-hidden');
    }

    // Close mobile drawer on Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeMobileMenu();
        }
    });
</script>
