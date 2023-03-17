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
<%@ page import="java.text.DecimalFormat" %>
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
		$(document).ready(function() {
			$.fnc_select = function(material_id, material_name, material_code, material_main_type, material_sub_type, material_unit,stock_count) {
				window.parent.$.fnc_select_to_parent_material_stock('<%=param_seq %>',material_id, material_name, material_code, material_main_type, material_sub_type, material_unit,stock_count);
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
																	<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">대분류</th>
																	<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">소분류</th>
																	<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">자재명</th>
																	<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">자재코드</th>
																	<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">자재재고</th>
																	<th style="border-top:5px solid #666; border:1px solid #ccc; font-size:10px; font-weight:bold; text-align:center;">선택</th>
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
	query = " select x.clm_material_id,z2.clm_code_sub_id,z1.clm_code_sub_name, x.clm_company_key, x.clm_material_code, x.clm_material_name ,x.clm_material_main_type ,coalesce(z1.clm_code_sub_name,'') as clm_material_main_type_name, x.clm_comment, x.clm_material_safety_stock,x.clm_delete_yn,x.clm_reg_user,x.clm_reg_datetime,x.clm_update_user,x.clm_update_datetime ";
	query += " , coalesce(x.clm_material_sub_type, '') clm_material_sub_type, coalesce(z2.clm_code_sub_name,'') as clm_material_sub_type_name , coalesce(x.clm_material_unit, '') clm_material_unit, coalesce(z3.clm_code_sub_name,'') as clm_material_unit_name,c.clm_stock_count ";
	query += " from tbl_material_info x ";
	query += " left outer join tbl_code_sub_info z1 on x.clm_company_key = z1.clm_company_key and x.clm_material_main_type = z1.clm_code_sub_id and z1.clm_code_id = '0001' ";
	query += " left outer join tbl_code_sub_info z2 on x.clm_company_key = z2.clm_company_key and x.clm_material_sub_type = z2.clm_code_sub_id and z2.clm_code_id = '0002' ";
	query += " left outer join tbl_code_sub_info z3 on x.clm_company_key = z3.clm_company_key and x.clm_material_unit = z3.clm_code_sub_id and z3.clm_code_id = '0003' ";
	query += " left outer join tbl_material_stock c on x.clm_material_id = c.clm_material_id and x.clm_company_key = c.clm_company_key ";
	query += " where x.clm_company_key = '" + SessionCompanyKey + "'";
	query += " order by x.clm_material_id ";
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

	String int_clm_stock_count = "";
	String float_clm_stock_count = "";

	DecimalFormat decFormat = new DecimalFormat("###,###");


	int iRowCnt = 0;
	while (rs.next()) {
		String mod_material_id				 = rs.getString("clm_material_id");
		String mod_material_name		 	 = rs.getString("clm_material_name");
		String mod_material_code			 = rs.getString("clm_material_code");
		String mod_main_type				 = rs.getString("clm_material_main_type_name");
		String mod_sub_type				 	 = rs.getString("clm_material_sub_type_name");
		String mod_material_unit			 = rs.getString("clm_material_unit_name");
		String mod_stock_count			 	 = rs.getString("clm_stock_count");


		
		if(mod_stock_count.contains(".")){
			String[] split_clm_stock_count = mod_stock_count.split("\\.");
			int_clm_stock_count = split_clm_stock_count[0];
			float_clm_stock_count = split_clm_stock_count[1];
		 }else{
			int_clm_stock_count = mod_stock_count;
		 }
		 System.out.println(int_clm_stock_count);
		 mod_stock_count = decFormat.format(Integer.parseInt(int_clm_stock_count));


		 if(!float_clm_stock_count.equals("")){

			mod_stock_count = mod_stock_count + "." + float_clm_stock_count;

		 }



													
%>		 


				<tr id="tr_<%=mod_material_id %>">
					<td style="font-size:14px; border:1px solid #ccc; text-align:left;"><%=mod_main_type %></td>
					<td style="font-size:14px; border:1px solid #ccc; text-align:left;"><%=mod_sub_type %></td>
					<td style="font-size:14px; border:1px solid #ccc; text-align:left;"><%=mod_material_name %></td>
					<td style="font-size:14px; border:1px solid #ccc; text-align:center;"><%=mod_material_code %></td>
					<td style="font-size:14px; border:1px solid #ccc; text-align:center;"><%=mod_stock_count %></td>
					<td>
						<a href="#" style="font-weight:bold; color:#4285f4;  " onClick="JavaScript:$.fnc_select('<%=mod_material_id %>','<%=mod_material_name %>','<%=mod_material_code %>','<%=mod_main_type %>','<%=mod_sub_type %>','<%=mod_material_unit %>','<%=mod_stock_count %>');" data-dismiss="modal">
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