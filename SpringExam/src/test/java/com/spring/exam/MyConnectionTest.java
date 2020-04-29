package com.spring.exam;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class MyConnectionTest {
	protected final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	private static String Driver = "com.mysql.jdbc.Driver";
	private static String Url = "jdbc:mysql://127.0.0.1:3306/board?allowPublicKeyRetrieval=true&useSSL=false";
	private static String UserName = "SpringExam";
	private static String Password = "tops2006";
	
	@Test
	public void getMySqlConnectionTest() {
		Connection conn = null;
		Statement stmt = null;
		
		logger.info("================= MySQL Connection START =================");
		
		try {
			Class.forName(Driver);
			
			conn = DriverManager.getConnection(Url, UserName, Password);
			stmt = conn.createStatement();
			
			String sql = "SELECT * FROM TB_BOARD";
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				
				String boardSubject = rs.getString("BOARD_SUBJECT");
				String boardContent = rs.getString("BOARD_CONTENT");
				String boardWriter = rs.getString("BOARD_WRITER");
				
				logger.info("BOARD_SUBJECT : " + boardSubject);
				logger.info("BOARD_CONTENT : " + boardContent);
				logger.info("BOARD_WRITER : " + boardWriter);
			}
		}
		catch(SQLException se) {
			se.printStackTrace();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			try {
				if(stmt != null) {
					stmt.close();
				}
			}
			catch(SQLException e) {
				e.printStackTrace();
			}
			
			try {
				if(conn != null) {
					conn.close();
				}
			}
			catch(SQLException e) {
				e.printStackTrace();
			}
		}
		
		logger.info("================= MySQL Connection END =================");
	}
}
