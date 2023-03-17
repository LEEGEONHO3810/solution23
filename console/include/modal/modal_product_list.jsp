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

	System.out.println("> " + param_seq + " / " + param_seq);

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
		function fnc_select(product_id, product_name, product_code, product_main_type_name, product_sub_type_name, product_spec,stock_count){
			window.parent.$.fnc_select_to_parent_product('<%=param_seq %>',product_id, product_name, product_code, product_main_type_name, product_sub_type_name, product_spec,stock_count);
		}
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
																	<th style="border-top:5px solid #666;  border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">대분류</th>
																	<th style="border-top:5px solid #666;  border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">소분류</th>
																	<th style="border-top:5px solid #666;  border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">제품명</th>
																	<th style="border-top:5px solid #666;  border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">제품크기</th>
																	<th style="border-top:5px solid #666;  border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">제품재고</th>
																	<th style="border-top:5px solid #666;  border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">선택</th>
																</td>
															</tr>
															</tr>
														</thead>
														<tbody>
<%

try {
	stmt = conn.createStatement();

	String query = "";
	query = " select x.clm_product_id,z2.clm_code_sub_id,z1.clm_code_sub_name, x.clm_company_key, x.clm_product_code,y.clm_stock_count ";
	query += " , x.clm_product_name,coalesce(z1.clm_code_sub_name,'') as clm_product_main_type_name, x.clm_comment,x.clm_delete_yn ";
	query += " , coalesce(z2.clm_code_sub_name,'') as clm_product_sub_type_name , coalesce(z3.clm_code_sub_name,'') as clm_product_spec_name ,coalesce(z4.clm_code_sub_name,'') as clm_product_code_name ";
	query += " from tbl_product_info x ";
	query += " left outer join tbl_product_stock y on x.clm_product_id = y.clm_product_id and x.clm_company_key = y.clm_company_key ";
	query += " left outer join tbl_code_sub_info z1 on x.clm_company_key = z1.clm_company_key and x.clm_product_main_type = z1.clm_code_sub_id and z1.clm_code_id = '0005' ";
	query += " left outer join tbl_code_sub_info z2 on x.clm_company_key = z2.clm_company_key and x.clm_product_sub_type = z2.clm_code_sub_id and z2.clm_code_id = '0006' ";
	query += " left outer join tbl_code_sub_info z3 on x.clm_company_key = z3.clm_company_key and x.clm_product_spec = z3.clm_code_sub_id and z3.clm_code_id = '0007' ";
	query += " left outer join tbl_code_sub_info z4 on x.clm_company_key = z4.clm_company_key and x.clm_product_code = z4.clm_code_sub_id and z4.clm_code_id = '0008' ";
	query += " where x.clm_company_key = '" + SessionCompanyKey + "'";
	query += " order by x.clm_product_id ";
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
		String mod_product_id					 = rs.getString("clm_product_id");
		String mod_product_name					 = rs.getString("clm_product_name");
		String mod_company_key					 = rs.getString("clm_company_key");
		String mod_product_code					 = rs.getString("clm_product_code");
		String mod_product_code_name			 = rs.getString("clm_product_code_name");
		String mod_product_main_type_name		 = rs.getString("clm_product_main_type_name");
		String mod_product_sub_type_name		 = rs.getString("clm_product_sub_type_name");
		String mod_product_spec_name			 = rs.getString("clm_product_spec_name");
		String mod_delete_yn					 = rs.getString("clm_delete_yn");
		String mod_comment			 			 = rs.getString("clm_comment");
		String mod_stock_count			 	 	 = rs.getString("clm_stock_count");

%>		 


				<tr id="tr_<%=mod_product_id %>">
					<td style="font-size:14px;  border:1px solid #ccc; text-align:center;"><%=mod_product_main_type_name %></td>
					<td style="font-size:14px;  border:1px solid #ccc; text-align:center;"><%=mod_product_sub_type_name %></td>
					<td style="font-size:14px;  border:1px solid #ccc; text-align:left;"><%=mod_product_name %></td>
					<td style="font-size:14px;  border:1px solid #ccc; text-align:center;"><%=mod_product_code %></td>
					<td style="font-size:14px;  border:1px solid #ccc; text-align:right;"><%=mod_stock_count %></td>
					<td style="font-size:14px;  border:1px solid #ccc; text-align:center;">
						<a href="#" style="font-weight:bold; color:#4285f4;  " onClick="fnc_select('<%=mod_product_id %>','<%=mod_product_name %>','<%=mod_product_code %>','<%=mod_product_main_type_name %>','<%=mod_product_sub_type_name %>','<%=mod_product_spec_name %>','<%=mod_stock_count %>');" data-dismiss="modal">
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