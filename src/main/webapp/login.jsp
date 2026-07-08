<%-- 
  MealMate redirect handler to bridge servlet typo redirect to Login.html.
  This preserves the backend servlet class exactly as required.
--%>
<%
    response.sendRedirect("Login.html?error=invalid");
%>
