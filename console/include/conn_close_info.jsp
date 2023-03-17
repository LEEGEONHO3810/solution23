
	<%
	}
	catch(Exception e) {
		System.out.println("> e.toString().1 " + e.toString());
	}
	finally {
		if(stmt!=null) {
			stmt.close();
		}

		if(conn!=null) {
			conn.close();
		}
	}
	%>