package vn.edu.utc.grade.config;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Bộ lọc chuẩn hóa bảng mã UTF-8 (hỗ trợ hiển thị tiếng Việt sắc nét)
 */
@WebFilter("/*")
public class EncodingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");

        String path = req.getRequestURI();
        if (path != null && !path.endsWith(".css") && !path.endsWith(".js") && !path.endsWith(".png") && !path.endsWith(".ico") && !path.endsWith(".xlsx")) {
            res.setContentType("text/html; charset=UTF-8");
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
