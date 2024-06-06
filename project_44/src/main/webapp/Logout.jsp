<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Logout</title>
</head>
<body>
    <%-- Invalidate the current session if it exists --%>
    <%
        session.invalidate();
    %>

    <%-- Redirect the response to the login page --%>
    <%
        response.sendRedirect("Login.jsp"); 
    %>
</body>
</html>