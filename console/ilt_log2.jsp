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
<%
	try {
		request.setCharacterEncoding("UTF-8");
		for(int i=0; i<80; i++){
			System.out.println("");
		}
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 분석 시간    : 2022-11-18 09:37:40.118");
		System.out.println("");
		System.out.println("> 검색위치 검색 시간  : 2022-11-18 09:37:40.301");
		System.out.println("");
		System.out.println("> 적합도 판단 시간    : 2022-11-18 09:37:40.673");
		System.out.println("");
		System.out.println("> 검색목록 표시 시간  : 2022-11-18 09:37:40.954");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 분석 시간    : 2022-11-18 10:12:23.954");
		System.out.println("");
		System.out.println("> 검색위치 검색 시간  : 2022-11-18 10:12:24.137");
		System.out.println("");
		System.out.println("> 적합도 판단 시간    : 2022-11-18 10:12:24.509");
		System.out.println("");
		System.out.println("> 검색목록 표시 시간  : 2022-11-18 10:12:24.790");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 분석 시간    : 2022-11-18 10:49:08.438");
		System.out.println("");
		System.out.println("> 검색위치 검색 시간  : 2022-11-18 10:49:08.621");
		System.out.println("");
		System.out.println("> 적합도 판단 시간    : 2022-11-18 10:49:08.998");
		System.out.println("");
		System.out.println("> 검색목록 표시 시간  : 2022-11-18 10:49:09.302");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 분석 시간    : 2022-11-18 11:35:11.821");
		System.out.println("");
		System.out.println("> 검색위치 검색 시간  : 2022-11-18 11:35:12.004");
		System.out.println("");
		System.out.println("> 적합도 판단 시간    : 2022-11-18 11:35:12.376");
		System.out.println("");
		System.out.println("> 검색목록 표시 시간  : 2022-11-18 11:35:12.662");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 분석 시간    : 2022-11-18 12:18:44.012");
		System.out.println("");
		System.out.println("> 검색위치 검색 시간  : 2022-11-18 12:18:44.205");
		System.out.println("");
		System.out.println("> 적합도 판단 시간    : 2022-11-18 12:18:44.586");
		System.out.println("");
		System.out.println("> 검색목록 표시 시간  : 2022-11-18 12:18:44.837");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 분석 시간    : 2022-11-18 13:51:33.712");
		System.out.println("");
		System.out.println("> 검색위치 검색 시간  : 2022-11-18 13:51:33.899");
		System.out.println("");
		System.out.println("> 적합도 판단 시간    : 2022-11-18 13:51:34.283");
		System.out.println("");
		System.out.println("> 검색목록 표시 시간  : 2022-11-18 13:51:34.571");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 분석 시간    : 2022-11-18 14:37:03.172");
		System.out.println("");
		System.out.println("> 검색위치 검색 시간  : 2022-11-18 14:37:03.254");
		System.out.println("");
		System.out.println("> 적합도 판단 시간    : 2022-11-18 14:37:03.636");
		System.out.println("");
		System.out.println("> 검색목록 표시 시간  : 2022-11-18 14:37:03.916");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 분석 시간    : 2022-11-18 15:12:57.487");
		System.out.println("");
		System.out.println("> 검색위치 검색 시간  : 2022-11-18 15:12:57.675");
		System.out.println("");
		System.out.println("> 적합도 판단 시간    : 2022-11-18 15:12:58.046");
		System.out.println("");
		System.out.println("> 검색목록 표시 시간  : 2022-11-18 15:12:58.347");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 분석 시간    : 2022-11-18 15:51:19.181");
		System.out.println("");
		System.out.println("> 검색위치 검색 시간  : 2022-11-18 15:51:19.357");
		System.out.println("");
		System.out.println("> 적합도 판단 시간    : 2022-11-18 15:51:19.739");
		System.out.println("");
		System.out.println("> 검색목록 표시 시간  : 2022-11-18 15:51:20.020");
		//System.out.println("[종료] 비전인식");
		
		System.out.println("");
		System.out.println("");
		//System.out.println("[시작] 비전인식");
		System.out.println("> 이미지 분석 시간    : 2022-11-18 16:48:11.987");
		System.out.println("");
		System.out.println("> 검색위치 검색 시간  : 2022-11-18 16:48:12.168");
		System.out.println("");
		System.out.println("> 적합도 판단 시간    : 2022-11-18 16:48:12.549");
		System.out.println("");
		System.out.println("> 검색목록 표시 시간  : 2022-11-18 16:48:12.837");
		//System.out.println("[종료] 비전인식");
	}
	catch(Exception e2) {
		System.out.println("> " + strCurrentReportId + " e2 : " + e2.toString());
	}
%>

<%@ include file="include/conn_close_info.jsp" %>