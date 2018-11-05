package com.rsnorrena.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class DateOfNextGame {
	
	public static String date;
	public static int daysToNextGame;
	
	public DateOfNextGame(){
		//default constructor necessary for system to use a managed bean.
	}
	
	public static String getDateOfNextGame(){
		// collect the current date
					LocalDate nextHockeyDate = LocalDate.now();

					// pull the day of week from the current date.
					String dayOfWeek = nextHockeyDate.getDayOfWeek().name();
					
					daysToNextGame = 0;

					// use the day of week to calculate the date of the next hockey session
					switch (dayOfWeek) {

					case "MONDAY":
						nextHockeyDate = nextHockeyDate.plusDays(4);
						daysToNextGame = 4;
						break;
					case "TUESDAY":
						nextHockeyDate = nextHockeyDate.plusDays(3);
						daysToNextGame = 3;
						break;
					case "WEDNESDAY":
						nextHockeyDate = nextHockeyDate.plusDays(2);
						daysToNextGame = 2;
						break;
					case "THURSDAY":
						nextHockeyDate = nextHockeyDate.plusDays(1);
						daysToNextGame = 1;
						break;
					case "FRIDAY":
						// nextHockeyDate.plusDays(1);
						daysToNextGame = 0;
						break;
					case "SATURDAY":
						nextHockeyDate = nextHockeyDate.plusDays(6);
						daysToNextGame = 6;
						break;
					case "SUNDAY":
						nextHockeyDate = nextHockeyDate.plusDays(5);
						daysToNextGame = 5;
						break;

					}

					//format the date string before forwarding the the welcome screen
					DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE MMMM dd, yyyy");
					String date = nextHockeyDate.format(formatter);
					
					return date;

	}
	
	public static int getNumberOfDaysToNextGame(){
		return daysToNextGame;
	}

}
