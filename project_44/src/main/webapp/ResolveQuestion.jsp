<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
    <%
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        String resolveText = request.getParameter("resolve_text");
        String questionId = request.getParameter("q_id");
        String replyId = request.getParameter("rep_id");

        String query = "INSERT INTO resolves VALUES(?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(query);

        ps.setString(1, questionId);
        ps.setString(2, replyId);
        ps.setString(3, resolveText);

        ps.executeUpdate();

    %>
        <jsp:forward page="CustomerRepExamineQuestion.jsp">
        <jsp:param name="rep_id" value="<%= replyId %>"/> 
        <jsp:param name="q_id" value="<%= questionId %>"/>
        </jsp:forward>
</body>
</html>