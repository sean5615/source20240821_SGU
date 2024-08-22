<%/*
----------------------------------------------------------------------------------
File Name		: scd215r_01m1.jsp
Author			: barry
Description		: 列印績優生獎狀名冊 - 處理邏輯頁面
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
/** 處理列印功能 */
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
				//TITLE_ASYS_NAME = "空大全校前二十名";
			}else if("2".equals(ASYS)){
				//TITLE_ASYS_NAME = "空大各中心第一名";
			}
		}else if("2".equals(ASYS)){
			if("1".equals(KIND)){
				//TITLE_ASYS_NAME = "空專全校前三名";
			}else if("2".equals(ASYS)){
				//TITLE_ASYS_NAME = "空專各中心第一名";
			}
		}else{
			//TITLE_ASYS_NAME = "空大空專各中心各科第一名";
		}
		
		// 取得傳入學年期的下一個學年期
		String inputAyear  = Utility.dbStr(requestMap.get("AYEAR"));
		String inputSms  = Utility.dbStr(requestMap.get("SMS"));
		String nextSmsNM  = "";
		if (inputSms.equals("2") || inputSms.equals("3")){
			inputAyear = String.valueOf( Integer.parseInt(inputAyear) + 1);
			inputSms = "1";
			nextSmsNM = "上";
		}else{
			inputSms = "2";
			nextSmsNM = "下";
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
			/** 取得 DBResult */
			Vector	result	=	 SCDT021.getDataForScd215r(input);
			/** 初始化 rptFile */
			RptFile		rptFile	=	new RptFile(session.getId());
			rptFile.setColumn("表身_1,表身_2,表身_3,表身_4,表身_5,表身_6,表身_7,表身_8,表身_9,表身_10,表身_11");
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
					String COND = "全校前20名";
					
					if("1".equals(Utility.dbStr(requestMap.get("ASYS")))){
						COND = "全校前20名名冊(大學部)";
					}else{
						COND = "全校前3名名冊(專科部)";
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
						rptFile.add("　");
				}else{
					rptFile.add("　");
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
				
				/* 2028/8/21 移除出生日期BIRTHDATE，更改為證號AWARD_NO*/
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
						rptFile.add("　");
				}else{
					rptFile.add("　");
				}
				
				// 下學期修讀科目代碼及面授班級
				if(!Utility.checkNull(tmp.get("CRSNO_CLASS"), "").equals("")){
					rptFile.add((String)tmp.get("CRSNO_CLASS"));
				}else{
					rptFile.add("&nbsp;");
				}
			}

			if (rptFile.size() == 0)
			{
				out.println("<script>top.close();alert(\"無符合資料可供列印!!\");</script>");
				return;
			}

			/** 初始化報表物件 */
			report		report_	=	new report(dbManager, conn, out, "scd215r_01r1", report.onlineHtmlMode);

			/** 靜態變數處理 */
			Hashtable	ht	=	new Hashtable();
			if(!Utility.checkNull(AYEAR, "").equals("")){
				if(AYEAR.trim().length() != 0)
					ht.put("表頭_1", TITLE_ASYS_NAME+"&nbsp;&nbsp;&nbsp;&nbsp;"+AYEAR);
				else
					ht.put("表頭_1","&nbsp;");
			}else{
				ht.put("表頭_1","&nbsp;");
			}
			if(!Utility.checkNull(SMS_NAME, "").equals("")){
				if(SMS_NAME.trim().length() != 0)
					ht.put("表頭_2", SMS_NAME);
				else
					ht.put("表頭_2","&nbsp;");
			}else{
				ht.put("表頭_2","&nbsp;");
			}
			if(!Utility.checkNull(AYEAR, "").equals("")){
				ht.put("表頭_3",inputAyear + nextSmsNM + "選修之科目名稱及面授班級");
			}else{
				ht.put("表頭_3","&nbsp;");
			}
			report_.setDynamicVariable(ht);

			/** 開始列印 */
			report_.genReport(rptFile);
		}else if(KIND.equals("2")){
			input.put("RANK", "1");			
			/** 取得 DBResult */
			Vector	result	=	 SCDT021.getDataForScd215r(input);
			/** 初始化 rptFile */
			RptFile		rptFile	=	new RptFile(session.getId());
			rptFile.setColumn("表頭_3,表身_1,表身_2,表身_3,表身_4,表身_5,表身_6,表身_7,表身_8,表身_9,表身_10");

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
				/* 2028/8/21 移除出生日期BIRTHDATE，更改為證號AWARD_NO*/
				if(!Utility.checkNull(tmp.get("AWARD_NO"), "").equals("")){
					if(((String)tmp.get("AWARD_NO")).trim().length() != 0)
						rptFile.add(DateUtil.formatDate((String)tmp.get("AWARD_NO")));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				
				// 下學期修讀科目名稱及面授班級
				if(!Utility.checkNull(tmp.get("CRSNO_CLASS"), "").equals("")){
					rptFile.add((String)tmp.get("CRSNO_CLASS"));
				}else{
					rptFile.add("&nbsp;");
				}
			}

			if (rptFile.size() == 0)
			{
				out.println("<script>top.close();alert(\"無符合資料可供列印!!\");</script>");
				return;
			}

			/** 初始化報表物件 */
			report		report_	=	new report(dbManager, conn, out, "scd215r_01r2", report.onlineHtmlMode);

			/** 靜態變數處理 */
			Hashtable	ht	=	new Hashtable();
						if(!Utility.checkNull(AYEAR, "").equals("")){
				if(AYEAR.trim().length() != 0)
					ht.put("表頭_1", TITLE_ASYS_NAME+"&nbsp;&nbsp;&nbsp;&nbsp;"+AYEAR);
				else
					ht.put("表頭_1","&nbsp;");
			}else{
				ht.put("表頭_1","&nbsp;");
			}
			
			String COND = "空大各中心第一名";						
			if("1".equals(Utility.dbStr(requestMap.get("ASYS")))){
				COND = "(大學部)";
				}else{
				COND = "(專科部)";
				}
			
			if(!Utility.checkNull(SMS_NAME, "").equals("")){
				String TITLE = "各學習指導中心第1名名冊";
				if(SMS_NAME.trim().length() != 0)
					ht.put("表頭_2", SMS_NAME+TITLE+COND ) ;
				else
					ht.put("表頭_2","&nbsp;");
			}else{
				ht.put("表頭_2","&nbsp;");
			}
// 			if(!Utility.checkNull(AYEAR, "").equals("")){
// 				ht.put("表頭_3","&nbsp;");
// 			}else{
// 				ht.put("表頭_3","&nbsp;");
// 			}
			if(!Utility.checkNull(AYEAR, "").equals("")){
				ht.put("表頭_4",inputAyear + nextSmsNM + "選修之科目名稱及面授班級");
			}else{
				ht.put("表頭_4","&nbsp;");
			}
			report_.setDynamicVariable(ht);

			/** 開始列印 */
			report_.genReport(rptFile);
		}else{
			input.put("RANK", "1");
			
			/** 取得 DBResult */
			Vector	result	=	 SCDT021.getDataForScd215r(input);
			/** 初始化 rptFile */
			RptFile		rptFile	=	new RptFile(session.getId());
			//rptFile.setColumn("表頭_3,表頭_4,表身_1,表身_2,表身_3,表身_4,表身_5,表身_6,表身_7,表身_8,表身_9,表身_10");
			rptFile.setColumn("表頭_3,表頭_4,表身_1,表身_2,表身_3,表身_4,表身_5,表身_6,表身_7,表身_8,表身_9,表身_10,表身_11");

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
					rptFile.add("全部學習指導中心&nbsp;");
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
				
				/* 2028/8/21 移除出生日期BIRTHDATE，更改為證號AWARD_NO*/
				if(!Utility.checkNull(tmp.get("AWARD_NO"), "").equals("")){
					if(((String)tmp.get("AWARD_NO")).trim().length() != 0)
						rptFile.add(DateUtil.formatDate((String)tmp.get("AWARD_NO")));
					else
						rptFile.add("&nbsp;");
				}else{
					rptFile.add("&nbsp;");
				}
				
				// 下學期修讀科目代碼及面授班級
				if(!Utility.checkNull(tmp.get("CRSNO_CLASS"), "").equals("")){
					rptFile.add((String)tmp.get("CRSNO_CLASS"));
				}else{
					rptFile.add("&nbsp;");
				}
			}

			if (rptFile.size() == 0)
			{
				out.println("<script>top.close();alert(\"無符合資料可供列印!!\");</script>");
				return;
			}

			/** 初始化報表物件 */
			report		report_	=	new report(dbManager, conn, out, "scd215r_01r3", report.onlineHtmlMode);

			/** 靜態變數處理 */
			Hashtable	ht	=	new Hashtable();
			if(!Utility.checkNull(AYEAR, "").equals("")){
				if(AYEAR.trim().length() != 0)
					ht.put("表頭_1", TITLE_ASYS_NAME+"&nbsp;&nbsp;&nbsp;&nbsp;"+AYEAR);
				else
					ht.put("表頭_1","&nbsp;");
			}else{
				ht.put("表頭_1","&nbsp;");
			}
			if(!Utility.checkNull(SMS_NAME, "").equals("")){
				String TITLE = "";
				if("3".equals(KIND)){
					TITLE = "全校各科第一名";
				}else if("4".equals(KIND)){
					TITLE = "各中心各科第1名名冊(大學部、專科部併計)";
				}

				if(SMS_NAME.trim().length() != 0)
					ht.put("表頭_2", SMS_NAME+TITLE );
				else
					ht.put("表頭_2","&nbsp;");
			}else{
				ht.put("表頭_2","&nbsp;");
			}
			if(!Utility.checkNull(AYEAR, "").equals("")){
				ht.put("表頭_5",inputAyear + nextSmsNM + "選修之科目名稱及面授班級");
			}else{
				ht.put("表頭_5","&nbsp;");
			}
			report_.setDynamicVariable(ht);

			/** 開始列印 */
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