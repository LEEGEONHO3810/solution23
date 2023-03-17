<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%>
<%
		try {
			_clm_modal_code_id = "008";
			stmt = conn.createStatement();
			strCondition = "";
			strCondition += "and x.clm_code_id='" + _clm_modal_code_id + "'";
			query = "select x.* from _tbl_pub_code_info x where 1=1 " + strCondition + " order by x.clm_code_sub_id;";
			System.out.println("> query : " + query);
			rs = stmt.executeQuery(query);

			int iModalRowCnt = 0;
			List<Map<String, String>> lstModal = new ArrayList<Map<String, String>>();
			Map<String, String> mapModal = null;

			while (rs.next()) {
				mapModal = new HashMap<String, String>();
				mapModal.put("clm_code_id"        , rs.getString("clm_code_id")        );
				mapModal.put("clm_code_sub_id"    , rs.getString("clm_code_sub_id")    );
				mapModal.put("clm_code_name"      , rs.getString("clm_code_name")      );
				mapModal.put("clm_code_sub_name"  , rs.getString("clm_code_sub_name")  );
				mapModal.put("clm_code_value"     , rs.getString("clm_code_value")     );
				mapModal.put("clm_reg_user"       , rs.getString("clm_reg_user")       );
				mapModal.put("clm_reg_datetime"   , rs.getString("clm_reg_datetime")   );
				mapModal.put("clm_update_user"    , rs.getString("clm_update_user")    );
				mapModal.put("clm_update_datetime", rs.getString("clm_update_datetime"));
				mapModal.put("clm_use_yn"         , rs.getString("clm_use_yn")         );
				lstModal.add(mapModal);
				iModalRowCnt++;
			}
%>
							<div tabindex="-1" class="modal fade" id="form-dialog" style="display: none;" aria-hidden="true" id="mdl_product_info">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header bordered">
											<button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
											<h2 class="pmd-card-title-text">조치사항</h2>
										</div>
										<div class="modal-body">
											<form class="form-horizontal">
												<div class="form-group pmd-textfield pmd-textfield-floating-label">
													<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%">
														<thead>
															<tr>
																<th style="width:10%;">코드</th>
																<th style="width:80%;">문제유형</th>
																<th style="width:10%;">선택</th>
															</tr>
														</thead>
														<tbody>
<%
		// // String _clm_comment         = "";
		// // String _clm_reg_datetime    = "";
		// // String _clm_reg_user        = "";
		// // String _clm_update_datetime = "";
		// // String _clm_update_user     = "";
		//
		// try {
		// 	_clm_modal_code_id = "008";
		// 	stmt = conn.createStatement();
		// 	strCondition = "";
		// 	strCondition += "and x.clm_code_id='" + _clm_modal_code_id + "'";
		// 	query = "select x.* from _tbl_pub_code_info x where 1=1 " + strCondition + " order by x.clm_code_sub_id;";
		// 	System.out.println("> query : " + query);
		// 	rs = stmt.executeQuery(query);

			for(int j=0; j<lstModal.size(); j++) {
				_clm_code_id         = lstModal.get(j).get("clm_code_id");
				_clm_code_sub_id     = lstModal.get(j).get("clm_code_sub_id");
				_clm_code_name       = lstModal.get(j).get("clm_code_name");
				_clm_code_sub_name   = lstModal.get(j).get("clm_code_sub_name");
				_clm_code_value      = lstModal.get(j).get("clm_code_value");
				_clm_reg_user        = lstModal.get(j).get("clm_reg_user");
				_clm_reg_datetime    = lstModal.get(j).get("clm_reg_datetime");
				_clm_update_user     = lstModal.get(j).get("clm_update_user");
				_clm_update_datetime = lstModal.get(j).get("clm_update_datetime");
				_clm_use_yn          = lstModal.get(j).get("clm_use_yn");
%>
															<tr>
																<td><%=_clm_code_sub_id %></td>
																<td><%=_clm_code_sub_name %></td>
																<td class="modal_list_td" style="padding:0px;">
										<button class="btn btn-sm pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-primary" type="button" onClick="JavaScript:$.fnc_issue_confirm('<%=strDocId %>', '<%=_clm_report_id_ %>', '<%=_clm_write_date_ %>', '<%=_clm_write_time_ %>', '<%=_clm_product_id_ %>', '<%=_clm_manager_id_ %>', '<%=ss_user_id %>', '<%=_clm_code_sub_id %>');">
											<i class="material-icons pmd-sm" style="color:#ccc; font-size:24px;">check_circle</i>
										</button>
																</td>
															</tr>
<%
			}
		}
		catch(Exception e) {
			System.out.println("> e.toString().1 " + e.toString());
		}
		finally {
			// lstModal = null;
			// mapModal = null;

			if(stmt!=null) {
				stmt.close();
			}
		}
%>
														</tbody>
													</table>
												</div>
											</form>
										</div>
										<div class="pmd-modal-action">
											<button data-dismiss="modal"	class="btn pmd-ripple-effect btn-primary" type="button">조회</button>
											<button data-dismiss="modal"	class="btn pmd-ripple-effect btn-default" type="button">취소</button>
										</div>
									</div>
								</div>
							</div>