<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Account Dashboard</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 0;
	background-color: #f4f4f4;
}

.container {
	width: 650px;
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

.container nav ul {
	list-style-type: none;
	padding: 0;
}

.container nav ul li {
	display: inline;
	margin-right: 10px;
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
	%>

	<div class="container">
		<h1>Welcome to Your Dashboard</h1>
		<h3>
			Logged in as:
			<%=username%></h3>
		<nav>
			<ul>
				<li><a href="Home.jsp">Dashboard</a></li>
				<li><a href="Logout.jsp">Logout</a></li>
				<li><a href="UserCreateListing.jsp">Post New Listing</a></li>
				<li><a href="UserAskQuestion.jsp">Submit a Query</a></li>
				<li><a href="ViewActivity.jsp">View Activity</a></li>
				<li><a href="UserViewInterests.jsp">Manage Interests</a></li>
			</ul>
		</nav>

		<section>
			<%
			if (request.getParameter("msg") != null) {
			%>
			<p class="notifications"><%=request.getParameter("msg")%></p>
			<%
			}
			%>

			<%
			if (request.getParameter("createListingRet") != null) {
			%>
			<p class="notifications"><%=request.getParameter("createListingRet")%></p>
			<%
			}
			%>

			<%
			if (request.getParameter("askQuestionRet") != null) {
			%>
			<p class="notifications"><%=request.getParameter("askQuestionRet")%></p>
			<%
			}
			%>
		</section>

	</div>
</body>
</html>