package com.rsnorrena.database;

import java.io.File;
import java.net.URL;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import org.apache.log4j.Logger;

import com.rsnorrena.data.Player;

public class CRUD {
	
	static Logger log = Logger.getLogger(CRUD.class);
	
	//Declare the sqlite connect to be static to insure that there is only one connection
	private static Connection conn;

	public static Connection dbConnection() {
		try {
			if (conn == null || conn.isClosed()) {
				
//				File f = new File("myFile.txt");
//				System.out.println(f.getAbsolutePath());
//				
				Class.forName("org.sqlite.JDBC");
				
				String jdbc = "jdbc:sqlite:";
				//path for database file access on my dev machines
//				String path = "C:\\Github\\Java\\JavaEE\\2019-03\\program_archive\\DropInRegistration\\";
				//path for docker container
				String path = "//home/dropInRegistration/";
				
				String fileName = "PlayerInfo.db";

				String url = jdbc + path + fileName;
//				String url = "jdbc:sqlite:${catalina.base}\\webapps\\DropInRegistration\\WEB-INF\\classes\\PlayerInfo.db";
				
				conn = DriverManager.getConnection(url);
//				conn = DriverManager.getConnection("jdbc:sqlite:PlayerInfo.db");
				
				//String url = "jdbc:sqlite:C:/Dropbox/Development/Eclipse_Neon/Java/Work/WebApps/workspace/TestLogin/PlayerInfo.db";
//				conn = DriverManager.getConnection(url);
			}
			return conn;
		} catch (Exception e) {
			
			return null;
		}

	}
	
	public static boolean updateRecord(String firstName, String lastName, String password, boolean isRegistered, String email,
			String playerPosition, String playerStatus, int index){
		
		log.info("updateRecord called");
		
		int reg = isRegistered ? 1 : 0;

		conn = null;
		

		PreparedStatement stm = null;
		

		String msql = "UPDATE playerlist SET firstname = ?, "
				+ "lastname = ?, password = ?, isregistered = ?, "
				+ "position = ?, status = ?, index_no = ? WHERE email = ?";
		
		conn = dbConnection();

		try {

			conn.setAutoCommit(false);
			stm = conn.prepareStatement(msql);
			stm.setString(1, firstName);
			stm.setString(2, lastName);
			stm.setString(3, password);
			stm.setInt(4, reg);
			stm.setString(5, playerPosition);
			stm.setString(6, playerStatus);
			stm.setInt(7, index);
			stm.setString(8, email);
			stm.executeUpdate();
			conn.commit();

		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			try {
				stm.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		return true;
	}

	public static void insertRecord(String firstName, String lastName, String password,
			boolean isRegistered, String email, String position, String status, int index) {
		
		log.info("insertRecord called");
		
		int reg = isRegistered ? 1 : 0;
		
		conn = null;
		PreparedStatement stm = null;
		
//		String sql = "INSERT INTO Employees VALUES (" + employeeId + ", '" + name + "', '" + surname + "', '" + userName + "','" + password + "', " + age + ")";

		String sql ="INSERT INTO playerlist "
				+ "(firstname, lastname, password, isregistered, email, position, status, index_no) " 
				+ "VALUES (?,?,?,?,?,?,?,?)";
		
		conn = dbConnection();

		try {
			conn.setAutoCommit(false);
			stm = conn.prepareStatement(sql);
			stm.setString(1, firstName);
			stm.setString(2, lastName);
			stm.setString(3, password);
			stm.setInt(4, reg);
			stm.setString(5, email);
			stm.setString(6, position);
			stm.setString(7, status);
			stm.setInt(8, index);
			stm.executeUpdate();
			conn.commit();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			try {
				stm.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	public static Player getRecord(String email){
		
		log.info("getRecord called");
		
		conn = null;
		
		Statement stm = null;
		ResultSet rs = null;
		
		Player currentPlayer = new Player();
		
		//Here we check the value if the player email exists in the database. 
//		if (!playerCheck(email)){
			
			
			String query = "SELECT * FROM playerlist WHERE email = '" + email + "'";
			
			conn = dbConnection();

				try {
					stm = conn.createStatement();
					rs = stm.executeQuery(query);
								
					currentPlayer.setFirstName(rs.getString("firstname"));
					currentPlayer.setLastName(rs.getString("lastname"));
					currentPlayer.setPassword(rs.getString("password"));
					currentPlayer.setEmailAddress(rs.getString("email"));
					currentPlayer.setRegistered((rs.getInt("isregistered"))== 1 ? true : false);
					currentPlayer.setPosition(rs.getString("position"));
					currentPlayer.setStatus(rs.getString("status"));
					currentPlayer.setIndex(rs.getInt("index_no"));
					
								
				} catch (SQLException e) {
					e.printStackTrace();
				}finally{
					try {
						stm.close();
						rs.close();
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
		
		return currentPlayer;
	}

	public static int getRegisteredCount() {
		
		log.info("getRegisteredCount called");
		
		conn = null;
		int registeredCount = 0;
		
		Statement stm = null;
		ResultSet rs = null;
		
		try {
			/**
			 * Get a connection to the sqlite database and create a statement
			 */
			conn = dbConnection();
			stm = conn.createStatement();
			// Send a sql query to the dastabase and return a result set.
			rs = stm.executeQuery("SELECT * FROM Players WHERE isregistered = 'true'");
			while (rs.next()) {
				++registeredCount;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			try{
				stm.close();
				rs.close();
				conn.close();
			}catch (Exception e){
				e.printStackTrace();
			}
		}
		return registeredCount;
	}

	public static int login(String userName, String passWord) {
		
		log.info("login called");
		
		conn = null;
		String query = "select * from playerlist where email = ? and password = ?";
		int count = 0;
		PreparedStatement pst = null;
		ResultSet rs = null;

		try {
			conn = dbConnection();
			pst = conn.prepareStatement(query);
			pst.setString(1, userName);
			pst.setString(2, passWord);

			rs = pst.executeQuery();
			while (rs.next()) {
				count = count + 1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			try {
				rs.close();
				pst.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return count;
	}

	public static boolean playerCheck(String email) {
		
		log.info("playerCheck called");

		conn = null;
		
		Statement stm = null;
		ResultSet rs = null;
		
		boolean emailExistsInDB = true;
		
		String sql = "SELECT * FROM playerlist WHERE Email = " + "'" + email + "'";
		
		conn = dbConnection();
		
		try {
			stm = conn.createStatement();
			rs = stm.executeQuery(sql);

					if (!rs.next() ) {    
					    emailExistsInDB = false;
					} 
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			try {
				rs.close();
				stm.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
		}
		
		
		
		return emailExistsInDB;
	}

	public static boolean deleteRecord(String email) {
		
		log.info("deleteRecord called");
		
		boolean recordDeleted = false;
		conn = null;
		Statement stm = null;
		String sql = "DELETE FROM playerlist WHERE email = " + "'" + email + "'";
		
		conn = dbConnection();
		try {
			conn.setAutoCommit(false);
			stm = conn.createStatement();
			stm.executeUpdate(sql);
			conn.commit();
			recordDeleted = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			try {
				stm.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return recordDeleted;
	}
	
public static ArrayList<Player> getAllPlayers(){
	
	log.info("getAllPlayers called");
		
		conn = null;
		
		Statement stm = null;
		ResultSet rs = null;
		
		ArrayList<Player> allPlayers = new ArrayList<Player>();
		
			String query = "SELECT * FROM playerlist";
			
			conn = dbConnection();
			
				try {
					stm = conn.createStatement();
					rs = stm.executeQuery(query);
					
					while (rs.next()){
						
							
							Player currentPlayer = new Player();
							
							currentPlayer.setFirstName(rs.getString("firstname"));
							currentPlayer.setLastName(rs.getString("lastname"));
							currentPlayer.setPassword(rs.getString("password"));
							currentPlayer.setRegistered((rs.getInt("isregistered"))== 1 ? true : false);
							currentPlayer.setEmailAddress(rs.getString("email"));
							currentPlayer.setPosition(rs.getString("position"));
							currentPlayer.setStatus(rs.getString("status"));
							currentPlayer.setIndex(rs.getInt("index_no"));
							
							allPlayers.add(currentPlayer);
							
						}
						
								
								
				} catch (SQLException e) {
					e.printStackTrace();
				}finally{
					try {
						stm.close();
						rs.close();
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
		
		return allPlayers;
	}

public static boolean updateRegistration(String email, boolean isRegistered, String status, int index){
	
	log.info("updatRegistration called");
	
	int reg = isRegistered ? 1 : 0;

	conn = null;
	
	PreparedStatement stm = null;
	
	String msql = "UPDATE playerlist SET isregistered = ?, status = ?, index_no = ? WHERE email = ?";
	
	conn = dbConnection();

	try {

		conn.setAutoCommit(false);
		stm = conn.prepareStatement(msql);
		stm.setInt(1, reg);
		stm.setString(2, status);
		stm.setInt(3, index);
		stm.setString(4, email);
		stm.executeUpdate();
		conn.commit();

	} catch (SQLException e) {
		e.printStackTrace();
	}finally{
		try {
			stm.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	return true;
}


}
