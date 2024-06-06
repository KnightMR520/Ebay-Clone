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
            <a href="Home.jsp">Home</a>
        </nav>
        <% 
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            String username = (String) session.getAttribute("username");
            if (username == null) {
                response.sendRedirect("Login.jsp");
            }
            String lid = request.getParameter("lid");
            Statement stmt = con.createStatement();
            ResultSet resultset = stmt.executeQuery("SELECT * from listings WHERE l_id='"+lid+"';");

            String name = null;
            String subcat = null;
            String subattr = null;
            String price = null;
            String minsale = null;
            String cdt = null;
            String status = null;
            Double p = null;
            Double m = null;
            Double minbid = null;
            Double minprice = null;

            Statement stmt2 = con.createStatement();
            ResultSet fetchposter = stmt2.executeQuery("SELECT username from posts WHERE l_id="+lid+";");
            String postedby = null;

            while(resultset.next()){
                name = resultset.getString(2);
                subcat = resultset.getString(3);
                subattr = resultset.getString(4);
                price = resultset.getString(5);
                minsale = resultset.getString(6);
                cdt = resultset.getString(7);
                status = resultset.getString(8);

                p = Double.parseDouble(price);
                p = Math.round(p * 100.0)/100.0;
                minbid = p+.01;
                minbid = Math.round(minbid * 100.0)/100.0;

                minprice = Double.parseDouble(minsale);
                minprice = Math.round(minprice * 100.0)/100.0;
            }

            while(fetchposter.next()){
                postedby = fetchposter.getString(1);
            }
        %>

        <h1><%=name%></h1>
        <% if (status.equals("0")) { %>
            <p><b>Current Price: $<%=price%></b></p>
        <% } %>

        <% if (!postedby.equals(username)) { %>
            <form method="post" action="Bid.jsp">
                <table>
                    <tr>
                        <td><input type="hidden" name="lid" value="<%=lid%>" /></td>
                    </tr>
                    <tr>
                        <td><input type="hidden" name="price" value="<%=price%>" /></td>
                    </tr>

                    <% if(status.equals("0")){ %>
                        <tr>
                            <td>Bid: <input type="number" required name="bid" min="0" value="<%=minbid%>" step=".01"></td>
                        </tr>
                        <tr>
                            <td><input type="submit" value="Make Bid" style="width: 100%;"/></td>
                        </tr>
                    <% } %>
                </table>
            </form>
            <form method="post" action="AutoBid.jsp">
                <table>
                    <tr>
                        <td><input type="hidden" name="lid" value="<%=lid%>" /></td>
                    </tr>
                    <tr>
                        <td><input type="hidden" name="price" value="<%=price%>" /></td>
                    </tr>

                    <% if(status.equals("0")){ %>
                        <tr>
                            <td style="text-align: center"> or </td>
                        </tr>
                        <tr>
                            <td>Bid Limit: <input type="number" required name="bid_limit" min="0" step=".01"></td>
                        </tr>
                        <tr>
                            <td>Increment: <input type="number" required name="increment" min="0" step=".01"></td>
                        </tr>
                        <tr>
                            <td><input type="submit" value="Set Automatic Bid" style="width: 100%;"/></td>
                        </tr>
                    <% } %>
                </table>
            </form>
        <% } %>

        <% if (p >= minprice && status.equals("1") ) { %>
            <table>
                <tr>
                    <td><h4>ITEM SOLD!</h4></td>
                </tr>
                <tr>
                    <td>Sale Price: $<%=price%></td>
                </tr>
            </table>
        <% } else if (status.equals("1")) { %>
            <table>
                <tr>
                    <td><h4>Auction Closed: No Winner ;(</h4></td>
                </tr>
                <tr>
                    <td>Final Price: $<%=price%></td>
                </tr>
                <tr>
                    <td>Desired Minimum: $<%=minprice%></td>
                </tr>
            </table>
        <% } %>

        <% if (request.getParameter("msg") != null) { %>
            <table>
                <tr>
                    <td style="text-align: center; color: red"><%=request.getParameter("msg")%></td>
                </tr>
            </table>
        <% } %>

        <% if (request.getParameter("makeBidRet") != null) { %>
            <tr>
                <td><p style="text-align: center; color: blue"><%=request.getParameter("makeBidRet")%></p></td>
            </tr>
        <% } %>
    </div>

    <hr>
    <h3>Details:</h3>
    <p><b>Seller: </b><%=postedby%></p>
    <p><b>Closing Date/Time: </b><%=cdt%></p>
    <p><b>Subcategory: </b><%=subcat%></p>
    <p><b>Subattribute: </b><%=subattr%></p>
    <hr>

    <div class="container">
        <h3>Bid History</h3>
        <%
            Statement stmt3 = con.createStatement();
            ResultSet bidhist = stmt3.executeQuery("SELECT b.b_id, price, username, dtime from bids b "+
                    "LEFT JOIN bidson bo on bo.b_id = b.b_id LEFT JOIN places p on p.b_id = bo.b_id " +
                    "WHERE l_id= " +lid+";");
        %>

        <table BORDER="1">
            <TR>
                <TH>Price</TH>
                <TH>Bidder</TH>
                <TH>Date/Time</TH>
            </TR>
            <% while(bidhist.next()){ %>
            <TR>
                <TD><%=bidhist.getString(2)%></TD>
                <TD><%=bidhist.getString(3)%></TD>
                <TD><%=bidhist.getString(4)%></TD>
            </TR>
            <% } %>
        </TABLE>
        <hr>
        <h3>Similar Items</h3>
        <%
            Statement stmt4 = con.createStatement();
            ResultSet similar = stmt4.executeQuery("SELECT * from listings WHERE l_id != "+lid+" AND (itemname LIKE '%"+name+"%' OR subattribute LIKE '%"+subattr+"%');");
        %>
        <form method="post" action="ExamineListing.jsp">
            <table BORDER="1">    
                <TR>
                    <TH>View</TH>
                    <TH>Item Name</TH>
                    <TH>Subcategory</TH>
                    <TH>Attribute</TH>
                </TR>
                <% while(similar.next()){ %>
                <TR>
                    <TD> <button name="lid" type="submit" value="<%= similar.getString(1) %>">>></button></TD>
                    <TD><%=similar.getString(2)%></TD>
                    <TD><%=similar.getString(3)%></TD>
                    <TD><%=similar.getString(4)%></TD>
                </TR>
                <% } %>
            </TABLE>
        </form>
    </div>
</body>
</html>