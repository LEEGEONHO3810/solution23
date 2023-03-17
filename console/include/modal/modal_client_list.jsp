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
	String SessionCompanyKey = (session.getAttribute("clm_company_key").equals(""))?"0001":(String)session.getAttribute("clm_company_key");

	System.out.println("> " + param_code_id + " / " + param_code_sub_id);

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../conn_info.jsp" %>
	
		
		
<html>
<head>
	<title>에코비즈텍</title>

	<!-- Scripts Starts -->
	<script src="../../assets/js/jquery-1.12.2.min.js"></script>
	<script src="../../assets/js/bootstrap.min.js"></script>

	<script src="../../assets/js/propeller.min.js"></script>
	<script>
		$(document).ready(function() {
			$.fnc_select = function(client_id, client_name,client_addr) {
				window.parent.$.fnc_select_to_parent('<%=param_seq %>',client_id, client_name,client_addr);
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
																<tr>
																	<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:8px; font-weight:bold; text-align:center; width: 140px;">업체명</th>
																	<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:8px; font-weight:bold; text-align:center; width: 150px;">업체 대표명</th>
																	<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:8px; font-weight:bold; text-align:center;">업체 주소</th>
																	<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:8px; font-weight:bold; text-align:center; width: 60px;">선택</th>
																</td>
															</tr>
															</tr>
														</thead>
														<tbody>
<%

try {
	stmt = conn.createStatement();

	String query = "";
	query  = "";
	query += " select x.* ";
	query += " from tbl_client_info x  ";
	query += " where 1=1 and x.clm_delete_yn='N' and x.clm_company_key = '" + SessionCompanyKey + "' ";
	query += " order by x.clm_client_id desc;";
	rs = stmt.executeQuery(query);
	String reqDateStr = "";
	java.util.Date curDate = null;
	SimpleDateFormat dateFormat = null;
	java.util.Date reqDate = null;
	long reqDateTime = 0;
	long curDateTime = 0;
	long minute = 0;
	String duration_minute = "";
	String iSubRowCntFormatted = "";
	int iRowCnt = 0;
	while (rs.next()) {
		String mod_client_name			 = rs.getString("clm_client_name");
		String mod_client_addr		 	 = rs.getString("clm_client_addr");
		String mod_client_id			 = rs.getString("clm_client_id");
		String mod_client_ceo				 = rs.getString("clm_client_ceo");
													
%>		 


				<tr id="tr_<%=mod_client_id %>">
					<td style="font-size:14px; border:1px solid #ccc; text-align:left;"><%=mod_client_name %></td>
					<td style="font-size:14px; border:1px solid #ccc; text-align:center;"><%=mod_client_ceo %></td>
					<td style="font-size:14px; border:1px solid #ccc; text-align:left;"><%=mod_client_addr %></td>
					<td style="font-size:14px; border:1px solid #ccc; text-align:center;">
						<a href="#" style="font-weight:bold; color:#4285f4;  " onClick="JavaScript:$.fnc_select('<%=mod_client_id %>','<%=mod_client_name %>','<%=mod_client_addr %>');" data-dismiss="modal">
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
%>
														</tbody>
													</table>
												</div>
											</form>
</body>
</html>
<%@ include file="../conn_close_info.jsp" %>