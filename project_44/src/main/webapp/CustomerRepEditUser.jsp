<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>User Management</title>
</head>
<body>
    <%
        ApplicationDB database = new ApplicationDB();
        Connection connection = database.getConnection();

        String previousUser = request.getParameter("old_user");
        String userUnderExamination = previousUser;
        String newUser = request.getParameter("new_user");
        String newPassword = request.getParameter("new_pass");
        String deleteAction = request.getParameter("delete");

        if (deleteAction != null && deleteAction.equals("true")) {
            PreparedStatement deleteStatement = connection.prepareStatement(
                    "DELETE FROM users WHERE username=(?)"
            );
            deleteStatement.setString(1, previousUser);
            deleteStatement.executeUpdate();
            response.sendRedirect("CustomerRepHome.jsp");
        } else {
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                PreparedStatement updatePasswordStatement = connection.prepareStatement(
                        "UPDATE users SET password=(?) WHERE username=(?)"
                );
                updatePasswordStatement.setString(1, newPassword);
                updatePasswordStatement.setString(2, previousUser);
                updatePasswordStatement.executeUpdate();
            }

            if (newUser != null && !newUser.trim().isEmpty()) {
                PreparedStatement updateUsernameStatement = connection.prepareStatement(
                        "UPDATE users SET username=(?) WHERE username=(?)"
                );
                updateUsernameStatement.setString(1, newUser);
                updateUsernameStatement.setString(2, previousUser);
                userUnderExamination = newUser;
                updateUsernameStatement.executeUpdate();
            }
    %>
    <jsp:forward page="CustomerRepExamineUser.jsp">
        <jsp:param name="username" value="<%=userUnderExamination%>"/> 
    </jsp:forward>
    <% } %>
</body>
</html>