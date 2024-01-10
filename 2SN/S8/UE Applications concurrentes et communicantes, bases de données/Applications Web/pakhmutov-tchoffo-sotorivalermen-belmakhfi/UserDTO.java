package model;

import java.sql.Date;

public class UserDTO {
	
	String firstName;
	
	String lastName;
	
	String email;
	
	String birthDateString;
	
	Date birthDate;

	public UserDTO(String firstName, String lastName, String email, String birthDateString, Date birthDate) {
		super();
		this.firstName = firstName;
		this.lastName = lastName;
		this.email = email;
		this.birthDateString = birthDateString;
		this.birthDate = birthDate;
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

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getBirthDateString() {
		return birthDateString;
	}

	public void setBirthDateString(String birthDateString) {
		this.birthDateString = birthDateString;
	}

	public Date getBirthDate() {
		return birthDate;
	}

	public void setBirthDate(Date birthDate) {
		this.birthDate = birthDate;
	}
	
	
}