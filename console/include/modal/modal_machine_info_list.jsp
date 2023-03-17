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
	String SessionCompanyKey = (session.getAttribute("clm_company_key").equals(""))?"0001":(String)session.getAttribute("clm_company_key");
	
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
			$.fnc_select = function(machine_id,machine_name,machine_type,machine_type_name) {
				window.parent.$.fnc_select_to_parent_machine('<%=param_seq %>',machine_id,machine_name,machine_type,machine_type_name);
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
																<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:8px; font-weight:bold; text-align:center;">설비명</th>
																<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:8px; font-weight:bold; text-align:center;">타입명</th>
																<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:8px; font-weight:bold; text-align:center;">특이사항</th>
																<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:8px; font-weight:bold; text-align:center;">선택</th>
															</tr>
														</thead>
														<tbody>
<%

		Statement modal_stmt = null;

		try { 
			modal_stmt = conn.createStatement();
			String modal_strCondition = "";
			
			if(!param_code_id.equals("")) {
				modal_strCondition += "and x.clm_code_id='" + param_code_id + "'";
			} 
			
			String query = ""; 
				query = " select coalesce(z1.clm_code_sub_name,'') as clm_machine_type_name,x.clm_machine_id,x.clm_company_key,x.clm_del_yn  ";
				query += " ,x.clm_machine_name,x.clm_machine_type,x.clm_comment";
				query += " from tbl_machine_info x ";
				query += " left outer join tbl_code_sub_info z1 on x.clm_company_key = z1.clm_company_key and x.clm_machine_type = z1.clm_code_sub_id and z1.clm_code_id = '0009' ";
				query += " where x.clm_company_key = '"+ SessionCompanyKey +"' and x.clm_del_yn  = 'N' ";
				query += " order by x.clm_machine_id; ";
				System.out.println("> query : " + query);
				ResultSet modal_rs = modal_stmt.executeQuery(query);	

			int iRowCnt = 0;
			while (modal_rs.next()) {
				String mod_machine_id						 = modal_rs.getString("clm_machine_id");
				String mod_company_key						 = modal_rs.getString("clm_company_key");
				String mod_machine_name						 = modal_rs.getString("clm_machine_name");
				String mod_machine_type_name				 = modal_rs.getString("clm_machine_type_name");
				String mod_machine_type						 = modal_rs.getString("clm_machine_type");
				String mod_comment							 = modal_rs.getString("clm_comment");

				System.out.println("> " + mod_machine_id + " " + mod_machine_id);


%>				 


															<tr>
																<td  style="font-size:14px; border:1px solid #ccc; text-align:left;"><%=mod_machine_name %></td>
																<td  style="font-size:14px; border:1px solid #ccc; text-align:center;"><%=mod_machine_type_name %></td>
																<td  style="font-size:14px; border:1px solid #ccc; text-align:left;"><%=mod_comment %></td>
																<td   style="font-size:14px; border:1px solid #ccc; text-align:center;" class="modal_list_td">
																	<a href="#" style="font-weight:bold; color:#4285f4;  " onClick="JavaScript:$.fnc_select('<%=mod_machine_id %>','<%=mod_machine_name %>','<%=mod_machine_type %>','<%=mod_machine_type_name %>');" data-dismiss="modal">
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