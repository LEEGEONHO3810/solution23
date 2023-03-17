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
<%
		String saveFolderRoot = "C:/Program Files/Apache Software Foundation/Tomcat9Sever1/webapps/ROOT/ESTIMATION/GAGA/excel";

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
		
		try {
			String strOrderIdList = "";
			for(int i=0; i<_chk_order_id_.length; i++) {
				strOrderIdList += "'" + _chk_order_id_[i] + "',";
			}
			int iRowCnt = 0;

			strOrderIdList = strOrderIdList.substring(0, strOrderIdList.length()-1);

			stmt = conn.createStatement();
			String strCondition = "";
			strCondition += " and (x.clm_code_id || '-' || x.clm_code_sub_id) in (" + strOrderIdList + ") ";

			System.out.println("> strCondition : " +strCondition);
			String query  = "";
			query += "select x.* ";
			query += "  from tbl_code_info x ";
			query += " where 1=1 and x.clm_del_yn='N' and x.clm_code_sub_id <> '0000' " + strCondition + " ";
			query += " order by x.clm_code_id, cast(x.clm_code_sub_id as numeric) asc ;";
			System.out.println("> " + strCurrentReportId + ".data_list " + query);
			rs = stmt.executeQuery(query);

			workbook = new HSSFWorkbook();
			sheet = workbook.createSheet("코드 정보 관리");
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
			
			String[] headers = new String[] { "상위코드", "하위코드", "상위코드명", "하위코드명", "코드값", "특이사항" };
			int[] headers_width = new int[] { 3000, 3000, 7000, 7000, 6000, 10000 };
			
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
				String clm_code_id			 = rs.getString("clm_code_id");
				String clm_code_sub_id		 = rs.getString("clm_code_sub_id");
				String clm_code_total		 = rs.getString("clm_code_total");
				String clm_code_seq			 = rs.getString("clm_code_seq");
				String clm_code_value		 = rs.getString("clm_code_value");
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
				
				row = sheet.createRow(iRowCnt);
				row.setHeight((short)370);

				cell = row.createCell(0);
				cell.setCellValue(clm_code_id);
				cell.setCellStyle(Center_DataStyle);

				cell = row.createCell(1);
				cell.setCellValue(clm_code_sub_id);
				cell.setCellStyle(Center_DataStyle);
				
				cell = row.createCell(2);
				cell.setCellValue(clm_code_name);
				cell.setCellStyle(Center_DataStyle);
				
				cell = row.createCell(3);
				cell.setCellValue(clm_code_sub_name);
				cell.setCellStyle(Center_DataStyle);

				cell = row.createCell(4);
				cell.setCellValue(clm_code_value);
				cell.setCellStyle(Center_DataStyle);
				
				cell = row.createCell(5);
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