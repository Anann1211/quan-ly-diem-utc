<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Đổi mật khẩu" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="max-w-xl mx-auto">
    <div class="bg-white rounded-2xl shadow-sm border border-slate-200 p-4 sm:p-6 md:p-8">
        <div class="flex items-center gap-3 pb-5 sm:pb-6 border-b border-slate-200 mb-5 sm:mb-6">
            <div class="w-10 h-10 sm:w-12 sm:h-12 rounded-xl bg-blue-50 text-utc-blue flex items-center justify-center text-lg sm:text-xl flex-shrink-0">
                <i class="fa-solid fa-key"></i>
            </div>
            <div>
                <h1 class="text-lg sm:text-xl font-bold text-slate-800">Đổi Mật Khẩu</h1>
                <p class="text-xs text-slate-500">Cập nhật mật khẩu bảo mật tài khoản cá nhân</p>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="mb-5 p-3.5 rounded-xl bg-rose-50 border border-rose-200 text-rose-700 text-sm flex items-center space-x-2">
                <i class="fa-solid fa-circle-exclamation flex-shrink-0"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="mb-5 p-3.5 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-700 text-sm flex items-center space-x-2">
                <i class="fa-solid fa-circle-check flex-shrink-0"></i>
                <span>${success}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/change-password" method="POST" class="space-y-4">
            <div>
                <label class="block text-xs font-semibold uppercase tracking-wider text-slate-600 mb-1.5" for="oldPassword">
                    Mật khẩu hiện tại
                </label>
                <input type="password" id="oldPassword" name="oldPassword" required
                       class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-utc-blue focus:border-utc-blue text-sm">
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase tracking-wider text-slate-600 mb-1.5" for="newPassword">
                    Mật khẩu mới
                </label>
                <input type="password" id="newPassword" name="newPassword" required
                       class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-utc-blue focus:border-utc-blue text-sm">
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase tracking-wider text-slate-600 mb-1.5" for="confirmPassword">
                    Xác nhận mật khẩu mới
                </label>
                <input type="password" id="confirmPassword" name="confirmPassword" required
                       class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-utc-blue focus:border-utc-blue text-sm">
            </div>

            <div class="pt-4">
                <button type="submit" 
                        class="w-full py-2.5 px-4 rounded-xl bg-utc-blue hover:bg-utc-dark text-white font-semibold text-sm shadow transition flex items-center justify-center space-x-2">
                    <i class="fa-solid fa-check"></i>
                    <span>Cập nhật Mật khẩu</span>
                </button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
