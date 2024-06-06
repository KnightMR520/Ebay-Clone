<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Customer Representative Home</title>
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
        // Get the database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        String rep_id = (String) session.getAttribute("employeeid");
        if (rep_id == null) {
            response.sendRedirect("Login.jsp");
        }
    %>
    <div class="container">
        <h1>Welcome back!</h1>
        <h2>Questions</h2>
        <% 
            Statement stmt = con.createStatement();
            ResultSet resultset = stmt.executeQuery("SELECT q_id, q_text FROM question");
        %>
        <form action="CustomerRepExamineQuestion.jsp">
            <table>    
                <tr>
                    <th></th>
                    <th>Question</th>
                </tr>
                <% while(resultset.next()){ 
                %>
                <tr>
                    <td> <button name="q_id" type="submit" value="<%= resultset.getString(1) %>">>></button></td>
                    <td><%= resultset.getString(2) %></td>
                </tr>
                <% } %>
            </table>
        </form>
        <hr>
        <%
            resultset = stmt.executeQuery("SELECT l_id, itemname, subcategory, price FROM listings");
        %>
        <h2>Bids and Auctions</h2>
        <form action="CustomerRepEditListing.jsp">
            <table>    
                <tr>
                    <th></th>
                    <th>Item</th>
                    <th>Subcategory</th>
                    <th>Price</th>
                </tr>
                <% while(resultset.next()){ 
                %>
                <tr>
                    <td> <button name="lid" type="submit" value="<%= resultset.getString(1) %>">>></button></td>
                    <td><%= resultset.getString(2) %></td>
                    <td><%= resultset.getString(3) %></td>
                    <td><%= resultset.getString(4) %></td>
                </tr>
                <% } %>
            </table>
        </form>
        <hr>
        <%
            resultset = stmt.executeQuery("SELECT username FROM users");
        %>
        <h2>User Account Access</h2>
        <form action="CustomerRepExamineUser.jsp">
            <table>    
                <tr>
                    <th></th>
                    <th>Username</th>
                </tr>
                <% while(resultset.next()){ 
                %>
                <tr>
                    <td> <button name="username" type="submit" value="<%= resultset.getString(1) %>">>></button></td>
                    <td><%= resultset.getString(1) %></td>
                </tr>
                <% } %>
            </table>
        </form>
        <hr>
        <a href="Logout.jsp">Logout</a>
    </div>
</body>
</html>