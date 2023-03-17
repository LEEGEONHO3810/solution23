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
	import="java.text.DateFormat"
	%>
<%@ include file="include/session_info.jsp" %>
<%@ include file="include/conn_info.jsp" %>
<%@ include file="include/menu_info.jsp" %>
<%@ include file="include/request_info.jsp" %>
<%
		String saveFolderRoot = "C:/Program Files/Apache Software Foundation/Tomcat9Sever1/webapps/ROOT/ESTIMATION/GAGA/excel";

		if(ss_user_id==null) {
			ss_user_id = "admin";
		}

		String folderPath = saveFolderRoot + "/" + _order_id_;
		String file_name = "";

		java.util.Date c_today = new java.util.Date();
		SimpleDateFormat c_df = new SimpleDateFormat("YYYYMMddHHmmss");
		String c_current_date = c_df.format(c_today);

		String c_date_today	 = c_current_date.replaceAll("/", "");

		if(ss_user_id==null) {
			ss_user_id = "admin";
		}

		file_name = ss_user_id + "_" + c_date_today;
		
		HSSFWorkbook workbook = null;
		HSSFSheet sheet = null;
		
		try {
			String strOrderIdList = "";
			for(int i=0; i<_chk_order_id_.length; i++) {
				strOrderIdList += "'" + _chk_order_id_[i] + "',";
			}
			int iRowCnt = 0;

			strOrderIdList = strOrderIdList.substring(0, strOrderIdList.length()-1);

			stmt = conn.createStatement();
			String strCondition = " and x.clm_order_id in (" + strOrderIdList + ") ";
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
			rs = stmt.executeQuery(query);

			workbook = new HSSFWorkbook();
			sheet = workbook.createSheet("작업 정보 관리");
			Font TestFontHeader = workbook.createFont();
			TestFontHeader.setFontName("맑은 고딕");
			TestFontHeader.setBoldweight(Font.BOLDWEIGHT_BOLD);
			TestFontHeader.setFontHeightInPoints((short) 12);

			CellStyle DataStyleHeader = workbook.createCellStyle();
			DataStyleHeader.setAlignment(CellStyle.ALIGN_CENTER);
			DataStyleHeader.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
			DataStyleHeader.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			DataStyleHeader.setBorderRight(HSSFCellStyle.BORDER_THIN);
			DataStyleHeader.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			DataStyleHeader.setBorderTop(HSSFCellStyle.BORDER_THIN);
			DataStyleHeader.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
			DataStyleHeader.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			HSSFRow row = null;
			HSSFCell cell = null;
			
			String[] headers = new String[] { "관리번호", "의뢰업체", "작업명", "작업기간", "진척률", "비용진행", "상태" };
			int[] headers_width = new int[] { 4000, 10000, 10000, 6500, 3000, 3000, 5000 };
			
			row = sheet.createRow(iRowCnt);
			row.setHeight((short)450);

			for (int i=0; i<headers.length; i++) {
				cell = row.createCell(i);
				cell.setCellValue(headers[i]);
				DataStyleHeader.setFont(TestFontHeader);
				cell.setCellStyle(DataStyleHeader);
				sheet.setColumnWidth(i, headers_width[i]);
			}
			
			Font TestFont = workbook.createFont();
			TestFont.setFontName("맑은 고딕");
			TestFont.setFontHeightInPoints((short) 10);
			
			CellStyle Left_DataStyle = workbook.createCellStyle();
			Left_DataStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
			Left_DataStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			Left_DataStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			Left_DataStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			Left_DataStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			Left_DataStyle.setFont(TestFont);

			CellStyle Center_DataStyle = workbook.createCellStyle();
			Center_DataStyle.setAlignment(CellStyle.ALIGN_CENTER);
			Center_DataStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
			Center_DataStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			Center_DataStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			Center_DataStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			Center_DataStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			Center_DataStyle.setFont(TestFont);

			CellStyle Right_DataStyle = workbook.createCellStyle();
			Right_DataStyle.setAlignment(CellStyle.ALIGN_RIGHT);
			Right_DataStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
			Right_DataStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			Right_DataStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			Right_DataStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			Right_DataStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			Right_DataStyle.setFont(TestFont);
			
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
				String clm_work_state_type_name				 = rs.getString("clm_work_state_type_name");
				String clm_work_manager_name					 = rs.getString("clm_work_manager_name");
				String clm_work_start_date_formatted			 = rs.getString("clm_work_start_date_formatted");
				String clm_work_end_date_formatted					 = rs.getString("clm_work_end_date_formatted");
				String clm_user_name							 = rs.getString("clm_user_name");

				String clm_work_cost_total							 = rs.getString("clm_work_cost_total");
				String clm_work_income_total						 = rs.getString("clm_work_income_total");
				String clm_work_calc_total							 = rs.getString("clm_work_calc_total");
				String clm_work_cost_total_without_comma			 = clm_work_cost_total.replace(",", "");
				String clm_work_income_total_without_comma			 = clm_work_income_total.replace(",", "");
				String clm_work_calc_total_without_comma			 = clm_work_calc_total.replace(",", "");
				String clm_estimation_price_without_comma			 = clm_work_estimation_price.replace(",", "");
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

				DateFormat format = new SimpleDateFormat("yyyyMMdd");
				
				java.util.Date date_gap_start	 = format.parse( date_start );
				java.util.Date date_gap_end	 = format.parse( date_end );
				java.util.Date date_gap_today	 = format.parse( date_today );
				
				String start_date = date_start.replaceAll("-", "");
				String end_date = date_end.replaceAll("-", "");
				String today_date = date_today.replaceAll("-", "");

				DateFormat format_dt = new SimpleDateFormat("yyyyMMdd");

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
				
				row = sheet.createRow(iRowCnt);
				row.setHeight((short)370);

				cell = row.createCell(0);
				cell.setCellValue(clm_order_id);
				cell.setCellStyle(Center_DataStyle);

				cell = row.createCell(1);
				cell.setCellValue(clm_user_name);
				cell.setCellStyle(Left_DataStyle);
				
				cell = row.createCell(2);
				cell.setCellValue(clm_order_name);
				cell.setCellStyle(Left_DataStyle);

				cell = row.createCell(3);
				cell.setCellValue(clm_work_start_date_formatted+" ~ "+clm_work_end_date_formatted);
				cell.setCellStyle(Center_DataStyle);

				cell = row.createCell(4);
				cell.setCellValue(day_date_rate_info+" %");
				cell.setCellStyle(Right_DataStyle);
				
				cell = row.createCell(5);
				cell.setCellValue(clm_work_purchased_rate+" %");
				cell.setCellStyle(Right_DataStyle);

				cell = row.createCell(6);
				cell.setCellValue(clm_work_state_type_name);
				cell.setCellStyle(Center_DataStyle);
			}
			
			try {
				FileOutputStream fileoutputstream = new FileOutputStream(saveFolderRoot + "/" + file_name + ".xls");
				workbook.write(fileoutputstream);
				fileoutputstream.close();
				System.out.println("엑셀파일생성성공");

				JSONObject jsonMain = new JSONObject();
				JSONArray jArray = new JSONArray();
				JSONObject jObject = null;

				jObject = new JSONObject();
				jObject.put("excel_file_name", file_name + ".xls");
				jArray.add(0, jObject);

				jsonMain.put("excel_files", jArray);

				response.setContentType("application/x-json; charset=UTF-8");
				response.getWriter().print(jsonMain);
				System.out.println(jsonMain.toJSONString());
			}
			catch (Exception e) {
				e.printStackTrace();
				System.out.println("엑셀파일생성실패");
			}
		}
		catch(Exception e) {

		}

		stmt.close();
%>
<%@ include file="include/conn_close_info.jsp" %>