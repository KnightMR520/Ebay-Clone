<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Your Interests</title>
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
	.container form {
	    margin-bottom: 15px;
	}
	.container form label, .container form input {
	    display: block;
	    margin-bottom: 10px;
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
<link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
	<% 
    	//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		String username = (String) session.getAttribute("username");
		if (username == null) {
			response.sendRedirect("Login.jsp");
		}
		PreparedStatement ps = con.prepareStatement(
				"SELECT interest " +
				"FROM interests " +
				"WHERE username=(?)");
		ps.setString(1, username);
		ResultSet rs = ps.executeQuery();
    %>

    <div class="container">
    	<h1>Your Interests</h1>
    	<form method="post" action="UserAddNewInterest.jsp">
    		<label for="interest">Add Interest:</label>
    		<input type="text" id="interest" name="interest">
    		<input type="submit" value="Add Interest">
    	</form>
    	<br>
    	<table>
    		<tr>
	    		<th>Your Interests</th>
    		</tr>
    		<% while (rs.next()) { %>
    			<tr> 
    				<td><%=rs.getString(1)%></td>
    			</tr>
    		<% } %>
    	</table>
    	<a href="UserAccount.jsp">Back</a>
    </div>
</body>
</html>
