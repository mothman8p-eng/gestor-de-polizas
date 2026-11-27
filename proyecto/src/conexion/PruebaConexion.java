/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package conexion;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;



public class PruebaConexion {

    public static void main(String[] args) throws Exception {
        Connection con = ConexionBD.conectar();
        if (con == null) {
            System.out.println("La prueba fallo: sin conexion");
            return;
        }
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SHOW TABLES");
        System.out.println("Tablas en gestor_polizas:");
        while (rs.next()) {
            System.out.println(" - " + rs.getString(1));
        }
        con.close();
        System.out.println("Prueba terminada correctamente");
    }
}