package model;

import java.io.Serializable;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collection;

import javax.persistence.*;

@Entity
@Table(name = "users")
public class User{
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	int userId;
	
	@OneToMany(fetch=FetchType.EAGER, mappedBy = "user", cascade = CascadeType.ALL)
	private Collection<Reservation> listReservation = new ArrayList<Reservation>();

	private String firstName;
	private String lastName;
	@Column(unique=true)
	private String email;
	private String password;
	private String birthDateString;
	private Date birthDate;
	private boolean isAdmin = false;
	
	public User(String email, String password){
		this.email = email;
		this.password = password;
	}
	
	public User(String email, String password, boolean isAdmin){
		this.email = email;
		this.password = password;
		this.isAdmin = isAdmin;
	}
	
	public User(){
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
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getBirthDateString() {
		return birthDateString;
	}
	public void setBirthDateString(String birthDateString) {
		this.birthDateString = birthDateString;
	}
	public boolean isAdmin() {
		return isAdmin;
	}
	public void setAdmin(boolean isAdmin) {
		this.isAdmin = isAdmin;
	}
	public Date getBirthDate() {
		return birthDate;
	}
	public void setBirthDate(Date birthDate) {
		this.birthDate = birthDate;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public Collection<Reservation> getListReservation() {
		return listReservation;
	}

	public void setListReservation(Collection<Reservation> listReservation) {
		this.listReservation = listReservation;
	}
	

}
