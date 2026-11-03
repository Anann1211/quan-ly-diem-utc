<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Nhật Ký Sửa Điểm (Audit Log)" />
<c:set var="activeMenu" value="audit" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Header -->
    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm">
        <h1 class="text-xl font-bold text-slate-800 flex items-center">
            <i class="fa-solid fa-clock-rotate-left text-rose-600 mr-2.5"></i>Nhật Ký Biến Động Điểm (Audit Log)
        </h1>
        <p class="text-xs text-slate-500 mt-1">Lưu vết toàn bộ thao tác điều chỉnh điểm sau khi công bố hoặc phúc khảo nhằm đảm bảo tính minh bạch tuyệt đối</p>
    </div>

    <!-- Logs Table -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs text-slate-600">
                <thead class="bg-slate-50 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                    <tr>
                        <th class="px-4 py-3.5">Mã Log</th>
                        <th class="px-4 py-3.5">Thời Gian</th>
                        <th class="px-4 py-3.5">Người Thực Hiện</th>
                        <th class="px-4 py-3.5">Sinh Viên</th>
                        <th class="px-4 py-3.5">Lớp Học Phần</th>
                        <th class="px-4 py-3.5">Điểm Cũ</th>
                        <th class="px-4 py-3.5">Điểm Mới Sau Sửa</th>
                        <th class="px-4 py-3.5">Lý Do Điều Chỉnh</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="log" items="${logs}">
                        <tr class="hover:bg-slate-50/80">
                            <td class="px-4 py-3 font-semibold text-slate-400">#${log.id}</td>
                            <td class="px-4 py-3 font-medium text-slate-700 whitespace-nowrap">
                                ${log.modifiedTime}
                            </td>
                            <td class="px-4 py-3 font-semibold text-utc-blue">
                                <i class="fa-solid fa-user-shield mr-1 text-slate-400"></i>${log.modifiedBy}
                            </td>
                            <td class="px-4 py-3">
                                <div class="font-bold text-slate-800">${log.studentName}</div>
                                <div class="text-[10px] text-slate-500">${log.studentId}</div>
                            </td>
                            <td class="px-4 py-3 font-medium text-slate-700">${log.courseClassName}</td>
                            <td class="px-4 py-3 text-rose-600 font-semibold">${log.oldScore}</td>
                            <td class="px-4 py-3 text-emerald-600 font-bold">${log.newScore}</td>
                            <td class="px-4 py-3 text-slate-700 max-w-xs" title="${log.reason}">
                                <div class="line-clamp-2">${log.reason}</div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty logs}">
                        <tr>
                            <td colspan="8" class="px-4 py-10 text-center text-slate-400">Chưa có lịch sử biến động điểm nào được ghi nhận.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
