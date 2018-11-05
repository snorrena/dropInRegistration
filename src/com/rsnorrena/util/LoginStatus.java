package com.rsnorrena.util;

public class LoginStatus {
	
	public static String LOGIN_STATUS = null;
	
	public static String getLoginStatus(){
		return LOGIN_STATUS;
	}
	
	public static void setLoginStatus(String msg){
		LOGIN_STATUS = msg;
	}
	
}
