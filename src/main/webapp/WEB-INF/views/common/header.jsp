<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'Hệ thống Quản lý Điểm'} - ĐH Giao Thông Vận Tải</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        utc: {
                            blue: '#003366',
                            dark: '#002244',
                            light: '#0b5394',
                            red: '#c0392b',
                            accent: '#e74c3c',
                            gold: '#f1c40f'
                        }
                    }
                }
            }
        }
    </script>
    <!-- Font Awesome 6 Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="icon" type="image/webp" href="${pageContext.request.contextPath}/assets/images/utc-logo.webp">
    <style>
        body { font-family: 'Inter', sans-serif; }
        @media print {
            .no-print { display: none !important; }
        }
    </style>
</head>
<body class="bg-slate-50 text-slate-800 flex flex-col min-h-screen">

    <!-- Top Navigation Bar -->
    <header class="bg-utc-blue text-white shadow-md sticky top-0 z-50 no-print">
        <div class="max-w-7xl mx-auto px-3 sm:px-6 lg:px-8">
            <div class="flex items-center justify-between h-16 gap-2">
                <!-- Logo & Brand -->
                <a href="${pageContext.request.contextPath}/" class="flex items-center space-x-2.5 sm:space-x-3 min-w-0 flex-shrink hover:opacity-95 transition">
                    <img src="${pageContext.request.contextPath}/assets/images/utc-logo.webp" 
                         alt="Logo UTC" 
                         class="w-10 h-10 sm:w-11 sm:h-11 object-contain rounded-full shadow-md bg-white p-0.5 border-2 border-utc-gold hover:scale-105 transition-transform flex-shrink-0">
                    <div class="min-w-0">
                        <div class="text-[10px] sm:text-xs uppercase tracking-wider text-slate-300 font-medium truncate hidden sm:block">Trường Đại học Giao thông Vận tải</div>
                        <div class="text-sm sm:text-lg font-bold tracking-tight text-white flex items-center">
                            <span class="truncate">UTC GRADE PORTAL</span>
                            <span class="ml-1.5 sm:ml-2 px-1.5 py-0.5 text-[9px] sm:text-[10px] bg-utc-red font-semibold rounded uppercase whitespace-nowrap">Tín Chỉ</span>
                        </div>
                    </div>
                </a>

                <!-- User Profile & Actions -->
                <div class="flex items-center space-x-1.5 sm:space-x-3 flex-shrink-0">
                    <c:if test="${not empty sessionScope.currentUser}">
                        <div class="hidden md:flex flex-col text-right">
                            <span class="text-sm font-semibold truncate max-w-[160px]">${sessionScope.currentUser.fullName}</span>
                            <span class="text-xs text-slate-300">
                                <c:choose>
                                    <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">
                                        <i class="fa-solid fa-shield-halved text-amber-400 mr-1"></i>Phòng Đào Tạo
                                    </c:when>
                                    <c:when test="${sessionScope.currentUser.role == 'GIANG_VIEN'}">
                                        <i class="fa-solid fa-chalkboard-user text-sky-400 mr-1"></i>Giảng Viên
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fa-solid fa-user-graduate text-emerald-400 mr-1"></i>Sinh Viên (${sessionScope.currentStudent.studentId})
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <!-- Dropdown Menu / Buttons -->
                        <div class="flex items-center gap-1.5 sm:gap-2">
                            <a href="${pageContext.request.contextPath}/change-password" 
                               title="Đổi mật khẩu"
                               class="p-2 rounded-lg bg-utc-dark/60 hover:bg-utc-dark text-slate-200 transition">
                                <i class="fa-solid fa-key text-xs sm:text-sm"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/logout" 
                               title="Đăng xuất"
                               class="py-2 px-2.5 sm:px-3 rounded-lg bg-rose-600/80 hover:bg-rose-700 text-white transition flex items-center space-x-1 text-xs sm:text-sm font-medium">
                                <i class="fa-solid fa-right-from-bracket"></i>
                                <span class="hidden sm:inline">Thoát</span>
                            </a>
                            <!-- Mobile Hamburger Menu Toggle Button -->
                            <button type="button" onclick="toggleMobileMenu()" 
                                    class="md:hidden p-2 rounded-lg bg-utc-dark/70 hover:bg-utc-dark text-white transition focus:outline-none flex items-center justify-center"
                                    aria-label="Mở menu chức năng">
                                <i class="fa-solid fa-bars text-base"></i>
                            </button>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Container Layout with Sidebar -->
    <div class="flex-1 flex max-w-7xl w-full mx-auto px-3 sm:px-6 lg:px-8 py-4 sm:py-6 gap-4 sm:gap-6">
        <c:if test="${not empty sessionScope.currentUser}">
            <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
        </c:if>
        <main class="flex-1 overflow-x-hidden min-w-0">
