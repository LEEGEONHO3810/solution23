<%@ page language="java" contentType="text/html;charset=UTF-8"
	import="java.sql.*"
	import="java.util.Date"
	import="java.net.*"
	import="java.util.*"
	import="java.text.SimpleDateFormat"
	import="org.json.simple.JSONArray"
	import="org.json.simple.JSONObject" %>
<%
request.setCharacterEncoding("utf-8");
System.out.println("=====================");
String id = request.getParameter("id");
String pw = request.getParameter("pw");
String company_key = request.getParameter("company_key");
String ip = "";
String ip1 = request.getHeader("x-forwarded-for");
String ip2 = request.getRemoteAddr();

if(ip1 == null || ip1.length() < 4) {
	ip1 = request.getHeader("INTEL_SOURCE_IP");
}
if(ip1 == null || ip1.length() < 4){
	ip = ip2;
}else{
	ip = ip1;
}

System.out.println("+ ip : " + ip);
System.out.println("+ id : " + id);
System.out.println("+ pw : " + pw);
System.out.println("+ company_key : " + company_key);

String url = "jdbc:postgresql://itfactoryddns.iptime.org:5432/CHEONGJU_SOLUTION_2023";
String usr = "postgres";
String pwd = "postgres";
Class.forName("org.postgresql.Driver");
Connection conn = DriverManager.getConnection(url, usr, pwd);
Statement stmt = conn.createStatement();

String query = " ";
query += " select x.clm_company_key ";
query += "	 from tbl_company_info x ";
query += "  where x.clm_company_key = '"+company_key+"' ";
//System.out.println("+ UserInfoProc.Query.0 : " + query);
ResultSet rs = stmt.executeQuery(query);

while (rs.next()) {
	String clm_company_key = rs.getString("clm_company_key");
	
	session.setAttribute("clm_company_key", clm_company_key);
}

query = " ";
query += " select x.clm_user_id, x.clm_user_name, x.clm_user_pw, coalesce(y.clm_header_color,'') as clm_header_color , coalesce(x.clm_user_img,'') as clm_user_img ";
query += "	 from tbl_user_info x ";
query += "	 	left outer join tbl_user_option y ";
query += "	 		on y.clm_user_id = x.clm_user_id and y.clm_company_key = '"+ company_key +"' ";
query += "  where x.clm_user_id = '"+id+"' ";
query += "    and x.clm_user_pw = '"+pw+"' ";
query += "	  and x.clm_company_key = '"+company_key+"' ";
//System.out.println("+ UserInfoProc.Query.0 : " + query);
rs = stmt.executeQuery(query);
JSONObject jsonMain = new JSONObject();
JSONObject jObject = null;
JSONArray jArray = new JSONArray();

int iRowCount = 0;
while (rs.next()) {
	String user_id = rs.getString("clm_user_id");
    String user_name = rs.getString("clm_user_name");
	String clm_header_color = rs.getString("clm_header_color");
	String clm_user_img = rs.getString("clm_user_img");

	System.out.println("+ user_info : " + user_id + " / " + user_name + " / ");
	
	session.setAttribute("user_id", user_id);
    session.setAttribute("user_name", user_name);
	session.setAttribute("mes_name", "CHEONGJU_SOLUTION_2023");
	session.setAttribute("header_color", clm_header_color);
	session.setAttribute("user_img", clm_user_img);

	session.setMaxInactiveInterval(-1);

	jObject = new JSONObject();
	jObject.put("user_id", user_id.trim());
	jObject.put("user_name", user_name.trim());
	jObject.put("mes_name", "CHEONGJU_SOLUTION_2023");

	jArray.add(iRowCount, jObject);
    iRowCount++;
}

System.out.println("+ iRowCount : " + iRowCount);

stmt.close();

jsonMain.put("user_info", jArray);

// 권한 추가
stmt = conn.createStatement();

query = " select x.clm_screen_id , y.clm_screen_name , y.clm_screen_type ";
query +=       "	 from tbl_authority_detail_info x ";
query +=       "     	left outer join tbl_screen_info y ";
query += 	   "     		on y.clm_screen_id = x.clm_screen_id and y.clm_company_key = '"+company_key+"' ";
query +=       "  		left outer join tbl_user_info z ";
query += 	   " 			 on z.clm_user_authority = x.clm_authority_id and z.clm_company_key = '"+company_key+"'";
query +=       " 	where 1=1 ";
query +=       " 		and z.clm_user_id = '"+ id +"' ";
query += 	   "	    and x.clm_company_key = '"+company_key+"' ";
System.out.println("+ query : " + query);
rs = stmt.executeQuery(query);

ArrayList<String> screen_arr = new ArrayList<>();
while (rs.next()) {
    String clm_screen_id = rs.getString("clm_screen_id");
	screen_arr.add(clm_screen_id);
}

stmt.close();

session.setAttribute("screen_arr", screen_arr);


System.out.println(jsonMain.toJSONString());
out.println(jsonMain.toJSONString());

if(iRowCount==1){
	//     response.sendRedirect("main.jsp");               // 로그인 성공 메인페이지 이동
}else{

}

conn.close();
%>
