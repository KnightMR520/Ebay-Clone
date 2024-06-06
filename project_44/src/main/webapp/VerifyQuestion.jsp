<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Ask a Question</title>
</head>
<body>
    
    <div>
        <h1>Customer Rep. Help</h1>
        <form method="post" action="VerifyQuestion.jsp">
            <table>
                <tr>  
                    <td><p><label for="question">Please fill out the form below:</label></p>
                        <textarea id="question" name="question" rows="4" cols="50">Ask us anything!</textarea>
                    </td>
                </tr>
                <tr>
                    <td><input type="submit" value="Post"/></td>
                </tr>
                <tr>
                    <td><a href="UserAccount.jsp">Back</a></td>
                </tr>                    
                <% if (request.getParameter("msg") != null) { %>
                <tr>
                    <td><p><%=request.getParameter("msg")%></p></td>
                </tr>
                <% } %>
            </table>
        </form>
    </div>
    <script>
        document.getElementById('question').addEventListener('focus', function() {
            if (this.value === 'Ask us anything!') {
                this.value = '';
            }
        });

        document.getElementById('question').addEventListener('blur', function() {
            if (this.value === '') {
                this.value = 'Ask us anything!';
            }
        });
    </script>
    <%
        try {
            // Get the database connection
            ApplicationDB db = new ApplicationDB();    
            Connection con = db.getConnection();
            Statement stmt = con.createStatement();
            
            String username = (String) session.getAttribute("username");
            if (username == null) {
                response.sendRedirect("Login.jsp");
            }
            String question = request.getParameter("question"); // Their question
            
            String insert = "INSERT INTO question(q_text) " 
                    + "VALUES(?)";
            
            PreparedStatement ps = con.prepareStatement(insert);
            ps.setString(1, question);
            ps.executeUpdate();
            
            insert = "INSERT INTO asks(asker, q_id) " 
                    + "VALUES(?, (SELECT MAX(q_id) FROM question))";
            
            ps = con.prepareStatement(insert);
            ps.setString(1, username);
            ps.executeUpdate();
            
            %>
            <jsp:forward page="UserAccount.jsp">
            <jsp:param name="askQuestionRet" value="Question posted!"/> 
            </jsp:forward>
            <% 
        } catch (SQLException e) {
            String code = e.getSQLState();
            if (code.equals("23000")) {
                %>
                <jsp:forward page="UserAskQuestion.jsp">
                <jsp:param name="msg" value="ERROR"/> 
                </jsp:forward>
                <%
            } else {
                %>
                <jsp:forward page="UserAskQuestion.jsp">
                <jsp:param name="msg" value="ERROR"/> 
                </jsp:forward>
                <%
            }
        } catch (Exception e) {
            out.print("Unknown exception.");
            %>
            <jsp:forward page="UserAskQuestion.jsp">
            <jsp:param name="msg" value="ERROR"/> 
            </jsp:forward>
            <%
        }
    %>
</body>
</html>