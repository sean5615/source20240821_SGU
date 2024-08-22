<%/*
----------------------------------------------------------------------------------
File Name		: scd215r_01m1.jsp
Author			: barry
Description		: �C�L�Z�u�ͼ����W�U - �B�z�޿譶��
Modification Log	:

Vers		Date       	By            	Notes
--------------	--------------	--------------	----------------------------------
0.0.1		096/08/10	barry    	Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/modulepageinit.jsp"%>
<%@page import="com.nou.scd.dao.*"%>
<%@page import="java.util.*"%>
<%@page import="com.acer.util.DateUtil"%>

<%!
/** �B�z�C�L�\�� */
private void doPrint(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	try
	{
		Connection	conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("NOU", session));
		Hashtable input = new Hashtable();
		Hashtable tmp = null;
		SCDT021GATEWAY SCDT021 = new SCDT021GATEWAY(dbManager, conn);
		int tmp2 = 0;
		String AYEAR = "";
		String SMS_NAME = "";
		String KIND = Utility.dbStr(requestMap.get("KIND"));
		String ASYS = Utility.dbStr(requestMap.get("ASYS"));
		String TITLE_ASYS_NAME = "";
		String ASYS_NAME = "";
		if("1".equals(ASYS)){
			if("1".equals(KIND)){
				//TITLE_ASYS_NAME = "�Ťj���իe�G�Q�W";
			}else if("2".equals(ASYS)){
				//TITLE_ASYS_NAME = "�Ťj�U���߲Ĥ@�W";
			}
		}else if("2".equals(ASYS)){
			if("1".equals(KIND)){
				//TITLE_ASYS_NAME = "�űM���իe�T�W";
			}else if("2".equals(ASYS)){
				//TITLE_ASYS_NAME = "�űM�U���߲Ĥ@�W";
			}
		}else{
			//TITLE_ASYS_NAME = "�Ťj�űM�U���ߦU��Ĥ@�W";
		}
		
		// ���o�ǤJ�Ǧ~�����U�@�ӾǦ~��
		String inputAyear  = Utility.dbStr(requestMap.get("AYEAR"));
		String inputSms  = Utility.dbStr(requestMap.get("SMS"));
		String nextSmsNM  = "";
		if (inputSms.equals("2") || inputSms.equals("3")){
			inputAyear = String.valueOf( Integer.parseInt(inputAyear) + 1);
			inputSms = "1";
			nextSmsNM = "�W";
		}else{
			inputSms = "2";
			nextSmsNM = "�U";
		}
		input.put("NEXT_AYEAR", inputAyear);
		input.put("NEXT_SMS", inputSms);

		if(!Utility.checkNull(requestMap.get("AYEAR"), "").equals(""))
			input.put("AYEAR", Utility.dbStr(requestMap.get("AYEAR")));
		if(!Utility.checkNull(requestMap.get("SMS"), "").equals(""))
			input.put("SMS", Utility.dbStr(requestMap.get("SMS")));
		if(!Utility.checkNull(requestMap.get("KIND"), "").equals(""))
			input.put("KIND", Utility.dbStr(requestMap.get("KIND")));
		if(!Utility.checkNull(requestMap.get("AYEAR"), "").equals(""))
			input.put("AYEAR", Utility.dbStr(requestMap.get("AYEAR")));
		if(!Utility.checkNull(requestMap.get("ASYS"), "").equals(""))
			input.put("ASYS", Utility.dbStr(requestMap.get("ASYS")));
		if(!Utility.checkNull(requestMap.get("CENTER_CODE"), "").equals(""))
			input.put("CENTER_CODE", Utility.dbStr(requestMap.get("CENTER_CODE")));		
		if(KIND.equals("1"))
		{
			/** ���o DBResult */
			Vector	result	=	 SCDT021.getDataForScd215r(input);
			/** ��l�� rptFile */
			RptFile		rptFile	=	new RptFile(session.getId());
			rptFile.setColumn("��_1,��_2,��_3,��_4,��_5,��_6,��_7,��_8,��_9,��_10,��_11");
			while(!result.isEmpty())
			{
				tmp = (Hashtable)result.remove(0);
				if(AYEAR.equals("") && !Utility.checkNull(tmp.get("AYEAR"), "").equals(""))
				{
					if(((String)tmp.get("AYEAR")).trim().length() != 0)
						AYEAR = (String)tmp.get("AYEAR");
					else
						AYEAR = "";
				}
				if(SMS_NAME.equals("") && !Utility.checkNull(tmp.get("SMS_NAME"), "").equals(""))
				{
					String COND = "���իe20�W";
					
					if("1".equals(Utility.dbStr(requestMap.get("ASYS")))){
						COND = "���իe20�W�W�U(�j�ǳ�)";
					}else{
						COND = "���իe3�W�W�U(�M�쳡)";
					}
					if(((String)tmp.get("SMS_NAME")).trim().length() != 0)
						SMS_NAME = (String)tmp.get("SMS_NAME")+COND;
					else
						SMS_NAME = "";
				}
				if(!Utility.checkNull(tmp.get("STNO"), "").equals("")){
					if(((String)tmp.get("STNO")).trim().length() != 0)
						rptFile.add((String)tmp.get("STNO"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("NAME"), "").equals("")){
					if(((String)tmp.get("NAME")).trim().length() != 0)
						rptFile.add((String)tmp.get("NAME"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("SEX"), "").equals("")){
					if(((String)tmp.get("SEX")).trim().length() != 0)
						rptFile.add((String)tmp.get("SEX"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("AVG_MARK"), "").equals("")){
					if(((String)tmp.get("AVG_MARK")).trim().length() != 0)
					{
						if(((String)tmp.get("AVG_MARK")).indexOf(".") == -1)
						{
							rptFile.add(((String)tmp.get("AVG_MARK")) + ".00");
						}else if(((String)tmp.get("AVG_MARK")).length() - ((String)tmp.get("AVG_MARK")).indexOf(".") == 2)
							rptFile.add(((String)tmp.get("AVG_MARK")) + "0");
						else
							rptFile.add(((String)tmp.get("AVG_MARK")));
					}
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("MOBILE"), "").equals("")){
					if(((String)tmp.get("MOBILE")).trim().length() != 0)
						rptFile.add((String)tmp.get("MOBILE"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("TEL_HOME"), "").equals("")){
					if(((String)tmp.get("TEL_HOME")).trim().length() != 0)
						rptFile.add((String)tmp.get("TEL_HOME"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("CRRSADDR"), "").equals("")){
					if(((String)tmp.get("CRRSADDR")).trim().length() != 0)
						rptFile.add((String)tmp.get("CRRSADDR"));
					else
						rptFile.add("�@");
				}else{
					rptFile.add("�@");
				}
				if(!Utility.checkNull(tmp.get("RANK"), "").equals("")){
					if(((String)tmp.get("RANK")).trim().length() != 0)
					{
						if(((String)tmp.get("RANK")).indexOf("0") == 0)
							rptFile.add(((String)tmp.get("RANK")).substring(1));
						else
							rptFile.add(((String)tmp.get("RANK")));
					}
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				
				/* 2028/8/21 �����X�ͤ��BIRTHDATE�A��אּ�Ҹ�AWARD_NO*/
				if(!Utility.checkNull(tmp.get("AWARD_NO"), "").equals("")){
					if(((String)tmp.get("AWARD_NO")).trim().length() != 0)
						rptFile.add(DateUtil.formatDate((String)tmp.get("AWARD_NO")));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				
				
				if(!Utility.checkNull(tmp.get("CENTER_NAME"), "").equals("")){
					if(((String)tmp.get("CENTER_NAME")).trim().length() != 0)
						rptFile.add(((String)tmp.get("CENTER_NAME")).substring(0, 2));
					else
						rptFile.add("�@");
				}else{
					rptFile.add("�@");
				}
				
				// �U�Ǵ���Ū��إN�X�έ��¯Z��
				if(!Utility.checkNull(tmp.get("CRSNO_CLASS"), "").equals("")){
					rptFile.add((String)tmp.get("CRSNO_CLASS"));
				}else{
					rptFile.add("&nbsp;");
				}
			}

			if (rptFile.size() == 0)
			{
				out.println("<script>top.close();alert(\"�L�ŦX��ƥi�ѦC�L!!\");</script>");
				return;
			}

			/** ��l�Ƴ����� */
			report		report_	=	new report(dbManager, conn, out, "scd215r_01r1", report.onlineHtmlMode);

			/** �R�A�ܼƳB�z */
			Hashtable	ht	=	new Hashtable();
			if(!Utility.checkNull(AYEAR, "").equals("")){
				if(AYEAR.trim().length() != 0)
					ht.put("���Y_1", TITLE_ASYS_NAME+"&nbsp;&nbsp;&nbsp;&nbsp;"+AYEAR);
				else
					ht.put("���Y_1","&nbsp;");
			}else{
				ht.put("���Y_1","&nbsp;");
			}
			if(!Utility.checkNull(SMS_NAME, "").equals("")){
				if(SMS_NAME.trim().length() != 0)
					ht.put("���Y_2", SMS_NAME);
				else
					ht.put("���Y_2","&nbsp;");
			}else{
				ht.put("���Y_2","&nbsp;");
			}
			if(!Utility.checkNull(AYEAR, "").equals("")){
				ht.put("���Y_3",inputAyear + nextSmsNM + "��פ���ئW�٤έ��¯Z��");
			}else{
				ht.put("���Y_3","&nbsp;");
			}
			report_.setDynamicVariable(ht);

			/** �}�l�C�L */
			report_.genReport(rptFile);
		}else if(KIND.equals("2")){
			input.put("RANK", "1");			
			/** ���o DBResult */
			Vector	result	=	 SCDT021.getDataForScd215r(input);
			/** ��l�� rptFile */
			RptFile		rptFile	=	new RptFile(session.getId());
			rptFile.setColumn("���Y_3,��_1,��_2,��_3,��_4,��_5,��_6,��_7,��_8,��_9,��_10");

			while(!result.isEmpty())
			{
				tmp = (Hashtable)result.remove(0);
				if(AYEAR.equals("") && !Utility.checkNull(tmp.get("AYEAR"), "").equals(""))
				{
					if(((String)tmp.get("AYEAR")).trim().length() != 0)
						AYEAR = (String)tmp.get("AYEAR");
					else
						AYEAR = "";
				}
				if(SMS_NAME.equals("") && !Utility.checkNull(tmp.get("SMS_NAME"), "").equals(""))
				{
					if(((String)tmp.get("SMS_NAME")).trim().length() != 0)
						SMS_NAME = (String)tmp.get("SMS_NAME");
					else
						SMS_NAME = "";
				}
				if(!Utility.checkNull(tmp.get("CENTER_NAME"), "").equals("")){
					if(((String)tmp.get("CENTER_NAME")).trim().length() != 0){
						rptFile.add((String)tmp.get("CENTER_NAME"));
					}
					else{
						rptFile.add("&nbsp;");
					}
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("STNO"), "").equals("")){
					if(((String)tmp.get("STNO")).trim().length() != 0)
						rptFile.add((String)tmp.get("STNO"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("NAME"), "").equals("")){
					if(((String)tmp.get("NAME")).trim().length() != 0)
						rptFile.add((String)tmp.get("NAME"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("SEX"), "").equals("")){
					if(((String)tmp.get("SEX")).trim().length() != 0)
						rptFile.add((String)tmp.get("SEX"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("AVG_MARK"), "").equals("")){
					if(((String)tmp.get("AVG_MARK")).trim().length() != 0)
					{
						if(((String)tmp.get("AVG_MARK")).indexOf(".") == -1)
						{
							rptFile.add(((String)tmp.get("AVG_MARK")) + ".00");
						}else if(((String)tmp.get("AVG_MARK")).length() - ((String)tmp.get("AVG_MARK")).indexOf(".") == 2)
							rptFile.add(((String)tmp.get("AVG_MARK")) + "0");
						else
							rptFile.add(((String)tmp.get("AVG_MARK")));
					}
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("MOBILE"), "").equals("")){
					if(((String)tmp.get("MOBILE")).trim().length() != 0)
						rptFile.add((String)tmp.get("MOBILE"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("TEL_HOME"), "").equals("")){
					if(((String)tmp.get("TEL_HOME")).trim().length() != 0)
						rptFile.add((String)tmp.get("TEL_HOME"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("CRRSADDR"), "").equals("")){
					if(((String)tmp.get("CRRSADDR")).trim().length() != 0)
						rptFile.add((String)tmp.get("CRRSADDR"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("RANK"), "").equals("")){
					if(((String)tmp.get("RANK")).trim().length() != 0)
						rptFile.add((String)tmp.get("RANK"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				/* 2028/8/21 �����X�ͤ��BIRTHDATE�A��אּ�Ҹ�AWARD_NO*/
				if(!Utility.checkNull(tmp.get("AWARD_NO"), "").equals("")){
					if(((String)tmp.get("AWARD_NO")).trim().length() != 0)
						rptFile.add(DateUtil.formatDate((String)tmp.get("AWARD_NO")));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				
				// �U�Ǵ���Ū��ئW�٤έ��¯Z��
				if(!Utility.checkNull(tmp.get("CRSNO_CLASS"), "").equals("")){
					rptFile.add((String)tmp.get("CRSNO_CLASS"));
				}else{
					rptFile.add("&nbsp;");
				}
			}

			if (rptFile.size() == 0)
			{
				out.println("<script>top.close();alert(\"�L�ŦX��ƥi�ѦC�L!!\");</script>");
				return;
			}

			/** ��l�Ƴ����� */
			report		report_	=	new report(dbManager, conn, out, "scd215r_01r2", report.onlineHtmlMode);

			/** �R�A�ܼƳB�z */
			Hashtable	ht	=	new Hashtable();
						if(!Utility.checkNull(AYEAR, "").equals("")){
				if(AYEAR.trim().length() != 0)
					ht.put("���Y_1", TITLE_ASYS_NAME+"&nbsp;&nbsp;&nbsp;&nbsp;"+AYEAR);
				else
					ht.put("���Y_1","&nbsp;");
			}else{
				ht.put("���Y_1","&nbsp;");
			}
			
			String COND = "�Ťj�U���߲Ĥ@�W";						
			if("1".equals(Utility.dbStr(requestMap.get("ASYS")))){
				COND = "(�j�ǳ�)";
				}else{
				COND = "(�M�쳡)";
				}
			
			if(!Utility.checkNull(SMS_NAME, "").equals("")){
				String TITLE = "�U�ǲ߫��ɤ��߲�1�W�W�U";
				if(SMS_NAME.trim().length() != 0)
					ht.put("���Y_2", SMS_NAME+TITLE+COND ) ;
				else
					ht.put("���Y_2","&nbsp;");
			}else{
				ht.put("���Y_2","&nbsp;");
			}
// 			if(!Utility.checkNull(AYEAR, "").equals("")){
// 				ht.put("���Y_3","&nbsp;");
// 			}else{
// 				ht.put("���Y_3","&nbsp;");
// 			}
			if(!Utility.checkNull(AYEAR, "").equals("")){
				ht.put("���Y_4",inputAyear + nextSmsNM + "��פ���ئW�٤έ��¯Z��");
			}else{
				ht.put("���Y_4","&nbsp;");
			}
			report_.setDynamicVariable(ht);

			/** �}�l�C�L */
			report_.genReport(rptFile);
		}else{
			input.put("RANK", "1");
			
			/** ���o DBResult */
			Vector	result	=	 SCDT021.getDataForScd215r(input);
			/** ��l�� rptFile */
			RptFile		rptFile	=	new RptFile(session.getId());
			//rptFile.setColumn("���Y_3,���Y_4,��_1,��_2,��_3,��_4,��_5,��_6,��_7,��_8,��_9,��_10");
			rptFile.setColumn("���Y_3,���Y_4,��_1,��_2,��_3,��_4,��_5,��_6,��_7,��_8,��_9,��_10,��_11");

			while(!result.isEmpty())
			{
				tmp = (Hashtable)result.remove(0);
				if(AYEAR.equals("") && !Utility.checkNull(tmp.get("AYEAR"), "").equals(""))
				{
					if(((String)tmp.get("AYEAR")).trim().length() != 0)
						AYEAR = (String)tmp.get("AYEAR");
					else
						AYEAR = "";
				}
				if(SMS_NAME.equals("") && !Utility.checkNull(tmp.get("SMS_NAME"), "").equals(""))
				{
					if(((String)tmp.get("SMS_NAME")).trim().length() != 0)
						SMS_NAME = (String)tmp.get("SMS_NAME");
					else
						SMS_NAME = "";
				}	
				
				if("3".equals(KIND)){
					rptFile.add("�����ǲ߫��ɤ���&nbsp;");
					rptFile.add("&nbsp;");
				}else{
					if(!Utility.checkNull(tmp.get("CENTER_NAME"), "").equals("")){
						if(((String)tmp.get("CENTER_NAME")).trim().length() != 0){
							rptFile.add((String)tmp.get("CENTER_NAME"));
							rptFile.add((String)tmp.get("CENTER_NAME"));
						}else{
							rptFile.add("&nbsp;");
							rptFile.add("&nbsp;");
						}	
					}else{
						rptFile.add("&nbsp;");
						rptFile.add("&nbsp;");
					}
				}
				
				//bypoto
				rptFile.add((String)tmp.get("CRS_NAME"));
				if(!Utility.checkNull(tmp.get("STNO"), "").equals("")){
					if(((String)tmp.get("STNO")).trim().length() != 0)
						rptFile.add((String)tmp.get("STNO"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("NAME"), "").equals("")){
					if(((String)tmp.get("NAME")).trim().length() != 0)
						rptFile.add((String)tmp.get("NAME"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("SEX"), "").equals("")){
					if(((String)tmp.get("SEX")).trim().length() != 0)
						rptFile.add((String)tmp.get("SEX"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("CRSNO_SMSGPA"), "").equals("")){
					if(((String)tmp.get("CRSNO_SMSGPA")).trim().length() != 0)
					{
						if(((String)tmp.get("CRSNO_SMSGPA")).indexOf(".") == -1)
						{
							rptFile.add(((String)tmp.get("CRSNO_SMSGPA")) + ".00");
						}else if(((String)tmp.get("CRSNO_SMSGPA")).length() - ((String)tmp.get("CRSNO_SMSGPA")).indexOf(".") == 2)
							rptFile.add(((String)tmp.get("CRSNO_SMSGPA")) + "0");
						else
							rptFile.add(((String)tmp.get("CRSNO_SMSGPA")));
					}
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("MOBILE"), "").equals("")){
					if(((String)tmp.get("MOBILE")).trim().length() != 0)
						rptFile.add((String)tmp.get("MOBILE"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("TEL_HOME"), "").equals("")){
					if(((String)tmp.get("TEL_HOME")).trim().length() != 0)
						rptFile.add((String)tmp.get("TEL_HOME"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("CRRSADDR"), "").equals("")){
					if(((String)tmp.get("CRRSADDR")).trim().length() != 0)
						rptFile.add((String)tmp.get("CRRSADDR"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				if(!Utility.checkNull(tmp.get("RANK"), "").equals("")){
					if(((String)tmp.get("RANK")).trim().length() != 0)
						rptFile.add((String)tmp.get("RANK"));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				
				/* 2028/8/21 �����X�ͤ��BIRTHDATE�A��אּ�Ҹ�AWARD_NO*/
				if(!Utility.checkNull(tmp.get("AWARD_NO"), "").equals("")){
					if(((String)tmp.get("AWARD_NO")).trim().length() != 0)
						rptFile.add(DateUtil.formatDate((String)tmp.get("AWARD_NO")));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				
				// �U�Ǵ���Ū��إN�X�έ��¯Z��
				if(!Utility.checkNull(tmp.get("CRSNO_CLASS"), "").equals("")){
					rptFile.add((String)tmp.get("CRSNO_CLASS"));
				}else{
					rptFile.add("&nbsp;");
				}
			}

			if (rptFile.size() == 0)
			{
				out.println("<script>top.close();alert(\"�L�ŦX��ƥi�ѦC�L!!\");</script>");
				return;
			}

			/** ��l�Ƴ����� */
			report		report_	=	new report(dbManager, conn, out, "scd215r_01r3", report.onlineHtmlMode);

			/** �R�A�ܼƳB�z */
			Hashtable	ht	=	new Hashtable();
			if(!Utility.checkNull(AYEAR, "").equals("")){
				if(AYEAR.trim().length() != 0)
					ht.put("���Y_1", TITLE_ASYS_NAME+"&nbsp;&nbsp;&nbsp;&nbsp;"+AYEAR);
				else
					ht.put("���Y_1","&nbsp;");
			}else{
				ht.put("���Y_1","&nbsp;");
			}
			if(!Utility.checkNull(SMS_NAME, "").equals("")){
				String TITLE = "";
				if("3".equals(KIND)){
					TITLE = "���զU��Ĥ@�W";
				}else if("4".equals(KIND)){
					TITLE = "�U���ߦU���1�W�W�U(�j�ǳ��B�M�쳡�֭p)";
				}

				if(SMS_NAME.trim().length() != 0)
					ht.put("���Y_2", SMS_NAME+TITLE );
				else
					ht.put("���Y_2","&nbsp;");
			}else{
				ht.put("���Y_2","&nbsp;");
			}
			if(!Utility.checkNull(AYEAR, "").equals("")){
				ht.put("���Y_5",inputAyear + nextSmsNM + "��פ���ئW�٤έ��¯Z��");
			}else{
				ht.put("���Y_5","&nbsp;");
			}
			report_.setDynamicVariable(ht);

			/** �}�l�C�L */
			report_.genReport(rptFile);
		}
	}
		catch (Exception ex)
	{
		throw ex;
	}
	finally
	{
		dbManager.close();
	}
}
%>