<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Viewing Question</title>
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
            text-align: left;
        }
        .container form .form-group {
            margin-bottom: 15px;
        }
        .container form .form-group label {
            display: block;
            color: #666;
        }
        .container form .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .container form .form-group input[type="submit"] {
            background-color: #5cb85c;
            border-color: #4cae4c;
            color: white;
            cursor: pointer;
        }
        .container .logout {
            text-align: right;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="UserViewQuestions.jsp"> Back to QA</a>
        <%
            ApplicationDB db = new ApplicationDB();    
            Connection con = db.getConnection();
            String q_id = request.getParameter("q_id");
            
            PreparedStatement ps;
            ResultSet rs;
            String asker = "Unknown", q_text = "No question Text Available", resolver_id = null, resolve_text = null;

            ps = con.prepareStatement("SELECT asker FROM asks WHERE q_id=(?)");
            ps.setString(1, q_id);
            rs = ps.executeQuery();
            if (rs.next()) {
                asker = rs.getString(1);
            }

            ps = con.prepareStatement("SELECT q_text FROM question WHERE q_id=(?)");
            ps.setString(1, q_id);
            rs = ps.executeQuery();
            if (rs.next()) {
                q_text = rs.getString(1);
            }
        %>
        <h2><%= asker %> asks:</h2>
        <p><%= q_text %></p>
        <%
            ps = con.prepareStatement("SELECT resolver, resolve_text FROM resolves WHERE q_id=(?)");
            ps.setString(1, q_id);
            rs = ps.executeQuery();
            if (rs.next()) {
                resolver_id = rs.getString(1);
                resolve_text = rs.getString(2);
            }
            
            if (resolver_id == null) {
        %>
        <h4>This issue has not yet been resolved!</h4>
        <% } else { %>
        <h4>Resolved by Customer Rep Id #<%= resolver_id %>:</h4>
        <p><%= resolve_text %></p>
        <% } %>
    </div>
</body>
</html>
