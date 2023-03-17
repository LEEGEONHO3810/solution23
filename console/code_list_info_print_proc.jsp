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

		// SimpleDateFormat format = new SimpleDateFormat("YYYY/MM/dd");
		// DateFormat format = new SimpleDateFormat("yyyyMMdd");
		// System.out.println("> " + date_today);

		_chk_order_id_ = _str_order_id_.split(",");

		try {
			String strOrderIdList = "";
			for(int i=0; i<_chk_order_id_.length; i++) {
				strOrderIdList += "'" + _chk_order_id_[i] + "',";
			}
			int iRowCnt = 0;

			strOrderIdList = strOrderIdList.substring(0, strOrderIdList.length()-1);
			// String[] headers = new String[] { "주문명", "견적가", "작업지주소", "작업시작일자", "작업종료일자", "연면적", "대지면적", "건축물구조", "층고", "해체신고여부", "공사행정진행", "고객명", "작업명", "등록직원", "견적가액" };

			stmt = conn.createStatement();
			String strCondition = "";
			strCondition += "and (x.clm_code_id || '-' || x.clm_code_sub_id) in (" + strOrderIdList + ") ";
			String query  = "";
			query += "select ";
			query += "x.* ";
			query += "from ";
			query += "	tbl_code_info x ";
			query += "where 1=1 and x.clm_del_yn='N' and x.clm_code_sub_id<>'0000' " + strCondition + " ";
			query += "order by x.clm_code_id, x.clm_code_sub_id asc;";
			System.out.println("> " + strCurrentReportId + ".data_list " + query);
			rs = stmt.executeQuery(query);
%>
	<body>
			<table style="width:100%;">
				<thead>
					<tr>
						<th style="text-align:center; background-color:#ccc;">상위코드</th>
						<th style="text-align:center; background-color:#ccc;">하위코드</th>
						<th style="text-align:center; background-color:#ccc;">상위코드명</th>
						<!--
						<th style="text-align:center; background-color:#ccc;">작업시작일자</th>
						<th style="text-align:center; background-color:#ccc;">작업종료일자</th>
						-->
						<th style="text-align:center; background-color:#ccc;">하위코드명</th>
						<th style="text-align:center; background-color:#ccc;">코드값</th>
						<th style="text-align:center; background-color:#ccc;">특이사항</th>
					</tr>
				</thead>
				<tbody>
<%

			while (rs.next()) {
				iRowCnt++;
				String clm_code_id			 = rs.getString("clm_code_id");
				String clm_code_sub_id		 = rs.getString("clm_code_sub_id");
				String clm_code_total		 = rs.getString("clm_code_total");
				String clm_code_seq			 = rs.getString("clm_code_seq");
				String clm_code_value		= rs.getString("clm_code_value");
				String clm_code_price		 = rs.getString("clm_code_price");
				String clm_code_unit		 = rs.getString("clm_code_unit");
				String clm_code_name		 = rs.getString("clm_code_name");
				String clm_code_sub_name	 = rs.getString("clm_code_sub_name");
				String clm_comment			 = rs.getString("clm_comment");
				String clm_reg_datetime		 = rs.getString("clm_reg_datetime");
				String clm_reg_user			 = rs.getString("clm_reg_user");
				String clm_update_datetime	 = rs.getString("clm_update_datetime");
				String clm_update_user		 = rs.getString("clm_update_user");
				String clm_code_unit_type	 = rs.getString("clm_code_unit_type");
				String clm_del_yn			 = rs.getString("clm_del_yn");
%>
					<tr>
						<td style="text-align:center;"><%=clm_code_id %></td>
						<td style="text-align:center;"><%=clm_code_sub_id %></td>
						<td style="text-align:center;"><%=clm_code_name %></td>
						<td style="text-align:left;"><%=clm_code_sub_name %></td>
						<td style="text-align:left;"><%=clm_code_value %></td>
						<td style="text-align:left;"><%=clm_comment %></td>
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
