<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Create Listing</title>
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
	.container fieldset {
	    width: 94%;
	    margin-bottom: 15px;
	}
	.container fieldset label, .container fieldset input, .container fieldset select {
	    display: block;
	    margin-bottom: 10px;
	}
	.notifications {
	    background-color: #008000;
	}	
</style>
<link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
	<% 
    	//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		String username = (String) session.getAttribute("username");
		if (username == null) {
			response.sendRedirect("Login.jsp");
		}
    %>

    <div class="container">
    	<h1>Create A Listing</h1>
    	<form method="post" action="Listing.jsp">
	    	<fieldset>
	    		<legend>Item Details</legend>
	    		<label for="itemname">Item Name:</label>
	    		<input type="text" id="itemname" name="itemname" value="" maxlength="30" required/>
	    		<label for="subcategory">Subcategory:</label>
	    		<select id="subcategory" name="subcategory" onchange="func()">
	    			<option value="NONE">-SELECT AN OPTION-</option>
	    			<option value="GraphicsCards">Graphics Cards</option>
	    			<option value="CPUs">CPUs</option>
	    			<option value="MotherBoards">Mother Boards</option>
	    		</select>
	    		<label for="subattribute" id="Subattr">Subattribute:</label>
	    		<input type="text" id="subattribute" name="subattribute" value="" maxlength="30" required/>
	    		<label for="price">Starting Price:</label>
	    		<input type="number" id="price" name="price" min="0" value="0" step=".01" required/>
	    		<label for="minsale">Min. Sale Price (Hidden):</label>
	    		<input type="number" id="minsale" name="minsale" min="0.01" value="0" step=".01" required/>
	    		<label for="dt">Closing Date/Time:  </label>
	    		<input type="datetime-local" id="dt" name="dt" required/>
	    		<input type="submit" value="Create"/>
	    	</fieldset>
	    	<a href="UserAccount.jsp">Back</a>
	    	<% if (request.getParameter("msg") != null) { %>
			<p class="notifications"><%=request.getParameter("msg")%></p>
			<% } %>
    	</form>
    </div>
    <script>
    	function func(){
    	    var idElement = document.getElementById("subcategory");
    	    var selectedValue = idElement.options[idElement.selectedIndex].text;   
    	    if(selectedValue=="CPUs"){document.getElementById("Subattr").innerHTML = "Cores: ";}
    	   	else if(selectedValue=="GraphicsCards"){document.getElementById("Subattr").innerHTML = "GB: ";}
    	   	else{document.getElementById("Subattr").innerHTML = "Size: ";}
    	}
    </script>
</body>
</html>
