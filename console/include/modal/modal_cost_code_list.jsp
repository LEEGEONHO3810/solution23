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
	<title>견적관리시스템</title>

	<!-- Scripts Starts -->
	<script src="../../assets/js/jquery-1.12.2.min.js"></script>
	<script src="../../assets/js/bootstrap.min.js"></script>

	<script src="../../assets/js/propeller.min.js"></script>
	<script>
		$(document).ready(function() {
			$.fnc_select = function(code_id, code_name,clm_max_code_sub_id) {
				window.parent.$.fnc_select_to_parent('<%=param_seq %>',code_id,code_name,clm_max_code_sub_id);
			}
		});
	</script>
	<%@ include file="../../include/style_info_inc.jsp" %>
</head>

<body topmargin="0"  leftmargin="0" marginwidth="0" marginheight="0">
											<form class="form-horizontal">
												<div class="form-group pmd-textfield pmd-textfield-floating-label">
													<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%">
														<thead>
															<tr>
																<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:8px; font-weight:bold; text-align:center;">상위코드</th>
																<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:8px; font-weight:bold; text-align:center;">상위 코드명</th>
																<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:8px; font-weight:bold; text-align:center;">선택</th>
															</tr>
														</thead>
														<tbody>
<%
		// String _clm_comment            = "";
		// String _clm_reg_user           = "";
		// String _clm_reg_datetime       = "";
		// String _clm_update_user        = "";
		// String _clm_update_datetime    = "";
		int sub_code_max_count = 0;
		
	
		Statement modal_stmt = null;

		try {
			modal_stmt = conn.createStatement();
			String modal_strCondition = "";
			if(!param_code_id.equals("")) {
				modal_strCondition += "and x.clm_code_id='" + param_code_id + "'";
			} 

			String modal_query = "select x.clm_code_id,x.clm_code_name, max(y.clm_code_sub_id) clm_max_code_sub_id from tbl_code_info x left outer join tbl_code_sub_info y on x.clm_code_id = y.clm_code_id where 1=1 " + modal_strCondition + "group by x.clm_code_id,x.clm_code_name order by cast(x.clm_code_id as numeric) asc;";
			System.out.println("> modal_query : " + modal_query);
			ResultSet modal_rs = modal_stmt.executeQuery(modal_query);

			int iRowCnt = 0;
			while (modal_rs.next()) {
				String mod_code_id         = modal_rs.getString("clm_code_id");
				String mod_code_name       = modal_rs.getString("clm_code_name");
				String clm_max_code_sub_id = modal_rs.getString("clm_max_code_sub_id");

				if(clm_max_code_sub_id == null){
					clm_max_code_sub_id = "0000";
				}
						System.out.println("> " + mod_code_id + " " + mod_code_name);


%>				 


															<tr>
																<td style="font-size:14px; border:1px solid #ccc; text-align:center;"><%=mod_code_id %></td>
																<td style="font-size:14px; border:1px solid #ccc; text-align:left;"><%=mod_code_name %></td>
																<td style="font-size:14px; border:1px solid #ccc; text-align:center;" class="modal_list_td">
																	<a href="#" style="font-weight:bold; color:#4285f4;  " onClick="JavaScript:$.fnc_select('<%=mod_code_id %>','<%=mod_code_name %>','<%=clm_max_code_sub_id %>');" data-dismiss="modal">
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