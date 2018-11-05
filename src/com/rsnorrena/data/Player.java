/**
 * Project: TestLogin
 * File: Player.java
 * Date: Jun 27, 2017
 * Time: 10:39:28 PM
 */

package com.rsnorrena.data;

import java.util.Comparator;

/**
 * @author Robert Scott Norrena, A00835056
 *
 */

public class Player implements Comparable<Player>{

	String firstName;
	String lastName;
	String password;
	String emailAddress;
	boolean isRegistered;
	String position;
	String status;
	int index;

	public Player(String firstName, String lastName, String password, String emailAddress, boolean isRegistered, String position, String status, int index) {
		super();
		this.firstName = firstName;
		this.lastName = lastName;
		this.password = password;
		this.emailAddress = emailAddress;
		this.isRegistered = isRegistered;
		this.position = position;
		this.status = status;
		this.index = index;
	}
	
	public Player(){
		this.firstName = "";
		this.lastName = "";
		this.password = "";
		this.emailAddress = "";
		this.isRegistered = false;
		this.position = "";
		this.status = "TBD";
		this.index = 0;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getEmailAddress() {
		return emailAddress;
	}

	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}

	public boolean isRegistered() {
		return isRegistered;
	}

	public void setRegistered(boolean isRegistered) {
		this.isRegistered = isRegistered;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public int getIndex() {
		return index;
	}
	
	public void setIndex(int index){
		this.index = index;
	}

	@Override
	public int compareTo(Player arg0) {
		return this.firstName.compareTo(arg0.firstName);
	}
	
	/*Comparator for sorting the list by Student Name*/
    public static Comparator<Player> indexComparator = new Comparator<Player>() {

	public int compare(Player s1, Player s2) {


	   //ascending order
	   return s1.getIndex() - s2.getIndex();

	   //descending order
	   //return StudentName2.compareTo(StudentName1);
    }};

}
