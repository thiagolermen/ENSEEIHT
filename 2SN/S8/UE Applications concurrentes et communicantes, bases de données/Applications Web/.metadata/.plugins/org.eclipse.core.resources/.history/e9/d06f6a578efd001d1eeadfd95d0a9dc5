package model;

import java.sql.Date;

import javax.persistence.*;

@Entity
@Table(name = "passengers")
public class Passenger {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	int passengerId;
	
	@ManyToOne
	Flight flight;
	
	@OneToOne
	Ticket ticket;
	
	private String firstName;
	private String lastName;
	private String birthDateString;
	private Date birthDate;
	private String passportNumber;
	
	public Passenger(String firstName, String lastName, String birthDateString, String passportNumber) {
		this.firstName = firstName;
		this.lastName = lastName;
		this.passportNumber = passportNumber;
	}
	public Passenger() {
		super();
	}
	public int getPassengerId() {
		return passengerId;
	}
	public void setPassengerId(int passengerId) {
		this.passengerId = passengerId;
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
	public String getPassportNumber() {
		return passportNumber;
	}
	public void setPassportNumber(String passportNumber) {
		this.passportNumber = passportNumber;
	}
	public Flight getFlight() {
		return flight;
	}
	public void setFlight(Flight flight) {
		this.flight = flight;
	}
	public Ticket getTicket() {
		return ticket;
	}
	public void setTicket(Ticket ticket) {
		this.ticket = ticket;
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
