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
<script type="text/javascript" language="javascript">
	window.onload = function() {
		window.print();
	};
</script>
<%
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
			query += "     , (TO_CHAR(to_timestamp(substring(x.clm_reg_datetime, 1, 10),'YYYYMMDDHH24MI'),'YYYY-MM-DD HH24:MI')) clm_reg_datetime_formatted ";
			query += "	   , (CASE ";
			query += "			WHEN clm_work_state = '00' THEN '작업전' ";
			query += "			WHEN clm_work_state = '01' THEN '건축물해체허가신청기간' ";
			query += "			WHEN clm_work_state = '02' THEN '착공계제출' ";
			query += "			WHEN clm_work_state = '03' THEN '감리자계약' ";
			query += "			WHEN clm_work_state = '04' THEN '감리자지정' ";
			query += "			WHEN clm_work_state = '05' THEN '해체착공계제출' ";
			query += "			WHEN clm_work_state = '06' THEN '해체허가완료' ";
			query += "			WHEN clm_work_state = '07' THEN '비산먼지신고기간' ";
			query += "			WHEN clm_work_state = '08' THEN '비산먼지신고' ";
			query += "			WHEN clm_work_state = '09' THEN '특정공사신고' ";
			query += "			WHEN clm_work_state = '10' THEN '도로점용신고' ";
			query += "			WHEN clm_work_state = '11' THEN '건축물구조검토기간' ";
			query += "			WHEN clm_work_state = '12' THEN '건축물구조검토완료' ";
			query += "			WHEN clm_work_state = '13' THEN '철거심의기간' ";
			query += "			WHEN clm_work_state = '14' THEN '철거심의완료' ";
			query += "			WHEN clm_work_state = '15' THEN '건설폐기물신고' ";
			query += "			WHEN clm_work_state = '16' THEN '석면신고기간' ";
			query += "			WHEN clm_work_state = '17' THEN '석면공사' ";
			query += "			WHEN clm_work_state = '18' THEN '해체완료' ";
			query += "			WHEN clm_work_state = '19' THEN '감리완료' ";
			query += "			WHEN clm_work_state = '20' THEN '멸실신고' ";
			query += "			WHEN clm_work_state = '21' THEN '등기정리' ";
			query += "		  END) clm_work_state_type_name ";
			query += "	   , y.clm_work_start_date clm_work_start_date_formatted ";
			query += "     , y.clm_work_end_date clm_work_end_date_formatted ";
			query += "     , coalesce((select y.clm_client_name from tbl_client_info y where y.clm_client_id=x.clm_client_id), '-') clm_user_name ";
			query += "     , (select y.clm_code_name from fn_code_sub_info('0003', x.clm_building_deconstruction_report_yn) y) clm_building_deconstruction_report_yn_name ";
			query += "     , coalesce((select y.clm_user_name from fn_user_info(y.clm_work_manager_id) y), '-') clm_work_manager_name ";
			query += "     , coalesce((select y.clm_user_name from fn_user_info(x.clm_reg_user_id) y), '-') clm_reg_user_name ";
			query += "	   , (select count(*) from tbl_order_file y where y.clm_order_id=x.clm_order_id) clm_file_count ";
			query += "  from tbl_order_info x, tbl_work_info y ";
			query += " where 1=1 and x.clm_order_id=y.clm_order_id and x.clm_del_yn='N' ";
			query += "   and x.clm_order_state_type='B' ";
			query += strCondition + " ";
			query += " order by x.clm_order_id desc;";
			System.out.println("> " + strCurrentReportId + ".data_list " + query);
			rs = stmt.executeQuery(query);
%>
	<body>
		<table style="width:100%;">
			<thead>
				<tr>
					<th style="text-align:center; background-color:#ccc;" width="60px;">관리번호</th>
					<th style="text-align:center; background-color:#ccc;" width="200px;">의뢰업체</th>
					<th style="text-align:center; background-color:#ccc;">작업명</th>
					<th style="text-align:center; background-color:#ccc;" width="150px;">작업기간</th>
					<th style="text-align:center; background-color:#ccc;" width="70px;">진척률</th>
					<th style="text-align:center; background-color:#ccc;" width="80px;">비용집행</th>
					<th style="text-align:center; background-color:#ccc;" width="140px;">상태</th>
				</tr>
			</thead>
			<tbody>
<%

			while (rs.next()) {
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
				String clm_reg_user_name						 = rs.getString("clm_reg_user_name");
				String clm_work_progress_01						 = rs.getString("clm_work_progress_01");
				String clm_work_progress_02						 = rs.getString("clm_work_progress_02");
				String clm_hold_state							 = rs.getString("clm_hold_state");
				String clm_work_start_date						 = rs.getString("clm_work_start_date");
				String clm_work_end_date						 = rs.getString("clm_work_end_date");
				String clm_work_manager_id						 = rs.getString("clm_work_manager_id");
				String clm_purchased_work_price					 = rs.getString("clm_purchased_work_price");
				String clm_work_estimation_price				 = rs.getString("clm_estimation_price");
				String clm_work_state_type_name					 = rs.getString("clm_work_state_type_name");
				String clm_work_manager_name					 = rs.getString("clm_work_manager_name");
				String clm_work_start_date_formatted			 = rs.getString("clm_work_start_date_formatted");
				String clm_work_end_date_formatted				 = rs.getString("clm_work_end_date_formatted");
				String clm_user_name							 = rs.getString("clm_user_name");

				String clm_work_cost_total						 = rs.getString("clm_work_cost_total");
				String clm_work_income_total					 = rs.getString("clm_work_income_total");
				String clm_work_calc_total						 = rs.getString("clm_work_calc_total");
				String clm_work_cost_total_without_comma		 = clm_work_cost_total.replace(",", "");
				String clm_work_income_total_without_comma		 = clm_work_income_total.replace(",", "");
				String clm_work_calc_total_without_comma		 = clm_work_calc_total.replace(",", "");
				String clm_estimation_price_without_comma		 = clm_work_estimation_price.replace(",", "");
				if(clm_estimation_price_without_comma.equals("0")) {
					clm_estimation_price_without_comma = clm_work_cost_total_without_comma;
				}
				int clm_work_purchased_rate_tmp						 = (int)((Double.parseDouble(clm_work_cost_total_without_comma)/Double.parseDouble(clm_estimation_price_without_comma))*100);
				String clm_work_purchased_rate						 = String.format("%,d", clm_work_purchased_rate_tmp);
				String clm_order_state_color = "";
				String clm_mail_send_color = "";

				java.util.Date today = new java.util.Date();
				SimpleDateFormat df = new SimpleDateFormat("YYYY/MM/dd");
				String current_date = df.format(today);

				String date_start	 = clm_work_start_date.replaceAll("/", "");
				String date_end		 = clm_work_end_date.replaceAll("/", "");
				String date_today	 = current_date.replaceAll("/", "");

				SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
				
				java.util.Date date_gap_start	 = format.parse( date_start );
				java.util.Date date_gap_end		 = format.parse( date_end );
				java.util.Date date_gap_today	 = format.parse( date_today );
				
				String start_date = date_start.replaceAll("-", "");
				String end_date = date_end.replaceAll("-", "");
				String today_date = date_today.replaceAll("-", "");

				SimpleDateFormat format_dt = new SimpleDateFormat("yyyyMMdd");

				/* Date타입으로 변경 */

				java.util.Date dt_start_date = format_dt.parse( start_date );
				java.util.Date dt_end_date = format_dt.parse( end_date );
				java.util.Date dt_today_date = format_dt.parse( today_date );
				long sec_start_date = (dt_end_date.getTime() - dt_start_date.getTime()) / 1000; // 초
				long sec_end_date = (dt_today_date.getTime() - dt_start_date.getTime()) / 1000; // 초
				long sec_today_date = (dt_today_date.getTime() - dt_end_date.getTime()) / 1000; // 초
				long Min = (dt_end_date.getTime() - dt_start_date.getTime()) / 60000; // 분
				long Hour = (dt_end_date.getTime() - dt_start_date.getTime()) / 3600000; // 시
				long day_start_date = sec_start_date / (24*60*60); // 일자수
				long day_end_date = sec_end_date / (24*60*60); // 일자수
				long day_today_date = sec_today_date / (24*60*60); // 일자수
				int day_date_rate = (int)(((double)day_end_date/(double)day_start_date)*100);
				String day_date_rate_info = (day_date_rate>100)?"100":String.valueOf(day_date_rate);

				if(clm_order_state_type.equals("A")) {
					clm_order_state_color = "grey";
				}
				else if(clm_order_state_type.equals("B")) {
					clm_order_state_color = "red";
				}
				else if(clm_order_state_type.equals("C")) {
					clm_order_state_color = "blue";
				}
				else if(clm_order_state_type.equals("D")) {
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
						<td style="text-align:center;">
							<%=clm_work_start_date_formatted %>&nbsp;~&nbsp;<%=clm_work_end_date_formatted %>
						</td>
						<td style="text-align:right;">
							<%=day_date_rate_info %>&nbsp;%&nbsp;
						</td>
						<td style="text-align:right;">
							<%=clm_work_purchased_rate %>&nbsp;%
						</td>
						<td style="text-align:center;">
							<%=clm_work_state_type_name %>
						</td>
					</tr>
			
<%
				iRowCnt++;
			}
		}
		catch(Exception e) {
			System.out.println("> e " + e);
		}

		stmt.close();
%>
			</tbody>
		</table>
	</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>
