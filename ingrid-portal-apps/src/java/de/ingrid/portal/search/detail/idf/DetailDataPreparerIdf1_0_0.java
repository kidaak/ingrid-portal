package de.ingrid.portal.search.detail.idf;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.portlet.RenderRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.velocity.context.Context;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import de.ingrid.portal.global.IngridResourceBundle;
import de.ingrid.portal.global.IngridSysCodeList;
import de.ingrid.portal.global.UtilsVelocity;
import de.ingrid.utils.xml.XPathUtils;

//TODO: remove annotation
@SuppressWarnings("unchecked")
public class DetailDataPreparerIdf1_0_0 {
	
	private final static Log	log							= LogFactory.getLog(DetailDataPreparerIdf1_0_0.class);
	
	public final static String	DATA_TAB_GENERAL			= "elementsGeneral";
	public final static String	DATA_TAB_REFERENCE			= "elementsReference";
	public final static String	DATA_TAB_AREA_TIME			= "elementsAreaTime";
	public final static String	DATA_TAB_SUBJECT			= "elementsSubject";
	public final static String	DATA_TAB_AVAILABILITY		= "elementsAvailability";
	public final static String	DATA_TAB_ADDITIIONAL_INFO	= "elementsAdditionalInfo";
	
	public final static String	UDK_OBJ_CLASS_TYPE					= "UDK_OBJ_CLASS_TYPE";
	
	public Node					rootNode;
	public NodeList				nodeList;
	public Context				context;
	public IngridResourceBundle	messages;
	public IngridSysCodeList	sysCodeList;
	public RenderRequest		request;
	
	public ArrayList			elementsGeneral;
	public ArrayList			elementsReference;
	public ArrayList			elementsAreaTime;
	public ArrayList			elementsSubject;
	public ArrayList			elementsAvailability;
	public ArrayList			elementsAdditionalInfo;
	
	public DetailDataPreparerIdf1_0_0(Node node, Context context, RenderRequest request) {
		this.rootNode = node;
		this.context = context;
		this.request = request;
		messages = (IngridResourceBundle) context.get("MESSAGES");
		sysCodeList = new IngridSysCodeList(request.getLocale());
	}
	
	public void prepare(HashMap data) {
		initialArrayLists(data);
		
		if (rootNode != null) {
			HashMap general = new HashMap();
			
			String xpathExpression;
			
			xpathExpression = "//idf:udkObjClass";
			getUdkObjClass(xpathExpression, general);
			
			xpathExpression = "//idf:title";
			getTitle(xpathExpression, general);
			
			xpathExpression = "//idf:modTime";
			getModTime(xpathExpression, general);
			
			data.put("general", general);
			
			xpathExpression = "//idf:a[@type='application/vnd.ogc.wms_xml']";
			getWmsUrls(xpathExpression, data);
			
			data.put(DATA_TAB_GENERAL, elementsGeneral);
		}
	}
	
	private void getWmsUrls(String xpathExpression, HashMap data) {
		boolean nodeExist = XPathUtils.nodeExists(rootNode, xpathExpression);
		if (nodeExist) {
			if (log.isDebugEnabled()) {
				log.debug("xPathExpression exist: " + xpathExpression);
			}
			NodeList nodeList = XPathUtils.getNodeList(rootNode, xpathExpression);
			for (int i = 0; i < nodeList.getLength(); i++) {
				Node node = nodeList.item(i);
				HashMap element = new HashMap();
				String title = getValueForNode(node.getFirstChild());
				if (title == null || title.length() < 1) {
					title = messages.getString("common.result.showCoord.unknown");
				}
				element.put("title", title.concat(" (" + messages.getString("common.result.showMap") + ")"));
				element.put("type", "linkLine");
				element.put("hasLinkIcon", new Boolean(false));
				element.put("isExtern", new Boolean(false));
				element.put("href", "main-maps.psml?wms_url=" + UtilsVelocity.urlencode(getValueForNode(node.getAttributes().getNamedItem("href"))));
				
				String nodeType = getValueForNode(node.getAttributes().getNamedItem("type"));
				if (nodeType != null && nodeType.equals("application/vnd.ogc.wms_xml")) {
					ArrayList elements = (ArrayList) data.get(DATA_TAB_AREA_TIME);
					if (elements == null) {
						elements = new ArrayList();
					}
					addGroupTitleForPreNode(node, elements, data, element, DATA_TAB_AREA_TIME);
				}
			}
		}
		
	}

	private void getModTime(String xpathExpression, HashMap element) {
		boolean nodeExist = XPathUtils.nodeExists(rootNode, xpathExpression);
		if (nodeExist) {
			if (log.isDebugEnabled()) {
				log.debug("xPathExpression exist: " + xpathExpression);
			}
			String modTime = XPathUtils.getString(rootNode, xpathExpression);
			element.put("modTime", modTime);
		}
		
	}

	private void getUdkObjClass(String xpathExpression, HashMap element) {
		boolean nodeExist = XPathUtils.nodeExists(rootNode, xpathExpression);
		if (nodeExist) {
			if (log.isDebugEnabled()) {
				log.debug("xPathExpression exist: " + xpathExpression);
			}
			String udkObjClass = XPathUtils.getString(rootNode, xpathExpression);
			element.put("udkObjClass", udkObjClass);
			addElementUdkClass(elementsGeneral, udkObjClass);
		}else{
			xpathExpression = "//gmd:MD_Metadata";
			nodeExist = XPathUtils.nodeExists(rootNode, xpathExpression);
			if (nodeExist) {
				getUdkObjectClassType(xpathExpression);
				element.put("udkObjClass", (String) context.get(UDK_OBJ_CLASS_TYPE));
				addElementUdkClass(elementsGeneral,(String) context.get(UDK_OBJ_CLASS_TYPE));
			}
		}
	}

	private void getTitle(String xpathExpression, HashMap element) {
		boolean nodeExist = XPathUtils.nodeExists(rootNode, xpathExpression);
		if (nodeExist) {
			String title = XPathUtils.getString(rootNode, xpathExpression);
			element.put("title", title);
		}else{
			xpathExpression = "//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title";
			nodeExist = XPathUtils.nodeExists(rootNode, xpathExpression);
			if (nodeExist) {
				String title = XPathUtils.getString(rootNode, xpathExpression);
				element.put("title", title);
			}else{
				element.put("title", "No title");
			}
		}	
		
	}

	private void getUdkObjectClassType(String xpathExpression) {
		if(XPathUtils.nodeExists(rootNode, xpathExpression)){
			Node node = XPathUtils.getNode(rootNode, xpathExpression);
			if(node.hasChildNodes()){
				String hierachyLevel = "";
				String hierachyLevelName = "";
				String hierachyLevelExpression ="";
				
				hierachyLevelExpression = "gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue";
				if(XPathUtils.nodeExists(node, hierachyLevelExpression)){
					hierachyLevel = XPathUtils.getString(node, hierachyLevelExpression).trim();
				}
				
				hierachyLevelExpression = "gmd:hierarchyLevelName";
				if(XPathUtils.nodeExists(node, hierachyLevelExpression)){
					hierachyLevelName = XPathUtils.getString(node, hierachyLevelExpression).trim();
				}
				
				if(hierachyLevelName.equals("service") && hierachyLevel.equals("service")){
					context.put(UDK_OBJ_CLASS_TYPE, "6");
				}else if(hierachyLevelName.equals("application") && hierachyLevel.equals("application")){
					context.put(UDK_OBJ_CLASS_TYPE, "3");
				}else if(hierachyLevelName.equals("job") && hierachyLevel.equals("nonGeographicDataset")){
					context.put(UDK_OBJ_CLASS_TYPE, "0");
				}else if(hierachyLevelName.equals("document") && hierachyLevel.equals("nonGeographicDataset")){
					context.put(UDK_OBJ_CLASS_TYPE, "2");
				}else if(hierachyLevelName.equals("project") && hierachyLevel.equals("nonGeographicDataset")){
					context.put(UDK_OBJ_CLASS_TYPE, "4");
				}else if(hierachyLevelName.equals("database") && hierachyLevel.equals("nonGeographicDataset")){
					context.put(UDK_OBJ_CLASS_TYPE, "5");
				}else if(hierachyLevel.equals("dataset") || hierachyLevel.equals("series")){
					context.put(UDK_OBJ_CLASS_TYPE, "1");
				}
			}
		}		
	}

	public void initialArrayLists(HashMap data) {
		this.elementsGeneral = (ArrayList) data.get(DATA_TAB_GENERAL);
		if (this.elementsGeneral == null)
			this.elementsGeneral = new ArrayList();
		
		this.elementsReference = (ArrayList) data.get(DATA_TAB_REFERENCE);
		if (this.elementsReference == null)
			this.elementsReference = new ArrayList();
		
		this.elementsAreaTime = (ArrayList) data.get(DATA_TAB_AREA_TIME);
		if (this.elementsAreaTime == null)
			this.elementsAreaTime = new ArrayList();
		
		this.elementsSubject = (ArrayList) data.get(DATA_TAB_SUBJECT);
		if (this.elementsSubject == null)
			this.elementsSubject = new ArrayList();
		
		this.elementsAvailability = (ArrayList) data.get(DATA_TAB_AVAILABILITY);
		if (this.elementsAvailability == null)
			this.elementsAvailability = new ArrayList();
		
		this.elementsAdditionalInfo = (ArrayList) data.get(DATA_TAB_ADDITIIONAL_INFO);
		if (this.elementsAdditionalInfo == null)
			this.elementsAdditionalInfo = new ArrayList();
	}
	
	public void addElementEntry(List elements, String body, String title) {
		addElementEntry(elements, body, title, null);
	}
	
	public void addElementEntry(List elements, String body, String title, String alternateName) {
		if (UtilsVelocity.hasContent(body).booleanValue()) {
			HashMap element = new HashMap();
			element.put("type", "entry");
			if (title == null) {
				element.put("header", messages.getString("detail_description"));
			}
			if (alternateName == null) {
				element.put("title", title);
			} else {
				element.put("title", alternateName);
			}
			// show line breaks correctly in HTML
			element.put("body", body.replaceAll("\n", "<br />"));
			elements.add(element);
		}
	}
	
	public void addElementEntryLabelLeft(List elements, String body, String title) {
		if (UtilsVelocity.hasContent(body).booleanValue()) {
			HashMap element = new HashMap();
			element.put("type", "textLabelLeft");
			element.put("title", title);
			element.put("body", body);
			elements.add(element);
		}
	}
	
	public void addElementEntryLabelAbove(List elements, String body, String title, boolean line) {
		if (UtilsVelocity.hasContent(body).booleanValue()) {
			HashMap element = new HashMap();
			element.put("type", "textLabelAbove");
			element.put("title", title);
			element.put("line", line);
			element.put("body", body);
			elements.add(element);
		}
	}
	
	public void addElementEntryLabelDuring(List elements, String body, String title) {
		if (UtilsVelocity.hasContent(body).booleanValue()) {
			HashMap element = new HashMap();
			element.put("type", "textLabelDuring");
			element.put("title", title);
			element.put("body", body);
			elements.add(element);
		}
	}
	
	public void addElementUdkClass(List elements, String udkClass) {
		if (UtilsVelocity.hasContent(udkClass).booleanValue()) {
			HashMap element = new HashMap();
			element.put("type", "udkClass");
			element.put("udkClass", udkClass);
			element.put("udkClassName", messages.getString("udk_obj_class_name_".concat(udkClass)));
			elements.add(element);
		}
	}
	
	public void addSuperiorObjects(List elements, List linkList) {
		if (!linkList.isEmpty()) {
			HashMap element = new HashMap();
			element.put("type", "linkList");
			element.put("title", messages.getString("superior_references"));
			element.put("linkList", linkList);
			elements.add(element);
		}
	}
	
	public void addSubordinatedObjects(List elements, List linkList) {
		if (!linkList.isEmpty()) {
			HashMap element = new HashMap();
			element.put("type", "linkList");
			element.put("title", messages.getString("subordinated_references"));
			element.put("linkList", linkList);
			elements.add(element);
		}
	}
	
	public void addLine(List elements) {
		HashMap element = new HashMap();
		element.put("type", "line");
		elements.add(element);
	}
	
	public void addSpace(List elements) {
		HashMap element = new HashMap();
		element.put("type", "space");
		elements.add(element);
	}
	
	public void openDiv(List elements) {
		HashMap element = new HashMap();
		element.put("type", "beginnDiv");
		elements.add(element);
	}
	
	public void closeDiv(List elements) {
		HashMap element = new HashMap();
		element.put("type", "endDiv");
		elements.add(element);
	}
	
	public void addSectionTitle(List elements, String title) {
		addSpace(elements);
		HashMap element = new HashMap();
		element.put("type", "section");
		element.put("title", title);
		elements.add(element);
		openDiv(elements);
	}
	
	public void addGroupTitle(List elements, String title) {
		HashMap element = new HashMap();
		element.put("type", "group");
		element.put("title", title);
		elements.add(element);
	}
	
	public boolean isEmptyRow(List row) {
		for (int i = 0; i < row.size(); i++) {
			if (row.get(i) != null && row.get(i) instanceof String && ((String) row.get(i)).length() > 0) {
				return false;
			}
		}
		return true;
	}
	
	public boolean isEmptyLine(HashMap line) {
		if (line.get("type") != null && (line.get("type").equals("textLine") || line.get("type").equals("textLabelLeft"))) {
			if (line.get("body") != null && line.get("body") instanceof String && ((String) line.get("body")).length() > 0) {
				return false;
			}
		}
		return true;
	}
	
	public boolean isEmptyList(HashMap listEntry) {
		if (listEntry.get("type") != null && listEntry.get("type").equals("textList") || listEntry.get("type").equals("linkList")) {
			if (listEntry.get("body") != null && listEntry.get("body") instanceof String && ((String) listEntry.get("body")).length() > 0) {
				return false;
			}
		}
		return true;
	}
	
	public String notNull(String in) {
		if (in == null) {
			return "";
		} else {
			return in;
		}
	}
	
	public String getValueForNode(Node node) {
		return node.getNodeValue().trim();
	}
	
	public String getNameForNode(Node node) {
		return node.getNodeName().trim();
	}
	
	private void addGroupTitleForPreNode(Node node, ArrayList elements, HashMap data, HashMap element, String elementType) {
		Node preNode = node.getPreviousSibling().getPreviousSibling();
		if (preNode != null) {
			if (getNameForNode(preNode).equals("strong")) {
				addSpace(elements);
				addGroupTitle(elements, getValueForNode(preNode.getFirstChild()));
			}
		}
		elements.add(element);
		data.put(elementType, elements);
	}
}