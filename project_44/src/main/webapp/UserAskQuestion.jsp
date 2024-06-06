<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Ask a Question</title>
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
    </style>
</head>
<body>
    <% 
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        String username = (String) session.getAttribute("username");
        if (username == null) {
            response.sendRedirect("Login.jsp");
        }
    %>
    <div class="container">
        <h1>Customer Rep. Help</h1>
        <form method="post" action="VerifyQuestion.jsp">
            <table>
                <tr>  
                    <td><p><label for="question">Please fill out the form below:</label></p>
                        <textarea id="question" name="question" rows="4" cols="50">Ask us anything!</textarea>
                    </td>
                </tr>
                <tr>
                    <td><input type="submit" value="Post" style="width: 50%;"/></td>
                </tr>
                <tr>
                    <td><a href="UserAccount.jsp">Back</a></td>
                </tr>                    
                <% if (request.getParameter("msg") != null) { %>
                <tr>
                    <td><p style="text-align: center; color: red"><%=request.getParameter("msg")%></p></td>
                </tr>
                <% } %>
            </table>
        </form>
    </div>
    <script>
        document.getElementById('question').addEventListener('focus', function() {
            if (this.value === 'Ask us anything!') {
                this.value = '';
            }
        });
        document.getElementById('question').addEventListener('blur', function() {
            if (this.value === '') {
                this.value = 'Ask us anything!';
            }
        });
    </script>
</body>
</html>