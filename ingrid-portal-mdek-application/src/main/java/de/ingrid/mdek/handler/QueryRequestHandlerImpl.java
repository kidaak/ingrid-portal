package de.ingrid.mdek.handler;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import org.apache.log4j.Logger;

import de.ingrid.mdek.MdekKeys;
import de.ingrid.mdek.beans.CatalogBean;
import de.ingrid.mdek.beans.address.MdekAddressBean;
import de.ingrid.mdek.beans.object.MdekDataBean;
import de.ingrid.mdek.beans.query.AddressExtSearchParamsBean;
import de.ingrid.mdek.beans.query.AddressSearchResultBean;
import de.ingrid.mdek.beans.query.AddressWorkflowResultBean;
import de.ingrid.mdek.beans.query.ObjectExtSearchParamsBean;
import de.ingrid.mdek.beans.query.ObjectSearchResultBean;
import de.ingrid.mdek.beans.query.ObjectWorkflowResultBean;
import de.ingrid.mdek.beans.query.SearchResultBean;
import de.ingrid.mdek.caller.IMdekCallerAddress;
import de.ingrid.mdek.caller.IMdekCallerCatalog;
import de.ingrid.mdek.caller.IMdekCallerQuery;
import de.ingrid.mdek.dwr.util.HTTPSessionHelper;
import de.ingrid.mdek.util.MdekAddressUtils;
import de.ingrid.mdek.util.MdekCatalogUtils;
import de.ingrid.mdek.util.MdekObjectUtils;
import de.ingrid.mdek.util.MdekUtils;
import de.ingrid.utils.IngridDocument;

public class QueryRequestHandlerImpl implements QueryRequestHandler {

	private final static Logger log = Logger.getLogger(QueryRequestHandlerImpl.class);

	// Injected by Spring
	private ConnectionFacade connectionFacade;

	// Initialized by spring through the init method
	private IMdekCallerQuery mdekCallerQuery;
	private IMdekCallerAddress mdekCallerAddress;

	public void init() {
		mdekCallerQuery = connectionFacade.getMdekCallerQuery();
		mdekCallerAddress = connectionFacade.getMdekCallerAddress();
	}

	
	public AddressSearchResultBean queryAddressesThesaurusTerm(String topicId, int startHit, int numHits) {
		log.debug("Searching for addresses with topicId: "+topicId);

		IngridDocument response = mdekCallerQuery.queryAddressesThesaurusTerm(connectionFacade.getCurrentPlugId(), topicId, startHit, numHits, HTTPSessionHelper.getCurrentSessionId());
		
		return MdekAddressUtils.extractAddressSearchResultsFromResponse(response);
	}

	public AddressSearchResultBean queryAddressesExtended(AddressExtSearchParamsBean query, int startHit, int numHits) {
		IngridDocument queryParams = MdekUtils.convertAddressExtSearchParamsToIngridDoc(query);

		IngridDocument response = mdekCallerQuery.queryAddressesExtended(connectionFacade.getCurrentPlugId(), queryParams, startHit, numHits, HTTPSessionHelper.getCurrentSessionId());
		return MdekAddressUtils.extractAddressSearchResultsFromResponse(response);
	}

	public ObjectSearchResultBean queryObjectsExtended(ObjectExtSearchParamsBean query, int startHit, int numHits) {
		IngridDocument queryParams = MdekUtils.convertObjectExtSearchParamsToIngridDoc(query);

		IngridDocument response = mdekCallerQuery.queryObjectsExtended(connectionFacade.getCurrentPlugId(), queryParams, startHit, numHits, HTTPSessionHelper.getCurrentSessionId());
		return MdekObjectUtils.extractObjectSearchResultsFromResponse(response);
	}

	public AddressSearchResultBean queryAddressesFullText(String searchTerm, int startHit, int numHits) {
		IngridDocument response = mdekCallerQuery.queryAddressesFullText(connectionFacade.getCurrentPlugId(), searchTerm, startHit, numHits, HTTPSessionHelper.getCurrentSessionId());
		return MdekAddressUtils.extractAddressSearchResultsFromResponse(response);
	}

	public ObjectSearchResultBean queryObjectsFullText(String searchTerm, int startHit, int numHits) {
		IngridDocument response = mdekCallerQuery.queryObjectsFullText(connectionFacade.getCurrentPlugId(), searchTerm, startHit, numHits, HTTPSessionHelper.getCurrentSessionId());
		return MdekObjectUtils.extractObjectSearchResultsFromResponse(response);
	}

	public SearchResultBean queryHQL(String hqlQuery, int startHit, int numHits) {
		log.debug("Searching via HQL query: "+hqlQuery);

		IngridDocument response = mdekCallerQuery.queryHQL(connectionFacade.getCurrentPlugId(), hqlQuery, startHit, numHits, HTTPSessionHelper.getCurrentSessionId());

		return MdekUtils.extractSearchResultsFromResponse(response);
	}

	public SearchResultBean queryHQLToCSV(String hqlQuery) {
		log.debug("Searching via HQL to csv query: "+hqlQuery);

		IngridDocument response = mdekCallerQuery.queryHQLToCsv(connectionFacade.getCurrentPlugId(), hqlQuery, HTTPSessionHelper.getCurrentSessionId());

		return MdekUtils.extractSearchResultsFromResponse(response);
	}

	public ObjectSearchResultBean queryObjectsThesaurusTerm(String topicId, int startHit, int numHits) {
		log.debug("Searching for objects with topicId: "+topicId);

		IngridDocument response = mdekCallerQuery.queryObjectsThesaurusTerm(connectionFacade.getCurrentPlugId(), topicId, startHit, numHits, HTTPSessionHelper.getCurrentSessionId());
		
		return MdekObjectUtils.extractObjectSearchResultsFromResponse(response);
	}

	public AddressSearchResultBean searchAddresses(MdekAddressBean adr, int startHit, int numHits) {
		IngridDocument adrDoc = (IngridDocument) MdekAddressUtils.convertFromAddressRepresentation(adr);

		log.debug("Sending the following address search:");
		log.debug(adrDoc);

		IngridDocument response = mdekCallerAddress.searchAddresses(connectionFacade.getCurrentPlugId(), adrDoc, startHit, numHits, HTTPSessionHelper.getCurrentSessionId());
		
		// TODO Convert the response
		return MdekAddressUtils.extractAddressSearchResultsFromResponse(response);
	}

	public ArrayList<AddressWorkflowResultBean> searchAddressesForWorkflowManagement() {
		ArrayList<AddressWorkflowResultBean> adrResults = new ArrayList<AddressWorkflowResultBean>();

		Integer expiryDuration = getExpiryDuration();
		if (expiryDuration == null || expiryDuration <= 0) {
			return adrResults;
		}

		Calendar expireCal = Calendar.getInstance();
		expireCal.add(Calendar.DAY_OF_MONTH, -(expiryDuration));

		String qString = "select adr.adrUuid, adr.institution, adr.firstname, adr.lastname, adr.adrType, adr.modTime, " +
				"addr.adrUuid, addr.institution, addr.firstname, addr.lastname, addr.adrType " +
		"from AddressNode addrNode " +
			"inner join addrNode.t02AddressPublished adr " +
			"inner join adr.addressMetadata aMeta, " +
			"AddressNode as aNode " +
			"inner join aNode.t02AddressPublished addr " +
			"inner join addr.t021Communications comm " +
		"where " +
			"adr.responsibleUuid = aNode.addrUuid " +
			" and adr.modTime <= " + de.ingrid.mdek.MdekUtils.dateToTimestamp(expireCal.getTime()) +
			" and adr.responsibleUuid = '"+HTTPSessionHelper.getCurrentSessionId()+"'";

		IngridDocument response = mdekCallerQuery.queryHQLToMap(connectionFacade.getCurrentPlugId(), qString, 10, "");
		IngridDocument result = MdekUtils.getResultFromResponse(response);

		if (result != null) {
			List<IngridDocument> adrs = (List<IngridDocument>) result.get(MdekKeys.ADR_ENTITIES);
			if (adrs != null) {
				for (IngridDocument adrEntity : adrs) {
					AddressWorkflowResultBean adrWf = new AddressWorkflowResultBean();

					Calendar cal = Calendar.getInstance();
					cal.setTime(MdekUtils.convertTimestampToDate(adrEntity.getString("adr.modTime")));
					cal.add(Calendar.DAY_OF_MONTH, expiryDuration);
					adrWf.setDate(cal.getTime());
					adrWf.setState("Expired");
					adrWf.setType("B");

					adrWf.setAddress(createAddressFromHQLMap(adrEntity, "adr.adrUuid", "adr.adrType", "adr.institution", "adr.firstname", "adr.lastname"));
					adrWf.setAssignedUser(createAddressFromHQLMap(adrEntity, "addr.adrUuid", "addr.adrType", "addr.institution", "addr.firstname", "addr.lastname"));

					adrResults.add(adrWf);
				}
			}
		}

		return adrResults;
	}

	private Integer getExpiryDuration() {
		IMdekCallerCatalog mdekCallerCatalog = connectionFacade.getMdekCallerCatalog();

		IngridDocument catDoc = mdekCallerCatalog.fetchCatalog(connectionFacade.getCurrentPlugId(), "");
		CatalogBean cat = MdekCatalogUtils.extractCatalogFromResponse(catDoc);
		return cat.getExpiryDuration();		
	}

	public ArrayList<ObjectWorkflowResultBean> searchObjectsForWorkflowManagement() {
		ArrayList<ObjectWorkflowResultBean> objResults = new ArrayList<ObjectWorkflowResultBean>();

		Integer expiryDuration = getExpiryDuration();
		if (expiryDuration == null || expiryDuration <= 0) {
			return objResults;
		}

		Calendar expireCal = Calendar.getInstance();
		expireCal.add(Calendar.DAY_OF_MONTH, -(expiryDuration));

		String qString = "select obj.objUuid, obj.objClass, obj.objName, obj.modTime, addr.institution, addr.firstname, addr.lastname, addr.adrUuid, addr.adrType " +
		"from ObjectNode oNode " +
			"inner join oNode.t01ObjectPublished obj " +
			"inner join obj.objectMetadata oMeta, " +
			"AddressNode as aNode " +
			"inner join aNode.t02AddressPublished addr " +
			"inner join addr.t021Communications comm " +
		"where " +
			"obj.responsibleUuid = aNode.addrUuid " +
			" and obj.modTime <= " + de.ingrid.mdek.MdekUtils.dateToTimestamp(expireCal.getTime()) +
			" and obj.responsibleUuid = '"+HTTPSessionHelper.getCurrentSessionId()+"'";

		IngridDocument response = mdekCallerQuery.queryHQLToMap(connectionFacade.getCurrentPlugId(), qString, 10, HTTPSessionHelper.getCurrentSessionId());
		IngridDocument result = MdekUtils.getResultFromResponse(response);

		if (result != null) {
			List<IngridDocument> objs = (List<IngridDocument>) result.get(MdekKeys.OBJ_ENTITIES);
			if (objs != null) {
				for (IngridDocument objEntity : objs) {
					ObjectWorkflowResultBean objWf = new ObjectWorkflowResultBean();

					Calendar cal = Calendar.getInstance();
					cal.setTime(MdekUtils.convertTimestampToDate(objEntity.getString("obj.modTime")));
					cal.add(Calendar.DAY_OF_MONTH, expiryDuration);
					objWf.setDate(cal.getTime());
					objWf.setState("Expired");
					objWf.setType("B");

					objWf.setObject(createObjectFromHQLMap(objEntity, "obj.objUuid", "obj.objName", "obj.objClass"));
					objWf.setAssignedUser(createAddressFromHQLMap(objEntity, "addr.adrUuid", "addr.adrType", "addr.institution", "addr.firstname", "addr.lastname"));

					objResults.add(objWf);
				}
			}
		}

		return objResults;
	}

	private MdekDataBean createObjectFromHQLMap(IngridDocument objEntity, String uuidKey,
			String nameKey, String classKey) {
		MdekDataBean result = new MdekDataBean();
		result.setUuid(objEntity.getString(uuidKey));
		result.setObjectName(objEntity.getString(nameKey));
		result.setObjectClass((Integer) objEntity.get(classKey));
		return result;
	}

	private MdekAddressBean createAddressFromHQLMap(IngridDocument adrEntity, String uuidKey,
			String typeKey, String institutionKey, String firstnameKey, String lastnameKey) {
		MdekAddressBean result = new MdekAddressBean();
		result.setUuid(adrEntity.getString(uuidKey));
		result.setAddressClass((Integer) adrEntity.get(typeKey));
		result.setOrganisation(adrEntity.getString(institutionKey));
		result.setGivenName(adrEntity.getString(firstnameKey));
		result.setName(adrEntity.getString(lastnameKey));
		return result;
	}

	public IMdekCallerQuery getMdekCallerQuery() {
		return mdekCallerQuery;
	}

	public void setMdekCallerQuery(IMdekCallerQuery mdekCallerQuery) {
		this.mdekCallerQuery = mdekCallerQuery;
	}


	public ConnectionFacade getConnectionFacade() {
		return connectionFacade;
	}


	public void setConnectionFacade(ConnectionFacade connectionFacade) {
		this.connectionFacade = connectionFacade;
	}

}
