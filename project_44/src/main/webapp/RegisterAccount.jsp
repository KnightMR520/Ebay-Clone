<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Account Registration</title>
</head>
<body>
    <%
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String forwardPage = "Login.jsp";
        String message = "Account successfully created.";

        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            String insert = "INSERT INTO users(username, password) VALUES(?, ?)";
            PreparedStatement ps = con.prepareStatement(insert);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.executeUpdate();

        } catch (SQLException e) {
            String code = e.getSQLState();
            if (code.equals("23000")) {
                %>
                <jsp:forward page="RegisterPage.jsp">
                <jsp:param name="msg" value="This username is already exists."/> 
                </jsp:forward>
                <%
            } else {
                %>
                <jsp:forward page="RegisterPage.jsp">
                <jsp:param name="msg" value="Error creating account. Please try again."/> 
                </jsp:forward>
                <%
            }
        } catch (Exception e) {
            out.print("Unknown exception.");
            %>
            <jsp:forward page="RegisterPage.jsp">
            <jsp:param name="msg" value="Error creating account. Please try again."/> 
            </jsp:forward>
            <%
        }
    %>
    <jsp:forward page="<%= forwardPage %>">
        <jsp:param name="message" value="<%= message %>"/> 
    </jsp:forward>
</body>
</html>