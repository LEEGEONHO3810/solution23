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

<%@ page import="java.text.DecimalFormat" %>

<%@ include file="include/session_info.jsp" %>
<%@ include file="include/conn_info.jsp" %>
<%@ include file="include/menu_info.jsp" %>
<%@ include file="include/request_info.jsp" %>
<%
		//String saveFolderRoot = "C:/Program Files/Apache Software Foundation/Tomcat 9.0/webapps/ROOT/SOLUTION/excel";
		String saveFolderRoot = "C:/Program Files/Apache Software Foundation/Tomcat9Server6/webapps/ROOT/SOLUTION/excel";
		if(ss_user_id==null) {
			ss_user_id = "admin";
		}

		String folderPath = saveFolderRoot + "/" + _order_id_;
		String file_name = "";

		java.util.Date today = new java.util.Date();
		SimpleDateFormat df = new SimpleDateFormat("YYYYMMddHHmmss");
		String current_date = df.format(today);

		String date_today	 = current_date.replaceAll("/", "");

		if(ss_user_id==null) {
			ss_user_id = "admin";
		}

		file_name = ss_user_id + "_" + date_today;
		
		System.out.println("> file_name : " + file_name);
		HSSFWorkbook workbook = null;
		HSSFSheet sheet = null;

		DecimalFormat decFormat = new DecimalFormat("###,###");

		try {
			String strOrderIdList = "";
			for(int i=0; i<_chk_order_id_.length; i++) {
				strOrderIdList += "'" + _chk_order_id_[i] + "',";
			}
			int iRowCnt = 0;

			strOrderIdList = strOrderIdList.substring(0, strOrderIdList.length()-1);
			
			stmt = conn.createStatement();
			String strCondition = "";
			strCondition += "and x.clm_material_order_id in (" + strOrderIdList + ") ";
			String query  = "";
			query += " select x.clm_material_order_id , x.clm_client_id, y.clm_client_name , x.clm_order_date , x.clm_due_date, x.clm_all_income_yn , x.clm_comment,c.clm_order_count ";
			query += "      , case x.clm_all_income_yn when 'Y' then '입고완료' else '입고등록' end clm_status ";
			query += " from tbl_material_order_info x ";
			query += " 		left outer join tbl_client_info y ";
			query += " 			on y.clm_client_id = x.clm_client_id and y.clm_company_key = '" + SessionCompanyKey + "' ";
			query += " left outer join tbl_material_order_detail_info c on x.clm_material_order_id = c.clm_material_order_id and c.clm_company_key = '" + SessionCompanyKey + "'  ";
			query += " where x.clm_delete_yn = 'N' ";
			query += " 		and x.clm_company_key = '" + SessionCompanyKey + "' "+ strCondition +" ";
			query += " order by x.clm_material_order_id desc ";
			System.out.println("> " + strCurrentReportId + ".data_list " + query);
			rs = stmt.executeQuery(query);

			workbook = new HSSFWorkbook();
			sheet = workbook.createSheet("자재 정보 관리");
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

			String int_clm_order_count = "";
			String float_clm_order_count = "";

			String[] headers = new String[] { "거래처", "주문일자", "입고예정일", "입고상태", "특이사항" };
			int[] headers_width = new int[] { 8000, 6000, 6000, 3000, 10000 };
			
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
				String clm_material_order_id			= rs.getString("clm_material_order_id");
				String clm_client_id					= rs.getString("clm_client_id");
				String clm_client_name				 	= rs.getString("clm_client_name");
				String clm_order_date				 	= rs.getString("clm_order_date");
				String clm_due_date				 		= rs.getString("clm_due_date");
				String clm_comment			 			= rs.getString("clm_comment");
				String clm_all_income_yn			 	= rs.getString("clm_all_income_yn");
				String clm_order_count			 		= rs.getString("clm_order_count");
				String clm_status						= rs.getString("clm_status");

				
				if(clm_order_count.contains(".")){
					String[] split_clm_order_count = clm_order_count.split("\\.");
					int_clm_order_count = split_clm_order_count[0];
					float_clm_order_count = split_clm_order_count[1];
				 }else{
					int_clm_order_count = clm_order_count;
				 }
				 System.out.println(int_clm_order_count);
				 clm_order_count = decFormat.format(Integer.parseInt(int_clm_order_count));


				 if(!float_clm_order_count.equals("")){

					clm_order_count = clm_order_count + "." + float_clm_order_count;

				 }



				row = sheet.createRow(iRowCnt);
				row.setHeight((short)370);

				cell = row.createCell(0);
				cell.setCellValue(clm_client_name);
				cell.setCellStyle(Left_DataStyle);

				cell = row.createCell(1);
				cell.setCellValue(clm_order_date);
				cell.setCellStyle(Center_DataStyle);
				
				cell = row.createCell(2);
				cell.setCellValue(clm_due_date);
				cell.setCellStyle(Center_DataStyle);
				
				cell = row.createCell(3);
				cell.setCellValue(clm_status);
				cell.setCellStyle(Center_DataStyle);

				cell = row.createCell(4);
				cell.setCellValue(clm_comment);
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