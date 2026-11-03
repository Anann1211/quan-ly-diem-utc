<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Lớp Học Phần Phụ Trách" />
<c:set var="activeMenu" value="classes" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Header & Filter -->
    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
            <h1 class="text-xl font-bold text-slate-800 flex items-center">
                <i class="fa-solid fa-folder-open text-sky-600 mr-2.5"></i>Lớp Học Phần Được Phân Công Giảng Dạy
            </h1>
            <p class="text-xs text-slate-500 mt-1">Giảng viên: <strong>${sessionScope.currentLecturer.academicRank} ${sessionScope.currentLecturer.fullName}</strong> (${sessionScope.currentLecturer.facultyName})</p>
        </div>

        <!-- Semester Filter -->
        <form action="${pageContext.request.contextPath}/lecturer/classes" method="GET" class="w-full sm:w-auto">
            <select name="semesterId" onchange="this.form.submit()" 
                    class="w-full sm:w-auto px-3.5 py-2 rounded-xl border border-slate-300 text-xs font-semibold focus:ring-2 focus:ring-utc-blue bg-slate-50">
                <option value="">Tất cả học kỳ</option>
                <c:forEach var="sem" items="${semesters}">
                    <option value="${sem.semesterId}" ${selectedSemester == sem.semesterId ? 'selected' : ''}>
                        ${sem.displayName}
                    </option>
                </c:forEach>
            </select>
        </form>
    </div>

    <!-- Class Cards Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        <c:forEach var="c" items="${classes}">
            <div class="bg-white rounded-2xl border border-slate-200 shadow-sm hover:shadow-md transition p-5 flex flex-col justify-between">
                <div>
                    <!-- Header card -->
                    <div class="flex items-start justify-between mb-3">
                        <span class="text-xs font-bold px-2.5 py-1 rounded-lg bg-blue-50 text-utc-blue">
                            ${c.classId}
                        </span>
                        <div>${c.statusBadge}</div>
                    </div>

                    <!-- Course Title -->
                    <h3 class="font-bold text-slate-800 text-base mb-1">${c.className}</h3>
                    <p class="text-xs text-slate-500 mb-4">${c.subjectName} • <strong>${c.credits} Tín chỉ</strong></p>

                    <!-- Details -->
                    <div class="space-y-1.5 text-xs text-slate-600 pb-4 border-b border-slate-100 mb-4">
                        <div class="flex items-center justify-between">
                            <span class="text-slate-400">Học kỳ:</span>
                            <span class="font-medium text-slate-700">${c.semesterName} (${c.academicYear})</span>
                        </div>
                        <div class="flex items-center justify-between">
                            <span class="text-slate-400">Phòng học:</span>
                            <span class="font-medium text-slate-700">${c.room}</span>
                        </div>
                        <div class="flex items-center justify-between">
                            <span class="text-slate-400">Sĩ số sinh viên:</span>
                            <span class="font-bold text-slate-800">${c.enrolledCount} sinh viên</span>
                        </div>
                        <div class="flex items-center justify-between">
                            <span class="text-slate-400">Trọng số đề cương:</span>
                            <span class="font-medium text-utc-blue">CC ${c.weightAttendance * 100}% - GK ${c.weightMidterm * 100}% - Thi ${c.weightFinal * 100}%</span>
                        </div>
                    </div>
                </div>

                <!-- Action Button -->
                <div class="flex items-center space-x-2">
                    <a href="${pageContext.request.contextPath}/lecturer/grade-input?classId=${c.classId}"
                       class="flex-1 py-2.5 px-3 rounded-xl bg-utc-blue hover:bg-utc-dark text-white text-xs font-bold shadow text-center transition flex items-center justify-center space-x-1.5">
                        <i class="fa-solid fa-pen-to-square"></i>
                        <span>Vào Sổ Điểm</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/lecturer/export-excel?classId=${c.classId}"
                       class="p-2.5 rounded-xl border border-slate-300 hover:bg-slate-100 text-slate-600 text-xs font-semibold transition"
                       title="Xuất Excel bảng điểm mẫu">
                        <i class="fa-solid fa-file-excel text-emerald-600 text-sm"></i>
                    </a>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${empty classes}">
        <div class="bg-white rounded-xl border border-slate-200 p-12 text-center shadow-sm">
            <div class="w-16 h-16 rounded-full bg-slate-100 text-slate-400 flex items-center justify-center text-2xl mx-auto mb-3">
                <i class="fa-solid fa-chalkboard-user"></i>
            </div>
            <h3 class="text-base font-bold text-slate-700">Chưa có lớp học phần nào được phân công</h3>
            <p class="text-xs text-slate-400 mt-1">Vui lòng liên hệ Phòng Đào Tạo để kiểm tra lịch phân công giảng dạy.</p>
        </div>
    </c:if>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
