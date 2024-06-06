<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>CPUs</title>
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
    <%  ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        String username = (String) session.getAttribute("username");
        if (username == null) { response.sendRedirect("Login.jsp"); }
    %>
    <div class="container">
        <h1>Subcategory: CPUs</h1>
        <table>
            <tr>
                <td><a href="Home.jsp">Home</a></td>
                <td><a href="UserAccount.jsp">Account</a></td>
                <td><a href="Logout.jsp">Logout</a></td>
            </tr>
        </table>
        <form method="post" action="Search.jsp?subcat=CPUs">
            <input type="text" name="search" placeholder="Search goes here...">
            <button type="submit" name="save">Search</button>
        </form>
        <br>
        <form method="post" action="CPUs.jsp">
            <select name="sortby" id="sortby">
                <option value="None">---</option>
                <option value="Name">Name</option>
                <option value="lowToHigh">Price (Ascending)</option>
                <option value="highToLow">Price (Descending)</option>
                <option value="Tag">Cores</option>
                <option value="Open">Status: Open</option>
                <option value="Closed">Status: Closed</option>
            </select>
            <button type="submit" name="sortBy">Sort By</button>
        </form>
	    <%  Statement stmt = con.createStatement();
	        String sortParam = request.getParameter("sortby");
	        ResultSet resultset = null;
	        if (sortParam == null) {
	            resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='CPUs';");
	        } else if (sortParam.equals("Name")) {
	            resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='CPUs' ORDER BY itemname;");
	        } else if (sortParam.equals("lowToHigh")) {
	            resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='CPUs' ORDER BY price;");
	        } else if (sortParam.equals("highToLow")) {
	            resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='CPUs' ORDER BY price DESC;");
	        } else if (sortParam.equals("Tag")) {
	            resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='CPUs' ORDER BY subattribute;");
	        } else if (sortParam.equals("Open")) {
	            resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='CPUs' AND closed='0' ORDER BY itemname;");
	        } else if (sortParam.equals("Closed")) {
	            resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='CPUs' AND closed='1' ORDER BY itemname;");
	        } else {
	            resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='CPUs';");
	        }
	    %>
        <br><br>
        <form method="post" action="ExamineListing.jsp">
            <table border="1">
                <tr>
                    <th></th>
                    <th>Name</th>
                    <th>Cores</th>
                    <th>Price</th>
                    <th>Status</th>
                </tr>
	            <% while (resultset.next()) {
					String status = resultset.getString(8);
	            %>
	            <tr>
	                <td><button name="lid" type="submit" value="<%= resultset.getString(1) %>">>></button></td>
	                <td><%= resultset.getString(2) %></td>
	                <td><%= resultset.getString(4) %></td>
	                <td><%= resultset.getString(5) %></td>
	                <% if (status.equals("0")) { %>
	                	<td bgcolor="green">Open</td>
	                <% } else { %>
	                	<td bgcolor="red">CLOSED</TD>
	            	<% } %>
	            </TR>
	            <% } %>
            </table>
        </form>
    </div>
</body>
</html>