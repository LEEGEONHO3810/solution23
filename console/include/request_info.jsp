<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%>
<%
	String _order_id_ = (request.getParameter("_order_id_")==null)?"":request.getParameter("_order_id_");
	String _notice_id_ = (request.getParameter("_notice_id_")==null)?"":request.getParameter("_notice_id_");
	String _report_seq_ = (request.getParameter("_report_seq_")==null)?"":request.getParameter("_report_seq_");
	String _report_id_ = (request.getParameter("_report_id_")==null)?"":request.getParameter("_report_id_");
	String _product_id_ = (request.getParameter("_product_id_")==null)?"000000":request.getParameter("_product_id_");
	String _doc_id_ = (request.getParameter("_doc_id_")==null)?"":request.getParameter("_doc_id_");
	String _revision_id_ = (request.getParameter("_revision_id_")==null)?"":request.getParameter("_revision_id_");
	String _revision_id_prod_ = (request.getParameter("_revision_id_prod_")==null)?"":request.getParameter("_revision_id_prod_");

	/*
		// '_notice_title_' : notice_title,
		// '_notice_start_date_' : notice_start_date,
		// '_notice_end_date_' : notice_end_date,
		// '_notice_type_id_' : notice_type_id,
		// '_notice_contents_' : notice_contents,
	*/

	String _order_name_ = (request.getParameter("_order_name_")==null)?"":request.getParameter("_order_name_");
	String _customer_name_ = (request.getParameter("_customer_name_")==null)?"":request.getParameter("_customer_name_");
	String _building_address_ = (request.getParameter("_building_address_")==null)?"":request.getParameter("_building_address_");
	String _user_name_ = (request.getParameter("_user_name_")==null)?"":request.getParameter("_user_name_");
	String _work_from_date_ = (request.getParameter("_work_from_date_")==null)?"":request.getParameter("_work_from_date_");
	String _work_end_date_ = (request.getParameter("_work_end_date_")==null)?"":request.getParameter("_work_end_date_");
	String _building_type_ = (request.getParameter("_building_type_")==null)?"":request.getParameter("_building_type_");
	String _building_from_height_ = (request.getParameter("_building_from_height_")==null)?"":request.getParameter("_building_from_height_");
	String _building_end_height_ = (request.getParameter("_building_end_height_")==null)?"":request.getParameter("_building_end_height_");

	String _notice_title_ = (request.getParameter("_notice_title_")==null)?"":request.getParameter("_notice_title_");
	String _notice_start_date_ = (request.getParameter("_notice_start_date_")==null)?"":request.getParameter("_notice_start_date_");
	String _notice_end_date_ = (request.getParameter("_notice_end_date_")==null)?"":request.getParameter("_notice_end_date_");
	String _notice_type_id_ = (request.getParameter("_notice_type_id_")==null)?"":request.getParameter("_notice_type_id_");
	String _notice_contents_ = (request.getParameter("_notice_contents_")==null)?"":request.getParameter("_notice_contents_");

	String _customer_id_ = (request.getParameter("_customer_id_")==null)?"":request.getParameter("_customer_id_");
	String _user_id_ = (request.getParameter("_user_id_")==null)?"":request.getParameter("_user_id_");

	String _code_id_ = (request.getParameter("_code_id_")==null)?"":request.getParameter("_code_id_");
	String _code_sub_id_ = (request.getParameter("_code_sub_id_")==null)?"":request.getParameter("_code_sub_id_");
	String _code_type_ = (request.getParameter("_code_type_")==null)?"":request.getParameter("_code_type_");
	
	String _str_order_id_ = (request.getParameter("_str_order_id_")==null)?"":request.getParameter("_str_order_id_");

	String[] _chk_order_id_ = request.getParameterValues("chk_order_id");

	System.out.println("> _order_id_			 " + _order_id_);
	System.out.println("> _notice_id_			 " + _notice_id_);
	System.out.println("> _order_name_			 " + _order_name_);
	System.out.println("> _customer_name_		 " + _customer_name_);
	System.out.println("> _building_address_	 " + _building_address_);
	System.out.println("> _user_name_			 " + _user_name_);
	System.out.println("> _work_from_date_		 " + _work_from_date_);
	System.out.println("> _work_end_date_		 " + _work_end_date_);
	System.out.println("> _building_type_		 " + _building_type_);
	System.out.println("> _building_from_height_ " + _building_from_height_);
	System.out.println("> _building_end_height_	 " + _building_end_height_);

	System.out.println("> _notice_title_	 " + _notice_title_);
	System.out.println("> _notice_start_date_	 " + _notice_start_date_);
	System.out.println("> _notice_end_date_	 " + _notice_end_date_);
	System.out.println("> _notice_type_id_	 " + _notice_type_id_);
	System.out.println("> _notice_contents_	 " + _notice_contents_);

	System.out.println("> _customer_id_	 " + _customer_id_);
	System.out.println("> _user_id_	 " + _user_id_);

	System.out.println("> _code_id_	 " + _code_id_);
	System.out.println("> _code_sub_id_	 " + _code_sub_id_);

	System.out.println("> _code_type_	 " + _code_type_);
	System.out.println("> _chk_order_id_	 " + _chk_order_id_);

	System.out.println("> _str_order_id_	 " + _str_order_id_);

	if(_chk_order_id_!=null) {
		System.out.println("> _chk_order_id_.length()	 " + _chk_order_id_.length);
	}
%>