<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Customer Rep Homepage</title>
</head>
<body>
<%
    try {
        // Get the database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        String id = request.getParameter("id");
        String password = request.getParameter("password");

        if (id.equals("0")) {
            response.sendRedirect("AdminHomePage.jsp?CreateRet=You can not use ID 0");
        } else {
            String insertRep = "INSERT INTO customer_rep VALUES(?, ?)";
            PreparedStatement psRep = con.prepareStatement(insertRep);
            psRep.setString(1, id);
            psRep.setString(2, password);
            psRep.executeUpdate();

            String insertAdminCreates = "INSERT INTO admin_creates VALUES(0, ?)";
            PreparedStatement psAdminCreates = con.prepareStatement(insertAdminCreates);
            psAdminCreates.setString(1, id);
            psAdminCreates.executeUpdate();

            response.sendRedirect("AdminHomePage.jsp?CreateRet=Rep Successfully created!&CreateRetCode=0");
        }
    } catch (SQLException e) {
        String code = e.getSQLState();
        if (code.equals("23000")) {
            response.sendRedirect("AdminHomePage.jsp?CreateRet=A rep already exists with this ID.&CreateRetCode=1");
        } else {
            response.sendRedirect("AdminHomePage.jsp?CreateRet=Error creating Rep. Please try again.&CreateRetCode=1");
        }
    }
%>
</body>
</html>