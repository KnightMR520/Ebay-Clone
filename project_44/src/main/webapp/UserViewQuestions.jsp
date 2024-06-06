<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Questions and Answers!</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f4f4f4;
    }
    .container {
        width: 600px;
        padding: 16px;
        background-color: white;
        margin: 0 auto;
        margin-top: 50px;
        border-radius: 4px;
        box-shadow: 0px 0px 10px 0px #000;
        text-align: center;
    }
    .container h1, .container h2, .container h3, .container h4 {
        color: #333;
    }
    .container table {
        width: 100%;
        margin-bottom: 15px;
    }
    .container table th, .container table td {
        padding: 10px;
        border: 1px solid #ddd;
        text-align: center;
    }
    .notifications {
        background-color: #008000;
    }
</style>
</head>
<body>
<div class="container">
    <a href="Home.jsp"> Back to Home</a>
    <h1>Questions asked by you and other users!</h1>
    <%
        // Initialize database connection and statement
        ApplicationDB db = new ApplicationDB();    
        Connection con = db.getConnection();
        Statement stmt = con.createStatement();

        String keyword = request.getParameter("search");
        ResultSet resultset;

        if (keyword == null || keyword.isEmpty()) {
            resultset = stmt.executeQuery("SELECT q_id, q_text FROM question");
        } else {
            PreparedStatement ps = con.prepareStatement(
                "SELECT q_id, q_text FROM question WHERE q_text LIKE '%" + keyword + "%'"
            );
            resultset = ps.executeQuery();
        }
    %>
    <form method="post" action="UserViewQuestions.jsp">
        <input type="text" name="search" class="form-control" placeholder="Search by keyword">
        <button type="submit" name="save" class="btn btn-primary">Search</button>
    </form>
    <hr>
    <%
        if (keyword != null && !keyword.isEmpty()) {
    %>
    <h3>Showing results for: <%= keyword %></h3>
    <%
        }
    %>
    <form action="UserExamineQuestion.jsp">
        <table>
        <tr>
            <th></th>
            <th>Question</th>
        </tr>
         <% while (resultset.next()) { %>
        <tr>
            <td><button name="q_id" type="submit" value="<%= resultset.getString(1) %>">>></button></td>
            <td style="max-width: 300px; font-size: 18px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;"><%= resultset.getString(2) %></td>
        </tr>
    <% } %>
        </table>
    </form>
</div>
</body>
</html>
