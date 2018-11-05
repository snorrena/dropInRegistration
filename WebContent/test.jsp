<%@ page contentType="text/html" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.sqlite.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Sqlite database access test</title>
</head>
<body>
<table>
            <thead>
                <tr>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Password</th>
                    <th>Registration</th>
                    <th>Email</th>
                </tr>
            </thead>
            <tbody>
            <%
            
            String path = this.getServletContext().getRealPath("PlayerInfo.db");
            
                Class.forName("org.sqlite.JDBC");
                Connection conn =
                     DriverManager.getConnection("jdbc:sqlite:C:\\Dropbox\\Development\\Eclipse_Neon\\Java\\Work\\WebApps\\workspace\\TestLogin\\PlayerInfo.db");
                Statement stat = conn.createStatement();
 
                ResultSet rs = stat.executeQuery("select * from playerlist;");
 
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("firstname") + "</td>");
                    out.println("<td>" + rs.getString("lastname") + "</td>");
                    out.println("<td>" + rs.getString("password") + "</td>");
                    out.println("<td>" + rs.getInt("isregistered") + "</td>");
                    out.println("<td>" + rs.getString("email") + "</td>");
                    out.println("</tr>");
                }
 
                rs.close();
                conn.close();
            %>
            </tbody>
        </table>
</body>
</html>