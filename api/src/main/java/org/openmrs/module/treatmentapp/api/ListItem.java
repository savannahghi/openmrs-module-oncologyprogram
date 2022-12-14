package org.openmrs.module.treatmentapp.api;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * @author HealthIT
 */
public class ListItem {
	
	protected final Log log = LogFactory.getLog(getClass());
	
	private Integer id;
	
	private String name;
	
	private String description;
	
	public ListItem() {
	}
	
	public ListItem(Integer id, String name, String description) {
		this.id = id;
		this.name = name;
		this.description = description;
	}
	
	public String getDescription() {
		return description;
	}
	
	public void setDescription(String description) {
		this.description = description;
	}
	
	public Integer getId() {
		return id;
	}
	
	public void setId(Integer id) {
		this.id = id;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
}
