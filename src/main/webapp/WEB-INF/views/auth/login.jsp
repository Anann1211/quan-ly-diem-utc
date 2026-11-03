<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Cổng Quản lý Điểm UTC</title>
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
                            gold: '#f1c40f'
                        }
                    }
                }
            }
        }
    </script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="icon" type="image/webp" href="${pageContext.request.contextPath}/assets/images/utc-logo.webp">
    <style> 
    body { font-family: 'Inter', sans-serif; }
    .hd-campus-bg {
        width: 100vw;
        height: 100vh;
        object-fit: cover;
        /* Căn vị trí lấy nét ưu tiên vào cụm 2 tòa nhà bên phải khung đăng nhập */
        object-position: 65% center; 
        /* Tăng nhẹ độ tương phản viền để tranh vẽ 2D đanh nét khi thu nhỏ từ 2752px */
        filter: contrast(1.04) saturate(1.05);
    }
</style>
</head>
<body class="min-h-screen relative flex items-center justify-center md:justify-start md:pl-10 lg:pl-16 xl:pl-24 p-4 sm:p-6 bg-slate-950 overflow-x-hidden selection:bg-utc-blue selection:text-white">

    <!-- Campus Background Image -->
<div class="fixed inset-0 z-0 overflow-hidden pointer-events-none">
    <img src="${pageContext.request.contextPath}/assets/images/utc-campus.jpg?v=99" 
         alt="Khuôn viên Trường Đại học Giao thông Vận tải" 
         class="hd-campus-bg select-none"
         fetchpriority="high" />
</div>

<!-- Giảm lớp phủ tối xuống thật nhẹ để không làm đục màu ảnh -->
<div class="fixed inset-0 z-0 bg-gradient-to-r from-slate-950/40 via-transparent to-transparent md:via-[25%] pointer-events-none"></div>
    <!-- Login Container Aligned on Left -->
    <div class="relative z-10 max-w-md w-full my-auto">
        <!-- Solid Clean Login Card -->
        <div class="bg-white rounded-3xl shadow-2xl border border-slate-200/90 p-5 sm:p-7 transition-all">
            <!-- Brand Header inside Card -->
            <div class="flex items-center space-x-3.5 pb-4 border-b border-slate-100 mb-5">
                <img src="${pageContext.request.contextPath}/assets/images/utc-logo.webp" 
                     alt="Logo UTC" 
                     class="w-13 h-13 sm:w-14 sm:h-14 object-contain rounded-full shadow-md bg-white p-1 border-2 border-utc-gold/70 flex-shrink-0 hover:scale-105 transition-transform">
                <div class="min-w-0">
                    <div class="text-[10px] sm:text-[11px] uppercase font-bold tracking-wider text-utc-blue">
                        TRƯỜNG ĐẠI HỌC GIAO THÔNG VẬN TẢI
                    </div>
                    <h1 class="text-base sm:text-lg font-black text-slate-800 tracking-tight leading-snug">
                        CỔNG QUẢN LÝ ĐÀO TẠO
                    </h1>
                    <p class="text-[11px] text-slate-500 font-medium">Hệ thống Điểm Sinh viên theo Tín chỉ</p>
                </div>
            </div>

            <!-- Error message alert -->
            <c:if test="${not empty error}">
                <div class="mb-4 p-3 rounded-xl bg-rose-50 border border-rose-200 text-rose-700 text-xs sm:text-sm flex items-center space-x-2">
                    <i class="fa-solid fa-circle-exclamation flex-shrink-0 text-base"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <c:if test="${param.msg == 'logged_out'}">
                <div class="mb-4 p-3 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-700 text-xs sm:text-sm flex items-center space-x-2">
                    <i class="fa-solid fa-circle-check flex-shrink-0 text-base"></i>
                    <span>Bạn đã đăng xuất an toàn khỏi hệ thống!</span>
                </div>
            </c:if>

            <!-- Form -->
            <form id="loginForm" action="${pageContext.request.contextPath}/login" method="POST" class="space-y-4">
                <div>
                    <label class="block text-xs font-semibold uppercase tracking-wider text-slate-600 mb-1.5" for="username">
                        Tên đăng nhập / Mã SV / Mã GV
                    </label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400">
                            <i class="fa-regular fa-user"></i>
                        </span>
                        <input type="text" id="username" name="username" value="${username}" required autofocus
                               class="w-full pl-10 pr-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-utc-blue/30 focus:border-utc-blue transition text-sm bg-slate-50 focus:bg-white"
                               placeholder="Nhập tên đăng nhập...">
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-semibold uppercase tracking-wider text-slate-600 mb-1.5" for="password">
                        Mật khẩu
                    </label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400">
                            <i class="fa-solid fa-lock"></i>
                        </span>
                        <input type="password" id="password" name="password" required
                               class="w-full pl-10 pr-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-utc-blue/30 focus:border-utc-blue transition text-sm bg-slate-50 focus:bg-white"
                               placeholder="••••••••">
                    </div>
                </div>

                <button type="submit" 
                        class="w-full py-3 px-4 rounded-xl bg-gradient-to-r from-utc-blue to-utc-dark hover:from-utc-dark hover:to-utc-blue text-white font-semibold text-sm shadow-md hover:shadow-lg hover:scale-[1.01] active:scale-[0.99] transition duration-200 flex items-center justify-center space-x-2">
                    <i class="fa-solid fa-arrow-right-to-bracket"></i>
                    <span>ĐĂNG NHẬP</span>
                </button>
            </form>

            <!-- Demo Fast Login Chips -->
            <div class="mt-5 pt-4 border-t border-slate-200">
                <div class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-2.5 flex items-center justify-between">
                    <span>Đăng nhập nhanh thử nghiệm:</span>
                    <span class="text-[10px] text-utc-blue bg-blue-50 px-2 py-0.5 rounded-full font-bold">1-Click</span>
                </div>
                <div class="grid grid-cols-1 sm:grid-cols-3 gap-2 text-xs">
                    <button type="button" onclick="quickLogin('admin', 'admin123')"
                            class="p-2 sm:p-2 rounded-xl bg-amber-50 hover:bg-amber-100 border border-amber-200 text-amber-900 font-medium transition text-center flex sm:flex-col items-center justify-between sm:justify-center">
                        <div class="font-bold text-xs sm:text-[11px] flex items-center"><i class="fa-solid fa-shield-halved mr-1.5 sm:mr-1"></i>Admin</div>
                        <div class="text-[11px] sm:text-[10px] text-amber-700">admin / admin123</div>
                    </button>
                    <button type="button" onclick="quickLogin('gv_nguyenvanan', 'gv123')"
                            class="p-2 sm:p-2 rounded-xl bg-sky-50 hover:bg-sky-100 border border-sky-200 text-sky-900 font-medium transition text-center flex sm:flex-col items-center justify-between sm:justify-center">
                        <div class="font-bold text-xs sm:text-[11px] flex items-center"><i class="fa-solid fa-chalkboard-user mr-1.5 sm:mr-1"></i>Giảng viên</div>
                        <div class="text-[11px] sm:text-[10px] text-sky-700">gv_nguyenvanan</div>
                    </button>
                    <button type="button" onclick="quickLogin('211200001', 'sv123')"
                            class="p-2 sm:p-2 rounded-xl bg-emerald-50 hover:bg-emerald-100 border border-emerald-200 text-emerald-900 font-medium transition text-center flex sm:flex-col items-center justify-between sm:justify-center">
                        <div class="font-bold text-xs sm:text-[11px] flex items-center"><i class="fa-solid fa-user-graduate mr-1.5 sm:mr-1"></i>Sinh viên</div>
                        <div class="text-[11px] sm:text-[10px] text-emerald-700">211200001</div>
                    </button>
                </div>
            </div>
        </div>

        <p class="text-center text-xs text-white/80 mt-4 drop-shadow">
            Trường ĐH Giao thông Vận tải &copy; 2026. Hỗ trợ: <a href="mailto:daotao@utc.edu.vn" class="text-amber-300 underline font-medium hover:text-amber-200">daotao@utc.edu.vn</a>
        </p>
    </div>

    <!-- Floating Campus Location Tag (Desktop only) -->
    <div class="hidden xl:flex fixed bottom-6 right-8 z-10 items-center space-x-2.5 px-4 py-2 rounded-full bg-slate-900 border border-slate-700 text-white shadow-xl text-xs">
        <span class="w-2 h-2 rounded-full bg-amber-400 animate-pulse"></span>
        <span class="font-medium text-slate-300">Trụ sở chính:</span>
        <span class="font-bold text-white">Số 3 Cầu Giấy, Láng Thượng, Đống Đa, Hà Nội</span>
    </div>

    <script>
        function quickLogin(u, p) {
            var form = document.getElementById('loginForm') || document.querySelector('form');
            var uInput = document.getElementById('username');
            var pInput = document.getElementById('password');
            if (uInput && pInput && form) {
                uInput.value = u;
                pInput.value = p;
                form.submit();
            }
        }
    </script>
</body>
</html>