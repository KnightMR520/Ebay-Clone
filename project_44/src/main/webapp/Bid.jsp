<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Listing Verification</title>
</head>
<body>
	<%
		try {
			//Establishing database connection
			ApplicationDB database = new ApplicationDB();	
			Connection connection = database.getConnection();
			
			String currentUser = (String) session.getAttribute("username");
			if (currentUser == null) {
				response.sendRedirect("Login.jsp");
			}
			String listingId = request.getParameter("lid");
			String bidAmount = request.getParameter("bid");
			
			PreparedStatement preparedStatement = connection.prepareStatement("SELECT price FROM listings WHERE l_id=(?)");
			preparedStatement.setString(1, listingId);
			ResultSet resultSet = preparedStatement.executeQuery();
			resultSet.next();
			String price = resultSet.getString(1);
			Double bid = Double.parseDouble(bidAmount);
			Double currentPrice = Double.parseDouble(price);
			
            currentPrice = Math.round(currentPrice * 100.0)/100.0;
            bid = Math.round(bid * 100.0)/100.0;
            
			if(bidAmount.equals("NONE")){
				%>
				<jsp:forward page="ExamineListing.jsp">
				<jsp:param name="msg" value="You must input a bid."/> 
				<jsp:param name="lid" value="<%=listingId%>"/> 
				</jsp:forward>
			<% } else if (currentPrice >= bid) { %>
				<jsp:forward page="ExamineListing.jsp">
				<jsp:param name="msg" value="You must input a valid bid."/> 
				<jsp:param name="lid" value="<%=listingId%>"/> 
				</jsp:forward><%
			}else{
				String updateQuery = "UPDATE listings SET price = " + bid + " WHERE l_id = " + listingId;
				PreparedStatement updateStatement = connection.prepareStatement(updateQuery);
				updateStatement.executeUpdate();
				
				String insertBidQuery = "INSERT INTO bids(price, dtime)" 
						+ "VALUES(?,?)";
				PreparedStatement insertBidStatement = connection.prepareStatement(insertBidQuery);
				insertBidStatement.setString(1, bidAmount);
				insertBidStatement.setTimestamp(2, new Timestamp(new java.util.Date().getTime()));
				insertBidStatement.executeUpdate();
				
				String insertBidsonQuery = "INSERT INTO bidson(b_id, l_id)" 
						+ "VALUES((SELECT MAX(b_id) FROM bids),?)";
				PreparedStatement insertBidsonStatement = connection.prepareStatement(insertBidsonQuery);
				insertBidsonStatement.setString(1, listingId);
				insertBidsonStatement.executeUpdate();
				
				String insertPlacesQuery = "INSERT INTO places(b_id, username)" 
						+ "VALUES((SELECT MAX(b_id) FROM bids),?)";
				PreparedStatement insertPlacesStatement = connection.prepareStatement(insertPlacesQuery);
				insertPlacesStatement.setString(1, currentUser);
				insertPlacesStatement.executeUpdate();
				
				
			} 		
			
			%>
			<jsp:forward page="ExamineListing.jsp">
			<jsp:param name="makeBidRet" value="Bid success!"/>
			<jsp:param name="lid" value="<%=listingId%>"/>
			 
			</jsp:forward>
			<% 
		} catch (SQLException e) {
			String errorCode = e.getSQLState();
			e.printStackTrace();
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
