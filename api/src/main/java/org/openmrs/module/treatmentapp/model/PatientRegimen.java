package org.openmrs.module.treatmentapp.model;

import java.io.Serializable;
import java.util.Date;

public class PatientRegimen implements Serializable {
	
	private int id;
	
	private String medication;
	
	private String dose;
	
	private String route;
	
	private String dosingUnit;
	
	private String comment;
	
	private String tag;
	
	private String program;
	
	private Date createdAt;
	
	public int getId() {
		return id;
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
	public String getMedication() {
		return medication;
	}
	
	public void setMedication(String medication) {
		this.medication = medication;
	}
	
	public String getDose() {
		return dose;
	}
	
	public void setDose(String dose) {
		this.dose = dose;
	}
	
	public String getRoute() {
		return route;
	}
	
	public void setRoute(String route) {
		this.route = route;
	}
	
	public String getDosingUnit() {
		return dosingUnit;
	}
	
	public void setDosingUnit(String dosingUnit) {
		this.dosingUnit = dosingUnit;
	}
	
	public String getComment() {
		return comment;
	}
	
	public void setComment(String comment) {
		this.comment = comment;
	}
	
	public String getTag() {
		return tag;
	}
	
	public void setTag(String tag) {
		this.tag = tag;
	}
	
	public String getProgram() {
		return program;
	}
	
	public void setProgram(String program) {
		this.program = program;
	}
	
	public Date getCreatedAt() {
		return createdAt;
	}
	
	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
	
	public PatientRegimen(int id, String medication, String dose, String route, String dosingUnit, String comment, String tag,
						  String program) {
		this.id = id;
		this.medication = medication;
		this.dose = dose;
		this.route = route;
		this.dosingUnit = dosingUnit;
		this.comment = comment;
		this.tag = tag;
		this.program = program;
		this.createdAt = new Date();
	}
}
