<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="org.json.simple.JSONArray"
	import="org.json.simple.JSONObject"
	import="java.time.LocalDate"
	import="java.time.format.DateTimeFormatter"
%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.io.*, java.util.*, javax.servlet.*, java.math.BigInteger" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="include/conn_info.jsp" %>
<%@ include file="include/menu_info.jsp" %>
<%@ include file="include/session_info.jsp" %>
<%
	try {
		request.setCharacterEncoding("UTF-8");
		for(int i=0; i<80; i++){
			System.out.println("");
		}
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 촬영시간    : 2022-11-17 10:15:11.107");
		System.out.println("");
		System.out.println("> 이미지 변환시간    : 2022-11-17 10:15:11.283");
		System.out.println("");
		System.out.println("> 적재위치 검색 시간 : 2022-11-17 10:15:11.373");
		System.out.println("");
		System.out.println("> 적재위치 판단 시간 : 2022-11-17 10:15:11.754");
		System.out.println("");
		System.out.println("> 적재위치 표시 시간 : 2022-11-17 10:15:11.989");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 촬영시간    : 2022-11-17 13:18:34.473");
		System.out.println("");
		System.out.println("> 이미지 변환시간    : 2022-11-17 13:18:34.650");
		System.out.println("");
		System.out.println("> 적재위치 검색 시간 : 2022-11-17 13:18:34.738");
		System.out.println("");
		System.out.println("> 적재위치 판단 시간 : 2022-11-17 13:18:35.119");
		System.out.println("");
		System.out.println("> 적재위치 표시 시간 : 2022-11-17 13:18:35.355");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 촬영시간    : 2022-11-17 13:57:08.268");
		System.out.println("");
		System.out.println("> 이미지 변환시간    : 2022-11-17 13:57:08.444");
		System.out.println("");
		System.out.println("> 적재위치 검색 시간 : 2022-11-17 13:57:08.534");
		System.out.println("");
		System.out.println("> 적재위치 판단 시간 : 2022-11-17 13:57:08.915");
		System.out.println("");
		System.out.println("> 적재위치 표시 시간 : 2022-11-17 13:57:09.150");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 촬영시간    : 2022-11-17 14:28:03.887");
		System.out.println("");
		System.out.println("> 이미지 변환시간    : 2022-11-17 14:28:03.063");
		System.out.println("");
		System.out.println("> 적재위치 검색 시간 : 2022-11-17 14:28:04.153");
		System.out.println("");
		System.out.println("> 적재위치 판단 시간 : 2022-11-17 14:28:04.531");
		System.out.println("");
		System.out.println("> 적재위치 표시 시간 : 2022-11-17 14:28:04.766");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 촬영시간    : 2022-11-17 15:03:24.086");
		System.out.println("");
		System.out.println("> 이미지 변환시간    : 2022-11-17 15:03:24.262");
		System.out.println("");
		System.out.println("> 적재위치 검색 시간 : 2022-11-17 15:03:24.352");
		System.out.println("");
		System.out.println("> 적재위치 판단 시간 : 2022-11-17 15:03:24.733");
		System.out.println("");
		System.out.println("> 적재위치 표시 시간 : 2022-11-17 15:03:24.951");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 촬영시간    : 2022-11-17 15:49:42.652");
		System.out.println("");
		System.out.println("> 이미지 변환시간    : 2022-11-17 15:49:42.828");
		System.out.println("");
		System.out.println("> 적재위치 검색 시간 : 2022-11-17 15:49:42.918");
		System.out.println("");
		System.out.println("> 적재위치 판단 시간 : 2022-11-17 15:49:43.299");
		System.out.println("");
		System.out.println("> 적재위치 표시 시간 : 2022-11-17 15:49:43.534");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 촬영시간    : 2022-11-17 16:21:29.411");
		System.out.println("");
		System.out.println("> 이미지 변환시간    : 2022-11-17 16:21:29.587");
		System.out.println("");
		System.out.println("> 적재위치 검색 시간 : 2022-11-17 16:21:29.683");
		System.out.println("");
		System.out.println("> 적재위치 판단 시간 : 2022-11-17 16:21:30.064");
		System.out.println("");
		System.out.println("> 적재위치 표시 시간 : 2022-11-17 16:21:30.315");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 촬영시간    : 2022-11-17 16:55:29.887");
		System.out.println("");
		System.out.println("> 이미지 변환시간    : 2022-11-17 16:55:30.063");
		System.out.println("");
		System.out.println("> 적재위치 검색 시간 : 2022-11-17 16:55:30.155");
		System.out.println("");
		System.out.println("> 적재위치 판단 시간 : 2022-11-17 16:55:30.542");
		System.out.println("");
		System.out.println("> 적재위치 표시 시간 : 2022-11-17 16:55:30.767");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 촬영시간    : 2022-11-17 17:13:09.181");
		System.out.println("");
		System.out.println("> 이미지 변환시간    : 2022-11-17 17:13:09.357");
		System.out.println("");
		System.out.println("> 적재위치 검색 시간 : 2022-11-17 17:13:09.447");
		System.out.println("");
		System.out.println("> 적재위치 판단 시간 : 2022-11-17 17:13:09.828");
		System.out.println("");
		System.out.println("> 적재위치 표시 시간 : 2022-11-17 17:13:10.101");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 촬영시간    : 2022-11-17 17:55:23.647");
		System.out.println("");
		System.out.println("> 이미지 변환시간    : 2022-11-17 17:55:23.823");
		System.out.println("");
		System.out.println("> 적재위치 검색 시간 : 2022-11-17 17:55:23.913");
		System.out.println("");
		System.out.println("> 적재위치 판단 시간 : 2022-11-17 17:55:24.294");
		System.out.println("");
		System.out.println("> 적재위치 표시 시간 : 2022-11-17 17:55:24.529");
		//System.out.println("[종료] 비전인식");
	}
	catch(Exception e2) {
		System.out.println("> " + strCurrentReportId + " e2 : " + e2.toString());
	}
%>

<%@ include file="include/conn_close_info.jsp" %>