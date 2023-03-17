<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.sql.*"
	import="java.util.*"
	import="java.text.SimpleDateFormat"
	import="org.json.simple.JSONArray"
	import="org.json.simple.JSONObject"
	import="java.time.LocalDate"
	import="java.time.format.DateTimeFormatter"
	import="java.awt.Color"
	import="java.io.File"
	import="java.io.FileOutputStream"
	import="org.apache.poi.hssf.usermodel.HSSFCell"
	import="org.apache.poi.hssf.usermodel.HSSFRow"
	import="org.apache.poi.hssf.usermodel.HSSFSheet"
	import="org.apache.poi.hssf.usermodel.HSSFWorkbook"
	import="org.apache.poi.ss.usermodel.Cell"
	import="org.apache.poi.ss.usermodel.CellStyle"
	import="org.apache.poi.ss.usermodel.Font"
	import="org.apache.poi.ss.usermodel.Row"
	import="org.apache.poi.ss.usermodel.Sheet"
	import="org.apache.poi.ss.usermodel.Workbook"
	import="org.apache.poi.hssf.usermodel.HSSFCellStyle"
	import="org.apache.poi.ss.usermodel.IndexedColors"
	import="org.apache.poi.ss.usermodel.FillPatternType"
	%>
<%@ include file="include/conn_info.jsp" %>
<%@ include file="include/menu_info.jsp" %>
<%@ include file="include/request_info.jsp" %>
<%@ include file="include/session_info.jsp" %>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<meta name="Generator" content="EditPlus®">
		<meta name="Author" content="">
		<meta name="Keywords" content="">
		<meta name="Description" content="">
		<title>Document</title>
		<style>
		table, td, th {
			border : 1px solid black;
			border-collapse : collapse;
			font-size: 12px;
		};
		</style>
<script>
	window.onload = function() {
		window.print();
	};
</script>
	</head>
<%
		String clm_template_id            = "";
		// String clm_template_name          = "";
		String clm_product_id             = "";
		String clm_product_name           = "";
		String clm_model_name           = "";
		String clm_revision_id            = "";
		String clm_revision_id_prod       = "";
		String clm_update_datetime_format = "";
		String clm_doc_comment = "";

		java.util.Date today = new java.util.Date();
		SimpleDateFormat df = new SimpleDateFormat("YYYYMMddHHmmss");
		String current_date = df.format(today);

		String date_today	 = current_date.replaceAll("/", "");

		_chk_order_id_ = _str_order_id_.split(",");

		try {
			String strOrderIdList = "";
			for(int i=0; i<_chk_order_id_.length; i++) {
				strOrderIdList += "'" + _chk_order_id_[i] + "',";
			}
			int iRowCnt = 0;

			strOrderIdList = strOrderIdList.substring(0, strOrderIdList.length()-1);

			stmt = conn.createStatement();
			String strCondition = "";
			strCondition += "and x.clm_user_id in (" + strOrderIdList + ") ";
			String query  = "";
			query  = "";
			query += "select ";
			query += "x.* ";
			query += ", (select clm_department_name from fn_department_info(x.clm_user_department_id) y) clm_department_name ";
			query += ", (select clm_user_name from fn_user_info(x.clm_reg_user) y) clm_reg_user_name ";
			query += "from ";
			query += "	tbl_user_info x ";
			query += "where 1=1 and x.clm_del_yn='N' " + strCondition + " ";
			query += "order by x.clm_user_id desc;";
			System.out.println("> " + strCurrentReportId + ".data_list " + query);
			rs = stmt.executeQuery(query);
%>
	<body>
			<table style="width:100%;">
				<thead>
					<tr>
						<th style="text-align:center; background-color:#ccc;">직원ID</th>
						<th style="text-align:center; background-color:#ccc;">성명</th>
						<th style="text-align:center; background-color:#ccc;">소속부서</th>
						<th style="text-align:center; background-color:#ccc;">전화번호</th>
						<th style="text-align:center; background-color:#ccc;">FAX</th>
						<th style="text-align:center; background-color:#ccc;">Email</th>
					</tr>
				</thead>
				<tbody>
<%

			while (rs.next()) {
				iRowCnt++;
				String clm_user_id					 = rs.getString("clm_user_id");
				String clm_user_pw					 = rs.getString("clm_user_pw");
				String clm_user_name				 = rs.getString("clm_user_name");
				String clm_user_department_id		 = rs.getString("clm_user_department_id");
				String clm_comment					 = rs.getString("clm_comment");
				String clm_reg_user					 = rs.getString("clm_reg_user");
				String clm_reg_datetime				 = rs.getString("clm_reg_datetime");
				String clm_update_user				 = rs.getString("clm_update_user");
				String clm_update_datetime			 = rs.getString("clm_update_datetime");
				String clm_del_yn					 = rs.getString("clm_del_yn");
				String clm_flavor_operator_yn		 = rs.getString("clm_flavor_operator_yn");
				String clm_user_alias				 = rs.getString("clm_user_alias");
				String clm_balance_type_a_ip		 = rs.getString("clm_balance_type_a_ip");
				String clm_balance_type_b_ip		 = rs.getString("clm_balance_type_b_ip");
				String clm_user_work_yn				 = rs.getString("clm_user_work_yn");
				String clm_user_authority			 = rs.getString("clm_user_authority");
				String clm_user_authority_screen	 = rs.getString("clm_user_authority_screen");
				String clm_user_authority_button	 = rs.getString("clm_user_authority_button");
				String clm_phone_no					 = rs.getString("clm_phone_no");
				String clm_use_yn					 = rs.getString("clm_use_yn");
				String clm_user_seq					 = rs.getString("clm_user_seq");
				String clm_online_ip				 = rs.getString("clm_online_ip");
				String clm_user_img					 = rs.getString("clm_user_img");
				String clm_user_email				 = rs.getString("clm_user_email");
				String clm_user_fax					 = rs.getString("clm_user_fax");
				String clm_user_tel					 = (rs.getString("clm_user_tel")==null)?"":rs.getString("clm_user_tel");
				String clm_department_name			 = (rs.getString("clm_department_name")==null)?"":rs.getString("clm_department_name");
%>
					<tr>
						<td><%=clm_user_id %></td>
						<td style="text-align:left;"><%=clm_user_name %></td>
						<td style="text-align:center;"><%=clm_department_name %></td>
						<td style="text-align:center;"><%=clm_user_tel %></td>
						<td style="text-align:center;"><%=clm_user_fax %></td>
						<td style="text-align:center;"><%=clm_user_email %></td>
					<tr>
<%
			}
		}
		catch(Exception e) {
			System.out.println("> e " + e);
		}

		stmt.close();
%>
	</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>
