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
		<title>직원 목록</title>
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
			strCondition += "and x.clm_client_id in (" + strOrderIdList + ") ";
			String query  = "";
			query  = "";
			query += "select ";
			query += "x.* ";
			query += "from ";
			query += "	tbl_client_info x ";
			query += "where 1=1 and x.clm_delete_yn='N' " + strCondition + " and clm_company_key = '" + SessionCompanyKey + "' ";
			query += "order by x.clm_client_id desc;";
			System.out.println("> " + strCurrentReportId + ".data_list " + query);
			rs = stmt.executeQuery(query);
%>
	<body>
			<table style="width:100%;">
				<thead>
					<tr>
						<th style="text-align:center; background-color:#ccc;">업체명</th>
						<th style="text-align:center; background-color:#ccc;">대표자명</th>
						<th style="text-align:center; background-color:#ccc;">주소</th>
						<th style="text-align:center; background-color:#ccc;">상세주소</th>
						<th style="text-align:center; background-color:#ccc;">연락처</th>
						<th style="text-align:center; background-color:#ccc;">Fax</th>
						<th style="text-align:center; background-color:#ccc;">Phone</th>
					</tr>
				</thead>
				<tbody>
<%

			while (rs.next()) {
				iRowCnt++;
				String clm_client_id			 = rs.getString("clm_client_id");
				String clm_client_tel			 = rs.getString("clm_client_tel");
				String clm_client_phone		 = rs.getString("clm_client_phone");
				String clm_client_addr			 = rs.getString("clm_client_addr");
				String clm_reg_datetime			 = rs.getString("clm_reg_datetime");
				String clm_reg_user			 = rs.getString("clm_reg_user");
				String clm_update_user		 = rs.getString("clm_update_user");
				String clm_update_datetime		 = rs.getString("clm_update_datetime");
				String clm_client_address_detail			 = rs.getString("clm_client_address_detail");
				String clm_comment				 = rs.getString("clm_comment");
				String clm_client_serial_no		 = rs.getString("clm_client_serial_no");
				String clm_client_name				 = rs.getString("clm_client_name");
				String clm_client_fax			 = rs.getString("clm_client_fax");
%>
					<tr>
						<td><%=clm_client_name %></td>
						<td style="text-align:center;"><%=clm_client_name %></td>
						<td style="text-align:left;"><%=clm_client_addr %></td>
						<td style="text-align:left;"><%=clm_client_address_detail %></td>
						<td style="text-align:center;"><%=clm_client_tel %></td>
						<td style="text-align:center;"><%=clm_client_fax %></td>
						<td style="text-align:center;"><%=clm_client_phone %></td>
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
