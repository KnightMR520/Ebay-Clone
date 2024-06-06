<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.sql.Timestamp, java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Viewing Sales Report</title>
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
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .container form .form-group input[type="submit"] {
            background-color: #5cb85c;
            border-color: #4cae4c;
            color: white;
            cursor: pointer;
        }
        .container .logout {
            text-align: right;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <nav>
            <a href="AdminHomePage.jsp"> Exit Sales Report</a>
        </nav>
        <% 
            ApplicationDB db = new ApplicationDB();    
            Connection con = db.getConnection();
            
            String start = request.getParameter("date1");
            String end = request.getParameter("date2");
            SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            SimpleDateFormat printer = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss");
            
            Timestamp date1 = new Timestamp(fmt.parse(start).getTime());
            Timestamp date2 = new Timestamp(fmt.parse(end).getTime());
            try {
                String total_earnings = getTotalEarnings(con, date1, date2);
        %>
        <h1>Viewing Sale Report</h1>
        <h3>From: <%= printer.format(fmt.parse(start)) %></h3>
        <h3>To: <%= printer.format(fmt.parse(end)) %></h3>
        <hr>
        <h3>Total Earnings: $<%= total_earnings %></h3>
        <%
            ResultSet rs = getBestSellingItems(con, date1, date2);
        %>
        <br>
        <h4>Best Selling Items</h4>
        <%= generateTable(rs, new String[]{"Item", "Category", "Earnings", "Number Sold"}) %>
        
        <%
            rs = getBestSellingCategories(con, date1, date2);
        %>
        <br>
        <h4>Best Selling Categories</h4>
        <%= generateTable(rs, new String[]{"Category", "Earnings", "Number Items Sold"}) %>
        
        <%
            rs = getBiggestSpenders(con, date1, date2);
        %>
        <br>
        <h4>Biggest Spenders</h4>
        <%= generateTable(rs, new String[]{"Username", "Total Spent", "Number Items Bought"}) %>
        
        <%
            rs = getBiggestEarners(con, date1, date2);
        %>
        <br>
        <h4>Biggest Earners</h4>
        <%= generateTable(rs, new String[]{"Username", "Total Earnings", "Number Items Bought"}) %>
        
        <%
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>
    </div>
</body>
</html>

<%!
    private String getTotalEarnings(Connection con, Timestamp date1, Timestamp date2) throws SQLException {
        PreparedStatement ps = con.prepareStatement(
            "SELECT SUM(price) " +
            "FROM listings l " +
            "WHERE " +
                "dt >= (?) AND dt <= (?) AND closed=1 " +
                "AND l.l_id IN (SELECT g.l_id FROM generates g)"
        );
        ps.setTimestamp(1, date1);
        ps.setTimestamp(2, date2);
        ResultSet rs = ps.executeQuery();
        String total_earnings = "0.00";
        if (rs.next()) {
            total_earnings = rs.getString(1);
        }
        return total_earnings;
    }

    private ResultSet getBestSellingItems(Connection con, Timestamp date1, Timestamp date2) throws SQLException {
        PreparedStatement ps = con.prepareStatement(
            "SELECT l.itemname, l.subcategory, SUM(price), COUNT(*) " +
            "FROM listings l " +
            "WHERE " +
                "dt >= (?) AND dt <= (?) AND closed=1 " +
                "AND l.l_id IN (SELECT g.l_id FROM generates g) " +
            "GROUP BY l.itemname " +
            "ORDER BY SUM(l.price) DESC"
        );
        ps.setTimestamp(1, date1);
        ps.setTimestamp(2, date2);
        return ps.executeQuery();
    }

    private ResultSet getBestSellingCategories(Connection con, Timestamp date1, Timestamp date2) throws SQLException {
        PreparedStatement ps = con.prepareStatement(
            "SELECT l.subcategory, SUM(price), COUNT(*) " +
            "FROM listings l " +
            "WHERE " +
                "dt >= (?) AND dt <= (?) AND closed=1 " +
                "AND l.l_id IN (SELECT g.l_id FROM generates g) " +
            "GROUP BY l.subcategory " +
            "ORDER BY SUM(l.price) DESC"
        );
        ps.setTimestamp(1, date1);
        ps.setTimestamp(2, date2);
        return ps.executeQuery();
    }

    private ResultSet getBiggestSpenders(Connection con, Timestamp date1, Timestamp date2) throws SQLException {
        PreparedStatement ps = con.prepareStatement(
            "SELECT p.username, SUM(l.price), COUNT(*) " +
            "FROM listings l " +
            "INNER JOIN bidson bd ON l.l_id = bd.l_id " +
            "INNER JOIN bids b ON bd.b_id = b.b_id " + 
            "INNER JOIN places p ON p.b_id = b.b_id " +
            "WHERE l.closed=1 AND l.price=b.price AND l.l_id IN (SELECT g.l_id FROM generates g) " +
            "AND dt >= (?) AND dt <= (?) " +
            "GROUP BY p.username " +
            "ORDER BY SUM(l.price) DESC"
        );
        ps.setTimestamp(1, date1);
        ps.setTimestamp(2, date2);
        return ps.executeQuery();
    }

    private ResultSet getBiggestEarners(Connection con, Timestamp date1, Timestamp date2) throws SQLException {
        PreparedStatement ps = con.prepareStatement(
            "SELECT p.username, SUM(l.price), COUNT(*) " +
            "FROM listings l " +
            "INNER JOIN posts p ON p.l_id = l.l_id " +
            "WHERE l.closed=1 AND l.l_id IN (SELECT g.l_id FROM generates g) " +
            "AND dt >= (?) AND dt <= (?) " +
            "GROUP BY p.username " +
            "ORDER BY SUM(l.price) DESC"
        );
        ps.setTimestamp(1, date1);
        ps.setTimestamp(2, date2);
        return ps.executeQuery();
    }

    private String generateTable(ResultSet rs, String[] headers) throws SQLException {
        StringBuilder sb = new StringBuilder();
        sb.append("<table class=\"center\">\n<tr>\n");
        for (String header : headers) {
            sb.append("<th>").append(header).append("</th>\n");
        }
        sb.append("</tr>\n");
        while (rs.next()) {
            sb.append("<tr>\n");
            for (int i = 1; i <= headers.length; i++) {
                sb.append("<td>").append(rs.getString(i)).append("</td>\n");
            }
            sb.append("</tr>\n");
        }
        sb.append("</table>\n");
        return sb.toString();
    }
%>
