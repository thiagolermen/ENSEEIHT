package model;

import java.util.ArrayList;
import java.util.Collection;

import javax.persistence.*;


@Entity
@Table(name = "aircrafts")
public class Aircraft {
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	int aircraftId;
	
	@OneToMany(fetch=FetchType.EAGER,mappedBy="aircraft")
	Collection<Flight> listFlights = new ArrayList<Flight>();
	
	private String aircraftName;
	@Column(unique=true)
	private String aircraftIcaoCode;
	private int aircraftCapacity;
	
	public Aircraft(){
		super();
	}

	public Aircraft(String aircraftName, String icaoCode, int aircraftCapacity) {
		super();
		this.aircraftName = aircraftName;
		this.aircraftIcaoCode = icaoCode;
		this.aircraftCapacity = aircraftCapacity;
	}
	
	public String getAircraftName() {
		return aircraftName;
	}
	public void setAircraftName(String aircraftName) {
		this.aircraftName = aircraftName;
	}
	public String getAircraftIcaoCode() {
		return aircraftIcaoCode;
	}

	public void setAircraftIcaoCode(String aircraftIcaoCode) {
		this.aircraftIcaoCode = aircraftIcaoCode;
	}
	public int getAircraftCapacity() {
		return aircraftCapacity;
	}
	public void setAircraftCapacity(int aircraftCapacity) {
		this.aircraftCapacity = aircraftCapacity;
	}
	
	
}
