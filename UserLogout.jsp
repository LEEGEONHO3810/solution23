<%@ page language ="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
	session.invalidate();
%>
<% 
	String type = (request.getParameter("type")==null)?"":request.getParameter("type");
%>
<script>
<% if(type.equals("UserSession")){ %>
	location.href="./UserLogin.jsp";
<% } else { %>
	location.href="./UserLogin.jsp";
<% } %>
</script>
