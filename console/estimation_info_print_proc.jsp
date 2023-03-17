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
<%@ include file="include/session_info.jsp" %>
<%@ include file="include/conn_info.jsp" %>
<%@ include file="include/menu_info.jsp" %>
<%@ include file="include/request_info.jsp" %>
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
<script type="text/javascript" language="javascript">
	window.onload = function() {
		window.print();
	};
</script>
<%
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
			// String[] headers = new String[] { "주문명", "견적가", "작업지주소", "작업시작일자", "작업종료일자", "연면적", "대지면적", "건축물구조", "층고", "해체신고여부", "공사행정진행", "고객명", "작업명", "등록직원", "견적가액" };

			stmt = conn.createStatement();
			String strCondition = "";
			strCondition += "and x.clm_order_id in (" + strOrderIdList + ") ";
			String query  = "";
			query += "select x.*, y.* ";
			query += "	   , (TO_CHAR(to_timestamp(substring(x.clm_reg_datetime, 1, 10),'YYYYMMDDHH24MI'),'YYYY-MM-DD HH24:MI')) clm_reg_datetime_formatted ";
			query += "     , (CASE ";
			query += "			 WHEN clm_order_state_type='A' THEN '견적' ";
			query += "			 WHEN clm_order_state_type='B' THEN '주문' ";
			query += "			 WHEN clm_order_state_type='C' THEN '주문취소' ";
			query += "		  END) clm_order_state_type_name ";
			query += "	   , coalesce((select y.clm_client_name from tbl_client_info y where y.clm_client_id=x.clm_client_id), '-') clm_user_name ";
			query += "     , coalesce((select y.clm_user_name from fn_user_info(x.clm_reg_user_id) y), '-') clm_reg_user_name ";
			query += "     , (select count(*) from tbl_order_file y where y.clm_order_id=x.clm_order_id) clm_file_count ";
			query += "from ";
			query += "	tbl_order_info x, tbl_work_info y ";
			query += "where 1=1 and x.clm_del_yn='N' and x.clm_order_id=y.clm_order_id " + strCondition + " ";
			query += " order by x.clm_order_id desc";
			System.out.println("> " + strCurrentReportId + ".data_list " + query);
			rs = stmt.executeQuery(query);
%>
	<body>
		<div id="div_table">
			<table style="width:100%;">
				<thead>
					<tr>
						<th style="text-align:center; background-color:#ccc;">관리번호</th>
						<th style="text-align:center; background-color:#ccc;">의뢰업체</th>
						<th style="text-align:center; background-color:#ccc;">작업명</th>
						<th style="text-align:center; background-color:#ccc;">작업시작일자</th>
						<th style="text-align:center; background-color:#ccc;">작업종료일자</th>
						<th style="text-align:center; background-color:#ccc;">연면적</th>
						<th style="text-align:center; background-color:#ccc;">층고</th>
						<th style="text-align:center; background-color:#ccc;">견적가액</th>
						<th style="text-align:center; background-color:#ccc;">상태</th>
						<th style="text-align:center; background-color:#ccc;">등록일시</th>
						<th style="text-align:center; background-color:#ccc;">등록직원</th>
					</tr>
				</thead>
				<tbody>
<%

			while (rs.next()) {
				iRowCnt++;
				String clm_order_id								 = rs.getString("clm_order_id");
				String clm_order_name							 = rs.getString("clm_order_name");
				String clm_order_estimation_price				 = rs.getString("clm_order_estimation_price");
				String clm_building_address						 = rs.getString("clm_building_address");
				String clm_building_start_datetime				 = rs.getString("clm_building_start_datetime");
				String clm_building_fininsh_datetime			 = rs.getString("clm_building_fininsh_datetime");
				String clm_building_volume						 = rs.getString("clm_building_volume");
				String clm_building_base_volume					 = rs.getString("clm_building_base_volume");
				String clm_building_type						 = rs.getString("clm_building_type");
				String clm_building_height						 = rs.getString("clm_building_height");
				String clm_building_deconstruction_report_yn	 = rs.getString("clm_building_deconstruction_report_yn");
				String clm_order_state_type_name				 = rs.getString("clm_order_state_type_name");
				String clm_order_state_type						 = rs.getString("clm_order_state_type");
				String clm_order_datetime						 = rs.getString("clm_order_datetime");
				String clm_del_yn								 = rs.getString("clm_del_yn");
				String clm_mail_send_yn							 = rs.getString("clm_mail_send_yn");
				String clm_customer_id							 = rs.getString("clm_customer_id");
				String clm_inbound_user_id						 = rs.getString("clm_inbound_user_id");
				String clm_cancel_yn							 = rs.getString("clm_cancel_yn");
				String clm_comment								 = rs.getString("clm_comment");
				String clm_reg_datetime							 = rs.getString("clm_reg_datetime_formatted");
				String clm_reg_user_id							 = rs.getString("clm_reg_user_id");
				String clm_update_datetime						 = rs.getString("clm_update_datetime");
				String clm_update_user_id						 = rs.getString("clm_update_user_id");
				String clm_file_count							 = rs.getString("clm_file_count");
				String clm_order_email							 = rs.getString("clm_order_email");
				String clm_user_name							 = rs.getString("clm_user_name");
				String clm_estimation_price						 = rs.getString("clm_estimation_price");
				String clm_reg_user_name						 = rs.getString("clm_reg_user_name");
				String clm_work_start_date						 = rs.getString("clm_work_start_date");
				String clm_work_end_date						 = rs.getString("clm_work_end_date");
				String clm_order_state_color = "";
				String clm_mail_send_color = "";

				if(clm_order_state_type.equals("A")) {
					clm_order_state_color = "grey";
				}
				else if(clm_order_state_type.equals("B")) {
					clm_order_state_color = "red";
				}
				else if(clm_order_state_type.equals("C")) {
					clm_order_state_color = "blue";
				}
				else if(clm_order_state_type.equals("C")) {
					clm_order_state_color = "green";
				}

				if(clm_mail_send_yn.equals("Y")) {
					clm_mail_send_color = "grey";
				}
				else if(clm_mail_send_yn.equals("N")) {
					clm_mail_send_color = "red";
				}
%>
					<tr id="tr_<%=clm_order_id %>">
						<td style="text-align:center;">
							<%=clm_order_id %>
						</td>
						<td style="text-align:left;">
							<%=clm_user_name %>
						</td>
						<td style="text-align:left;">
							<%=clm_order_name %>
						</td>
						<td style="text-align:left;">
							<%=clm_work_start_date %>
						</td>
						<td style="text-align:left;">
							<%=clm_work_end_date %>
						</td>
						<td style="text-align:left;">
							<%=clm_building_volume + " ㎡" %>
						</td>
						<td style="text-align:left;">
							<%=clm_building_height + " m" %>
						</td>
						<td style="text-align:right;">\<%=clm_estimation_price %></td>
						<td style="text-align:center;">
							<span class="status-btn blue-bg">
								<%=clm_order_state_type_name %>
							</span>
						</td>
						<td style="text-align:center;"><%=clm_reg_datetime %></td>
						<td style="text-align:center;"><%=clm_reg_user_name %></td>
					</tr>
			
<%
			}
		}
		catch(Exception e) {
			System.out.println("> e " + e);
		}

		stmt.close();
%>
				</tbody>
			</table>
		</div>
	</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>
