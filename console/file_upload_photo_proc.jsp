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

<%@ include file="include/session_info.jsp" %>
<%@ include file="include/conn_info.jsp" %>

<%@ page import="java.nio.file.attribute.BasicFileAttributes" %>
<%@ page import="java.util.zip.ZipEntry" %>
<%@ page import="java.util.zip.ZipOutputStream" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String _test_			 = request.getParameter("test");
	String _ta_comment_			 = request.getParameter("ta_comment");
	String _order_id_		 = request.getParameter("order_id");

	System.out.println("> _test_ " + _test_);
	System.out.println("> _ta_comment_ " + _ta_comment_);

	// String saveFolder = "C:/Temp";
	String saveFolderRoot = "C:/Program Files (x86)/Apache Software Foundation/Tomcat 9.0/webapps/ROOT/ESTIMATION/GAGA_NEW/console/img/user";
	// String saveFolderRoot = "C:/Program Files/Apache Software Foundation/Tomcat 9.0/webapps/ROOT/ESTIMATION/GAGA/files";
	// String saveFolderRootLogical = "/ESTIMATION/GAGA/files";
	String encType = "UTF-8";
	int maxSize = 5 * 1024 * 1024;

	String query = "";
	String folderPath = saveFolderRoot;
	String profileImg = "";

	try {
		if(!_order_id_.equals("")) {
			stmt = conn.createStatement();
			query = "";
			query += "select x.* from tbl_user_info x where x.clm_user_id='" + _order_id_ + "';";
			System.out.println("> select_user_file_info " + query);
			rs = stmt.executeQuery(query);

			int iRowCnt = 0;
			while (rs.next()) {
				String clm_user_img = rs.getString("clm_user_img");
				if(!clm_user_img.equals("")) {
					profileImg = saveFolderRoot + "/" + clm_user_img;

					File flFolder = new File(profileImg);

					if (!flFolder.exists()) {
						try {
							flFolder.delete(); //폴더 생성합니다.
							System.out.println("프로필 이미지가 삭제되었습니다.");
						}
						catch(Exception e) {
							e.getStackTrace();
						}
					}
					else {}
				}

				iRowCnt++;
			}

			// if(iRowCnt==0) {
			// 	profileImg = saveFolderRoot + "/" + "user_" + _order_id_;
			// }
		}

		// _order_id_ = "user_" + _order_id_;
		//
		// String folderPath = saveFolderRoot + "/" + _order_id_;
		//
		// File flFolder = new File(folderPath);
		//
		// if (!flFolder.exists()) {
		// 	try {
		// 		flFolder.delete(); //폴더 생성합니다.
		// 		System.out.println("폴더가 생성되었습니다.");
		// 	}
		// 	catch(Exception e) {
		// 		e.getStackTrace();
		// 	}
		// }
		// else {}
		//
		// // Files.deleteIfExists(folderPath);
		// // flFolder.mkdir();
		// System.out.println("폴더가 생성되었습니다.");

		MultipartRequest multi = null;
		multi = new MultipartRequest(request, folderPath, maxSize, encType, new DefaultFileRenamePolicy());
		Enumeration params = multi.getParameterNames();

		while (params.hasMoreElements()) {
			String name = (String) params.nextElement();
			String value = multi.getParameter(name);
			System.out.println(">>> " + name + "=" + value + "");
		}

		List<File> fileList = new ArrayList<>();





		// query = "";
		// query += "delete from tbl_order_file where clm_order_id='" + _order_id_ + "';";
		// System.out.println("> delete_order_file_info " + query);
		// stmt.execute(query);
		//
		// query = "";
		// query += "delete from tbl_work_file where clm_order_id='" + _order_id_ + "';";
		// System.out.println("> delete_work_file_info " + query);
		// stmt.execute(query);

		Enumeration files = multi.getFileNames();
		int i_row_count = 0;

		System.out.println("> files " + files);
		while (files.hasMoreElements())
		{
			String name = (String) files.nextElement();
			String[] filename_full = name.split(".");
			// System.out.println("> filename_full " + filename_full.length);
			// for(int i=0; i<filename_full.length; i++) {
			// 	System.out.println("> filename_full[" + i + "] " + filename_full[i]);
			// }

			String filename = multi.getFilesystemName(name);
			String original = multi.getFilesystemName(name);
			String[] file_name_info = filename.split(".");
			String ext = original.substring(filename.lastIndexOf(".") + 1);
			String type = multi.getContentType(name);
			File f = multi.getFile(name);

			fileList.add(f);

			filename = _order_id_ + "_" + i_row_count + "_" + filename;

			File fileName = new File(folderPath + "/" + original);

			long fileSize = f.length();
			fileSize = fileSize/1024;
			String fileSizeVal = String.valueOf(fileSize);


			System.out.println("파라미터 이름 : " + name + "");
			System.out.println("실제 파일 이름 : " + original + "");
			System.out.println("저장된 파일 이름 : " + filename + "");
			System.out.println("파일 타입 : " + type + "");
			System.out.println("파일 크기 : " + fileSizeVal + "");

			String fileRenameExt = "user_" + _order_id_ + "." + ext;
			String fileRename = folderPath + "/" + fileRenameExt;
			File fileRenameTo = new File(fileRename);

			if(fileName.renameTo(fileRenameTo)) {
				System.out.println("파라미터 새이름 : " + fileRenameTo + " 변경 성공");
			};

			if (f != null) {
				System.out.println("크기 : " + f.length() + "바이트");
			}

			// String seq_format = String.format("%02d", i_row_count);
			//
			query = "";
			query += "update tbl_user_info set clm_user_img='" + fileRenameExt + "', clm_user_profile_file_name='" + original + "', clm_user_profile_file_size='" + fileSizeVal + "' where clm_user_id='" + _order_id_ + "';";
			System.out.println("> update_user_profile_img_info " + query);
			stmt.execute(query);
			//
			// query = "";
			// query += "insert into tbl_work_file(clm_order_id, clm_order_file_seq, clm_file_id, clm_file_name, clm_file_ext, clm_file_size, clm_file_path, clm_file_real_name) values('" + _order_id_ + "', '" + // seq_format + "', '" + (_order_id_+seq_format) + "', '" + filename + "', '" + type + "', '" + f.length() + "', '" + folderPath + "', '" + original + "');";
			// System.out.println("> insert_work_file_info " + query);
			// stmt.execute(query);

			i_row_count++;
			System.out.println(fileRenameExt);
			System.out.println("==============================");
			System.out.println(filename);
			System.out.println("==============================");
			System.out.println(original);

		}

		System.out.println(profileImg);

		// File zipFile = new File(saveFolderRoot, _order_id_ + ".zip");
		//
		// if (!zipFile.exists()) {
		// 	try {
		// 		zipFile.delete(); //폴더 생성합니다.
		// 		// System.out.println("폴더가 생성되었습니다.");
		// 	}
		// 	catch(Exception e) {
		// 		e.getStackTrace();
		// 	}
		// }
		// else {}
		//
		// byte[] buf = new byte[4096];
		//
		// try (ZipOutputStream outFile = new ZipOutputStream(new FileOutputStream(zipFile))) {
		//
		// 	System.out.println("압축 파일 시작");
		// 	for (File file : fileList) {
		// 		System.out.println("압축 파일 중");
		// 		try (FileInputStream in = new FileInputStream(file)) {
		// 			ZipEntry ze = new ZipEntry(file.getName());
		// 			outFile.putNextEntry(ze);
		//
		// 			int len;
		// 			while ((len = in.read(buf)) > 0) {
		// 				outFile.write(buf, 0, len);
		// 			}
		//
		// 			outFile.closeEntry();
		// 		}
		//
		// 	}
		// }
		System.out.println("프로필 파일 저장 성공");
	}
	catch (IOException ioe) {
		System.out.println(ioe);
	}
	catch (Exception ex) {
		System.out.println(ex);
	}
%>

<%@ include file="include/conn_close_info.jsp" %>