package vn.edu.utc.grade.config;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Quản lý kết nối JDBC tới Oracle Database 23ai Free
 */
public class DBConnection {

    private static String url = "jdbc:oracle:thin:@//localhost:1521/FREEPDB1";
    private static String username = "utc_grade";
    private static String password = "utc123";
    private static String driver = "oracle.jdbc.OracleDriver";

    static {
        try {
            Properties props = new Properties();
            InputStream is = DBConnection.class.getClassLoader().getResourceAsStream("db.properties");
            if (is != null) {
                props.load(is);
                url = props.getProperty("db.url", url);
                username = props.getProperty("db.user", username);
                password = props.getProperty("db.password", password);
                driver = props.getProperty("db.driver", driver);
            }
            Class.forName(driver);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }

    public static void close(AutoCloseable... closeables) {
        for (AutoCloseable c : closeables) {
            if (c != null) {
                try {
                    c.close();
                } catch (Exception ignored) {
                }
            }
        }
    }
}
