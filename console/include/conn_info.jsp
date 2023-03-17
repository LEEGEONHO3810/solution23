
	<%
		Connection conn = null;
		Statement stmt = null;

		String url = "jdbc:postgresql://itfactoryddns.iptime.org:5432/CHEONGJU_SOLUTION_2023";
		String usr = "postgres";
		String pwd = "postgres";
		Class.forName("org.postgresql.Driver");
		int iRowCount = 0;
		ResultSet rs = null;

		conn = DriverManager.getConnection(url, usr, pwd);
		
		try {
	%>