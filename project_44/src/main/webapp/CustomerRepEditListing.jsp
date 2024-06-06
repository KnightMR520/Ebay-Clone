<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Listing Editor</title>
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
    //Get the database connection
    ApplicationDB dbConnection = new ApplicationDB();
    Connection dbCon = dbConnection.getConnection();
    String repID = (String) session.getAttribute("employeeid"); //asker
    if (repID == null) {
        response.sendRedirect("Login.jsp");
    }
    String listingID = request.getParameter("lid");
    Statement statement = dbCon.createStatement();
    ResultSet listingResult = statement.executeQuery("SELECT * from listings WHERE l_id='"+listingID+"';") ;
    String listingName = null;
    String subCategory = null;
    String subAttribute = null;
    String listingPrice = null;
    String minSalePrice = null;
    String closingDateTime = null;
    Double price = null;
    Double minBid = null;

    Statement posterStatement = dbCon.createStatement();
    ResultSet posterResult = posterStatement.executeQuery("SELECT username from posts WHERE l_id="+listingID+";");
    String postedBy = null;

    while(listingResult.next()){
        listingName = listingResult.getString(2);
        subCategory = listingResult.getString(3);
        subAttribute = listingResult.getString(4);
        listingPrice = listingResult.getString(5);
        minSalePrice = listingResult.getString(6);
        closingDateTime = listingResult.getString(7);

        price = Double.parseDouble(listingPrice);
        price = Math.round(price * 100.0)/100.0;
        minBid = price+.01;
        minBid = Math.round(minBid * 100.0)/100.0;
    }

    while(posterResult.next()){
        postedBy = posterResult.getString(1);
    }
%>

    <div class="container">
        <a href="CustomerRepHome.jsp">Exit Listing</a>
        <h1><%=listingName%></h1>

        <table align="center">
            <tr>
                <td><input type="hidden" name="lid" value="<%=listingID%>" /></td>
            </tr>
            <tr>
                <td><input type="hidden" name="price" value="<%=listingPrice%>" /></td>
            </tr>
            <tr>
                <td>Current Price: <%=listingPrice%></td>
            </tr>
        </table>

        <hr>
        <h3><u>Details:</u></h3>
        <p><b>Seller: </b><%=postedBy%></p>
        <p><b>Closing Date/Time: </b><%=closingDateTime%></p>
        <p><b>Subcategory: </b><%=subCategory%></p>
        <p><b>Subattribute: </b><%=subAttribute%></p>
        <p><b>Min. Sale Price: </b><%=minSalePrice%></p>

        <hr>
        <h3>Bid History</h3>
        <%
            Statement bidStatement = dbCon.createStatement();
            ResultSet bidHistory = bidStatement.executeQuery("SELECT b.b_id, price, username, dtime from bids b "+
                "LEFT JOIN bidson bo on bo.b_id = b.b_id LEFT JOIN places p on p.b_id = bo.b_id " +
                "WHERE l_id= " +listingID+";");
        %>

        <form action="EditListing.jsp">
            <TABLE align="center" BORDER="1">
                <TR>
                    <TH>BidID</TH>
                    <TH>Price</TH>
                    <TH>Bidder</TH>
                    <TH>Date/Time</TH>
                </TR>
                <% while(bidHistory.next()){ %>
                <TR>
                    <TD><%=bidHistory.getString(1)%></TD>
                    <TD><%=bidHistory.getString(2)%></TD>
                    <TD><%=bidHistory.getString(3)%></TD>
                    <TD><%=bidHistory.getString(4)%></TD>
                    <td><button name="bid" type="submit" value="<%= bidHistory.getString(1) %>">Remove Bid</button></td>
                </TR>
                <% } %>
            </TABLE>
            <input type="hidden" name="operation" value="removeBid"/>
            <input type="hidden" name="lid" value="<%= listingID %>"/>
        </form>

        <hr>

        <form action="EditListing.jsp">
            <button name="lid" type="submit" value="<%= listingID %>">Remove Listing!</button>
            <input type="hidden" name="operation" value="removeListing"/>
        </form>
        <p> WARNING: Removal of a listing can not be undone!</p>
    </div>
</body>
</html>