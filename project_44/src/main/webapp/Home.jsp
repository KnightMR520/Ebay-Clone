<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Home</title>
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
        .notifications {
            background-color: #008000;
        }
    </style>
</head>
<body>
    <%
        ApplicationDB db = new ApplicationDB();    
        Connection con = db.getConnection();
        String username = (String) session.getAttribute("username");
        if (username == null) { response.sendRedirect("Login.jsp"); }    
    %>
    <div class="container">
        <h1>Computer PARTS (Ebay)</h1>
        <table>
            <tr>
                <td><a href="GraphicsCards.jsp">Graphics Cards</a></td>
                <td><a href="CPUs.jsp">CPUs</a></td>
                <td><a href="MotherBoards.jsp">Mother Boards</a></td>
            </tr>
        </table>
        <table>
            <tr>
                <td><a href="UserViewQuestions.jsp">QA</a></td>
                <td><a href="UserAccount.jsp">Account</a></td>
                <td><a href="Logout.jsp">Logout</a></td>
            </tr>
        </table>
    	<%  PreparedStatement ps = con.prepareStatement(
    			"SELECT l.itemname, l.price, MAX(b.price) AS user_max_bid " +
				"FROM places p " +
    			"INNER JOIN bidson bo ON bo.b_id = p.b_id " + 
				"INNER JOIN bids b ON b.b_id = p.b_id " +
				"INNER JOIN listings l ON bo.l_id = l.l_id " + 
				"WHERE p.username =(?) AND l.closed=0 " +
				"GROUP BY l.l_id " +
				"HAVING user_max_bid < l.price");
    		ps.setString(1, username);
    		ResultSet lostBids = ps.executeQuery();
    		
    		ps = con.prepareStatement(
    			"SELECT l.itemname, l.price, ab.b_limit " +
    			"FROM auto_bids ab " +
    			"INNER JOIN listings l ON ab.l_id = l.l_id " +
    			"WHERE ab.u_id =(?) AND l.closed=0 " +
    			"HAVING l.price > ab.b_limit");
    		ps.setString(1, username);
    		ResultSet lostAutoBids = ps.executeQuery();	
    		
    		ps = con.prepareStatement(
    			"SELECT DISTINCT l.itemname, l.price " +
  				"FROM listings l " +
  				"INNER JOIN bidson bd ON l.l_id = bd.l_id " +
  				"INNER JOIN bids b ON bd.b_id = b.b_id " + 
  				"INNER JOIN places p ON p.b_id = b.b_id " +
  				"WHERE l.closed=1 AND l.price=b.price AND l.l_id IN (SELECT g.l_id FROM generates g) AND p.username=(?)");
    		ps.setString(1, username);
    		ResultSet wonAuctions = ps.executeQuery();
    		
    		ps = con.prepareStatement(
        		"SELECT l.itemname " +
    			"FROM listings l " +
        		"INNER JOIN interests i ON l.itemname LIKE CONCAT('%', i.interest, '%') " + 
    			"WHERE i.username =(?) AND l.closed=0");
        	ps.setString(1, username);
        	ResultSet interests = ps.executeQuery();
       	 %>
        <table class="notifications">
            <tr><th>Notifications</th></tr>
            <% while(lostBids.next()) { %>
                <tr>
                    <td>
                        <span style="color:red">Alert! </span>Your bid on '<%= lostBids.getString(1) %>' is no longer the highest bid!
                        <p style="padding: 0">Your bid: $<%= lostBids.getString(3) %><br>Max bid: $<%= lostBids.getString(2) %></p>
                    </td>
                </tr>
            <% } %>
            <% while(lostAutoBids.next()) { %>
                <tr>
                    <td>
                        <span style="color:red">Alert! </span>Your auto bid limit on '<%= lostAutoBids.getString(1) %>' is below the current bid price.
                        <p style="padding: 0">Your limit: $<%= lostAutoBids.getString(3) %><br>Max bid: $<%= lostAutoBids.getString(2) %></p>
                    </td>
                </tr>
            <% } %>
            <% while(wonAuctions.next()) { %>
                <tr>
                    <td>
                        <span style="color:green">Congrats!</span> You won the auction '<%=wonAuctions.getString(1)%>'
                            with your bid of $<%=wonAuctions.getString(2)%>
                    </td>
                </tr>
            <% } %>
            <% while(interests.next()) { %>
                <tr>
                    <td>
                        <span style="color:blue">Availability Alert! </span>Your interest '<%=interests.getString(1)%>' is up for auction!
                    </td>
                </tr>
            <% } %>
        </table>
    </div>
</body>
</html>