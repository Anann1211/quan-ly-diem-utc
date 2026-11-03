package vn.edu.utc.grade;

import java.io.File;
import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

/**
 * [Tên tiếng Việt: Điểm Khởi Chạy Hệ Thống]
 * Chức năng: Khởi động máy chủ nhúng Apache Tomcat tại cổng 8080 và nạp ứng dụng web.
 */
public class Main {
    public static void main(String[] args) throws Exception {
        int port = 8080;
        String portStr = System.getenv("PORT");
        if (portStr != null && !portStr.trim().isEmpty()) {
            try {
                port = Integer.parseInt(portStr.trim());
            } catch (Exception ignored) {}
        }

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.getConnector();

        String webappDirLocation = new File("src/main/webapp").getAbsolutePath();
        StandardContext ctx = (StandardContext) tomcat.addWebapp("", webappDirLocation);
        ctx.setParentClassLoader(Main.class.getClassLoader());
        ctx.setAllowCasualMultipartParsing(true);

        File additionWebInfClasses = new File("target/classes");
        if (additionWebInfClasses.exists()) {
            WebResourceRoot resources = new StandardRoot(ctx);
            resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                    additionWebInfClasses.getAbsolutePath(), "/"));
            ctx.setResources(resources);
        }

        System.out.println("\n==================================================================");
        System.out.println("   TRƯỜNG ĐẠI HỌC GIAO THÔNG VẬN TẢI - UTC GRADE MANAGEMENT");
        System.out.println("   Công nghệ: Java Servlet / JSP, JDBC thuần, Oracle 23ai Free");
        System.out.println("   Hệ thống đang chạy tại: http://localhost:" + port);
        System.out.println("   --------------------------------------------------------------");
        System.out.println("   Tài khoản thử nghiệm:");
        System.out.println("   • Admin (Phòng Đào Tạo): admin           / admin123");
        System.out.println("   • Giảng viên:            gv_nguyenvanan  / gv123");
        System.out.println("   • Sinh viên:             211200001       / sv123");
        System.out.println("==================================================================\n");

        tomcat.start();
        tomcat.getServer().await();
    }
}
