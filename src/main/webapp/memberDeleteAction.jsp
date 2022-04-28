<%@page import="user.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.User" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/bootstrap.css">
<title>게시판 웹사이트</title>
</head>
<body>
<%
		// 현재 세션 상태를 체크한다
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		// 로그인을 한 사람만 글을 쓸 수 있도록 코드를 수정한다
		if(userID == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요')");
			script.println("location.href='login.jsp'");
			script.println("</script>");
		}
		
		userID = "";
		if(request.getParameter("userID") != null){
			userID = request.getParameter("userID");
		}
		if(userID == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 회원입니다')");
			script.println("location.href='member.jsp'");
			script.println("</script>");
		}
		//해당 'userID'에 대한 회원정보를 가져온 다음 세션을 통하여 본인이 맞는지 체크한다
		User user = new UserDAO().getUser(userID);
		if(!userID.equals(user.getUserID())){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다')");
			script.println("location.href='member.jsp'");
			script.println("</script>");
		} else{
			// 글 삭제 로직을 수행한다
			UserDAO userDAO = new UserDAO();
			int result = userDAO.delete(userID);
			// 데이터베이스 오류인 경우
			if(result == -1){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('회원정보 삭제에 실패했습니다')");
				script.println("history.back()");
				script.println("</script>");
			// 글 삭제가 정상적으로 실행되면 알림창을 띄우고 게시판 메인으로 이동한다
			}else {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('회원정보 삭제하기 성공')");
				script.println("location.href='bbs.jsp'");
				script.println("</script>");
			}
		}
	
	%>
	<%-- <% 
		// 현재 세션 상태를 체크한다
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		// 관리자 계정이 아니면 경고메세지
		if(userID == "admin"){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('관리자가 아닙니다')");
			script.println("location.href='login.jsp'");
			script.println("</script>");
		}
		
		userID = null;
		if(request.getParameter("userID") != null){
			userID = request.getParameter("userID");
		}
		// 만약 넘어온 데이터가 없다면
		if(userID == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 회원입니다')");
			script.println("location.href='bbs.jsp'");
			script.println("</script>");
			
		//해당 'bbsID'에 대한 게시글을 가져온 다음 세션을 통하여 작성자 본인이 맞는지 체크한다
		User user = new UserDAO().getList(userID);
		if(!userID.equals("admin")){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다')");
			script.println("location.href='bbs.jsp'");
			script.println("</script>");
		} else{
			// 글 삭제 로직을 수행한다
			UserDAO userDAO = new UserDAO();
			int result = userDAO.delete(userID);
			// 데이터베이스 오류인 경우
			if(result == -1){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('회원정보 삭제를 실패했습니다')");
				script.println("history.back()");
				script.println("</script>");
			// 글 삭제가 정상적으로 실행되면 알림창을 띄우고 게시판 메인으로 이동한다
			}else {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('회원정보 삭제하기 성공')");
				script.println("location.href='bbs.jsp'");
				script.println("</script>");
			}
		}
	
	%> --%>
	<!-- 부트스트랩 참조 영역 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>