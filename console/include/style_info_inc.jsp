
<!-- Google icon -->
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

<!-- Bootstrap css -->
<link rel="stylesheet" type="text/css" href="../../assets/css/bootstrap.min.css">

<!-- Propeller css -->
<!-- build:[href] assets/css/ -->
<link rel="stylesheet" type="text/css" href="../../assets/css/propeller.min.css">
<!-- /build -->

<!-- Propeller date time picker css-->
<link rel="stylesheet" type="text/css" href="../../components/datetimepicker/css/bootstrap-datetimepicker.css" />
<link rel="stylesheet" type="text/css" href="../../components/datetimepicker/css/pmd-datetimepicker.css" />

<!-- Propeller theme css-->
<link rel="stylesheet" type="text/css" href="../../themes/css/propeller-theme.css" />

<!-- Propeller admin theme css-->
<link rel="stylesheet" type="text/css" href="../../themes/css/propeller-admin.css">

<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.12/css/dataTables.bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/responsive/2.1.0/css/responsive.bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/select/1.2.0/css/select.dataTables.min.css">
<!-- Propeller dataTables css-->

<link rel="stylesheet" type="text/css" href="../../components/data-table/css/pmd-datatable.css">

<style>
@import url('https://fonts.googleapis.com/css?family=Nanum+Gothic:400,700,800');
@import url('https://cdn.jsdelivr.net/gh/moonspam/NanumSquare@1.0/nanumsquare.css');

body {
	font-family: 'NanumSquare';
}

h1 {
	font-family: 'NanumSquare';
	font-weight: bold;
}

th {
	background-color: #eee;
	font-size:14px;
	font-weight:bold;
	color:#666;
	border-bottom:1px solid #ccc;
}

thead th {
	background-color: #eee;
	font-size:12px;
	font-weight:bold;
	color:#666;
}

tr {
	background-color: #fff;
	font-size:12px;
	font-weight:normal;
	color:#333;
	border-bottom:1px solid #ccc;
}

td {
	background-color: #fff;
	font-size:12px;
	font-weight:normal;
	color:#333;
	border-bottom:1px solid #ccc;
}

.approval_table {
	background-color: #fff;
	font-size:12px;
	font-weight:normal;
	color:#333;
	height:75px;
	border:1px solid #ccc;
	padding:0px;
}

.approval_td {
	background-color: #fff;
	font-size:12px;
	font-weight:normal;
	color:#333;
	height:75px;
	border:1px solid #ccc;
	padding:5px;
}

.approval_th {
	background-color: #eee;
	text-align:center;
	font-size:12px;
	font-weight:bold;
	color:#333;
	border:1px solid #ccc;
	padding:5px;
}

.modal_list_td {
	text-align:center;
}

.nav_sub {
	font-family: 'NanumSquare'; font-size:24px; font-weight: bold;
}

/*
@font-face {
	font-family: 'NanumBarunGothicBold';
	src: url('resources/fonts/NanumBarunGothic/NanumBarunGothicBold.eot');
	src: url('resources/fonts/NanumBarunGothic/NanumBarunGothicBold.eot')
		format('embedded-opentype'),
		url('resources/fonts/NanumBarunGothic/NanumBarunGothicBold.woff')
		format('woff');
}
*/





.select {
  display: inline-block;
  width: 300px;
  border: 1px solid #999;
}

.select .selected {
  display: flex;
  justify-content: space-between;
  padding: 8px 5px;
}

.select .selected .selected-value {
  max-width: 300px;
  font-size:14px;
}

.select .selected .arrow {
  width: 24px;
  background: url("resources/img/icon/arrow_down.png") no-repeat 70% 50%;
  background-size: 50% 50%;
}

.select ul {
  display: none;
  width: 300px;
  border: 1px solid #999;
  position: absolute;
  background: #fff;
  border-top: none;
  margin: 1px 0 0 -1px;
  cursor: pointer;
  padding: 5px;
}

.select ul li,
.select .selected .selected-value {
  white-space: nowrap; /* 줄바꿈 안함 */
  overflow: hidden;
  text-overflow: ellipsis; /* 말줄임 적용 */
  padding: 2px;
}

.select ul li:hover {
  background: rgba(168, 156, 235, 0.35)
}

.select.active ul {
  display: initial;
}
</style>