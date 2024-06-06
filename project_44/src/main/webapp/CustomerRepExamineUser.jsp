<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>User Examination</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .center {
            text-align: center;
        }
        button {
            margin: 10px;
        }
    </style>
</head>
<body>
    <%
        ApplicationDB appDB = new ApplicationDB();
        Connection dbConnection = appDB.getConnection();
        String username = request.getParameter("username");
        PreparedStatement preparedStatement = dbConnection.prepareStatement(
            "SELECT password FROM users WHERE username=(?)"
        );
        preparedStatement.setString(1, username);
        ResultSet resultSet = preparedStatement.executeQuery();
        resultSet.next();
    %>
    <p><a href="CustomerRepHome.jsp"> Quit User Examination</a></p>
    <div class="center">
        <h1>Examining: <%= username %></h1>
        <form action="CustomerRepEditUser.jsp">
            <p>Current Username: <%= username %></p>
            <p>Current Password: <%= resultSet.getString(1) %></p>
            <br>
            <p>New Username: <input type="text" name="new_user" value="" maxlength="30"></p>
            <br>
            <p>New Password: <input type="text" name="new_pass" value="" maxlength="30"></p>
            <br>
            <button type="submit">Confirm Edits</button>
            <hr>
            <button name="delete" type="submit" value="true">DELETE USER</button>
            <input type="hidden" name="old_user" value="<%= username %>"/>
        </form>
    </div>
</body>
</html>