<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%>
							<div tabindex="-1" class="modal fade" id="form-dialog_01" style="display: none;" aria-hidden="true" id="mdl_user_info">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header bordered">
											<button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
											<h2 class="pmd-card-title-text">직원목록</h2>
										</div>
										<div class="modal-body">
											<form class="form-horizontal">
												<div class="form-group pmd-textfield pmd-textfield-floating-label">
													<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%">
														<thead>
															<tr>
																<th>직원명</th>
																<th>직원ID</th>
																<th>특이사항</th>
																<th>선택</th>
															</tr>
														</thead>
														<tbody>
<%
		// String _clm_comment            = "";
		// String _clm_reg_user           = "";
		// String _clm_reg_datetime       = "";
		// String _clm_update_user        = "";
		// String _clm_update_datetime    = "";

		try {
			stmt = conn.createStatement();
			strCondition = "";
			strCondition += "";
			query = "select x.* from _tbl_pub_user_info x where 1=1 " + strCondition;
			System.out.println("> query : " + query);
			rs = stmt.executeQuery(query);

			int iRowCnt = 0;
			while (rs.next()) {
				_clm_user_id            = rs.getString("clm_user_id");
				_clm_user_password      = rs.getString("clm_user_password");
				_clm_user_name          = rs.getString("clm_user_name");
				_clm_user_department_id = rs.getString("clm_user_department_id");
				_clm_comment            = rs.getString("clm_comment");
				_clm_reg_user           = rs.getString("clm_reg_user");
				_clm_reg_datetime       = rs.getString("clm_reg_datetime");
				_clm_update_user        = rs.getString("clm_update_user");
				_clm_update_datetime    = rs.getString("clm_update_datetime");
%>
															<tr>
																<td><%=_clm_user_name %></td>
																<td><%=_clm_user_id %></td>
																<td><%=_clm_comment %></td>
																<td class="modal_list_td">
																	<a href="#" style="font-weight:bold; color:#4285f4;" onClick="JavaScript:$.fnc_user_info('<%=_clm_user_id %>', '<%=_clm_user_name %>');" data-dismiss="modal">
																		선택
																	</a>
																</td>
															</tr>
<%
				iRowCnt++;
			}

			if(iRowCnt==0) {
%>
															<tr>
																<td colspan="4">조회된 정보가 없습니다.</td>
															</tr>
<%
			}
		}
		catch(Exception e) {
			System.out.println("> e.toString().0 " + e.toString());
		}

		stmt.close();
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