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
	String SessionCompanyKey = (session.getAttribute("clm_company_key").equals(""))?"0001":(String)session.getAttribute("clm_company_key");
	String clm_product_id = (request.getParameter("_product_id")==null)?"":request.getParameter("_product_id");

	System.out.println("> " + param_seq + " / " + param_seq);

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../conn_info.jsp" %>
<html>
<head>
	<title>제품 기록</title>

	<!-- Scripts Starts -->
	<script src="../../assets/js/jquery-1.12.2.min.js"></script>
	<script src="../../assets/js/bootstrap.min.js"></script>

	<script src="../../assets/js/propeller.min.js"></script>
	
	<%@ include file="../../include/style_info_inc.jsp" %>
</head>

<body topmargin="0"  leftmargin="0" marginwidth="0" marginheight="0">
											<form class="form-horizontal">
												<div class="form-group pmd-textfield pmd-textfield-floating-label">
													<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%">
														<thead>
															<tr>
																<tr>
																	<th style="border-top:5px solid #666;  border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">제품 코드</th>
																	<th style="border-top:5px solid #666;  border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">변경전 수량</th>
																	<th style="border-top:5px solid #666;  border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">변경후 수량</th>
																	<th style="border-top:5px solid #666;  border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">입고 수량</th>
																	<th style="border-top:5px solid #666;  border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">사용 수량</th>
																	<th style="border-top:5px solid #666;  border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">특이사항</th>
																</td>
															</tr>
															</tr>
														</thead>
														<tbody>
<%

try {
	stmt = conn.createStatement();

	String query = "";
	query = " select x.clm_company_key ,x.clm_material_id,x.clm_before_count,x.clm_after_count,x.clm_income_move,clm_use_move,x.clm_comment,y.clm_product_name  ";
	query += " from tbl_stock_move_log x ";
	query += " left outer join tbl_product_info y on x.clm_material_id = y.clm_product_id and x.clm_company_key  =  y.clm_company_key  ";
	query += " where x.clm_material_type = 'P' and x.clm_company_key = '"+ SessionCompanyKey +"' and x.clm_material_id ='"+ clm_product_id +"' ";
	query += " order by clm_material_id ";
	System.out.println("> productInfoRegPop.q.0 " + query);
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
		String clm_material_id					 = rs.getString("clm_material_id");
		String clm_before_count					 = rs.getString("clm_before_count");
		String clm_after_count					 = rs.getString("clm_after_count");
		String clm_income_move					 = rs.getString("clm_income_move");
		String clm_use_move						 = rs.getString("clm_use_move");
		String clm_comment						 = rs.getString("clm_comment");
		String clm_product_name					 = rs.getString("clm_product_name");
%>		 


				<tr id="tr_<%=clm_material_id %>">
					<td style="font-size:14px;  border:1px solid #ccc; text-align:center;"><%=clm_product_name %></td>
					<td style="font-size:14px;  border:1px solid #ccc; text-align:right;"><%=clm_before_count %></td>
					<td style="font-size:14px;  border:1px solid #ccc; text-align:right;"><%=clm_after_count %></td>
					<td style="font-size:14px;  border:1px solid #ccc; text-align:right;"><%=clm_income_move %></td>
					<td style="font-size:14px;  border:1px solid #ccc; text-align:right;"><%=clm_use_move %></td>
					<td style="font-size:14px;  border:1px solid #ccc; text-align:center;"><%=clm_comment %></td>
					
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