<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Viewing Question</title>
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
	    .container form .form-group textarea {
	        width: 100%;
	        height: 250px;
	        padding: 10px;
	        border: 1px solid #ddd;
	        border-radius: 4px;
	        box-sizing: border-box;
	    }
		.container form .form-group button {
		    background-color: #008000;
		    border-color: #006400;
		    color: white;
		    cursor: pointer;
		    padding: 10px 20px;
		    margin-top: 10px;
		    border-radius: 4px;
		    font-size: 16px;
		    width: 100%;
		}
		.container form .form-group button:hover {
		    background-color: #006400;
		}
    </style>
</head>
<body>
    <div class="container">
        <nav>
            <a href="CustomerRepHome.jsp"> Back to Rep Home</a>
        </nav>
        <% 
            // Get the database connection
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            String rep_id = (String) session.getAttribute("employeeid");
            if (rep_id == null) {
                response.sendRedirect("Login.jsp");
            }
            String q_id = request.getParameter("q_id");
            
            String ask_query = "SELECT asker FROM asks WHERE q_id=(?)";
            PreparedStatement ps = con.prepareStatement(ask_query);
            ps.setString(1, q_id);
            ResultSet rs = ps.executeQuery();
            rs.next();
            String asker = rs.getString(1);
            
            String q_text_query = "SELECT q_text FROM question WHERE q_id=(?)";
            ps = con.prepareStatement(q_text_query);
            ps.setString(1, q_id);
            rs = ps.executeQuery();
            rs.next();
            String q_text = rs.getString(1);
        %>
        <h2><%= asker %> asks:</h2>
        <p><%= q_text %></p>
        <hr>
        <%
            ps = con.prepareStatement(
                    "SELECT resolver, resolve_text FROM resolves WHERE q_id=(?)"
            );
            ps.setString(1, q_id);
            String resolver_id = null;
            String resolve_text = null;
            rs = ps.executeQuery();
            if (rs.next()) {
                resolver_id = rs.getString(1);
                resolve_text = rs.getString(2);
            }
            if (resolver_id == null) {
        %>
        <h4>Resolve this issue:</h4>
        <form action="ResolveQuestion.jsp">
            <div class="form-group">
                <textarea style="width:100%; height:250px" name="resolve_text"></textarea>
            </div>
            <div class="form-group">
                <button type="submit">Resolve!</button>
                <input type="hidden" name ="rep_id" value = "<%= rep_id %>" />
                <input type="hidden" name ="q_id" value = "<%= q_id %>" />
            </div>
        </form>
        <% } else { %>
        <h4>Resolved by Customer Rep Id #<%= resolver_id %>:</h4>
        <p><%= resolve_text %></p>
        <% } %>
    </div>
</body>
</html>
