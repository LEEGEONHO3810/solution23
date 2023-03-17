
<%
	String clm_report_id		 = "";
	String clm_report_name		 = "";
	String clm_contents_info	 = "";
	String clm_comment			 = "";
	String clm_report_type		 = "";
	String[] arrCurrentReportName = (request.getServletPath()).split("/");
	String strCurrentReportId = arrCurrentReportName[arrCurrentReportName.length-1].split("\\.")[0];
	String strCurrentReportName = "";

	List<Map<String, String>> lstMenu = null;
	Map<String, String> mapMenu = null;

		request.setCharacterEncoding("UTF-8");
		String strWhereConditions = "";
		JSONObject jsonMain = new JSONObject();
		JSONArray jArray = new JSONArray();
		JSONObject jObject = null;

		String query = "";
		String strCondition = "";
		String clm_template_name = "";
		int rowCnt = 0;

		String clm_body_model_id = "";

		try {
			stmt = conn.createStatement();
			query = "select x.* from _tbl_report_info_master x where 1=1 " + strCondition;
			System.out.println("> query : " + query);
			rs = stmt.executeQuery(query);

			// String json = "";

			lstMenu = new ArrayList<Map<String, String>>();

			rowCnt = 0;
			while (rs.next()) {
				mapMenu = new HashMap<String, String>();
				mapMenu.put("clm_report_id", rs.getString("clm_report_id"));
				mapMenu.put("clm_report_name", rs.getString("clm_report_name"));
				mapMenu.put("clm_contents_info", rs.getString("clm_contents_info"));
				mapMenu.put("clm_comment", rs.getString("clm_comment"));
				mapMenu.put("clm_report_type", rs.getString("clm_report_type"));
				if((strCurrentReportId.equals(rs.getString("clm_report_id")))) {
					strCurrentReportId = rs.getString("clm_report_id");
						strCurrentReportName = rs.getString("clm_report_name");
				}
				lstMenu.add(mapMenu);
			}
			
				System.out.println(">>> strCurrentReportName.2 " + strCurrentReportName);
		}
		catch(Exception e) {
			System.out.println("> e.toString().0 " + e.toString());
		}

		stmt.close();
%>