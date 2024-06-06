<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Insert title here</title>
</head>
<body>
<%
    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        String id = request.getParameter("employee_id");
        String password = request.getParameter("password");

        String lookupAdmin = "SELECT id, password FROM admin WHERE id = ? AND password = ?";
        String lookupCustomerRep = "SELECT id, password FROM customer_rep WHERE id = ? AND password = ?";

        PreparedStatement psAdmin = con.prepareStatement(lookupAdmin);
        psAdmin.setString(1, id);
        psAdmin.setString(2, password);
        ResultSet resultAdmin = psAdmin.executeQuery();

        PreparedStatement psCustomerRep = con.prepareStatement(lookupCustomerRep);
        psCustomerRep.setString(1, id);
        psCustomerRep.setString(2, password);
        ResultSet resultCustomerRep = psCustomerRep.executeQuery();

        if (resultAdmin.next()) {
            session.setAttribute("employeeid", id);
            response.sendRedirect("AdminHomePage.jsp?user=" + id);
        } else if (resultCustomerRep.next()) {
            session.setAttribute("employeeid", id);
            response.sendRedirect("CustomerRepHome.jsp?rep_id=" + id);
        } else {
            response.sendRedirect("AdminLoginScreen.jsp?loginRet=Incorrect employee ID or password.");
        }
    } catch (Exception e) {
        response.sendRedirect("AdminLoginScreen.jsp?loginRet=Error logging in. Please try again.");
    }
%>
</body>
</html>