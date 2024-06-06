<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Verify Listing</title>
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
<div class="container">
    <%
        ApplicationDB db = new ApplicationDB();	
        Connection con = db.getConnection();
        Statement stmt = con.createStatement();
        
        String username = (String) session.getAttribute("username");
        String itemname = request.getParameter("itemname");
        String subcategory = request.getParameter("subcategory");
        String subattribute = request.getParameter("subattribute");
        String price = request.getParameter("price");
        String minsale = request.getParameter("minsale");
        String dt = request.getParameter("dt");
        
        if (username == null) {
            response.sendRedirect("Login.jsp");
        } else if(subcategory.equals("NONE")){
            %>
            <jsp:forward page="UserCreateListing.jsp">
            <jsp:param name="msg" value="You must select a subcategory."/> 
            </jsp:forward>
        <%}else{
            try {
                String insert = "INSERT INTO listings(itemname, subcategory, subattribute, price, minsale, dt) " 
                        + "VALUES(?, ?, ?, ?, ?, ?)";
                
                PreparedStatement ps = con.prepareStatement(insert);
                ps.setString(1, itemname);
                ps.setString(2, subcategory);
                ps.setString(3, subattribute);
                ps.setString(4, price);
                ps.setString(5, minsale);
                ps.setString(6, dt);
                ps.executeUpdate();
                
                insert = "INSERT INTO posts(l_id, username) " 
                        + "VALUES((SELECT MAX(l_id) FROM listings),?)";
                ps = con.prepareStatement(insert);
                ps.setString(1, username);
                ps.executeUpdate();
                
                %>
                <jsp:forward page="UserAccount.jsp">
                <jsp:param name="createListingRet" value="Listing successfully created."/> 
                </jsp:forward>
                <% 
            } catch (SQLException e) {
                String code = e.getSQLState();
                if (code.equals("23000")) {
                    %>
                    <jsp:forward page="UserCreateListing.jsp">
                    <jsp:param name="msg" value="This Listing already exists."/> 
                    </jsp:forward>
                    <%
                } else {
                    %>
                    <jsp:forward page="UserAccount.jsp">
                    <jsp:param name="msg" value="Error creating listing. Please try again."/> 
                    </jsp:forward>
                    <%
                }
            } catch (Exception e) {
                out.print("Unknown exception.");
                %>
                <jsp:forward page="UserAccount.jsp">
                <jsp:param name="msg" value="Error creating listing. Please try again."/> 
                </jsp:forward>
                <%
            }
        }
    %>
</div>
</body>
</html>
