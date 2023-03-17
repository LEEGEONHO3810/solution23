<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="java.util.*, java.io.*"%>
<%@ page import="java.io.*, java.nio.file.*, java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.nio.file.attribute.BasicFileAttributes" %>
<%@ page import="java.util.zip.ZipEntry" %>
<%@ page import="java.util.zip.ZipOutputStream" %>
<%@ include file="include/session_info.jsp" %>
<%@ include file="include/conn_info.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String _test_			 = request.getParameter("test");
	String _ta_comment_		 = request.getParameter("ta_comment");
	String _notice_id_		 = request.getParameter("notice_id");
	
	System.out.println("> _notice_id_ " + _notice_id_);
	System.out.println("> _test_ " + _test_);
	System.out.println("> _ta_comment_ " + _ta_comment_);

	String saveFolderRoot = "C:/Program Files/Apache Software Foundation/Tomcat9Sever1/webapps/ROOT/ESTIMATION/GAGA/files";
	String saveFolderRootLogical = "/ESTIMATION/GAGA/files";
	String encType = "UTF-8";
	int maxSize = 30 * 1024 * 1024;

	String query = "";

	try {
		stmt = conn.createStatement();
		query = "";
		query += "delete from tbl_notice_file where clm_notice_id = '" + _notice_id_ + "';";
		System.out.println("> delete_notice_file_info " + query);
		stmt.execute(query);

		String folderPath = saveFolderRoot + "/" + _notice_id_;

		File flFolder = new File(folderPath);

		if (!flFolder.exists()) {
			try {
				flFolder.delete();
				System.out.println("폴더가 생성되었습니다.");
			}
			catch(Exception e) {
				e.getStackTrace();
			}
		}

		// Files.deleteIfExists(folderPath);
		flFolder.mkdir();
		System.out.println("폴더가 생성되었습니다.");

		MultipartRequest multi = null;
		multi = new MultipartRequest(request, folderPath, maxSize, encType, new DefaultFileRenamePolicy());
		Enumeration params = multi.getParameterNames();

		while (params.hasMoreElements()) {
			String name = (String) params.nextElement();
			String value = multi.getParameter(name);
			System.out.println(name + "=" + value + "");
		}

		List<File> fileList = new ArrayList<>();

		query = "";
		query += "delete from tbl_notice_file where clm_notice_id = '" + _notice_id_ + "';";
		System.out.println("> delete_notice_file_info " + query);
		stmt.execute(query);

		Enumeration files = multi.getFileNames();
		int i_row_count = 0;

		System.out.println("> files " + files);
		while (files.hasMoreElements())
		{
			String name = (String) files.nextElement();
			String[] filename_full = name.split(".");
			// System.out.println("> filename_full " + filename_full.length());

			String filename = multi.getFilesystemName(name);
			String original = multi.getFilesystemName(name);
			String type = multi.getContentType(name);
			File f = multi.getFile(name);

			fileList.add(f);

			filename = _notice_id_ + "_" + i_row_count + "_" + filename;

			System.out.println("파라미터 이름 : " + name + "");
			System.out.println("실제 파일 이름 : " + original + "");
			System.out.println("저장된 파일 이름 : " + filename + "");
			System.out.println("파일 타입 : " + type + "");

			if (f != null) {
				System.out.println("크기 : " + f.length() + "바이트");
			}
			
			if(!name.equals("") && !filename.equals("")){
				String seq_format = String.format("%02d", i_row_count);

				query = "";
				query += "insert into tbl_notice_file (clm_notice_id, clm_notice_file_seq, clm_file_id, clm_file_name, clm_file_ext, clm_file_size, clm_file_path, clm_file_real_name) values ('" + _notice_id_ + "', '" + seq_format + "', '" + (_notice_id_+seq_format) + "', '" + filename + "', '" + type + "', '" + f.length() + "', '" + folderPath + "', '" + original + "');";
				System.out.println("> insert_order_file_info " + query);
				stmt.execute(query);

				i_row_count++;
			}
		}


		File zipFile = new File(saveFolderRoot, _notice_id_ + ".zip");

		if (!zipFile.exists()) {
			try {
				zipFile.delete(); //폴더 생성합니다.
				// System.out.println("폴더가 생성되었습니다.");
			}
			catch(Exception e) {
				e.getStackTrace();
			}
		}
		else {}

		byte[] buf = new byte[4096];

		try (ZipOutputStream outFile = new ZipOutputStream(new FileOutputStream(zipFile))) {

			System.out.println("압축 파일 시작");
			for (File file : fileList) {
				System.out.println("압축 파일 중");
				try (FileInputStream in = new FileInputStream(file)) {
					ZipEntry ze = new ZipEntry(file.getName());
					outFile.putNextEntry(ze);

					int len;
					while ((len = in.read(buf)) > 0) {
						outFile.write(buf, 0, len);
					}

					outFile.closeEntry();
				}

			}
		}
		System.out.println("압축 파일 생성 성공");
	}
	catch (IOException ioe) {
		System.out.println(ioe);
	}
	catch (Exception ex) {
		System.out.println(ex);
	}
%>

<%@ include file="include/conn_close_info.jsp" %>