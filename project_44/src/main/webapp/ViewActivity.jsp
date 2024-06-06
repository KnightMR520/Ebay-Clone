<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Account Activity</title>
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
        String username = (String) session.getAttribute("username");
        if (username == null) {
            response.sendRedirect("Login.jsp");
        }
    %>
    <div class="container">
        <h1>Account Activity</h1>
        <p>View auctions you, or another user, have participated in.</p>
        <nav>
            <a href="Home.jsp">Home</a> |
            <a href="UserAccount.jsp">Account</a>
        </nav>
        <form method="post" action="ViewActivity.jsp">
            <input type="text" name="usersearch" placeholder="Search goes here...">
            <input type="submit" name="save" value="Search Another User">
        </form>
        <% 
            String usersearch = request.getParameter("usersearch");     
            if(usersearch!=null){
                %>
                <h4>Viewing User: <%=usersearch%></h4>
                <%
            }else{
                usersearch = username;
                %>
                <h4>Viewing User: <%=usersearch%></h4>
                <%    
            }
        
            Statement stmt1 = con.createStatement();
            String bidQuery = "SELECT l_id, b.b_id, price, username, dtime from bids b "+
                "LEFT JOIN bidson bo on bo.b_id = b.b_id LEFT JOIN places p on p.b_id = bo.b_id " +
                "WHERE username= '" +usersearch+"';";
            ResultSet bidhist = stmt1.executeQuery(bidQuery);
        %>
        <h4>Bids Placed</h4>
        <form method="post" action="ExamineListing.jsp">
            <table>    
                <tr>
                    <th>View</th>
                    <th>Price</th>
                    <th>Date/Time</th>
                </tr>
                <% while(bidhist.next()){ 
                %>
                <tr>
                    <td> <button name="lid" type="submit" value="<%= bidhist.getString(1) %>">>></button></td>
                    <td><%= bidhist.getString(3) %></td>
                    <td><%= bidhist.getString(4) %></td>
                </tr>
                <% } %>
            </table>
        </form>
        <%
            Statement stmt2 = con.createStatement();
            String listQuery = "SELECT l.l_id, l.itemname from listings l "+
                "LEFT JOIN posts p on p.l_id = l.l_id " +
                "WHERE username= '" +usersearch+"';";
            ResultSet listhist = stmt2.executeQuery(listQuery);
        %>
        <h4>Listings Posted</h4>
        <form method="post" action="ExamineListing.jsp">
            <table>    
                <tr>
                    <th>View</th>
                    <th>Item Name</th>
                </tr>
                <% while(listhist.next()){ 
                %>
                <tr>
                    <td> <button name="lid" type="submit" value="<%= listhist.getString(1) %>">>></button></td>
                    <td><%=listhist.getString(2)%></td>
                </tr>
                <% } %>
            </table>
        </form>
    </div>
</body>
</html>