
package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {
  

    private static final String URL =
        "jdbc:mysql://localhost:3306/gestor_polizas"
        + "?useSSL=false&serverTimezone=America/Cancun";
    private static final String USUARIO = "root";
    private static final String CONTRASENA = "2502001";

    public static Connection conectar() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con =
                DriverManager.getConnection(URL, USUARIO, CONTRASENA);
            System.out.println("Conexion exitosa a MySQL");
            return con;
        } catch (ClassNotFoundException e) {
            System.out.println("No se encontro el driver "
                + "MySQL Connector/J: " + e.getMessage());
            return null;
        } catch (SQLException e) {
            System.out.println("Error de conexion: "
                + e.getMessage());
            return null;
        }
    }
    
    
}