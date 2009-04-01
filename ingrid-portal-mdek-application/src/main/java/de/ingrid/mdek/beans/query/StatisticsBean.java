package de.ingrid.mdek.beans.query;

import java.util.Map;



public class StatisticsBean {

	// Map workstate (WorkState) to number of datasets
	public Map<String, Long> classMap;
	public Long numTotal;


	public Map<String, Long> getClassMap() {
		return classMap;
	}

	public void setClassMap(Map<String, Long> classMap) {
		this.classMap = classMap;
	}

	public Long getNumTotal() {
		return numTotal;
	}

	public void setNumTotal(Long numTotal) {
		this.numTotal = numTotal;
	}
}