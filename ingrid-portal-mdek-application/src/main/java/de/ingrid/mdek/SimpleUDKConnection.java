package de.ingrid.mdek;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;

import de.ingrid.mdek.dwr.MdekDataBean;
import de.ingrid.utils.IngridDocument;

public class SimpleUDKConnection implements DataConnectionInterface {

	private final static Logger log = Logger.getLogger(SimpleUDKConnection.class);
	
	private IMdekCaller mdekCaller; 
	private DataMapperInterface dataMapper;

	// TODO Load the file dynamically from a cfg file 	
	private final static String ENTRY_SERVICE_CFG_FILE = "C:\\_projekte\\ingrid\\ingrid-SVN\\ingrid-mdek\\trunk\\ingrid-mdek-api\\src\\main\\resources\\communication.properties";

	public SimpleUDKConnection() {
		File file = new File(ENTRY_SERVICE_CFG_FILE);
		MdekCaller.initialize(file);
		mdekCaller = MdekCaller.getInstance();
	}

	protected void finalize() {
		MdekCaller.shutdown();
		mdekCaller = null;
		dataMapper = null;
	}

	public DataMapperInterface getDataMapper() {
		return dataMapper;
	}


	public void setDataMapper(DataMapperInterface dataMapper) {
		this.dataMapper = dataMapper;
	}


	public MdekDataBean getNodeDetail(String uuid) {
		IngridDocument response = mdekCaller.fetchObjDetails(uuid);
		return extractSingleObjectFromResponse(response);
	}

	public ArrayList<HashMap<String, Object>> getRootAddresses() {
		IngridDocument response = mdekCaller.fetchTopAddresses();
		return extractAddressesFromResponse(response);
	}

	public ArrayList<HashMap<String, Object>> getRootObjects() {
		IngridDocument response = mdekCaller.fetchTopObjects();
		return extractObjectsFromResponse(response);
	}

	public ArrayList<HashMap<String, Object>> getSubObjects(String uuid, int depth) {
		IngridDocument response = mdekCaller.fetchSubObjects(uuid);
		return extractObjectsFromResponse(response);
	}

	public ArrayList<HashMap<String, Object>> getSubAddresses(String uuid, int depth) {
		IngridDocument response = mdekCaller.fetchSubAddresses(uuid);
		return extractObjectsFromResponse(response);
	}

	public void saveNode(MdekDataBean data) {
		IngridDocument obj = wrapObject((IngridDocument) dataMapper.convertFromMdekRepresentation(data));
		log.debug("Sending the following object:");
		log.debug(obj);

		mdekCaller.storeObjDetails(obj);
	}

	
	// ------------------------ Helper Methods ---------------------------------------	

	private ArrayList<HashMap<String, Object>> extractObjectsFromResponse(IngridDocument response)
	{
		IngridDocument result = mdekCaller.getResultFromResponse(response);

		ArrayList<HashMap<String, Object>> nodeList = null;
		
		if (result != null) {
			nodeList = new ArrayList<HashMap<String, Object>>();
			List<IngridDocument> objs = (List<IngridDocument>) result.get(MdekKeys.OBJ_ENTITIES);
			for (IngridDocument objEntity : objs) {
				nodeList.add(dataMapper.getSimpleMdekRepresentation(objEntity));
			}
		} else {
			log.error(mdekCaller.getErrorMsgFromResponse(response));			
		}
		return nodeList;
	}
	
	private ArrayList<HashMap<String, Object>> extractAddressesFromResponse(IngridDocument response)
	{
		IngridDocument result = mdekCaller.getResultFromResponse(response);

		ArrayList<HashMap<String, Object>> nodeList = null;
		
		if (result != null) {
			nodeList = new ArrayList<HashMap<String, Object>>();
			List<IngridDocument> adrs = (List<IngridDocument>) result.get(MdekKeys.ADR_ENTITIES);
			for (IngridDocument adrEntity : adrs) {
				nodeList.add(dataMapper.getSimpleMdekRepresentation(adrEntity));
			}
		} else {
			log.error(mdekCaller.getErrorMsgFromResponse(response));			
		}
		return nodeList;
	}	

	private MdekDataBean extractSingleObjectFromResponse(IngridDocument response)
	{
		IngridDocument result = mdekCaller.getResultFromResponse(response);

		if (result != null) {
			List<IngridDocument> objs = (List<IngridDocument>) result.get(MdekKeys.OBJ_ENTITIES);
			if (objs == null) {
				log.error("Error in SimpleUDKConnection.extractSingleObjectFromResponse. No object entities returned.");				
			}
			else if (objs.size() != 1) {
				log.error("Error in SimpleUDKConnection.extractSingleObjectFromResponse. Number of returned objects != 1.");				
			}
			else {
				return dataMapper.getDetailedMdekRepresentation(objs.get(0));
			}
		} else {
			log.error(mdekCaller.getErrorMsgFromResponse(response));			
		}
		return null;
	}

	private IngridDocument wrapObject(IngridDocument obj) {
		ArrayList<IngridDocument> list = new ArrayList();
		IngridDocument doc = new IngridDocument();

		list.add(obj);
		doc.put(MdekKeys.OBJ_ENTITIES, list);
		return doc;
	}
}
