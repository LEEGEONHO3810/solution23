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
			strOrderIdList = strOrderIdList.substring(0, strOrderIdList.length()-1);
			
			int iRowCnt = 0;
			stmt = conn.createStatement();
			String strCondition = "";
			strCondition += "and x.clm_notice_id in (" + strOrderIdList + ") ";
			String query  = "";
			query  = "";
			query += "select x.* ";
			query += "     , (select clm_user_name from fn_user_info(x.clm_reg_user_id) y) clm_reg_user_name ";
			query += "     , (select count(*) from tbl_order_file y where y.clm_order_id=x.clm_notice_id) clm_file_count ";
			query += "  from tbl_notice_info x ";
			query += " where 1=1 and x.clm_del_yn='N' ";
			query += strCondition + " ";
			query += " order by x.clm_notice_id desc;";
			System.out.println("> " + strCurrentReportId + ".data_list " + query);
			rs = stmt.executeQuery(query);
%>
	<body>
			<table style="width:100%;">
				<thead>
					<tr>
						<th style="text-align:center; background-color:#ccc;">공지번호</th>
						<th style="text-align:center; background-color:#ccc;">공지제목</th>
						<th style="text-align:center; background-color:#ccc;">시작일자</th>
						<th style="text-align:center; background-color:#ccc;">종료일자</th>
						<th style="text-align:center; background-color:#ccc;">작성자</th>
					</tr>
				</thead>
				<tbody>
<%

			while (rs.next()) {
				iRowCnt++;
				String clm_notice_id         = rs.getString("clm_notice_id");
				String clm_notice_contents   = rs.getString("clm_notice_contents");
				String clm_notice_start_date = rs.getString("clm_notice_start_date");
				String clm_notice_end_date   = rs.getString("clm_notice_end_date");
				String clm_notice_type       = rs.getString("clm_notice_type");
				String clm_del_yn            = rs.getString("clm_del_yn");
				String clm_comment           = rs.getString("clm_comment");
				String clm_reg_datetime      = rs.getString("clm_reg_datetime");
				String clm_reg_user_id       = rs.getString("clm_reg_user_id");
				String clm_update_datetime   = rs.getString("clm_update_datetime");
				String clm_update_user_id    = rs.getString("clm_update_user_id");
				String clm_notice_title      = rs.getString("clm_notice_title");
				String clm_file_count        = rs.getString("clm_file_count");
				String clm_reg_user_name     = rs.getString("clm_reg_user_name");

				if(clm_notice_start_date.equals("null")){
					clm_notice_start_date = "";
				}

				if(clm_notice_end_date.equals("null")){
					clm_notice_end_date = "";
				}
%>
					<tr>
						<td style="text-align:center;"><%=clm_notice_id %></td>
						<td style="text-align:left;"><%=clm_notice_title %></td>
						<td style="text-align:center;"><%=clm_notice_start_date %></td>
						<td style="text-align:center;"><%=clm_notice_end_date %></td>
						<td style="text-align:center;"><%=clm_reg_user_name %></td>
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
