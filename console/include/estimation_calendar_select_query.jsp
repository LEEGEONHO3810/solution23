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
<%@ include file="./conn_info.jsp" %>
<%@ include file="./menu_info.jsp" %>
<%@ include file="./request_info.jsp" %>
<%
		String customer_name = (request.getParameter("customer_name")==null)?"":request.getParameter("customer_name");
		String order_name = (request.getParameter("order_name")==null)?"":request.getParameter("order_name");
		
		System.out.println("> customer_name : " + customer_name + " | order_name : " + order_name);

		stmt = conn.createStatement();
		
		JSONObject jsonObj = new JSONObject();
        JSONArray jsonArr = new JSONArray();
		
		String query  = "";
		
		query  = "";
		query += " select x.clm_order_id, x.clm_order_name, y.clm_work_start_date, y.clm_work_end_date, x.clm_client_id ";
		query += " 		, coalesce((select a.clm_client_name from tbl_client_info a where a.clm_client_id = x.clm_client_id), '') clm_client_name ";
		query += " 		, x.clm_order_state_type, case x.clm_order_state_type when 'A' then '견적' when 'B' then '주문' end clm_order_state_type_name ";
		query += "      , x.clm_estimation_price , x.clm_building_deconstruction_report_yn, x.clm_building_address, x.clm_building_address_detail ";
		query += "      , y.clm_work_cost_total, y.clm_work_income_total, y.clm_work_calc_total ";
		query += "   from tbl_order_info x, tbl_work_info y ";
		query += "  where x.clm_order_id = y.clm_order_id ";
		query += "    and (x.clm_order_state_type = 'A' or x.clm_order_state_type = 'B') ";
		if(!customer_name.equals("")){
			query += "    and coalesce((select a.clm_client_name from tbl_client_info a where a.clm_client_id = x.clm_client_id), '') ilike '%"+customer_name+"%' ";
		}
		if(!order_name.equals("")){
			query += "    and x.clm_order_name ilike '%"+order_name+"%' ";
		}
		query += "  order by x.clm_order_id ";
		rs = stmt.executeQuery(query);
		while (rs.next()) {
			HashMap<String, Object> hash = new HashMap<>();
			hash.put("title", rs.getString("clm_order_name"));
			hash.put("order_id", rs.getString("clm_order_id"));
			hash.put("order_state_type", rs.getString("clm_order_state_type"));
			hash.put("client_name", rs.getString("clm_client_name"));
			hash.put("estimation_price", rs.getString("clm_estimation_price"));
			hash.put("building_deconstruction_report_yn", rs.getString("clm_building_deconstruction_report_yn"));
			hash.put("building_address", rs.getString("clm_building_address"));
			hash.put("building_address_detail", rs.getString("clm_building_address_detail"));
			hash.put("work_cost_total", rs.getString("clm_work_cost_total"));
			hash.put("work_income_total", rs.getString("clm_work_income_total"));
			hash.put("work_calc_total", rs.getString("clm_work_calc_total"));
			
			if((rs.getString("clm_order_state_type")).equals("A")){
				hash.put("color", "#1699DB");
			}else{
				hash.put("color", "#86DB16");
			}
			String work_start_date = rs.getString("clm_work_start_date");
			String work_end_date = rs.getString("clm_work_end_date");

			SimpleDateFormat dtFormat = new SimpleDateFormat("yyyy-MM-dd");
			Calendar cal = Calendar.getInstance();
			java.util.Date dt = dtFormat.parse(work_end_date);
			cal.setTime(dt);
			cal.add(Calendar.DATE,  1);
			String calc_work_end_date = dtFormat.format(cal.getTime());

			//System.out.println("> work_start_date : " + work_start_date);
			//System.out.println("> work_end_date : " + work_end_date);
			//System.out.println("> calc_work_end_date : " + calc_work_end_date);

            hash.put("start", work_start_date);
			hash.put("end", calc_work_end_date);
			hash.put("start_date", work_start_date);
			hash.put("end_date", work_end_date);

			jsonObj = new JSONObject(hash);
            jsonArr.add(jsonObj);
		}
		out.clear();
		out.println(jsonArr);
%>
<%@ include file="./conn_close_info.jsp" %>
