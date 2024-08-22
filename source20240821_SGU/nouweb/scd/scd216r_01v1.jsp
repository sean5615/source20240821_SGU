<%/*
----------------------------------------------------------------------------------
File Name		: scd216r_01v1
Author			: north
Description		: SCD216R_�C�L�Z�u�ͼ��� - ��ܭ���
Modification Log	:

Vers		Date       	By            	Notes
--------------	--------------	--------------	----------------------------------
0.0.2		097/03/13	sRu			1.�d�߱���[�W�Ǩ�ξǸ��A�Ǩ�w�]�b�Ťj
0.0.1		096/08/10	north    	Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="/utility/errorpage.jsp" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<html>
<head>
	<%@ include file="/utility/viewpageinit.jsp"%>
	<script src="<%=vr%>script/framework/query3_1_0_2.jsp"></script>
	<script src="scd216r_01c1.jsp"></script>
	<noscript>
		<p>�z���s�������䴩JavaScript�y�k�A���O�ä��v�T�z��������������e</p>
	</noscript>
</head>
<body background="<%=vr%>images/ap_index_bg.jpg" alt="�I����" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<!-- �w�q�d�ߪ� Form �_�l -->
<form name="QUERY" method="post" onsubmit="doQuery();" style="margin:0,0,5,0;">
	<input type=hidden name="control_type">
	<input type=hidden name="REAL_USED_NO">
	<input type=hidden name="print_type">

	<!-- �d�ߥ��e���_�l -->
	<TABLE id="QUERY_DIV" width="96%" border="0" align="center" cellpadding="0" cellspacing="0" summary="�ƪ��Ϊ��">
		<tr>
			<td width="13"><img src="<%=vr%>images/ap_search_01.jpg" alt="�ƪ��ιϥ�" width="13" height="12"></td>
			<td width="100%"><img src="<%=vr%>images/ap_search_02.jpg" alt="�ƪ��ιϥ�" width="100%" height="12"></td>
			<td width="13"><img src="<%=vr%>images/ap_search_03.jpg" alt="�ƪ��ιϥ�" width="13" height="12"></td>
		</tr>
		<tr>
			<td width="13" background="<%=vr%>images/ap_search_04.jpg" alt="�ƪ��ιϥ�">&nbsp;</td>
			<td width="100%" valign="top" bgcolor="#C5E2C3">
				<!-- ���s�e���_�l -->
				<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="�ƪ��Ϊ��">
					<tr class="mtbGreenBg">
						<td align=left>�i�C�L�e���j</td>
						<td align=right>
							<div id="serach_btn">
								<input type=button class="btn" value='�M  ��' onclick='doReset();' onkeypress='doReset();'>
								<input type=submit class="btn" name="PRT_ALL_BTN" value='���s�����Ҹ��[�妸�C�L' onclick='doPrint();' onkeypress='doPrint();'>
							</div>
						</td>
					</tr>
				</table>
				<!-- ���s�e������ -->

				<!-- �d�ߵe���_�l -->
				<table id="table1" width="100%" border="0" align="center" cellpadding="2" cellspacing="1" summary="�ƪ��Ϊ��">
					<tr>
						<td align='right'>
							�Ǧ~��<font color=red>��</font>�G
						</td>
						<td align='left' colspan ='1'>
							<input type='text' name='AYEAR'>
							<select name='SMS'>
								<option value=''>�п��</option>
								<script>Form.getSelectFromPhrase("scd216rSMS_SELECT", "KIND", "SMS");</script>
							</select>
						</td>
						<td align='right'>
							�Ǩ�G
						</td>
						<td align='left' colspan ='1'>
							<select name='ASYS'>
								<option value=''>�п��</option>
								<option value='1'>�j�ǳ�</option>
								<option value='2'>�M�쳡</option>
							</select>
						</td>
					</tr>
					<tr>
						<td align='right'>
							���O<font color=red>��</font>�G
						</td>
						<td>
							<select name='TYPE'>
								<option value=''>�п��</option>
								<option value='1|1'>(�j�ǳ�)���իe 20 �W</option>
								<option value='2|1'>(�M�쳡)���իe 3 �W</option>								
								<option value='1|2'>(�j�ǳ�)�U���߲� 1 �W</option>
								<option value='2|2'>(�M�쳡)�U���߲� 1 �W</option>								
								<option value='|4'>(�j�ǳ��B�M�쳡)�U���ߦU��� 1 �W</option>									
							</select>
						</td>
						<td align='right'>���ߡG</td>
						<td>
							<select name='CENTER_CODE'>
								<option value=''>�п��</option>
								<script>Form.getSelectFromPhrase("SCD216R_01_SELECT", "", "");</script>
							</select>
						</td>
					</tr>
					<tr>						
						<td align='right'>
							�Ǹ��G
						</td>
						<td>
							<input type='text' name='STNO'>
						</td>
						<td align='right'>�O�_�ۭq�Ҹ��G</td>
						<td>
							<select name='USE_USER_SET' onchange="openUsedNo(this.value);">
								<option value='N'>�_</option>
								<option value='Y'>�O</option>
							</select>
						</td>
					</tr>
					<tr>
						<td align='right'>�U�@���Ҹ�<font color=red>��</font>�G</td>
						<td align='left' colspan="3" >�~��:<input type="text" name="YEAR">�Ҹ�:<input type="text" name="USED_NO"></td>						
					</tr>
				</table>
				<!-- �d�ߵe������ -->
			</td>
			<td width="13" background="<%=vr%>images/ap_search_06.jpg" alt="�ƪ��ιϥ�">&nbsp;</td>
		</tr>
		<tr>
			<td width="13"><img src="<%=vr%>images/ap_search_07.jpg" alt="�ƪ��ιϥ�" width="13" height="13"></td>
			<td width="100%"><img src="<%=vr%>images/ap_search_08.jpg" alt="�ƪ��ιϥ�" width="100%" height="13"></td>
			<td width="13"><img src="<%=vr%>images/ap_search_09.jpg" alt="�ƪ��ιϥ�" width="13" height="13"></td>
		</tr>
	</table>
	<!-- �d�ߥ��e������ -->
</form>
<!-- �w�q�d�ߪ� Form ���� -->

<!-- ���D�e���_�l -->
<table width="96%" border="0" align="center" cellpadding="4" cellspacing="0" summary="�ƪ��Ϊ��">
	<tr>
		<td>
			<table width="500" height="27" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td background="<%=vr%>images/ap_index_title.jpg" alt="�ƪ��ιϥ�">
						�@�@<span class="title">SCD216R_���s�����Ҹ��[�妸�C�L</span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<!-- ���D�e������ -->

<script>
	document.write ("<font color=\"white\">" + document.lastModified + "</font>");
	window.attachEvent("onload", page_init);
	window.attachEvent("onload", onloadEvent);
</script>
</body>
</html>