<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login Verification</title>
</head>
<body>
    <%
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String forwardPage = "Login.jsp";
        String message = "Error logging in. Please try again.";

        try {
            ApplicationDB db = new ApplicationDB();    
            Connection con = db.getConnection();
            
            String lookup = "SELECT username, password FROM users WHERE username=(?) AND password=(?)";
            PreparedStatement ps = con.prepareStatement(lookup);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet result = ps.executeQuery();

            if (result.next()) {
                session.setAttribute("username", username);
                %>
                <jsp:forward page="Home.jsp">
                <jsp:param name="user" value="<%=username%>"/> 
                </jsp:forward>
                <% 
            } else {
                %>
                <jsp:forward page="Login.jsp">
                <jsp:param name="loginRet" value="Incorrect username or password."/> 
                </jsp:forward>
                <%
            }
        } catch (Exception e) {
                %>
                <jsp:forward page="Login.jsp">
                <jsp:param name="loginRet" value="Incorrect username or password."/> 
                </jsp:forward>
                <%
        }
    %>
    <jsp:forward page="<%= forwardPage %>">
        <jsp:param name="message" value="<%= message %>"/> 
    </jsp:forward>
</body>
</html>