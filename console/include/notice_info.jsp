<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%>

<%
		try {
			List <Map<String, String>> info_map_list = new ArrayList<Map<String, String>>();
			Map<String, String> info_map = null;
			stmt = conn.createStatement();
			String notice_strCondition = "";
			String notice_query  = "";
			notice_query  = "";
			notice_query += " select x.clm_notice_id,x.clm_notice_contents,x.clm_notice_start_date,x.clm_notice_end_date,x.clm_notice_title";
			notice_query += "  ,x.clm_notice_type,clm_del_yn,x.clm_comment,x.clm_reg_datetime,x.clm_reg_user_id,x.clm_company_key,coalesce(z1.clm_code_sub_name,'') as clm_notice_type_name  ";
			notice_query += "  from tbl_notice_info x ";
			notice_query += " left outer join tbl_code_sub_info z1 on x.clm_company_key = z1.clm_company_key and x.clm_notice_type = z1.clm_code_sub_id and z1.clm_code_id = '0010' ";
			notice_query += " where now() between to_timestamp(replace(clm_notice_start_date, '-', ''),'YYYYMMDD') and to_timestamp(replace(clm_notice_end_date, '-', ''),'YYYYMMDD') and x.clm_company_key = '" + SessionCompanyKey + "' and x.clm_del_yn='N' ";
			notice_query += " order by x.clm_notice_id desc;";
			System.out.println("> " + strCurrentReportId + ".data_list " + notice_query);
			rs = stmt.executeQuery(notice_query);

			int iInfoCnt = 0;
			while (rs.next()) {
				String clm_notice_id         	 = rs.getString("clm_notice_id");
				String clm_notice_contents  	 = rs.getString("clm_notice_contents");
				String clm_notice_start_date   	 = rs.getString("clm_notice_start_date");
				String clm_notice_end_date    	 = rs.getString("clm_notice_end_date");
				String clm_notice_type        	 = rs.getString("clm_notice_type");
				String clm_del_yn             	 = rs.getString("clm_del_yn");
				String clm_notice_comment            	 = rs.getString("clm_comment");
				String clm_notice_reg_datetime       	 = rs.getString("clm_reg_datetime");
				String clm_notice_title       	 = rs.getString("clm_notice_title");
				String clm_notice_company_key      	 = rs.getString("clm_company_key");
				String clm_reg_user_id         	 = rs.getString("clm_reg_user_id");
				String clm_notice_type_name    	 = rs.getString("clm_notice_type_name");
				info_map = new HashMap<String, String>();
				info_map.put("clm_notice_id", clm_notice_id);
				info_map.put("clm_notice_contents", clm_notice_contents);
				info_map.put("clm_notice_start_date", clm_notice_start_date);
				info_map.put("clm_notice_end_date", clm_notice_end_date);
				info_map.put("clm_notice_type", clm_notice_type);
				info_map.put("clm_del_yn", clm_del_yn);
				info_map.put("clm_notice_comment", clm_notice_comment);
				info_map.put("clm_notice_reg_datetime", clm_notice_reg_datetime);
				info_map.put("clm_notice_title", clm_notice_title);
				info_map.put("clm_notice_company_key", clm_notice_company_key);
				info_map.put("clm_reg_user_id", clm_reg_user_id);
				info_map.put("clm_notice_type_name", clm_notice_type_name);
				iInfoCnt++;
			}
%>
		<div class="pmd-navbar-right-icon pull-right navigation">
			<!-- Notifications -->
			<div class="dropdown notification icons pmd-dropdown">
				<a href="javascript:void(0)" title="Notification" class="dropdown-toggle pmd-ripple-effect"	data-toggle="dropdown" role="button" aria-expanded="true">
					<div data-badge="<%=iInfoCnt %>" class="material-icons md-light pmd-sm pmd-badge	pmd-badge-overlap">notifications_none</div>
				</a>

				<div class="dropdown-menu dropdown-menu-right pmd-card pmd-card-default pmd-z-depth" role="menu">
					<!-- Card header -->
					<div class="pmd-card-title">
						<div class="media-body media-middle">
							<!--
							<a href="notifications.html" class="pull-right"><%=iInfoCnt %>개 공지가 등록되었습니다.</a>
							-->
							<a href="notice_list.jsp" class="pull-right"><%=iInfoCnt %>개 공지가 진행중입니다.</a>
							<h3 class="pmd-card-title-text">알림</h3>
						</div>
					</div>

					<!-- Notifications list -->
					<ul class="list-group pmd-list-avatar pmd-card-list">
						<li class="list-group-item hidden">
							<p class="notification-blank">
								<span class="dic dic-notifications-none"></span>
								<span>You don´t have any notifications</span>
							</p>
						</li>
<%
		// try {
			stmt = conn.createStatement();
			notice_strCondition = "";
			notice_query  = "";
			// notice_query += "select ";
			// notice_query += "  x.* ";
			// notice_query += ", (select clm_user_name from fn_user_info(x.clm_reg_user_id) y) ckn_reg_user_name ";
			// notice_query += ", (select count(*) from tbl_order_file y where y.clm_order_id=x.clm_notice_id) clm_file_count ";
			// notice_query += "from ";
			// notice_query += "	tbl_notice_info x ";
			// notice_query += "where 1=1 and x.clm_del_yn='N' " + notice_strCondition + " ";
			// notice_query += "order by x.clm_notice_id desc;";
			notice_query += "select x.*, z.clm_user_name, z.clm_user_img from tbl_notice_info x, (select y.* from tbl_user_info y) z where now() between to_timestamp(replace(clm_notice_start_date, '-', ''),'YYYYMMDD') and to_timestamp(replace(clm_notice_end_date, '-', ''),'YYYYMMDD') and x.clm_reg_user_id=z.clm_user_seq order by clm_notice_id desc;";
			System.out.println("> " + strCurrentReportId + ".data_list " + notice_query);
			rs = stmt.executeQuery(notice_query);

			String img_path = "img/user/";

			iInfoCnt = 0;
			for(int i=0; i<info_map_list.size(); i++) {
				String clm_notice_id         		= info_map_list.get(i).get("clm_notice_id");
				String clm_notice_contents   		= info_map_list.get(i).get("clm_notice_contents");
				String clm_notice_start_date 		= info_map_list.get(i).get("clm_notice_start_date");
				String clm_notice_end_date   		= info_map_list.get(i).get("clm_notice_end_date");
				String clm_notice_type       		= info_map_list.get(i).get("clm_notice_type");
				String clm_del_yn            		= info_map_list.get(i).get("clm_del_yn");
				String clm_notice_comment           = info_map_list.get(i).get("clm_notice_comment");
				String clm_notice_reg_datetime      = info_map_list.get(i).get("clm_notice_reg_datetime");
				String clm_reg_user_id      	    = info_map_list.get(i).get("clm_reg_user_id");
				String clm_notice_update_datetime  	= info_map_list.get(i).get("clm_update_datetime");
				String clm_update_user_id    		= info_map_list.get(i).get("clm_update_user_id");
				String clm_notice_title      		= info_map_list.get(i).get("clm_notice_title");
				String clm_user_name        		= info_map_list.get(i).get("clm_user_name");
				String clm_user_img         		= info_map_list.get(i).get("clm_user_img");

				// clm_file_download_path   = saveFolderRootLogical + "/" + clm_notice_id + ".zip";
%>
						<li class="list-group-item unread">
							<a href="notice_info_detail.jsp?_notice_id_=<%=clm_notice_id %>">
								<div class="media-left">
									<span class="avatar-list-img40x40">
										<%
											clm_user_img = img_path + ((!clm_user_img.equals(""))?"user_admin.png":"user_logo.png");
											System.out.println("> clm_user_img " + clm_user_img);
										%>
										<img alt="40x40" data-src="holder.js/40x40" class="img-responsive" src="<%=clm_user_img %>" data-holder-rendered="true">
									</span>
								</div>
								<div class="media-body">
									<span class="list-group-item-heading">
										<span>
										<b>
										<%
											if(clm_notice_type.equals("00050001")) {
										%>
											[일반]
										<%
											}
											else {
										%>
											<font color="red">[긴급]</font>
										<%
											}
										%>
										</b>
										</span>
										<%=clm_notice_title %>
									</span>
									<span class="list-group-item-text" style="padding-top:3px;">
										<%=clm_notice_start_date %> ~ <%=clm_notice_end_date %>
									</span>
								</div>
							</a>
						</li>
<%
				iInfoCnt++;
			}

			// int iInfoCntTmp = 15;
			//
			// if(iInfoCnt<iInfoCntTmp) {
			// 	for(int i=0; i<iInfoCntTmp-iInfoCnt; i++) {
%>
					<!--
					<tr>
						<td data-title="Ticket No"></td>
						<td data-title="Browser Name" style="padding:10px; height:50px;"></td>
						<td data-title="Month"></td>
						<td data-title="Month"></td>
						<td data-title="Status"></td>
						<td data-title="date"></td>
					</tr>
					-->
<%
			// 	}
			// }
		}
		catch(Exception e) {
			System.out.println("> e.toString().0 " + e.toString());
		}

		stmt.close();
%>
					</ul><!-- End notifications list -->
				</div>
			</div> <!-- End notifications -->
		</div>