<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Listing Confirmation</title>
</head>
<body>
	<%
		try {
			
			ApplicationDB databaseConnection = new ApplicationDB();	
			Connection connection = databaseConnection.getConnection();
			
			Statement statement = connection.createStatement();
			
			String currentUser = (String) session.getAttribute("username");
			if (currentUser == null) {
				response.sendRedirect("Login.jsp");
			}
			
			String listingIdentifier = request.getParameter("lid");
			PreparedStatement preparedStatement = connection.prepareStatement("SELECT price FROM listings WHERE l_id=(?)");
			preparedStatement.setString(1, listingIdentifier);
			ResultSet resultSet = preparedStatement.executeQuery();
			resultSet.next();
			String price = resultSet.getString(1);
			String bidLimit = request.getParameter("bid_limit");
			String increment = request.getParameter("increment");

			Double limitValue = Double.parseDouble(bidLimit);
			Double incrementValue = Double.parseDouble(increment);
			Double priceValue = Double.parseDouble(price);
            priceValue = Math.round(priceValue * 100.0)/100.0;
            limitValue = Math.round(limitValue * 100.0)/100.0;
            incrementValue = Math.round(incrementValue * 100.0)/100.0;
            
			if (bidLimit.equals("NONE")) {
				%>
				<jsp:forward page="ExamineListing.jsp">
				<jsp:param name="msg" value="You must input a bid limit."/> 
				<jsp:param name="lid" value="<%=listingIdentifier%>"/> 
				</jsp:forward>
			<% } else if (priceValue >= limitValue) { %>
				<jsp:forward page="ExamineListing.jsp">
				<jsp:param name="msg" value="Bid limit must be greater than current bid."/> 
				<jsp:param name="lid" value="<%=listingIdentifier%>"/> 
				</jsp:forward><%
			} else { 
				PreparedStatement ps = connection.prepareStatement(
						"INSERT INTO auto_bids(u_id, l_id, increment, b_limit, current_price) " +
						"VALUES(?, ?, ?, ?, ?) " +
						"ON DUPLICATE KEY UPDATE increment = (?), b_limit = (?), current_price = (?)");
				ps.setString(1, currentUser);
				ps.setString(2, listingIdentifier);
				ps.setDouble(3, incrementValue);
				ps.setDouble(4, limitValue);
				ps.setDouble(5, priceValue);
				ps.setDouble(6, incrementValue);
				ps.setDouble(7, limitValue);
				ps.setDouble(8, priceValue);
				ps.executeUpdate();
			} 		
			
			%>
			<jsp:forward page="ExamineListing.jsp">
			<jsp:param name="makeBidRet" value="Automatic bid added!"/>
			<jsp:param name="lid" value="<%=listingIdentifier%>"/>
			 
			</jsp:forward>
			<% 
		} catch (SQLException e) {
			String errorCode = e.getSQLState();
			if (errorCode.equals("23000")) {
				%>
				<jsp:forward page="UserAccount.jsp">
				<jsp:param name="msg" value="This bid already exists."/> 
				</jsp:forward>
				<%
			} else {
				%>
				<jsp:forward page="UserAccount.jsp">
				<jsp:param name="msg" value="Error making bid... Please try again."/> 
				</jsp:forward>
				<%
			}
		} catch (Exception e) {
			out.print("Unknown exception.");
			%>
			<jsp:forward page="UserAccount.jsp">
			<jsp:param name="msg" value="Error making bid. Please try again."/> 
			</jsp:forward>
			<%
		}
	%>
</body>
</html>