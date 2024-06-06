<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Admin HomePage</title>
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
            width: 96.3%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .container form .form-group input[type="submit"] {
        	display: block;
        	margin: auto;
            background-color: #5cb85c;
            border-color: #4cae4c;
            color: white;
            cursor: pointer;
        }
        .container form .form-group input[type="submit"]:hover {
            background-color: #449d44;
        }
        .container .logout {
            text-align: right;
            margin-top: 15px;
        }
    </style>
</head>
<body>

	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		String admin_id = (String) session.getAttribute("employeeid");
		if (admin_id == null) {
			response.sendRedirect("Login.jsp");
		}
		ResultSet resultset = stmt.executeQuery("SELECT id, password FROM customer_rep");
	%>


    <div class="container">
        <h1>Welcome back, Admin.</h1>
        <h2>Your Customer Representatives</h2>
        <table>
            <tr>
                <th>Customer_Rep ID</th>
                <th>Password</th>
            </tr>
            <% if (!resultset.next()) { %>
            <tr>
                <td colspan="2"> No Customer Reps found! </td>
            </tr>
            <% } else {
                // Need to reset after the previous if check
                resultset.beforeFirst();
                while (resultset.next()) { %>
            <tr>
                <td> <%= resultset.getString(1) %></td>
                <td> <%= resultset.getString(2) %></td>
            </tr>
            <% } }%>
        </table>
        <h3>Add a Customer Rep to the Team!</h3>
        <form method="post" action="CreateCustomerRep.jsp">
            <div class="form-group">
                <label for="id">New Rep ID:</label>
                <input type="text" id="id" name="id" maxlength="3" required/>
            </div>
            <div class="form-group">
                <label for="password">Rep Password:</label>
                <input type="text" id="password" name="password" maxlength="30" required/>
            </div>
            <div class="form-group">
                <input type="submit" value="Create!"/>
            </div>
            <% if (request.getParameter("CreateRet") != null) { %>
            <p style="text-align: center; 
                color: <%= request.getParameter("CreateRetCode").equals("0") ? "blue" : "red" %>">
                    <%=request.getParameter("CreateRet")%>
            </p>
            <% } %>
        </form>
        <hr>
        <h2>Create Sales Reports</h2>
        <h4>Generate new sales report</h4>
        <form action="GenerateSalesReport.jsp">
            <table>
                <tr>
                    <th>From (Start Date)</th>
                    <th>To (End Date)</th>
                </tr>
                <tr>
                    <td><input type="datetime-local" required name="date1"></td>
                    <td><input type="datetime-local" required name="date2"></td>
                </tr>
            </table>
            <input type="submit" value="Generate">
        </form>
        <div class="logout">
            <a href="Logout.jsp">Logout</a>
        </div>
    </div>
</body>
</html>
