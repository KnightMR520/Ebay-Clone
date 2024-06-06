<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
    ApplicationDB database = new ApplicationDB();
    Connection connection = database.getConnection();

    String operationType = request.getParameter("operation");
    String listingId = request.getParameter("lid");
    PreparedStatement preparedStatement;
    String sql;

    if (operationType.equals("removeListing")) {
        sql = "DELETE FROM listings WHERE l_id=(?)";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, listingId);
        preparedStatement.executeUpdate();
        response.sendRedirect("CustomerRepHome.jsp");
    } else if (operationType.equals("removeBid")) {
        String bidId = request.getParameter("bid");
        sql = "DELETE FROM bids WHERE b_id=(?)";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, bidId);
        preparedStatement.executeUpdate();

        sql = "SELECT MAX(b.price) FROM listings l INNER JOIN bidson bd ON bd.l_id = l.l_id INNER JOIN bids b ON b.b_id = bd.b_id WHERE l.l_id=(?)";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, listingId);
        ResultSet resultSet = preparedStatement.executeQuery();
        String updatedPrice = resultSet.next() ? resultSet.getString(1) : null;

        if (updatedPrice == null) {
            sql = "UPDATE listings SET price=0.01 WHERE l_id=(?)";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, listingId);
        } else {
            sql = "UPDATE listings SET price=(?) WHERE l_id=(?)";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, updatedPrice);
            preparedStatement.setString(2, listingId);
        }
        preparedStatement.executeUpdate();
%>
        <jsp:forward page="CustomerRepEditListing.jsp">
            <jsp:param name="lid" value="<%= listingId %>"/>
        </jsp:forward>
<%
    }
%>
</body>
</html>