<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.sql.*"
	import="java.util.*"
	import="java.text.SimpleDateFormat"
	import="org.json.simple.JSONArray"
	import="org.json.simple.JSONObject"
	import="java.time.LocalDate"
	import="java.time.format.DateTimeFormatter"
%>
<%
	String param_seq = (request.getParameter("seq")==null)?"":request.getParameter("seq");
	String param_code_id = (request.getParameter("code_id")==null)?"":request.getParameter("code_id");
	String param_code_sub_id = (request.getParameter("code_sub_id")==null)?"":request.getParameter("code_sub_id");

	System.out.println("> " + param_code_id + " / " + param_code_sub_id);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../conn_info.jsp" %>
<html>
<head>
<title>MES시스템</title>
<script src="../../assets/js/jquery-1.12.2.min.js"></script>
<script src="../../assets/js/bootstrap.min.js"></script>
<script src="../../assets/js/propeller.min.js"></script>
<script>
	$(document).ready(function() {
		$.fnc_select = function(client_id, client_name, client_address, client_employee_name, email, client_tel, comment) {
			window.parent.$.fnc_select_to_parent_customer(client_id, client_name, client_address, client_employee_name, email, client_tel, comment);
		}
	});
</script>
</head>
<%@ include file="../../include/style_info_inc.jsp" %>
<body topmargin="0"  leftmargin="0" marginwidth="0" marginheight="0">
	<form class="form-horizontal">
		<div class="form-group pmd-textfield pmd-textfield-floating-label">
			<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%">
				<thead>
					<tr>
						<th>고객명</th>
						<th>담당자</th>
						<th>특이사항</th>
						<th>선택</th>
					</tr>
				</thead>
				<tbody>
<%
		Statement modal_stmt = null;

		try {
			modal_stmt = conn.createStatement();
			String modal_strCondition = "";
			if(!param_code_id.equals("")) {
				modal_strCondition += "and x.clm_customer_id='" + param_code_id + "'";
			}
			String modal_query = "select x.* from tbl_client_info x where 1=1 " + modal_strCondition;
			System.out.println("> modal_query : " + modal_query);
			ResultSet modal_rs = modal_stmt.executeQuery(modal_query);

			int iRowCnt = 0;
			while (modal_rs.next()) {
				String mod_client_name          = modal_rs.getString("clm_client_name");
				String mod_client_tel           = modal_rs.getString("clm_client_tel");
				String mod_client_address       = modal_rs.getString("clm_client_addr");
				String mod_client_employee_name = modal_rs.getString("clm_client_employee_name");
				String mod_client_id            = modal_rs.getString("clm_client_id");
				String mod_comment              = modal_rs.getString("clm_comment");
				String mod_client_serial_no     = modal_rs.getString("clm_client_serial_no");
				String mod_email                = modal_rs.getString("clm_client_email");

				String customer_info = mod_client_employee_name + ((mod_client_tel.equals(""))?"":"(" + mod_client_tel + ")");

				// System.out.println("> " + mod_code_id + " " + mod_code_sub_id);
%>
				<tr>
					<td><%=mod_client_name %></td>
					<td><%=customer_info %></td>
					<td><%=mod_comment %></td>
					<td class="modal_list_td">
						<a href="#" style="font-weight:bold; color:#4285f4;" onClick="JavaScript:$.fnc_select('<%=mod_client_id %>', '<%=mod_client_name %>', '<%=mod_client_address %>', '<%=mod_client_employee_name %>', '<%=mod_email %>', '<%=mod_client_tel %>', '<%=mod_comment %>');" data-dismiss="modal">
							선택
						</a>
					</td>
				</tr>
<%
				iRowCnt++;
			}

			if(iRowCnt==0) {
%>
				<tr>
					<td colspan="4">조회된 정보가 없습니다.</td>
				</tr>
<%
			}
		}
		catch(Exception e) {
			System.out.println("> e.toString().0 " + e.toString());
		}

		modal_stmt.close();
%>
				</tbody>
			</table>
		</div>
	</form>
</body>
</html>
<%@ include file="../conn_close_info.jsp" %>