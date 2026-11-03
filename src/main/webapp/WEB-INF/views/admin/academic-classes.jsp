<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Quản Lý Lớp Chuyên Ngành & Sinh Viên" />
<c:set var="activeMenu" value="academic-classes" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Alert Messages -->
    <c:if test="${not empty sessionScope.importSuccessMsg}">
        <div class="p-4 bg-emerald-50 border border-emerald-200 text-emerald-800 rounded-xl text-xs font-semibold flex items-start space-x-3 shadow-xs">
            <i class="fa-solid fa-circle-check text-emerald-600 text-lg mt-0.5 flex-shrink-0"></i>
            <div>
                <div class="font-bold text-sm text-emerald-900 mb-0.5">Thành Công!</div>
                <div class="text-xs text-emerald-700 leading-relaxed">${sessionScope.importSuccessMsg}</div>
            </div>
        </div>
        <c:remove var="importSuccessMsg" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.importErrors}">
        <div class="p-4 bg-rose-50 border border-rose-200 text-rose-800 rounded-xl text-xs font-medium shadow-xs space-y-2.5">
            <div class="flex items-center justify-between flex-wrap gap-2">
                <div class="flex items-center space-x-2 text-rose-900 font-bold text-sm">
                    <i class="fa-solid fa-triangle-exclamation text-rose-600 text-base"></i>
                    <span>Nhập danh sách sinh viên từ Excel không thành công (Phát hiện ${sessionScope.importErrors.size()} lỗi thao tác):</span>
                </div>
                <button type="button" onclick="openImportExcelModal()" class="px-3 py-1 bg-rose-600 hover:bg-rose-700 text-white rounded-lg text-[11px] font-bold shadow-xs transition inline-flex items-center space-x-1">
                    <i class="fa-solid fa-rotate-right"></i>
                    <span>Tải Lên Lại</span>
                </button>
            </div>
            <p class="text-[11px] text-rose-700 leading-relaxed">
                Hệ thống đã dừng nhập để đảm bảo toàn vẹn dữ liệu. Vui lòng kiểm tra và sửa lại các vị trí lỗi dưới đây trong tệp Excel trước khi thực hiện tải lên lại:
            </p>
            <div class="bg-white p-3.5 rounded-xl border border-rose-200 max-h-64 overflow-y-auto">
                <ul class="space-y-1.5 text-rose-700 text-[11px]">
                    <c:forEach var="err" items="${sessionScope.importErrors}">
                        <li class="flex items-start space-x-2">
                            <i class="fa-solid fa-circle-xmark text-rose-500 mt-0.5 text-xs flex-shrink-0"></i>
                            <span class="font-medium">${err}</span>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
        <c:remove var="importErrors" scope="session" />
    </c:if>

    <c:if test="${not empty param.msg}">
        <div class="p-3.5 bg-emerald-50 border border-emerald-200 text-emerald-700 rounded-xl text-xs font-semibold flex items-center">
            <i class="fa-solid fa-circle-check mr-2 text-sm text-emerald-500"></i>
            <c:choose>
                <c:when test="${param.msg == 'class_added'}">Thêm lớp chuyên ngành mới thành công!</c:when>
                <c:when test="${param.msg == 'class_updated'}">Cập nhật thông tin lớp chuyên ngành thành công!</c:when>
                <c:when test="${param.msg == 'class_deleted'}">Đã xóa lớp chuyên ngành thành công!</c:when>
                <c:when test="${param.msg == 'student_added'}">Thêm sinh viên vào lớp thành công!</c:when>
                <c:when test="${param.msg == 'imported'}">
                    Nhập Excel thành công: Đã thêm ${param.count} / ${param.total} sinh viên vào lớp!
                </c:when>
                <c:otherwise>Thao tác thực hiện thành công!</c:otherwise>
            </c:choose>
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="p-3.5 bg-rose-50 border border-rose-200 text-rose-700 rounded-xl text-xs font-semibold flex items-center">
            <i class="fa-solid fa-triangle-exclamation mr-2 text-sm text-rose-500"></i>
            <c:choose>
                <c:when test="${param.error == 'class_exists'}">Mã lớp chuyên ngành đã tồn tại trong hệ thống!</c:when>
                <c:when test="${param.error == 'user_exists'}">Mã sinh viên đã tồn tại trong hệ thống!</c:when>
                <c:when test="${param.error == 'empty_fields'}">Vui lòng điền đầy đủ các thông tin bắt buộc!</c:when>
                <c:when test="${param.error == 'no_file'}">Vui lòng chọn tệp Excel (.xlsx) để tải lên!</c:when>
                <c:otherwise>${param.error}</c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <c:choose>
        <%-- ========================================================= --%>
        <%-- CHI TIẾT LỚP CHUYÊN NGÀNH & DANH SÁCH SINH VIÊN            --%>
        <%-- ========================================================= --%>
        <c:when test="${isDetailView}">
            <!-- Breadcrumb & Header -->
            <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <div class="flex items-center space-x-2 text-xs text-slate-400 mb-1">
                        <a href="${pageContext.request.contextPath}/admin/academic-classes" class="hover:text-utc-blue">
                            <i class="fa-solid fa-arrow-left mr-1"></i>Danh sách lớp chuyên ngành
                        </a>
                        <span>/</span>
                        <span class="text-slate-600 font-semibold">${classRoom.classId}</span>
                    </div>
                    <h1 class="text-xl font-bold text-slate-800 flex items-center">
                        <i class="fa-solid fa-users-rectangle text-utc-blue mr-2.5"></i>Lớp: ${classRoom.className}
                    </h1>
                    <p class="text-xs text-slate-500 mt-1">
                        Khóa: <b>K${classRoom.intakeYear}</b> | Ngành: <b>${classRoom.majorName}</b> | Khoa: <b>${classRoom.facultyName}</b> | Sĩ số: <b>${students.size()} sinh viên</b>
                    </p>
                </div>

                <div class="flex flex-wrap items-center gap-2 w-full md:w-auto">
                    <a href="${pageContext.request.contextPath}/admin/academic-classes?action=download_template" 
                       class="flex-1 sm:flex-initial px-3.5 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-bold transition flex items-center justify-center space-x-1.5 shadow-2xs">
                        <i class="fa-solid fa-file-excel text-emerald-600"></i>
                        <span>Tải Mẫu Excel</span>
                    </a>
                    <button type="button" onclick="openImportExcelModal()"
                            class="flex-1 sm:flex-initial px-3.5 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold shadow-xs flex items-center justify-center space-x-1.5 transition">
                        <i class="fa-solid fa-file-import"></i>
                        <span>Nhập DS từ Excel</span>
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/users?tab=student&classId=${classRoom.classId}&openModal=add_student"
                       class="w-full sm:w-auto px-4 py-2 bg-utc-blue hover:bg-utc-dark text-white rounded-xl text-xs font-bold shadow-xs flex items-center justify-center space-x-1.5 transition">
                        <i class="fa-solid fa-user-plus"></i>
                        <span>Thêm Sinh Viên Mới</span>
                    </a>
                </div>
            </div>

            <!-- Student List Table -->
            <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-xs text-slate-600">
                        <thead class="bg-slate-50 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                            <tr>
                                <th class="px-4 py-3.5 text-center">STT</th>
                                <th class="px-4 py-3.5">Mã Sinh Viên</th>
                                <th class="px-4 py-3.5">Họ và tên</th>
                                <th class="px-4 py-3.5 text-center">Ngày sinh</th>
                                <th class="px-4 py-3.5 text-center">Giới tính</th>
                                <th class="px-4 py-3.5">Quê quán</th>
                                <th class="px-4 py-3.5">Email</th>
                                <th class="px-4 py-3.5">Số điện thoại</th>
                                <th class="px-4 py-3.5 text-center">Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-200">
                            <c:forEach var="st" items="${students}" varStatus="loop">
                                <tr class="hover:bg-slate-50/80">
                                    <td class="px-4 py-3 text-center text-slate-400 font-medium">${loop.index + 1}</td>
                                    <td class="px-4 py-3 font-bold text-slate-800 font-mono">${st.studentId}</td>
                                    <td class="px-4 py-3 font-semibold text-slate-800">${st.fullName}</td>
                                    <td class="px-4 py-3 text-center text-slate-600">
                                        <fmt:formatDate value="${st.dateOfBirth}" pattern="dd/MM/yyyy" />
                                    </td>
                                    <td class="px-4 py-3 text-center text-slate-600">${st.gender}</td>
                                    <td class="px-4 py-3 text-slate-600">${st.hometown}</td>
                                    <td class="px-4 py-3 text-slate-600">${st.email}</td>
                                    <td class="px-4 py-3 text-slate-600 font-mono">${st.phone}</td>
                                    <td class="px-4 py-3 text-center">
                                        <span class="inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800">
                                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 mr-1.5"></span>Đang học
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty students}">
                                <tr>
                                    <td colspan="9" class="px-4 py-12 text-center text-slate-400">
                                        <i class="fa-solid fa-users text-4xl mb-2 text-slate-300 block"></i>
                                        Lớp chuyên ngành này chưa có sinh viên nào. Vui lòng thêm sinh viên từ màn hình Quản lý người dùng hoặc nhập từ tệp Excel.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Modal Import Excel -->
            <div id="importExcelModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
                <div class="bg-white rounded-2xl max-w-lg w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
                    <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
                        <h3 class="font-bold text-slate-800 text-xs sm:text-sm flex items-center">
                            <i class="fa-solid fa-file-excel text-emerald-600 mr-2 text-base"></i>Nhập Danh Sách Sinh Viên Từ Excel Vào Lớp
                        </h3>
                        <button type="button" onclick="closeImportExcelModal()" class="text-slate-400 hover:text-slate-600 p-1">
                            <i class="fa-solid fa-xmark text-lg"></i>
                        </button>
                    </div>

                    <form action="${pageContext.request.contextPath}/admin/academic-classes" method="POST" enctype="multipart/form-data" 
                          onsubmit="return validateExcelUpload(this);" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
                        <input type="hidden" name="action" value="import_excel">
                        <input type="hidden" name="classId" value="${classRoom.classId}">

                        <!-- Hướng dẫn & Quy định dữ liệu -->
                        <div class="p-3.5 bg-blue-50 border border-blue-200 rounded-xl text-[11px] text-blue-900 leading-relaxed space-y-1.5">
                            <div class="font-bold text-utc-blue flex items-center text-xs">
                                <i class="fa-solid fa-circle-info mr-1.5 text-base"></i>Quy định nhập dữ liệu từ tệp mẫu:
                            </div>
                            <ul class="list-disc list-inside space-y-1 text-slate-700">
                                <li>Cột <b>Mã SV (*)</b> & <b>Họ và tên (*)</b> là <b>thông tin bắt buộc</b>.</li>
                                <li>Ngày sinh: định dạng chuẩn <b>dd/MM/yyyy</b> (ví dụ: <i>15/05/2003</i>).</li>
                                <li>Giới tính: chỉ nhập <b>Nam</b> hoặc <b>Nữ</b> (để trống mặc định là Nam).</li>
                                <li>Nếu chưa có tệp mẫu, vui lòng <a href="${pageContext.request.contextPath}/admin/academic-classes?action=download_template" class="text-utc-blue underline font-bold hover:text-utc-dark">bấm vào đây để tải Tệp Mẫu Excel</a>.</li>
                            </ul>
                        </div>

                        <div>
                            <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Chọn tệp Excel đã điền dữ liệu (*.xlsx, *.xls)</label>
                            <input type="file" id="excelFileInput" name="excelFile" accept=".xlsx, .xls" required
                                   class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue bg-slate-50 cursor-pointer file:mr-3 file:py-1 file:px-3 file:rounded-lg file:border-0 file:text-xs file:font-semibold file:bg-utc-blue file:text-white hover:file:bg-utc-dark">
                            <div id="fileErrorMsg" class="text-[11px] text-rose-600 font-semibold mt-1 hidden"></div>
                        </div>

                        <div class="flex flex-wrap items-center justify-end gap-2 pt-3 border-t border-slate-200">
                            <button type="button" onclick="closeImportExcelModal()"
                                    class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-xs font-semibold text-slate-600 hover:bg-slate-50 transition text-center">
                                Hủy bỏ
                            </button>
                            <button type="submit"
                                    class="flex-1 sm:flex-initial px-5 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold shadow-xs transition flex items-center justify-center space-x-1.5">
                                <i class="fa-solid fa-cloud-arrow-up"></i>
                                <span>Tiến Hành Nhập</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                function openImportExcelModal() { 
                    document.getElementById('importExcelModal').classList.remove('hidden'); 
                    document.getElementById('fileErrorMsg').classList.add('hidden');
                }
                function closeImportExcelModal() { 
                    document.getElementById('importExcelModal').classList.add('hidden'); 
                }

                function validateExcelUpload(form) {
                    var fileInput = document.getElementById('excelFileInput');
                    var errDiv = document.getElementById('fileErrorMsg');
                    if (!fileInput.files || fileInput.files.length === 0) {
                        errDiv.textContent = 'Vui lòng chọn tệp Excel trước khi bấm Tiến Hành Nhập!';
                        errDiv.classList.remove('hidden');
                        return false;
                    }
                    var fileName = fileInput.files[0].name.toLowerCase();
                    if (!fileName.endsWith('.xlsx') && !fileName.endsWith('.xls')) {
                        errDiv.textContent = 'Định dạng tệp không hợp lệ! Vui lòng chỉ chọn tệp có đuôi .xlsx hoặc .xls.';
                        errDiv.classList.remove('hidden');
                        return false;
                    }
                    errDiv.classList.add('hidden');
                    return true;
                }
            </script>
        </c:when>

        <%-- ========================================================= --%>
        <%-- DANH SÁCH LỚP CHUYÊN NGÀNH                                 --%>
        <%-- ========================================================= --%>
        <c:otherwise>
            <!-- Header & Action -->
            <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h1 class="text-xl font-bold text-slate-800 flex items-center">
                        <i class="fa-solid fa-school text-utc-blue mr-2.5"></i>Danh Sách Lớp Chuyên Ngành (Niên Chế)
                    </h1>
                    <p class="text-xs text-slate-500 mt-1">Quản lý các lớp sinh hoạt sinh viên theo Khóa, Ngành, Khoa và danh sách sinh viên theo lớp</p>
                </div>

                <div class="flex flex-wrap items-center gap-2 w-full md:w-auto">
                    <button type="button" onclick="openAddClassModal()"
                            class="w-full sm:w-auto px-4 py-2 bg-utc-blue hover:bg-utc-dark text-white rounded-xl text-xs font-bold shadow-xs flex items-center justify-center space-x-1.5 transition">
                        <i class="fa-solid fa-plus"></i>
                        <span>Tạo Lớp Chuyên Ngành Mới</span>
                    </button>
                </div>
            </div>

            <!-- Filters -->
            <div class="bg-white rounded-xl border border-slate-200 shadow-sm p-4">
                <form action="${pageContext.request.contextPath}/admin/academic-classes" method="GET" class="flex flex-wrap items-center gap-2.5">
                    <div class="w-full sm:w-auto sm:min-w-[140px] flex-1">
                        <select name="intakeYear" onchange="this.form.submit()" 
                                class="w-full px-3 py-2 rounded-xl border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-utc-blue bg-slate-50">
                            <option value="">Tất cả các khóa</option>
                            <c:forEach var="yr" items="${intakeYears}">
                                <option value="${yr}" ${selectedIntakeYear == yr ? 'selected' : ''}>Khóa K${yr}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="w-full sm:w-auto sm:min-w-[200px] flex-1">
                        <select name="facultyId" onchange="this.form.submit()" 
                                class="w-full px-3 py-2 rounded-xl border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-utc-blue bg-slate-50">
                            <option value="">Tất cả các Khoa</option>
                            <c:forEach var="f" items="${faculties}">
                                <option value="${f.facultyId}" ${selectedFaculty == f.facultyId ? 'selected' : ''}>${f.facultyName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="w-full sm:w-auto sm:min-w-[200px] flex-1">
                        <select name="majorId" onchange="this.form.submit()" 
                                class="w-full px-3 py-2 rounded-xl border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-utc-blue bg-slate-50">
                            <option value="">Tất cả các Ngành</option>
                            <c:forEach var="m" items="${majors}">
                                <option value="${m.majorId}" ${selectedMajor == m.majorId ? 'selected' : ''}>${m.majorName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <c:if test="${not empty selectedIntakeYear || not empty selectedFaculty || not empty selectedMajor}">
                        <a href="${pageContext.request.contextPath}/admin/academic-classes" class="text-xs text-rose-600 hover:underline px-2 py-1">
                            Xóa lọc
                        </a>
                    </c:if>
                </form>
            </div>

            <!-- Classes Table -->
            <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-xs text-slate-600">
                        <thead class="bg-slate-50 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                            <tr>
                                <th class="px-4 py-3.5">Mã Lớp</th>
                                <th class="px-4 py-3.5">Tên Lớp Chuyên Ngành</th>
                                <th class="px-4 py-3.5 text-center">Khóa học</th>
                                <th class="px-4 py-3.5">Chuyên ngành đào tạo</th>
                                <th class="px-4 py-3.5">Khoa quản lý</th>
                                <th class="px-4 py-3.5 text-center">Sĩ số sinh viên</th>
                                <th class="px-4 py-3.5 text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-200">
                            <c:forEach var="c" items="${classes}">
                                <tr class="hover:bg-slate-50/80">
                                    <td class="px-4 py-3 font-bold text-slate-800 font-mono">${c.classId}</td>
                                    <td class="px-4 py-3 font-semibold text-slate-800">${c.className}</td>
                                    <td class="px-4 py-3 text-center">
                                        <span class="px-2 py-0.5 rounded-full text-[10px] font-bold bg-blue-100 text-utc-blue">
                                            K${c.intakeYear}
                                        </span>
                                    </td>
                                    <td class="px-4 py-3 text-slate-700">${c.majorName}</td>
                                    <td class="px-4 py-3 text-slate-600">${c.facultyName}</td>
                                    <td class="px-4 py-3 text-center">
                                        <span class="font-bold text-slate-800 px-2.5 py-1 bg-slate-100 rounded-lg">
                                            ${c.studentCount} SV
                                        </span>
                                    </td>
                                    <td class="px-4 py-3 text-center space-x-1.5 whitespace-nowrap">
                                        <!-- View Students Detail -->
                                        <a href="${pageContext.request.contextPath}/admin/academic-classes?action=detail&classId=${c.classId}"
                                           class="px-2.5 py-1.5 rounded-lg bg-blue-50 text-utc-blue hover:bg-blue-100 font-semibold text-[11px] transition inline-flex items-center">
                                            <i class="fa-solid fa-users mr-1"></i>DS Sinh viên
                                        </a>

                                        <!-- Edit Class Button -->
                                        <button type="button" 
                                                onclick="openEditClassModal('${c.classId}', '${c.className}', '${c.intakeYear}', '${c.majorId}')"
                                                class="px-2.5 py-1.5 rounded-lg bg-amber-50 text-amber-700 hover:bg-amber-100 font-semibold text-[11px] transition">
                                            <i class="fa-solid fa-pen-to-square mr-1"></i>Sửa
                                        </button>

                                        <!-- Delete Class Form -->
                                        <form action="${pageContext.request.contextPath}/admin/academic-classes" method="POST" class="inline"
                                              onsubmit="return confirm('Bạn có chắc chắn muốn xóa lớp chuyên ngành ${c.classId}?');">
                                            <input type="hidden" name="action" value="delete_class">
                                            <input type="hidden" name="classId" value="${c.classId}">
                                            <button type="submit"
                                                    class="px-2.5 py-1.5 rounded-lg bg-slate-100 text-slate-600 hover:bg-rose-100 hover:text-rose-700 font-semibold text-[11px] transition">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty classes}">
                                <tr>
                                    <td colspan="7" class="px-4 py-10 text-center text-slate-400">Không tìm thấy lớp chuyên ngành nào phù hợp.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Modal Tạo Lớp Chuyên Ngành Mới -->
            <div id="addClassModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
                <div class="bg-white rounded-2xl max-w-md w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
                    <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
                        <h3 class="font-bold text-slate-800 text-xs sm:text-sm flex items-center">
                            <i class="fa-solid fa-plus text-utc-blue mr-2"></i>Tạo Lớp Chuyên Ngành Mới
                        </h3>
                        <button type="button" onclick="closeAddClassModal()" class="text-slate-400 hover:text-slate-600 p-1">
                            <i class="fa-solid fa-xmark text-lg"></i>
                        </button>
                    </div>

                    <form action="${pageContext.request.contextPath}/admin/academic-classes" method="POST" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
                        <input type="hidden" name="action" value="add_class">

                        <div>
                            <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Mã Lớp (*)</label>
                            <input type="text" name="classId" required placeholder="Ví dụ: CNTT3-K63"
                                   class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                        </div>

                        <div>
                            <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Tên Lớp Chuyên Ngành (*)</label>
                            <input type="text" name="className" required placeholder="Ví dụ: Công nghệ Thông tin 3 - K63"
                                   class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                            <div>
                                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Khóa học</label>
                                <input type="number" name="intakeYear" value="63" required
                                       class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Chuyên ngành</label>
                                <select name="majorId" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                                    <c:forEach var="m" items="${majors}">
                                        <option value="${m.majorId}">${m.majorName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="flex flex-wrap items-center justify-end gap-2 pt-3 border-t border-slate-200">
                            <button type="button" onclick="closeAddClassModal()"
                                    class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-xs font-semibold text-slate-600 hover:bg-slate-50 transition text-center">
                                Hủy bỏ
                            </button>
                            <button type="submit"
                                    class="flex-1 sm:flex-initial px-5 py-2 bg-utc-blue hover:bg-utc-dark text-white rounded-xl text-xs font-bold shadow-xs transition text-center">
                                Lưu Lớp Mới
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Modal Sửa Lớp Chuyên Ngành -->
            <div id="editClassModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
                <div class="bg-white rounded-2xl max-w-md w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
                    <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
                        <h3 class="font-bold text-slate-800 text-xs sm:text-sm flex items-center">
                            <i class="fa-solid fa-pen-to-square text-amber-500 mr-2"></i>Cập Nhật Lớp Chuyên Ngành
                        </h3>
                        <button type="button" onclick="closeEditClassModal()" class="text-slate-400 hover:text-slate-600 p-1">
                            <i class="fa-solid fa-xmark text-lg"></i>
                        </button>
                    </div>

                    <form action="${pageContext.request.contextPath}/admin/academic-classes" method="POST" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
                        <input type="hidden" name="action" value="edit_class">

                        <div>
                            <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Mã Lớp (Không đổi)</label>
                            <input type="text" id="editClassId" name="classId" readonly
                                   class="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 bg-slate-100 text-slate-500 text-xs font-mono">
                        </div>

                        <div>
                            <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Tên Lớp Chuyên Ngành (*)</label>
                            <input type="text" id="editClassName" name="className" required
                                   class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                            <div>
                                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Khóa học</label>
                                <input type="number" id="editIntakeYear" name="intakeYear" required
                                       class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Chuyên ngành</label>
                                <select id="editMajorId" name="majorId" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                                    <c:forEach var="m" items="${majors}">
                                        <option value="${m.majorId}">${m.majorName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="flex flex-wrap items-center justify-end gap-2 pt-3 border-t border-slate-200">
                            <button type="button" onclick="closeEditClassModal()"
                                    class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-xs font-semibold text-slate-600 hover:bg-slate-50 transition text-center">
                                Hủy bỏ
                            </button>
                            <button type="submit"
                                    class="flex-1 sm:flex-initial px-5 py-2 bg-amber-600 hover:bg-amber-700 text-white rounded-xl text-xs font-bold shadow-xs transition text-center">
                                Cập Nhật
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                function openAddClassModal() { document.getElementById('addClassModal').classList.remove('hidden'); }
                function closeAddClassModal() { document.getElementById('addClassModal').classList.add('hidden'); }
                function openEditClassModal(classId, className, intakeYear, majorId) {
                    document.getElementById('editClassId').value = classId;
                    document.getElementById('editClassName').value = className;
                    document.getElementById('editIntakeYear').value = intakeYear;
                    document.getElementById('editMajorId').value = majorId;
                    document.getElementById('editClassModal').classList.remove('hidden');
                }
                function closeEditClassModal() { document.getElementById('editClassModal').classList.add('hidden'); }
            </script>
        </c:otherwise>
    </c:choose>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
