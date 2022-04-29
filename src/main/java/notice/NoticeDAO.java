package notice;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class NoticeDAO {

	private Connection conn;
	private ResultSet rs;

	public NoticeDAO() {
		try {
			String driverName = "oracle.jdbc.driver.OracleDriver";
			String dbURL = "jdbc:oracle:thin:@localhost:1521:xe";
			String dbID = "c##test";
			String dbPassword = "test";
			Class.forName(driverName);
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
//			System.out.println("DB연결 성공");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 작성일자 메소드
	public String getDate() {
		String sql = "select (to_char(sysdate,'yyyy.mm.dd hh24:mi')) from dual";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; // 데이터베이스 오류
	}

	// 게시글 번호 부여 메소드
	public int getNext() {
		// 현재 게시글을 내림차순으로 조회하여 가장 마지막 글의 번호를 구한다
		String sql = "select noticeID from notice order by noticeID desc";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // 첫 번째 게시물인 경우
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}

	// 글쓰기 메소드
	public int write(String noticeTitle, String userID, String noticeContent) {
		String sql = "insert into notice values(?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, noticeTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, noticeContent);
			pstmt.setInt(6, 1); // 글의 유효번호
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}

	// 게시글 리스트 메소드
	public ArrayList<Notice> getList(int pageNumber) {
		String sql = "select * from notice where noticeID < ? and noticeAvailable = 1 and rownum <=10 order by noticeID desc";
		ArrayList<Notice> list = new ArrayList<Notice>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Notice notice = new Notice();
				notice.setNoticeID(rs.getInt(1));
				notice.setNoticeTitle(rs.getString(2));
				notice.setUserID(rs.getString(3));
				notice.setNoticeDate(rs.getString(4));
				notice.setNoticeContent(rs.getString(5));
				notice.setNoticeAvailable(rs.getInt(6));
				list.add(notice);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// 페이징 처리 메소드
	public boolean nextPage(int pageNumber) {
		String sql = "select * from notice where noticeID < ? and noticeAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	// 하나의 게시글을 보는 메소드
	public Notice getNotice(int noticeID) {
		String sql = "select * from notice where noticeID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, noticeID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Notice notice = new Notice();
				notice.setNoticeID(rs.getInt(1));
				notice.setNoticeTitle(rs.getString(2));
				notice.setUserID(rs.getString(3));
				notice.setNoticeDate(rs.getString(4));
				notice.setNoticeContent(rs.getString(5));
				notice.setNoticeAvailable(rs.getInt(6));
				return notice;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	// 게시글 수정 메소드
	public int update(int noticeID, String noticeTitle, String noticeContent) {
		String sql = "update notice set noticeTitle = ?, noticeContent = ? where noticeID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, noticeTitle);
			pstmt.setString(2, noticeContent);
			pstmt.setInt(3, noticeID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}

	// 게시글 삭제 메소드
	public int delete(int noticeID) {
		// 실제 데이터를 삭제하는 것이 아니라 게시글 유효숫자를 '0'으로 수정한다
		String sql = "update notice set noticeAvailable = 0 where noticeID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, noticeID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
}
