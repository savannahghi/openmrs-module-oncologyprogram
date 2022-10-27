package org.openmrs.module.mchapp.model;

import java.io.Serializable;
import java.util.Date;

/**
 * @author Stanslaus Odhiambo Created on 8/26/2016.
 */

public class ImmunizationEquipment implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private int id;
	
	private String equipmentType;
	
	private String model;
	
	private boolean workingStatus;
	
	private String energySource;
	
	private Date dateOfManufacture;
	
	private String createdBy;
	
	private Date createdOn;
	
	private String remarks;
	
	public int getId() {
		return id;
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
	public String getEquipmentType() {
		return equipmentType;
	}
	
	public void setEquipmentType(String equipmentType) {
		this.equipmentType = equipmentType;
	}
	
	public String getModel() {
		return model;
	}
	
	public void setModel(String model) {
		this.model = model;
	}
	
	public boolean isWorkingStatus() {
		return workingStatus;
	}
	
	public void setWorkingStatus(boolean workingStatus) {
		this.workingStatus = workingStatus;
	}
	
	public String getEnergySource() {
		return energySource;
	}
	
	public void setEnergySource(String energySource) {
		this.energySource = energySource;
	}
	
	public Date getDateOfManufacture() {
		return dateOfManufacture;
	}
	
	public void setDateOfManufacture(Date dateOfManufacture) {
		this.dateOfManufacture = dateOfManufacture;
	}
	
	public String getCreatedBy() {
		return createdBy;
	}
	
	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}
	
	public Date getCreatedOn() {
		return createdOn;
	}
	
	public void setCreatedOn(Date createdOn) {
		this.createdOn = createdOn;
	}
	
	public String getRemarks() {
		return remarks;
	}
	
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
}
