package model;

import java.sql.Date;

import javax.persistence.*;

@Entity
@Table(name = "tickets")
public class Ticket {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	int ticketId;

	@ManyToOne
	Flight flight;
	@ManyToOne
	User user;
	
	String firstName;
	
	String lastName;
	
	String birthDateString;
	
	Date birthDate;
	
	String passportNumber;
	
	String seatNumber;
	
	float price;
	
	String mealType;

	boolean extraLuggage;
	
	boolean transportFromAirport;
	
	boolean paid = true;
	
	public Ticket(String firstName, String lastName, String birthDateString, Date birthDate, String passportNumber,
			String seatNumber, float price, String mealType, boolean extraLuggage, boolean transportFromAirport) {
		super();
		this.firstName = firstName;
		this.lastName = lastName;
		this.birthDateString = birthDateString;
		this.birthDate = birthDate;
		this.passportNumber = passportNumber;
		this.seatNumber = seatNumber;
		this.price = price;
		this.mealType = mealType;
		this.extraLuggage = extraLuggage;
		this.transportFromAirport = transportFromAirport;
	}

	public Ticket() {
		super();
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

	public String getPassportNumber() {
		return passportNumber;
	}

	public void setPassportNumber(String passportNumber) {
		this.passportNumber = passportNumber;
	}

	public String getSeatNumber() {
		return seatNumber;
	}

	public void setSeatNumber(String seatNumber) {
		this.seatNumber = seatNumber;
	}

	public float getPrice() {
		return price;
	}

	public void setPrice(float price) {
		this.price = price;
	}

	public int getTicketId() {
		return ticketId;
	}

	public void setTicketId(int ticketId) {
		this.ticketId = ticketId;
	}

	public Flight getFlight() {
		return flight;
	}

	public void setFlight(Flight flight) {
		this.flight = flight;
	}
	

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getMealType() {
		return mealType;
	}

	public void setMealType(String mealType) {
		this.mealType = mealType;
	}

	public boolean isExtraLuggage() {
		return extraLuggage;
	}

	public void setExtraLuggage(boolean extraLuggage) {
		this.extraLuggage = extraLuggage;
	}

	public boolean isTransportFromAirport() {
		return transportFromAirport;
	}

	public void setTransportFromAirport(boolean transportFromAirport) {
		this.transportFromAirport = transportFromAirport;
	}

	public boolean isPaid() {
		return paid;
	}

	public void setPaid(boolean paid) {
		this.paid = paid;
	}
	
	
	
	
}
