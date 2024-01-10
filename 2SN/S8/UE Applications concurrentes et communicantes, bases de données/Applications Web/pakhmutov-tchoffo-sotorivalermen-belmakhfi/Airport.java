package model;

import java.util.Collection;

import javax.persistence.*;

@Entity
@Table(name = "airports")
public class Airport {
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int airportId;
	
	@OneToMany(fetch=FetchType.EAGER,mappedBy="departureAirport")
	Collection<Flight> listDepartureFlights;
	
	@OneToMany(fetch=FetchType.EAGER,mappedBy="arrivalAirport")
	Collection<Flight> listArrivalFlights;
	
	private String airportName;
	@Column(unique=true)
	String airportIataCode;
	private String airportCountry;	
	
	public Airport(){
		super();
	}
	
	Airport(String airportName, String airportIataCode, String airportCountry){
		this.airportName = airportName;
		this.airportIataCode = airportIataCode;
		this.airportCountry = airportCountry;
	}

	public String getAirportName() {
		return airportName;
	}

	public void setAirportName(String airportName) {
		this.airportName = airportName;
	}

	public String getAirportIataCode() {
		return airportIataCode;
	}

	public void setAirportIataCode(String airportIataCode) {
		this.airportIataCode = airportIataCode;
	}

	public String getAirportCountry() {
		return airportCountry;
	}

	public void setAirportCountry(String airportCountry) {
		this.airportCountry = airportCountry;
	}
	
	
}
