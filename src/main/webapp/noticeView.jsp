<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="notice.Notice" %>
<%@ page import="notice.NoticeDAO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
	#btn {
		text-align: center;
	} 
</style>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/bootstrap.css">
<title>게시판 웹사이트</title>
</head>
<body>
	<%
		// 메인 페이지로 이동했을 때 세션에 값이 담겨있는지 체크
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		
		// bbsID를 초기화 시키고
		// 'bbsID'라는 데이터가 넘어온 것이 존재한다면 캐스팅을 하여 변수에 담는다
		int noticeID = 0;
		if(request.getParameter("noticeID") != null){
			noticeID = Integer.parseInt(request.getParameter("noticeID"));
		}
		
		// 만약 넘어온 데이터가 없다면
		if(noticeID == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다')");
			script.println("location.href='notice.jsp'");
			script.println("</script");
		}
		
		// 유효한 글이라면 구체적인 정보를 'bbs'라는 인스턴스에 담는다
		Notice notice = new NoticeDAO().getNotice(noticeID);
	%>
	<nav class="navbar navbar-default"> <!-- 네비게이션 -->
		<div class="navbar-header"> 	<!-- 네비게이션 상단 부분 -->
			<!-- 네비게이션 상단 박스 영역 -->
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<!-- 이 삼줄 버튼은 화면이 좁아지면 우측에 나타난다 -->
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<!-- 상단 바에 제목이 나타나고 클릭하면 main 페이지로 이동한다 -->
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<!-- 게시판 제목 이름 옆에 나타나는 메뉴 영역 -->
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class="active"><a href="notice.jsp">공지사항</a></li>
				<li><a href="bbs.jsp">게시판</a></li>
			</ul>
			<%
				// 로그인 하지 않았을 때 보여지는 화면
				if(userID == null){
			%>
			<!-- 헤더 우측에 나타나는 드랍다운 영역 -->
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<!-- 드랍다운 아이템 영역 -->	
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%
				// 로그인이 되어 있는 상태에서 보여주는 화면
				}else{
			%>
			<!-- 헤더 우측에 나타나는 드랍다운 영역 -->
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<!-- 드랍다운 아이템 영역 -->	
					<ul class="dropdown-menu">
						<li><a href="#">내정보</a></li>
						<%
						if (userID != null && userID.equals("admin")) {
						%>
						<li><a href="member.jsp">회원목록</a></li>
						<%
						}
						%>
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
			<%
			User user = new UserDAO().getUser(userID);
			%>
			<li><a><%=user.getUserID()%> 님</a></li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>
	<!-- 네비게이션 영역 끝 -->
	
	<!-- 게시판 글 보기 양식 영역 시작 -->
	<div class="container">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="2" style="background-color: #eeeeee; text-align: center;">공지사항 보기</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 20%;">공지 제목</td>
						<td colspan="2"><%= notice.getNoticeTitle().replaceAll(" ", "&nbsp;")
								.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="2"><%= notice.getUserID() %></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colspan="2"><%= notice.getNoticeDate().substring(0, 11) + notice.getNoticeDate().substring(11, 13) + "시"
								+ notice.getNoticeDate().substring(14, 16) + "분" %></td>
					</tr>
					<tr>
						<td>공지 내용</td>
						<td colspan="2" style="height: 200px; text-align: left;"><%= notice.getNoticeContent().replaceAll(" ", "&nbsp;")
							.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
					</tr>
				</tbody>
			</table>
			<div id="btn">
				<a href="notice.jsp" class="btn btn-primary">목록</a>
				
				<!-- 해당 글의 작성자가 본인이라면 수정과 삭제가 가능하도록 코드 추가 -->
				<%
					if(userID != null && (userID.equals(notice.getUserID()) || userID.equals("admin"))){
				%>
						<a href="noticeUpdate.jsp?noticeID=<%= noticeID %>" class="btn btn-primary">수정</a>
						<a onclick="return confirm('정말로 삭제하시겠습니까?')" href=
						"noticeDeleteAction.jsp?noticeID=<%= noticeID %>" class="btn btn-primary">삭제</a>
				<%
					}
				%>
			</div>
		</div>
	</div>
	<!-- 부트스트랩 참조 영역 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>