<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Professional Employee Login Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            width: 300px;
            padding: 16px;
            background-color: white;
            margin: 0 auto;
            margin-top: 100px;
            border-radius: 4px;
            box-shadow: 0px 0px 10px 0px #000;
        }
        .container h2 {
            text-align: center;
            color: #333;
        }
        .container form .form-group {
            margin-bottom: 15px;
        }
        .container form .form-group label {
            display: block;
            color: #666;
        }
        .container form .form-group input {
            width: 93%;
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
        .container .login {
            text-align: center;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Employee Login</h2>
        <form method="post" action="VerifyStaffLogin.jsp">
            <div class="form-group">
                <label for="employee_id">Employee ID:</label>
                <input type="text" id="employee_id" name="employee_id" maxlength="30" required/>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" maxlength="30" required/>
            </div>
            <div class="form-group">
                <input type="submit" value="Log in"/>
            </div>
            <% if (request.getParameter("registerRet") != null) { %>
                <p style="text-align: center; color: blue"><%=request.getParameter("registerRet")%></p>
            <% } else if (request.getParameter("loginRet") != null) { %>
                <p style="text-align: center; color: red"><%=request.getParameter("loginRet")%></p>
            <% } %>
        </form>
        <div class="login">
            Not an employee? <a href="Login.jsp">Login Here!</a>
        </div>
    </div>
</body>
</html>