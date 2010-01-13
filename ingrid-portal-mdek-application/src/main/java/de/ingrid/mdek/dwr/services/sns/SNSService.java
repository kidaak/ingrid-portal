package de.ingrid.mdek.dwr.services.sns;

import java.net.URL;
import java.text.Collator;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.TreeSet;

import org.apache.axis.AxisFault;
import org.apache.log4j.Logger;

import com.slb.taxi.webservice.xtm.stubs.TopicMapFragment;
import com.slb.taxi.webservice.xtm.stubs.TopicMapFragmentIndexedDocument;
import com.slb.taxi.webservice.xtm.stubs.xtm.Occurrence;

import de.ingrid.external.FullClassifyService;
import de.ingrid.external.GazetteerService;
import de.ingrid.external.ThesaurusService;
import de.ingrid.external.GazetteerService.QueryType;
import de.ingrid.external.om.Location;
import de.ingrid.external.om.RelatedTerm;
import de.ingrid.external.om.Term;
import de.ingrid.external.om.TreeTerm;
import de.ingrid.external.om.RelatedTerm.RelationType;
import de.ingrid.external.om.Term.TermType;
import de.ingrid.iplug.sns.SNSClient;
import de.ingrid.iplug.sns.utils.Topic;
import de.ingrid.mdek.dwr.services.sns.SNSTopic.Source;
import de.ingrid.mdek.dwr.services.sns.SNSTopic.Type;

public class SNSService {

	private final static Logger log = Logger.getLogger(SNSService.class);	

	// Switch to "rs:" when the native key changes
	// private static final String SNS_NATIVE_KEY_PREFIX = "rs:"; 
	private static final String SNS_NATIVE_KEY_PREFIX = "ags:";
    private static final int MAX_NUM_RESULTS = 100;
    private static final int MAX_ANALYZED_WORDS = 1000;
    private static final int SNS_TIMEOUT = 30000;

    // Error string for the frontend
    private static String ERROR_SNS_TIMEOUT = "SNS_TIMEOUT";
    private static String ERROR_SNS_INVALID_URL = "SNS_INVALID_URL";
    
    private static final SimpleDateFormat expiredDateParser = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");

    // Settings and language specific values
    private ResourceBundle resourceBundle; 
    private SNSClient snsClient;

    private ThesaurusService thesaurusService;
    private GazetteerService gazetteerService;
    private FullClassifyService fullClassifyService;

    // The three main SNS topic types
    private enum TopicType {EVENT, LOCATION, THESA}


    // Init Method is called by the Spring Framework on initialization
    public void init() throws Exception {
		resourceBundle = ResourceBundle.getBundle("sns");

    	snsClient = new SNSClient(
    			resourceBundle.getString("sns.username"),
    			resourceBundle.getString("sns.password"),
    			resourceBundle.getString("sns.language"),
        		new URL(resourceBundle.getString("sns.serviceURL")));
    	snsClient.setTimeout(SNS_TIMEOUT);
    }

	public void setThesaurusService(ThesaurusService thesaurusService) {
		this.thesaurusService = thesaurusService;
	}
	public void setGazetteerService(GazetteerService gazetteerService) {
		this.gazetteerService = gazetteerService;
	}
	public void setFullClassifyService(FullClassifyService fullClassifyService) {
		this.fullClassifyService = fullClassifyService;
	}

    public List<SNSTopic> getRootTopics() {
    	log.debug("     !!!!!!!!!! thesaurusService.getHierarchyNextLevel() from null (toplevel)");
    	List<SNSTopic> resultList = new ArrayList<SNSTopic>(); 
    	
    	TreeTerm[] treeTerms = thesaurusService.getHierarchyNextLevel(null, Locale.GERMAN);

    	TreeSet<TreeTerm> orderedTreeTerms = new TreeSet<TreeTerm>(new TermComparator());
    	orderedTreeTerms.addAll(Arrays.asList(treeTerms));

    	for (TreeTerm treeTerm : orderedTreeTerms) {
    		// NO ADDING OF CHILDREN !!!!!!!!! Otherwise wrong behavior in JSP !
    		SNSTopic resultTopic = convertTermToSNSTopic(treeTerm);
    		resultList.add(resultTopic);
    	}

    	return resultList;
    }

    /** This one is only called with direction "down" in JSPs !!!
     * So we call thesaurusService.getHierarchyNextLevel() */
    public List<SNSTopic> getSubTopics(String topicID, long depth, String direction) {
    	log.debug("     !!!!!!!!!! thesaurusService.getHierarchyNextLevel() from "+topicID+", "+depth+", "+direction+")");
    	List<SNSTopic> resultList = new ArrayList<SNSTopic>(); 
    	
    	TreeTerm[] treeTerms = thesaurusService.getHierarchyNextLevel(topicID, Locale.GERMAN);

    	TreeSet<TreeTerm> orderedTreeTerms = new TreeSet<TreeTerm>(new TermComparator());
    	orderedTreeTerms.addAll(Arrays.asList(treeTerms));

    	for (TreeTerm treeTerm : orderedTreeTerms) {
    		// ADDING OF CHILDREN !!!!!!!!! For right behavior in JSP !
    		SNSTopic resultTopic = convertTreeTermToSNSTopic(treeTerm);
    		resultList.add(resultTopic);
    	}

    	return resultList;
    }

    /** This one is only called with direction "up" in JSPs !!!
     * So we call thesaurusService.getHierarchyPathToTop() */
    public List<SNSTopic> getSubTopicsWithRoot(String topicID, long depth, String direction) {
    	log.debug("     !!!!!!!!!! thesaurusService.getHierarchyPathToTop() from "+topicID+", "+depth+", "+direction+")");
    	List<SNSTopic> resultList = new ArrayList<SNSTopic>(); 
    	
    	TreeTerm lastTerm = thesaurusService.getHierarchyPathToTop(topicID, Locale.GERMAN);

    	// Notice we have to build different structure for return list !
    	// parent is encapsulated in CHILD list on every level
    	if (lastTerm != null) {
    		SNSTopic lastTopic = convertTermToSNSTopic(lastTerm);
    		resultList.add(lastTopic);

    		// we use first parent on every level for hierarchy path ! 
    		while (lastTerm.getParents() != null) {
    			lastTerm = lastTerm.getParents().get(0);
    			SNSTopic currentTopic = convertTermToSNSTopic(lastTerm);

    			// set last topic as parent in current topic (but is child in hierarchy !)
    			List<SNSTopic> parents = new ArrayList<SNSTopic>();
    			parents.add(lastTopic);
    			currentTopic.setParents(parents);

    			// set current topic as child in last topic (but is parent in hierarchy !)
    			List<SNSTopic> children = new ArrayList<SNSTopic>();
    			children.add(currentTopic);
    			lastTopic.setChildren(children);
    			
    			lastTopic = currentTopic;
    		}
    	}

    	return resultList;
    }

    private static Type getTypeFromTopic(com.slb.taxi.webservice.xtm.stubs.xtm.Topic t) {
    	String nodeType = t.getInstanceOf(0).getTopicRef().getHref();
    	return getTypeForNodeType(nodeType);
    }

    private static Type getTypeForNodeType(String nodeType) {
		if (nodeType.indexOf("topTermType") != -1) 
			return Type.TOP_TERM;
		else if (nodeType.indexOf("nodeLabelType") != -1) 
			return Type.NODE_LABEL;
		else if (nodeType.indexOf("descriptorType") != -1) 
			return Type.DESCRIPTOR;
		else if (nodeType.indexOf("nonDescriptorType") != -1) 
			return Type.NON_DESCRIPTOR;
		else
			return Type.TOP_TERM;
    }

    /** NOTICE: Type.TOP_TERM can only be determined if term is TreeTerm !!!!!! */
    private static Type getTypeFromTerm(Term term) {
    	// first check whether we have a tree term ! Only then we can determine whether top node !
		if (TreeTerm.class.isAssignableFrom(term.getClass())) {
	    	if (((TreeTerm)term).getParents() == null) {
	    		return Type.TOP_TERM;
	    	}    	
		}

    	TermType termType = term.getType();
    	if (termType == TermType.NODE_LABEL) 
			return Type.NODE_LABEL;
		if (termType == TermType.DESCRIPTOR) 
			return Type.DESCRIPTOR;
		if (termType == TermType.NON_DESCRIPTOR) 
			return Type.NON_DESCRIPTOR;
		return Type.TOP_TERM;
    }

    /**
     * find the topic with name 'queryTerm'. If no topic is found with the given name, null is returned
     * @param queryTerm topic name to search for
     * @return the SNSTopic if it exists, null otherwise
     */
    public SNSTopic findTopic(String queryTerm) {
    	log.debug("     !!!!!!!!!! thesaurusService.findTermsFromQueryTerm() from " + queryTerm);
    	
    	Term[] terms = thesaurusService.findTermsFromQueryTerm(queryTerm,
    			de.ingrid.external.ThesaurusService.MatchingType.EXACT, true, Locale.GERMAN);

    	SNSTopic result = null;
    	for (Term term : terms) {
    		if (queryTerm.equalsIgnoreCase(term.getName())) {
        		result = convertTermToSNSTopic(term);
        		break;
    		}
    	}

    	return result;
    }

    /**
     * Find all topics for a given query string
     * @param queryTerm topic name to search for
     * @return All topics returned by the SNS, converted to SNSTopics 
     */
    public List<SNSTopic> findTopics(String queryTerm) {
    	log.debug("     !!!!!!!!!! thesaurusService.findTermsFromQueryTerm() from " + queryTerm);
    	
    	Term[] terms = thesaurusService.findTermsFromQueryTerm(queryTerm,
    			de.ingrid.external.ThesaurusService.MatchingType.EXACT, true, Locale.GERMAN);

    	List<SNSTopic> resultList = new ArrayList<SNSTopic>();
    	for (Term term : terms) {
    		resultList.add(convertTermToSNSTopic(term));
    	}

	    Collections.sort(resultList, new SNSTopicComparator());
	    return resultList;
    }

    /**
     * getPSI for 'topicId'. Returns the SNSTopic of given id !
     * @param topicId topic id to search for
     * @return the SNSTopic if it exists, null otherwise
     * @throws Exception if there was a connection/communication error with the SNS
     */
    public SNSTopic getPSI(String topicId) throws Exception {
    	log.debug("     !!!!!!!!!! thesaurusService.getTerm() from " + topicId);
    	
    	Term term = thesaurusService.getTerm(topicId, Locale.GERMAN);

    	SNSTopic result = null;
		if (term != null) {
    		result = convertTermToSNSTopic(term);
		}

    	return result;
    }

    /**
     * getPSI for location topics 'topicId'.
     * @param topicId topic id to search for
     * @return the SNSLocationTopic if it exists, null otherwise
     * @throws Exception if there was a connection/communication error with the SNS
     */
    public SNSLocationTopic getLocationPSI(String topicId) throws Exception {
    	log.debug("     !!!!!!!!!! gazetteerService.getLocation() from " + topicId);
    	
    	Location location = gazetteerService.getLocation(topicId, Locale.GERMAN);

    	SNSLocationTopic result = null;
		if (location != null) {
    		result = convertLocationToSNSLocation(location);
		}

    	return result;
    }

    public List<SNSTopic> getSimilarTerms(String[] queryTerms) {
    	return getSimilarTerms(queryTerms, MAX_NUM_RESULTS);
    }

    private List<SNSTopic> getSimilarTerms(String[] queryTerms, int numResults) {
    	log.debug("     !!!!!!!!!! thesaurusService.getSimilarTermsFromNames()");
    	List<SNSTopic> resultList = new ArrayList<SNSTopic>();
    	
    	Term[] terms = thesaurusService.getSimilarTermsFromNames(queryTerms, true, Locale.GERMAN);

    	int count = 0;
    	for (Term term : terms) {
    		if (term.getType() == TermType.DESCRIPTOR) {
        		SNSTopic resultTopic = convertTermToSNSTopic(term);
        		resultList.add(resultTopic);
        		count++;
        		if (count == numResults) {
        			break;
        		}
    		}
    	}

    	return resultList;
    }

    public List<SNSTopic> getSimilarDescriptors(String queryTerm) {
    	String[] words = queryTerm.split(" ");
    	List<SNSTopic> result = new ArrayList<SNSTopic>();
    	
    	for (int i = 0; i < words.length; i+=MAX_ANALYZED_WORDS) {
    		String queryStr = "";
    		for (int j = i; j < words.length && j < i+MAX_ANALYZED_WORDS; j++)
    			queryStr += words[j]+" ";

        	log.debug("sns query for words starting at: "+i);
    		log.debug("Query String: "+queryStr);
        	result.addAll(getTopicsForText(queryStr));
    	}

    	return result;
    }

    public List<SNSTopic> getTopicsForText(String queryTerm) {
    	log.debug("     !!!!!!!!!! thesaurusService.getTermsFromText()");
    	List<SNSTopic> resultList = new ArrayList<SNSTopic>();
    	
    	Term[] terms = thesaurusService.getTermsFromText(queryTerm, MAX_ANALYZED_WORDS,
    			false, Locale.GERMAN);

    	for (Term term : terms) {
    		if (term.getType() == TermType.DESCRIPTOR) {
        		SNSTopic resultTopic = convertTermToSNSTopic(term);
        		resultList.add(resultTopic);
    		}
    	}

//	    log.debug("Number of descriptors in the result: "+resultList.size());
    	return resultList;
    }

    /** Returns the topicID encapsulated in a SNSTopic with the parents, children and synonyms attached */
    public SNSTopic getTopicsForTopic(String topicId) {
    	log.debug("     !!!!!!!!!! thesaurusService.getRelatedTermsFromTerm() from " + topicId);
    	
    	RelatedTerm[] relatedTerms = thesaurusService.getRelatedTermsFromTerm(topicId, Locale.GERMAN);

    	SNSTopic result = null;
    	if (relatedTerms.length > 0) {
        	List<SNSTopic> synonyms = new ArrayList<SNSTopic>();
        	List<SNSTopic> parents = new ArrayList<SNSTopic>();
        	List<SNSTopic> children = new ArrayList<SNSTopic>();

        	for (RelatedTerm relatedTerm : relatedTerms) {
        		SNSTopic t = convertTermToSNSTopic(relatedTerm);
            	RelationType relationType = relatedTerm.getRelationType();
            	if (relationType == RelationType.CHILD) {
            		children.add(t);
            	} else if (relationType == RelationType.PARENT) {
	    			parents.add(t);
            	} else if (relationType == RelationType.RELATIVE) {
            		// check type of term !
            		if (relatedTerm.getType() == TermType.DESCRIPTOR) {
            			// !!!!!!!
    	    			result = t;
    	    			break;
            		} else {
    	    			synonyms.add(t);
            		}
            	}
        	}
        	
        	if (result == null) {
    			result = new SNSTopic(Type.DESCRIPTOR, Source.UMTHES, topicId, null, null, null);
    		    result.setChildren(children);
    		    result.setParents(parents);
    		    result.setSynonyms(synonyms);        		
        	}
    	}

    	return result;
    }

    public List<SNSLocationTopic> getLocationTopics(String queryTerm, String searchTypeStr, String pathStr) {
    	de.ingrid.external.GazetteerService.MatchingType matching =
    		getGazetteerMatchingType(searchTypeStr);
    	QueryType queryType = getGazetteerQueryType(pathStr);

    	log.debug("     !!!!!!!!!! gazetteerService.findLocationsFromQueryTerm() " + queryTerm +
    			" " + queryType + " " + matching);

    	Location[] locations = gazetteerService.findLocationsFromQueryTerm(queryTerm, queryType,
    			matching, Locale.GERMAN);

    	List<SNSLocationTopic> resultList = new ArrayList<SNSLocationTopic>();
    	for (Location location : locations) {
    		resultList.add(convertLocationToSNSLocation(location));
    	}

	    return resultList;
    }

    /** Returns all related locations including the one with passed id ! */
    public List<SNSLocationTopic> getLocationTopicsById(String topicID) {
    	log.debug("     !!!!!!!!!! gazetteerService.getRelatedLocationsFromLocation() from " + topicID);
    	
    	Location[] locations = gazetteerService.getRelatedLocationsFromLocation(topicID, true, Locale.GERMAN);

    	List<SNSLocationTopic> resultList = new ArrayList<SNSLocationTopic>();
    	for (Location location : locations) {
    		resultList.add(convertLocationToSNSLocation(location));
    	}

	    return resultList;
    }

    // SNS autoClassify operation for URLs
    public SNSTopicMap autoClassifyURL(String url, int analyzeMaxWords, String filter, boolean ignoreCase, String lang) {
    	SNSTopicMap result = new SNSTopicMap();
    	TopicMapFragment mapFragment = null;

    	try {
    		mapFragment = snsClient.autoClassifyToUrl(url, analyzeMaxWords, filter, ignoreCase, lang);

    	} catch (AxisFault f) {
    		log.debug("Error while calling autoClassifyToUrl.", f);
    		if (f.getFaultString().contains("Timeout"))
    			throw new RuntimeException(ERROR_SNS_TIMEOUT);
    		else
    			throw new RuntimeException(ERROR_SNS_INVALID_URL);

    	} catch (Exception e) {
	    	log.error("Error calling snsClient.autoClassifyToUrl", e);
    	}

    	if (null != mapFragment) {
    		TopicMapFragmentIndexedDocument indexedDocument = mapFragment.getIndexedDocument();
    		result.setIndexedDocument(new IndexedDocument(indexedDocument));

	    	com.slb.taxi.webservice.xtm.stubs.xtm.Topic[] topics = mapFragment.getTopicMap().getTopic();
	    	if (null == topics) {
	    		return result;
	    	}

	    	List<SNSEventTopic> eventTopics = new ArrayList<SNSEventTopic>();
	    	List<SNSLocationTopic> locationTopics = new ArrayList<SNSLocationTopic>();
	    	List<SNSTopic> thesaTopics = new ArrayList<SNSTopic>();

	    	for (com.slb.taxi.webservice.xtm.stubs.xtm.Topic topic : topics) {
            	switch (getTopicType(topic)) {
            	case EVENT:
            		eventTopics.add(createEventTopic(topic));
            		break;
            	case LOCATION:
            		SNSLocationTopic locTopic = createLocationTopic(topic);
            		// createLocationTopic returns null for expired topics
            		if (null != locTopic) {
            			locationTopics.add(locTopic);
            		}

            		break;
            	case THESA:
            		thesaTopics.add(convertTopicToSNSTopic(topic));
            		break;
            	}
	    	}
        	result.setEventTopics(eventTopics);
        	result.setLocationTopics(locationTopics);
        	result.setThesaTopics(thesaTopics);
    	}
    	return result;
    }

    private TopicType getTopicType(com.slb.taxi.webservice.xtm.stubs.xtm.Topic topic) {
		String instance = topic.getInstanceOf()[0].getTopicRef().getHref();
//		log.debug("InstanceOf: "+instance);
		if (instance.indexOf("topTermType") != -1 || instance.indexOf("nodeLabelType") != -1
		 || instance.indexOf("descriptorType") != -1 || instance.indexOf("nonDescriptorType") != -1) {
			return TopicType.THESA;

		} else if (instance.indexOf("activityType") != -1 || instance.indexOf("anniversaryType") != -1
				 || instance.indexOf("conferenceType") != -1 || instance.indexOf("disasterType") != -1
				 || instance.indexOf("historicalType") != -1 || instance.indexOf("interYearType") != -1
				 || instance.indexOf("legalType") != -1 || instance.indexOf("observationType") != -1
				 || instance.indexOf("natureOfTheYearType") != -1 || instance.indexOf("publicationType") != -1) {
			return TopicType.EVENT;

		} else { // if instance.indexOf("nationType") != -1 || ...
			return TopicType.LOCATION;
		}
    }

    private SNSEventTopic createEventTopic(com.slb.taxi.webservice.xtm.stubs.xtm.Topic topic) {
    	SNSEventTopic t = new SNSEventTopic();
    	t.setTopicId(topic.getId());
    	t.setName(topic.getBaseName()[0].getBaseNameString().get_value());

    	for (Occurrence occ: topic.getOccurrence()) {
    		if (occ.getInstanceOf().getTopicRef().getHref().endsWith("descriptionOcc")) {
    			if (occ.getScope().getTopicRef()[0].getHref().endsWith("de") && occ.getResourceData() != null)
    				t.setDescription(occ.getResourceData().get_value());

    		} else if (occ.getInstanceOf().getTopicRef().getHref().endsWith("temporalAtOcc")) {        		
    			log.debug("Temporal at: "+occ.getResourceData().get_value());
    			t.setAt(convertTemporalValueToDate(occ.getResourceData().get_value()));

    		} else if (occ.getInstanceOf().getTopicRef().getHref().endsWith("temporalFromOcc")) {        		
    			log.debug("Temporal from: "+occ.getResourceData().get_value());
    			t.setFrom(convertTemporalValueToDate(occ.getResourceData().get_value()));

    		} else if (occ.getInstanceOf().getTopicRef().getHref().endsWith("temporalToOcc")) {        		
    			log.debug("Temporal to: "+occ.getResourceData().get_value());
    			t.setTo(convertTemporalValueToDate(occ.getResourceData().get_value()));
        	}
    	}

    	return t;
    }

    private static SNSTopic convertTopicToSNSTopic(com.slb.taxi.webservice.xtm.stubs.xtm.Topic topic) {
    	Source topicSource = getSourceFromTopic(topic);
    	
//    	log.debug("topic source: " + topicSource);
//    	log.debug("topic type: " + getTypeFromTopic(topic));
    	String topicName = topic.getBaseName(0).getBaseNameString().get_value();
    	if (Source.UMTHES.equals(topicSource)) {
    		SNSTopic snsTopic = new SNSTopic(getTypeFromTopic(topic), topicSource, topic.getId(), topicName, null, null);
    		snsTopic.setInspireList(findInspireTopics(topic));
        	return snsTopic;

    	} else {
    		// if GEMET, then the title is used for the title in SNSTopic and, in case UMTHES is different
    		// the UMTHES value is stored in alternateTitle
    		SNSTopic snsTopic = new SNSTopic(getTypeFromTopic(topic), topicSource, topic.getId(), getGemetTitleFromTopic(topic), topicName, getGemetIdFromTopic(topic));
    		snsTopic.setInspireList(findInspireTopics(topic));
        	return snsTopic;
    	}
    }

    /** NO adding of children !
    /* NOTICE: Type.TOP_TERM can only be determined if term is TreeTerm !!!!!! */
    private SNSTopic convertTermToSNSTopic(Term term) {
    	Type type = getTypeFromTerm(term);
    	String id = term.getId();
    	String name = term.getName();
    	Source topicSource = getSourceFromTerm(term);

    	SNSTopic resultTopic;
    	if (Source.UMTHES.equals(topicSource)) {
    		resultTopic = new SNSTopic(type, topicSource, id, name, null, null);

    	} else {
    		// GEMET
    		resultTopic = new SNSTopic(type, topicSource, id, name, term.getAlternateName(), term.getAlternateId());
    	}

		resultTopic.setInspireList(term.getInspireThemes());
		
    	return resultTopic;
    }

    /** Also adds children ! */
    private SNSTopic convertTreeTermToSNSTopic(TreeTerm treeTerm) {
    	SNSTopic resultTopic = convertTermToSNSTopic(treeTerm);

    	List<TreeTerm> childTerms = treeTerm.getChildren();
		if (childTerms != null) {
			// set up list of mapped children
			List<SNSTopic> childTopics = new ArrayList<SNSTopic>();
			for (Term childTerm : childTerms) {
				SNSTopic childTopic = convertTermToSNSTopic(childTerm);

				// set parent in child
    			List<SNSTopic> parents = new ArrayList<SNSTopic>();
    			parents.add(resultTopic);
    			childTopic.setParents(parents);
				
				childTopics.add(childTopic);
			}
			
			// set children in result
			resultTopic.setChildren(childTopics);
		}

    	return resultTopic;
    }

    private static List<String> findInspireTopics(com.slb.taxi.webservice.xtm.stubs.xtm.Topic topic) {
    	List<String> inspireTopics = new ArrayList<String>();
    	
    	if (null != topic.getOccurrence()) {
	    	for (Occurrence occ: topic.getOccurrence()) {
	    		if (occ.getInstanceOf().getTopicRef().getHref().endsWith("iTheme2007")) {
	    			inspireTopics.add(getInspireTitleFromOccurenceString(occ.getResourceData().get_value()));
	    		}
	    	}
    	}
    	
		return inspireTopics;
	}

    // TODO AW: ENGLISH also!!!
	private static String getInspireTitleFromOccurenceString(String inspireOccurence) {
		if (inspireOccurence != null) {
    		String[] inspireParts = inspireOccurence.split("@");
    		return inspireParts[1];
    	}
		return null;
	}

    private static Source getSourceFromTopic(com.slb.taxi.webservice.xtm.stubs.xtm.Topic topic) {
    	Occurrence occ = getOccurrence(topic, "gemet1.0");
    	if (null != occ) {
    		return Source.GEMET;
    	} else {
        	// If there is no occurence of type 'gemet1.0'
    		return Source.UMTHES;
    	}
    }

    private static Source getSourceFromTerm(Term term) {
    	if (term.getAlternateId() != null) {
    		return Source.GEMET;
    	} else {
    		return Source.UMTHES;
    	}
    }

    private static String getGemetTitleFromTopic(com.slb.taxi.webservice.xtm.stubs.xtm.Topic topic) {
    	Occurrence occ = getOccurrence(topic, "gemet1.0");
    	if (null != occ) {
    		return getGemetTitleFromOccurenceString(occ.getResourceData().get_value());

    	} else {
    		return null;
    	}
    }

    private static String getGemetTitleFromOccurenceString(String gemetOccurence) {
//    	log.debug("gemet occurence string: "+gemetOccurence);
    	// gemetOccurence consists of: ID@GERMAN_TITLE@ENGLISH_TITLE
    	// We return the german title
    	if (gemetOccurence != null) {
    		String[] gemetParts = gemetOccurence.split("@");
//        	log.debug("gemet title: "+gemetParts[1]);
    		return gemetParts[1];

    	} else {
    		return null;
    	}
    }

    private static String getGemetIdFromTopic(com.slb.taxi.webservice.xtm.stubs.xtm.Topic topic) {
    	Occurrence occ = getOccurrence(topic, "gemet1.0");
    	if (null != occ) {
    		return getGemetIdFromOccurenceString(occ.getResourceData().get_value());

    	} else {
    		return null;
    	}
    }

    private static String getGemetIdFromOccurenceString(String gemetOccurence) {
//    	log.debug("gemet occurence string: "+gemetOccurence);
    	if (gemetOccurence != null) {
    		String[] gemetParts = gemetOccurence.split("@");
//        	log.debug("gemet id: "+gemetParts[0]);
    		return gemetParts[0];

    	} else {
    		return null;
    	}
    }


    private static Occurrence getOccurrence(com.slb.taxi.webservice.xtm.stubs.xtm.Topic topic, String occurrenceType) {
    	if (null != topic.getOccurrence()) {
	    	for (Occurrence occ: topic.getOccurrence()) {
	    		if (occ.getInstanceOf().getTopicRef().getHref().endsWith(occurrenceType)) {
	    			return occ;
	    		}
	    	}
    	}

    	// If the occurence was not found
    	return null;
    }

    private Date convertTemporalValueToDate(String dateString) {
		SimpleDateFormat standardDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat yearMonthDateFormat = new SimpleDateFormat("yyyy-MM");
		SimpleDateFormat yearDateFormat = new SimpleDateFormat("yyyy");

    	try { return standardDateFormat.parse(dateString); }
    	catch (java.text.ParseException pe) { log.debug(pe); }

    	try { return yearMonthDateFormat.parse(dateString); }
    	catch (java.text.ParseException pe) { log.debug(pe); }

    	try { return yearDateFormat.parse(dateString); }
    	catch (java.text.ParseException pe) { log.debug(pe); }

    	log.error("Error parsing date: "+dateString);
    	return null;
    }


    private SNSLocationTopic createLocationTopic(com.slb.taxi.webservice.xtm.stubs.xtm.Topic topic) {
    	SNSLocationTopic result = new SNSLocationTopic();
    	result.setTopicId(topic.getId());
    	result.setName(topic.getBaseName(0).getBaseNameString().get_value());
    	String type = topic.getInstanceOf(0).getTopicRef().getHref();
    	type = type.substring(type.lastIndexOf("#")+1);
    	result.setTypeId(type);
    	result.setType(resourceBundle.getString("sns.topic.ref."+type));

    	// If the topic doesn't contain any more information return the basic info
    	if (topic.getOccurrence() == null) {
    		return result;
    	}


    	// Iterate over all occurrences and extract the relevant information (bounding box wgs84 coords and the qualifier)
    	for(int i = 0; i < topic.getOccurrence().length; ++i) {
//    		log.debug(topic.getOccurrence(i).getInstanceOf().getTopicRef().getHref());
    		if (topic.getOccurrence(i).getInstanceOf().getTopicRef().getHref().endsWith("wgs84BoxOcc")) {
//    			log.debug("WGS84 Coordinates: "+topic.getOccurrence(i).getResourceData().get_value());        	            			
        		String coords = topic.getOccurrence(i).getResourceData().get_value();
        		String[] ar = coords.split("\\s|,");
        		if (ar.length == 4) {
        			result.setBoundingBox(new Float(ar[0]), new Float(ar[1]), new Float(ar[2]), new Float(ar[3]));
        		}
    		} else if (topic.getOccurrence(i).getInstanceOf().getTopicRef().getHref().endsWith("qualifier")) {
//    			log.debug("Qualifier: "+topic.getOccurrence(i).getResourceData().get_value());        	            			
        		result.setQualifier(topic.getOccurrence(i).getResourceData().get_value());
    		} else if (topic.getOccurrence(i).getInstanceOf().getTopicRef().getHref().endsWith("nativeKeyOcc")) {
    			String nativeKeyOcc = topic.getOccurrence(i).getResourceData().get_value();
    			String[] keys = nativeKeyOcc.split(" ");
    			for (String nativeKey : keys) {
    				if (nativeKey.startsWith(SNS_NATIVE_KEY_PREFIX)) {
    					result.setNativeKey(nativeKey.substring(SNS_NATIVE_KEY_PREFIX.length()));
    				}
    			}
    		} else if (topic.getOccurrence(i).getInstanceOf().getTopicRef().getHref().endsWith("expiredOcc")) {
                try {
                    Date expiredDate = expiredDateParser.parse(topic.getOccurrence(i).getResourceData().get_value());
                    if ((null != expiredDate) && expiredDate.before(new Date())) {
                        return null;
                    }
                } catch (java.text.ParseException e) {
                    log.error("Not expected date format in sns expiredOcc.", e);
                }
    		}
    	}
    	if (result.getQualifier() == null)
    		result.setQualifier(result.getType());
    	return result;
    }

    private SNSLocationTopic convertLocationToSNSLocation(Location location) {
    	SNSLocationTopic result = new SNSLocationTopic();

    	result.setTopicId(location.getId());
    	result.setName(location.getName());
    	
    	// null if not set !
    	result.setTypeId(location.getTypeId());
    	result.setType(location.getTypeName());
    	result.setBoundingBox(location.getBoundingBox());
   		result.setQualifier(location.getQualifier());
   		result.setNativeKey(location.getNativeKey());
		
    	return result;
    }

	/** Determine Gazetteer MatchingType from passed SNS search type string. */
	private de.ingrid.external.GazetteerService.MatchingType getGazetteerMatchingType(String searchTypeStr) {
		de.ingrid.external.GazetteerService.MatchingType matching;
		if (searchTypeStr == null) {
			matching = de.ingrid.external.GazetteerService.MatchingType.EXACT;
    	} else if ("exact".equalsIgnoreCase(searchTypeStr)) {
    		matching = de.ingrid.external.GazetteerService.MatchingType.EXACT;
    	} else if ("contains".equalsIgnoreCase(searchTypeStr)) {
    		matching = de.ingrid.external.GazetteerService.MatchingType.CONTAINS;
    	} else {
    		matching = de.ingrid.external.GazetteerService.MatchingType.BEGINS_WITH;    		
    	}
		
    	return matching;
	}

	/** Determine Gazetteer QueryType from passed SNS search path. */
	private QueryType getGazetteerQueryType(String pathStr) {

		QueryType queryType = QueryType.ALL_LOCATIONS;
		if ("/location/admin".equals(pathStr)) {
			queryType = QueryType.ONLY_ADMINISTRATIVE_LOCATIONS;
    	}
		
    	return queryType;
	}

    static public class TermComparator implements Comparator<Term> {
    	public final int compare(Term termA, Term termB) {
            try {
            	// Get the collator for the German Locale 
            	Collator gerCollator = Collator.getInstance(Locale.GERMAN);
            	return gerCollator.compare(termA.getName(), termB.getName());
            } catch (Exception e) {
                return 0;
            }
        }
    }
    static public class TopicComparator implements Comparator<Topic> {
    	public final int compare(Topic topicA, Topic topicB) {
            try {
            	// Get the collator for the German Locale 
            	Collator gerCollator = Collator.getInstance(Locale.GERMAN);
            	return gerCollator.compare(topicA.getTopicName(), topicB.getTopicName());
            } catch (Exception e) {
                return 0;
            }
        }
    }
    static public class SNSTopicComparator implements Comparator<SNSTopic> {
    	public final int compare(SNSTopic topicA, SNSTopic topicB) {
            try {
            	// Get the collator for the German Locale 
            	Collator gerCollator = Collator.getInstance(Locale.GERMAN);
            	return gerCollator.compare(topicA.getTitle(), topicB.getTitle());
            } catch (Exception e) {
                return 0;
            }
        }
    }
    static public class SNSLocationTopicComparator implements Comparator<SNSLocationTopic> {
    	public final int compare(SNSLocationTopic topicA, SNSLocationTopic topicB) {
            try {
            	// Get the collator for the German Locale 
            	Collator gerCollator = Collator.getInstance(Locale.GERMAN);
            	String labelA = topicA.getName()+" "+topicA.getQualifier();
            	String labelB = topicB.getName()+" "+topicB.getQualifier();
            	return gerCollator.compare(labelA, labelB);
            } catch (Exception e) {
                return 0;
            }
        }
    }
}
