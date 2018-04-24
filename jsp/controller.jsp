<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@	page import="com.baidu.ueditor.ActionEnter"%>
<%@ page pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ page import="com.founder.newsedit.ueditor.MainActionEnter"%>
<%
	request.setCharacterEncoding("utf-8");
	response.setHeader("Content-Type", "text/html");

	String rootPath = application.getRealPath("/");

	//out.write(new ActionEnter(request, rootPath).exec());

	out.write(new MainActionEnter(request, rootPath).exec());
%>