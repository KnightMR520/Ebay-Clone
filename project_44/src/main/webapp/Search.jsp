<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Search Results</title>
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
            String username = (String) session.getAttribute("username");
            if (username == null) {
                response.sendRedirect("Login.jsp");
            }
            String subcat = request.getParameter("subcat");
            String searchVal = request.getParameter("search");
        %>
        <h1>Search Results: <%=subcat%></h1>
        <table>
            <tr>  
                <td><a href="Home.jsp">Home</a></td>
                <td>|</td>
                <td><a href="UserAccount.jsp">Account</a></td>
                <td>|</td>
                <td><a href="Logout.jsp">Logout</a></td>
            </tr>
        </table>
        <div>
            <br>
            <form class="form-inline" method="post" action="Search.jsp?subcat=<%=subcat%>&search=<%=searchVal%>">
                <select name="sortby" id="sortby">
                    <option value="None">---</option>
                    <option value="Name">Name</option>
                    <option value="lowToHigh">Price (Ascending)</option>
                    <option value="highToLow">Price (Descending)</option>
                    <option value="Tag">Tag</option>
                    <option value="Open">Status: Open</option>
                    <option value="Closed">Status: Closed</option>
                </select>    
                <button type="submit" name="sortBy" >Sort By</button>
            </form>
        </div>
        <% 
            Statement stmt = con.createStatement();
            String sortParam = request.getParameter("sortby");
            ResultSet resultset = null;
            if (sortParam == null) {
                resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='"+subcat+"' AND itemname LIKE '%"+searchVal+"%';");
            } else {
                switch(sortParam) {
                    case "Name":
                        resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='"+subcat+"' AND itemname LIKE '%"+searchVal+"%' ORDER BY itemname;");
                        break;
                    case "lowToHigh":
                        resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='"+subcat+"' AND itemname LIKE '%"+searchVal+"%' ORDER BY price;");
                        break;
                    case "highToLow":
                        resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='"+subcat+"' AND itemname LIKE '%"+searchVal+"%' ORDER BY price DESC;");
                        break;
                    case "Tag":
                        resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='"+subcat+"' AND itemname LIKE '%"+searchVal+"%' ORDER BY subattribute;");
                        break;
                    case "Open":
                        resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='"+subcat+"' AND closed='0' AND itemname LIKE '%"+searchVal+"%' ORDER BY itemname;");
                        break;
                    case "Closed":
                        resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='"+subcat+"' AND closed='1' AND itemname LIKE '%"+searchVal+"%' ORDER BY itemname;");
                        break;
                    default:
                        resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='"+subcat+"' AND itemname LIKE '%"+searchVal+"%';");
                }
            }
        %>
        <br><br>
        <form method="post" action="ExamineListing.jsp">
            <TABLE BORDER="1">
                <TR>
                    <TH></TH>
                    <TH>Name</TH>
                    <TH>Tag</TH>
                    <TH>Price</TH>
                    <TH>Status</TH>
                </TR>
                <% while(resultset.next()){ 
                    String status = resultset.getString(8);
                %>
                <TR>
                    <TD> <button name="lid" type="submit" value="<%= resultset.getString(1) %>">>></button></TD>
                    <TD> <%=resultset.getString(2)%></TD>
                    <TD> <%= resultset.getString(4) %></TD>
                    <TD> <%= resultset.getString(5) %></TD>
                    <%if(status.equals("0")){
                        %>
                        <TD bgcolor="green">Open</TD>
                        <%
                    }else{
                        %>
                        <TD bgcolor="red">CLOSED</TD>
                        <%
                    } %>
                </TR>
                <% } %>
            </TABLE>
        </form>
    </div>
</body>
</html>
