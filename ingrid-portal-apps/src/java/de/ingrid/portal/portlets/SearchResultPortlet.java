/*
 * **************************************************-
 * Ingrid Portal Apps
 * ==================================================
 * Copyright (C) 2014 - 2015 wemove digital solutions GmbH
 * ==================================================
 * Licensed under the EUPL, Version 1.1 or – as soon they will be
 * approved by the European Commission - subsequent versions of the
 * EUPL (the "Licence");
 * 
 * You may not use this work except in compliance with the Licence.
 * You may obtain a copy of the Licence at:
 * 
 * http://ec.europa.eu/idabc/eupl5
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the Licence is distributed on an "AS IS" basis,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the Licence for the specific language governing permissions and
 * limitations under the Licence.
 * **************************************************#
 */
package de.ingrid.portal.portlets;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletException;
import javax.portlet.PortletSession;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.jetspeed.request.RequestContext;
import org.apache.portals.bridges.common.GenericServletPortlet;
import org.apache.portals.bridges.velocity.GenericVelocityPortlet;
import org.apache.velocity.context.Context;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import de.ingrid.portal.config.PortalConfig;
import de.ingrid.portal.global.CodeListServiceFactory;
import de.ingrid.portal.global.IngridHitsWrapper;
import de.ingrid.portal.global.IngridResourceBundle;
import de.ingrid.portal.global.Settings;
import de.ingrid.portal.global.Utils;
import de.ingrid.portal.global.UtilsFacete;
import de.ingrid.portal.search.QueryPreProcessor;
import de.ingrid.portal.search.QueryResultPostProcessor;
import de.ingrid.portal.search.SearchState;
import de.ingrid.portal.search.UtilsSearch;
import de.ingrid.portal.search.net.QueryDescriptor;
import de.ingrid.portal.search.net.ThreadedQueryController;
import de.ingrid.utils.query.IngridQuery;

/**
 * This portlet handles the "Result Display" fragment of the result page
 * 
 * @author martin@wemove.com
 */
public class SearchResultPortlet extends GenericVelocityPortlet {

    private final static Logger log = LoggerFactory.getLogger(SearchResultPortlet.class);

    /** view templates */
    private final static String TEMPLATE_NO_QUERY_SET = "/WEB-INF/templates/empty.vm";

    private final static String TEMPLATE_RESULT = "/WEB-INF/templates/search_result.vm";

    private final static String TEMPLATE_RESULT_ADDRESS = "/WEB-INF/templates/search_result_address.vm";

    //    private final static String TEMPLATE_NO_RESULT = "/WEB-INF/templates/search_no_result.vm";

    private static final String TEMPLATE_RESULT_JS = "/WEB-INF/templates/search_result_js.vm";

    private static final String TEMPLATE_RESULT_JS_RANKED = "/WEB-INF/templates/search_result_js_ranked.vm";

    private static final String TEMPLATE_RESULT_JS_UNRANKED = "/WEB-INF/templates/search_result_js_unranked.vm";

    private static final String TEMPLATE_RESULT_FILTERED_ONECOLUMN = "/WEB-INF/templates/search_result_iplug.vm";
    
    private HttpClient client;

    /*
     * (non-Javadoc)
     * 
     * @see javax.portlet.Portlet#init(javax.portlet.PortletConfig)
     */
    public void init(PortletConfig config) throws PortletException {
        super.init(config);
        client = new HttpClient();
        client.getHttpConnectionManager().getParams().setConnectionTimeout(1000);
    }

    public void doView(javax.portlet.RenderRequest request, javax.portlet.RenderResponse response)
            throws PortletException, IOException {
        Context context = getContext(request);
        IngridResourceBundle messages = new IngridResourceBundle(getPortletConfig().getResourceBundle(
                request.getLocale()), request.getLocale());
        context.put("MESSAGES", messages);
        context.put("Codelists", CodeListServiceFactory.instance());
        context.put("enableFacete", PortalConfig.getInstance().getBoolean(PortalConfig.PORTAL_ENABLE_SEARCH_FACETE, false));
        
        // add request language, used to localize the map client
        context.put("languageCode",request.getLocale().getLanguage());
        
        PortletSession ps = request.getPortletSession();
                
        if(request.getParameter("filter") != null){
        	if(request.getParameter("filter").equals("domain")){
        		context.put("isFilterDomain", true);
        	}
        }
        // ----------------------------------
        // check for passed RENDER PARAMETERS (for bookmarking) and
        // ADAPT OUR PERMANENT STATE VIA MESSAGES
        // ----------------------------------
        // starthit RANKED

        // WHEN NO GROUPING !!!
        String reqParam = null;
        
        int rankedStartHit = 0;
        try {
            reqParam = request.getParameter(Settings.PARAM_STARTHIT_RANKED);
            if (SearchState.adaptSearchState(request, Settings.PARAM_STARTHIT_RANKED, reqParam)) {
                rankedStartHit = (new Integer(reqParam)).intValue();
            }
        } catch (Exception ex) {
            if (log.isErrorEnabled()) {
                log.error("Problems parsing RANKED starthit from render request, set RANKED starthit to 0 ! reqParam="
                        + reqParam, ex);
            }
        }

        // WHEN GROUPING !!!
        // get the current page number, default to 1
        int currentSelectorPage = 1;
        try {
            reqParam = request.getParameter(Settings.PARAM_CURRENT_SELECTOR_PAGE);
            if (SearchState.adaptSearchState(request, Settings.PARAM_CURRENT_SELECTOR_PAGE, reqParam)) {
                currentSelectorPage = new Integer(reqParam).intValue();
            }
        } catch (Exception ex) {
            if (log.isErrorEnabled()) {
                log.error(
                        "Problems parsing currentSelectorPage from render request, set currentSelectorPage to 1 ! reqParam="
                                + reqParam, ex);
            }
        }

        // starthit UNRANKED

        // NO GROUPING !!!
        // Do we need to read unrankedStartHit, is passed from navi when not grouped but UNRANKED SEARCH IS ALWAYS GROUPED !!!
        int unrankedStartHit = 0;
        try {
            reqParam = request.getParameter(Settings.PARAM_STARTHIT_UNRANKED);
            if (SearchState.adaptSearchState(request, Settings.PARAM_STARTHIT_UNRANKED, reqParam)) {
                unrankedStartHit = (new Integer(reqParam)).intValue();
            }
        } catch (Exception ex) {
            if (log.isErrorEnabled()) {
                log.error(
                        "Problems parsing UNRANKED starthit from render request, set UNRANKED starthit to 0 ! reqParam="
                                + reqParam, ex);
            }
        }

        // GROUPING ONLY !!!
        // UNRANKED SEARCH IS ALWAYS GROUPED !!!
        // get the current page number, default to 1
        int currentSelectorPageUnranked = 1;
        try {
            reqParam = request.getParameter(Settings.PARAM_CURRENT_SELECTOR_PAGE_UNRANKED);
            if (SearchState.adaptSearchState(request, Settings.PARAM_CURRENT_SELECTOR_PAGE_UNRANKED, reqParam)) {
                currentSelectorPageUnranked = new Integer(reqParam).intValue();
            }
        } catch (Exception ex) {
            if (log.isErrorEnabled()) {
                log.error(
                        "Problems parsing currentSelectorPageUnranked from render request, set currentSelectorPageUnranked to 1 ! reqParam="
                                + reqParam, ex);
            }
        }

        // indicates whether we do a query or we read results from cache
        String queryType = (String) SearchState.getSearchStateObject(request, Settings.MSG_QUERY_EXECUTION_TYPE);
        if (queryType == null) {
            queryType = "";
        }

        // get the filter from REQUEST, not search state ! -> so back button works !
        // ALSO ADAPT SEARCH STATE, so following steps (query pre processor) work !
        String filter = request.getParameter(Settings.PARAM_FILTER);
        if (filter != null && filter.length() == 0) {
        	filter = null;
        }
        SearchState.adaptSearchState(request, Settings.PARAM_FILTER, filter);
        String filterSubject = request.getParameter(Settings.PARAM_SUBJECT);
        SearchState.adaptSearchState(request, Settings.PARAM_SUBJECT, filterSubject);        

        // set filter params into context for filter display
        if (filter != null) {
            context.put("filteredBy", filter);
            if (filter.equals(Settings.PARAMV_GROUPING_PARTNER)) {
                context.put("filterSubject", UtilsSearch.mapResultValue(Settings.RESULT_KEY_PARTNER, filterSubject, null));
            } else if (filter.equals(Settings.PARAMV_GROUPING_PROVIDER)) {
                context.put("filterSubject", UtilsSearch.mapResultValue(Settings.RESULT_KEY_PROVIDER, filterSubject, null));
            } else if (filter.equals(Settings.PARAMV_GROUPING_PLUG_ID)) {
                context.put("filterSubject", UtilsSearch.mapResultValue(Settings.RESULT_KEY_PLUG_ID, filterSubject, null));
            } else if (filter.equals(Settings.PARAMV_GROUPING_DOMAIN)) {
            	String[] keyValuePair = UtilsSearch.getDomainKeyValuePair(filterSubject);
            	String domainKey = keyValuePair[0];
            	String domainValue = keyValuePair[1];
            	// domain can be plugid or site or ...
            	// we extract the according value from our subject
            	if (domainKey.equals(Settings.QFIELD_PLUG_ID)) {
            		domainValue = UtilsSearch.mapResultValue(Settings.RESULT_KEY_PLUG_ID, domainValue, null);
            	}
            	context.put("filterSubject", domainValue);
            }
        }

        // datasource from state (set in SimpleSearch Portlet)
        String selectedDS = SearchState.getSearchStateObjectAsString(request, Settings.PARAM_DATASOURCE);

        // IngridQuery from state  (set in SimpleSearch Portlet)
        IngridQuery query = (IngridQuery) SearchState.getSearchStateObject(request, Settings.MSG_QUERY);
        
        // change datasource dependent from query input
        selectedDS = UtilsSearch.determineFinalPortalDatasource(selectedDS, query);

        // ----------------------------------
        // set initial view template
        // ----------------------------------

        // if no query set display "nothing"
        if (query == null) {
            setDefaultViewPage(TEMPLATE_NO_QUERY_SET);
            super.doView(request, response);
            return;
        }

        // selected data source ("Umweltinfo", Adressen" or "Forschungsprojekte")
        if (selectedDS == null) {
            selectedDS = Settings.SEARCH_INITIAL_DATASOURCE;
        }
        if (selectedDS.equals(Settings.PARAMV_DATASOURCE_ADDRESS)) {
            setDefaultViewPage(TEMPLATE_RESULT_ADDRESS);
        } else {
            setDefaultViewPage(TEMPLATE_RESULT);

            // default: right column IS grouped (by plugid)
        	// set in context e.g. to show grouped navigation
        	context.put("grouping_right", new Boolean(true));

            if (filter != null) {
            	// set one column result template if "Zeige alle ..." of plug or domain
            	if (filter.equals(Settings.PARAMV_GROUPING_PLUG_ID) ||
            		filter.equals(Settings.PARAMV_GROUPING_DOMAIN)) {
                    setDefaultViewPage(TEMPLATE_RESULT_FILTERED_ONECOLUMN);
                	// only one column to render we switch off grouping_right to show ungrouped navigation !
                    context.put("grouping_right", new Boolean(false));
            	}
            }
        }
        // check whether right column is switched OFF and set according context flag
        boolean rightColumnDisabled =
        	!PortalConfig.getInstance().getBoolean(PortalConfig.PORTAL_ENABLE_SEARCH_RESULTS_UNRANKED, true);
        context.put("RIGHT_COLUMN_DISABLED", rightColumnDisabled);


        String currentView = getDefaultViewPage();

        // ----------------------------------
        // business logic
        // ----------------------------------

        // check for Javascript
        boolean hasJavaScript = Utils.isJavaScriptEnabled(request);
        
        // determine whether we have to render only one result column
        boolean renderResultColumnRanked = true;
        boolean renderResultColumnUnranked = true;
        reqParam = request.getParameter("js_ranked");
        // finally disable query for right column if switched OFF !
        if (rightColumnDisabled) {
        	renderResultColumnUnranked = false;
        }

        // create threaded query controller
        ThreadedQueryController controller = new ThreadedQueryController();
        controller.setTimeout(PortalConfig.getInstance().getInt(PortalConfig.QUERY_TIMEOUT_THREADED, 120000));

        QueryDescriptor qd = null;

        // store query in session
        UtilsSearch.addQueryToHistory(request);

        // RANKED
        IngridHitsWrapper rankedHits = null;
        if (renderResultColumnRanked) {
        	if(reqParam == null){
	            // check if query must be executed
	            if (queryType.equals(Settings.MSGV_NO_QUERY) || queryType.equals(Settings.MSGV_UNRANKED_QUERY)) {
	                rankedHits = (IngridHitsWrapper) SearchState.getSearchStateObject(request, Settings.MSG_SEARCH_RESULT_RANKED);
	                if (log.isDebugEnabled()) {
	                    log.debug("Read RANKED hits from CACHE !!! rankedHits=" + rankedHits);
	                }
	            } else {
	                String queryString = request.getParameter(Settings.PARAM_QUERY_STRING);
	                if(queryString == null){
	                    rankedHits = (IngridHitsWrapper) SearchState.getSearchStateObject(request, Settings.MSG_SEARCH_RESULT_RANKED);
	                }

	                if(rankedHits == null){
	                    // process query, create QueryDescriptor
	                    qd = QueryPreProcessor.createRankedQueryDescriptor(request);
	                    if (qd != null) {
	                        controller.addQuery("ranked", qd);
	                        SearchState.resetSearchStateObject(request, Settings.MSG_SEARCH_FINISHED_RANKED);
	                    }
	                }
	            }
	        }
        }else{
			if(queryType.equals(Settings.MSGV_UNRANKED_QUERY)){
				if(ps.getAttribute("isPagingUnranked") != null && ps.getAttribute("isPagingUnranked").equals(currentSelectorPageUnranked + "")){
    				ps.removeAttribute("isPagingUnranked");
    				rankedHits = (IngridHitsWrapper) SearchState.getSearchStateObject(request, Settings.MSG_SEARCH_RESULT_RANKED);
	                if (log.isDebugEnabled()) {
	                    log.debug("Read RANKED hits from CACHE !!! rankedHits=" + rankedHits);
	                }
                }else{
                    String queryString = request.getParameter(Settings.PARAM_QUERY_STRING);
                    if(queryString == null){
                        rankedHits = (IngridHitsWrapper) SearchState.getSearchStateObject(request, Settings.MSG_SEARCH_RESULT_RANKED);
                    }
                    
                    if(rankedHits == null){
                    	// process query, create QueryDescriptor
    	                qd = QueryPreProcessor.createRankedQueryDescriptor(request);
    	                if (qd != null) {
    	                    controller.addQuery("ranked", qd);
    	                    SearchState.resetSearchStateObject(request, Settings.MSG_SEARCH_FINISHED_RANKED);
    	                }
                    }
                }
			}
        }

        // UNRANKED
        IngridHitsWrapper unrankedHits = null;
    	if (renderResultColumnUnranked) {
    		if(reqParam != null && reqParam.equals("false") || !hasJavaScript){
				if (!currentView.equals(TEMPLATE_RESULT_ADDRESS)) {
	                // check if query must be executed
	                if (queryType.equals(Settings.MSGV_NO_QUERY) || queryType.equals(Settings.MSGV_RANKED_QUERY)) {
	                    if(!currentView.equals(TEMPLATE_RESULT_FILTERED_ONECOLUMN)){
	                    	unrankedHits = (IngridHitsWrapper) SearchState.getSearchStateObject(request,
	                                Settings.MSG_SEARCH_RESULT_UNRANKED);
	                        if (log.isDebugEnabled()) {
	                            log.debug("Read UNRANKED hits from CACHE !!!! unrankedHits=" + unrankedHits);
	                        }
	                    }else{
	                        String queryString = request.getParameter(Settings.PARAM_QUERY_STRING);
	                        if(queryString == null){
	                            unrankedHits = (IngridHitsWrapper) SearchState.getSearchStateObject(request, Settings.MSG_SEARCH_RESULT_UNRANKED);
	                        }
	                        
	                        if(unrankedHits == null){
    	                    	// process query, create QueryDescriptor
    	                        qd = QueryPreProcessor.createUnrankedQueryDescriptor(request);
    	                        if (qd != null) {
    	                            controller.addQuery("unranked", qd);
    	                            SearchState.resetSearchStateObject(request, Settings.MSG_SEARCH_FINISHED_UNRANKED);
    	                        }
	                        }
	                    }
	                }else {
	                    String queryString = request.getParameter(Settings.PARAM_QUERY_STRING);
                        if(queryString == null){
                            unrankedHits = (IngridHitsWrapper) SearchState.getSearchStateObject(request, Settings.MSG_SEARCH_RESULT_UNRANKED);
                        }
                        
                        if(unrankedHits == null){
    	                    // process query, create QueryDescriptor
    	                    qd = QueryPreProcessor.createUnrankedQueryDescriptor(request);
    	                    if (qd != null) {
    	                        controller.addQuery("unranked", qd);
    	                        SearchState.resetSearchStateObject(request, Settings.MSG_SEARCH_FINISHED_UNRANKED);
    	                    }
                        }
	                }
    			}
    		}else{
    			if(queryType.equals(Settings.MSGV_RANKED_QUERY)){
    				if(ps.getAttribute("isPagingRanked") != null && ps.getAttribute("isPagingRanked").equals(currentSelectorPage + "")){
        				ps.removeAttribute("isPagingRanked");
        				unrankedHits = (IngridHitsWrapper) SearchState.getSearchStateObject(request,
                                Settings.MSG_SEARCH_RESULT_UNRANKED);
                        if (log.isDebugEnabled()) {
                            log.debug("Read UNRANKED hits from CACHE !!!! unrankedHits=" + unrankedHits);
                        }
                    }else{
                        String queryString = request.getParameter(Settings.PARAM_QUERY_STRING);
                        if(queryString == null){
                            unrankedHits = (IngridHitsWrapper) SearchState.getSearchStateObject(request, Settings.MSG_SEARCH_RESULT_UNRANKED);
                        }
                        
                        if(unrankedHits == null){
                        	// process query, create QueryDescriptor
    	                    qd = QueryPreProcessor.createUnrankedQueryDescriptor(request);
    	                    if (qd != null) {
    	                        controller.addQuery("unranked", qd);
    	                        SearchState.resetSearchStateObject(request, Settings.MSG_SEARCH_FINISHED_UNRANKED);
    	                    }
                        }
                    }
    			}
            }
        }

        // get possible changes AFTER PREPROCESSING QUERY !!!

        // Grouping may have changed !
        String grouping = (String) SearchState.getSearchStateObject(request, Settings.PARAM_GROUPING);

        // fire query, post process results
        boolean rankedColumnHasMoreGroupedPages = true;
        if (controller.hasQueries()) {
            // fire queries
            Map<Object, Object> results = controller.search();
            
            // check for zero results
            // log the result to the resource logger
            Iterator<Object> it = results.keySet().iterator();
            boolean noResults = true;
            String queryTypes = "";
            while (it.hasNext()) {
                Object key = it.next();
                if (queryTypes.length() > 0) {
                    queryTypes = queryTypes.concat(",");
                } else {
                    queryTypes = queryTypes.concat(key.toString());
                }
                IngridHitsWrapper hits = (IngridHitsWrapper)results.get(key);
                if (hits != null && hits.length() > 0) {
                    noResults = false;
                    break;
                }
            }
            if (noResults) {
                
                String url = PortalConfig.getInstance().getString(PortalConfig.PORTAL_LOGGER_RESOURCE);
                if (url != null) {
                    String queryString = SearchState.getSearchStateObjectAsString(request, Settings.PARAM_QUERY_STRING);                
                    HttpMethod method = null;
	                try{
	                    url = url.concat("?code=NO_RESULTS_FOR_QUERY&q=").concat(URLEncoder.encode(queryString, "UTF-8")).concat("&qtypes=").concat(URLEncoder.encode(queryTypes, "UTF-8"));
	                    method = new GetMethod(url);
	                    method.setFollowRedirects(true);
	                    client.executeMethod(method);
	                } catch (Throwable t) {
	                    if (log.isErrorEnabled()) {
	                        log.error("Cannot make connection to logger resource: ".concat(url), t);
	                    }
	                } finally {
	                    if (method != null) {
	                        try{
	                            method.releaseConnection();
	                        } catch (Throwable t) {
	                            if (log.isErrorEnabled()) {
	                                log.error("Cannot close connection to logger resource: ".concat(url), t);
	                            }
	                        }
	                    }
	                }
                }
            }
            
            
            // post process ranked hits if exists
            if (results.containsKey("ranked")) {
                rankedHits = QueryResultPostProcessor.processRankedHits((IngridHitsWrapper) results.get("ranked"), selectedDS);
                SearchState.adaptSearchState(request, Settings.MSG_SEARCH_RESULT_RANKED, rankedHits);
                SearchState.adaptSearchState(request, Settings.MSG_SEARCH_FINISHED_RANKED, Settings.MSGV_TRUE);

                // GROUPING ONLY !!!
                if (grouping != null && !grouping.equals(IngridQuery.GROUPED_OFF)) {
                    // get the grouping starthits history from session
                    // create and initialize if not exists
                	// NOTICE: when grouping by domain the navigation is like ungrouped navigation, so multiple pages are rendered !
                    try {
                        @SuppressWarnings("unchecked")
                        List<Object> groupedStartHits = 
                        	(List<Object>) SearchState.getSearchStateObject(request, Settings.PARAM_GROUPING_STARTHITS);
                        if (groupedStartHits == null) {
                            groupedStartHits = new ArrayList<Object>();
                            SearchState.adaptSearchState(request, Settings.PARAM_GROUPING_STARTHITS, groupedStartHits);
                        }
                        // set starthit of NEXT page ! ensure correct size of Array ! Notice: currentSelectorPage is 1 for first page !
                    	while (currentSelectorPage >= groupedStartHits.size()) {
                    		groupedStartHits.add(new Integer(0));
                    	}
                        // set start hit for next page (grouping)
                    	int nextStartHit = rankedHits.getGoupedHitsLength();
                        groupedStartHits.set(currentSelectorPage, new Integer(nextStartHit));

                        // check whether there are more pages for grouped hits ! this is done due to former Bug in Backend !
                        // still necessary ? well, these former checks don't damage anything ...
                        if (rankedHits.length() <= rankedHits.getGoupedHitsLength()) {
                            // total number of hits (ungrouped) already processed -> no more pages
                        	rankedColumnHasMoreGroupedPages = false;                        	
                        } else {
                        	int currentStartHit = ((Integer) groupedStartHits.get(currentSelectorPage - 1)).intValue();
                        	if (nextStartHit == currentStartHit) {
                                // start hit for next page same as start hit for current page -> no more pages
                            	rankedColumnHasMoreGroupedPages = false;
                        	}
                        }
                    } catch (Exception ex) {
                        if (log.isInfoEnabled()) {
                            log.info("Problems processing grouping starthits RANKED", ex);
                        }
                    }
                }

            }
            // post process unranked hits if exists
            if (results.containsKey("unranked")) {
                unrankedHits = QueryResultPostProcessor.processUnrankedHits((IngridHitsWrapper) results.get("unranked"),
                        selectedDS);
                SearchState.adaptSearchState(request, Settings.MSG_SEARCH_RESULT_UNRANKED, unrankedHits);
                SearchState.adaptSearchState(request, Settings.MSG_SEARCH_FINISHED_UNRANKED, Settings.MSGV_TRUE);
                // get the grouping starthits history from session
                // create and initialize if not exists
                try {
                    @SuppressWarnings("unchecked")
                    List<Object> groupedStartHits = 
                    	(List<Object>) SearchState.getSearchStateObject(request, Settings.PARAM_GROUPING_STARTHITS_UNRANKED);
                    if (groupedStartHits == null || unrankedHits == null) {
                        groupedStartHits = new ArrayList<Object>();
                        groupedStartHits.add(new Integer(0));
                        SearchState.adaptSearchState(request, Settings.PARAM_GROUPING_STARTHITS_UNRANKED,
                                groupedStartHits);
                    } else {
                        // set start hit for next page (grouping)
                    	int nextStartHit = unrankedHits.getGoupedHitsLength();
                        groupedStartHits.add(currentSelectorPageUnranked, new Integer(nextStartHit));
                    }
                } catch (Exception ex) {
                    if (log.isDebugEnabled()) {
                        log.debug("Problems processing grouping starthits UNRANKED", ex);
                    }
                    if (log.isInfoEnabled()) {
                        log.info("Problems processing grouping starthits UNRANKED. switch to debug level to get the exception logged.");
                    }
                }
            }
        }

        int totalNumberOfRankedHits = 0;
        if (rankedHits != null) {
            totalNumberOfRankedHits = (int) rankedHits.length();
        }
        // adapt settings of ranked page navigation
        Map<String, Object> rankedPageNavigation = UtilsSearch.getPageNavigation(rankedStartHit,
                Settings.SEARCH_RANKED_HITS_PER_PAGE, totalNumberOfRankedHits,
                Settings.SEARCH_RANKED_NUM_PAGES_TO_SELECT);

        int totalNumberOfUnrankedHits = 0;
        if (unrankedHits != null) {
            if (filter != null && filter.equals(Settings.RESULT_KEY_PLUG_ID)) {
                totalNumberOfUnrankedHits = (int) unrankedHits.length();
            } else {
                totalNumberOfUnrankedHits = unrankedHits.getInVolvedPlugs();
            }
        }
        // adapt settings of unranked page navigation
        Map<String, Object> unrankedPageNavigation = UtilsSearch.getPageNavigation(unrankedStartHit,
                Settings.SEARCH_UNRANKED_HITS_PER_PAGE, totalNumberOfUnrankedHits,
                Settings.SEARCH_UNRANKED_NUM_PAGES_TO_SELECT);

        Object rankedSearchFinished = SearchState.getSearchStateObject(request, Settings.MSG_SEARCH_FINISHED_RANKED);
        Object unrankedSearchFinished = SearchState.getSearchStateObject(request, Settings.MSG_SEARCH_FINISHED_UNRANKED);
        /*
         // DON'T SHOW separate Template when no results ! This one is never displayed when JS is active and search is performed
         // initially (cause then always two columns are rendered (via iframes)). Only afterwards, e.g. when similar terms are
         // clicked, this template is displayed, causing changes of result content (when similar terms are displayed).
         // WE DON'T WANT TO CHANGE RESULTS CONTENT, WHEN SIMILAR TERMS ARE CKLICKED (DO we ???)
         if (rankedSearchFinished != null && unrankedSearchFinished != null && numberOfRankedHits == 0
         && numberOfUnrankedHits == 0 && (renderOneResultColumnUnranked && renderOneResultColumnRanked)
         && filter.length() == 0) {
         // query string will be displayed when no results !
         String queryString = SearchState.getSearchStateObjectAsString(request, Settings.PARAM_QUERY_STRING);
         context.put("queryString", queryString);

         setDefaultViewPage(TEMPLATE_NO_RESULT);
         super.doView(request, response);
         return;
         }
         */
        // ----------------------------------
        // prepare view
        // ----------------------------------

        // GROUPING
        // adapt page navigation for grouping in left column 
        if (renderResultColumnRanked) {
            if (grouping != null && !grouping.equals(IngridQuery.GROUPED_OFF)) {
            	UtilsSearch.adaptRankedPageNavigationToGrouping(
               		rankedPageNavigation, currentSelectorPage, rankedColumnHasMoreGroupedPages, totalNumberOfRankedHits, request);

                if (grouping.equals(IngridQuery.GROUPED_BY_PARTNER)) {
                    context.put("grouping", "partner");
                } else if (grouping.equals(IngridQuery.GROUPED_BY_ORGANISATION)) {
                    context.put("grouping", "provider");
                } else if (grouping.equals(IngridQuery.GROUPED_BY_DATASOURCE)) {
                    context.put("grouping", "domain");
                }
            }
        }
        // adapt page navigation for right column (always grouped)
        if (renderResultColumnUnranked) {
            unrankedPageNavigation.put(Settings.PARAM_CURRENT_SELECTOR_PAGE_UNRANKED, new Integer(
                    currentSelectorPageUnranked));
            // check if we have more results to come
            if (unrankedHits != null) {
                int groupedHitsLength = unrankedHits.getGoupedHitsLength();
                if (groupedHitsLength > 0 && totalNumberOfUnrankedHits > 0) {
                    if (totalNumberOfUnrankedHits <= groupedHitsLength) {
                        unrankedPageNavigation.put("selectorHasNextPage", new Boolean(false));
                    } else {
                        unrankedPageNavigation.put("selectorHasNextPage", new Boolean(true));
                    }
                }
            }
        }

        boolean showAdminContent = false;
        if (request.getUserPrincipal() != null) {
        	showAdminContent = request.getUserPrincipal().getName().equals("admin");
        }
        
     // check for one column rendering
        if (reqParam != null) {
            // check if we have to render only the ranked column
            if (reqParam.equals("true")) {
                request.setAttribute(GenericServletPortlet.PARAM_VIEW_PAGE, TEMPLATE_RESULT_JS_RANKED);
                renderResultColumnUnranked = false;
            } else {
                request.setAttribute(GenericServletPortlet.PARAM_VIEW_PAGE, TEMPLATE_RESULT_JS_UNRANKED);
                renderResultColumnRanked = false;
            }
            // check for js enabled iframe rendering

        } else if (currentView.equals(TEMPLATE_RESULT_FILTERED_ONECOLUMN)) {
        	if (filter.equals(Settings.PARAMV_GROUPING_PLUG_ID) && rankedHits == null) {
                renderResultColumnRanked = false;
                context.put("IS_RANKED", new Boolean(false));
        	} else {
        		// grouping by domain
                renderResultColumnUnranked = false;
                context.put("IS_RANKED", new Boolean(true));
        	}

        } else if (currentView.equals(TEMPLATE_RESULT_ADDRESS)) {
            renderResultColumnUnranked = false;
            context.put("ds", request.getParameter("ds"));
            
            // check for js enabled iframe rendering
        } else if (hasJavaScript && queryType.equals(Settings.MSGV_NEW_QUERY)) {
            // if javascript and new query, set template to javascript enabled iframe template
            // exit method!!
            request.setAttribute(GenericServletPortlet.PARAM_VIEW_PAGE, TEMPLATE_RESULT_JS);
            
            context.put("ds", request.getParameter("ds"));
            
            if(rankedHits != null){
            	if(PortalConfig.getInstance().getBoolean(PortalConfig.PORTAL_ENABLE_SEARCH_FACETE, false)){
            		UtilsFacete.checkForExistingFacete((IngridHitsWrapper) rankedHits, request);
	                UtilsFacete.setParamsToContext(request, context, true);
            	}
            }
            
            context.put("adminContent", showAdminContent);
            context.put("rankedPageSelector", rankedPageNavigation);
            context.put("rankedResultList", rankedHits);
            context.put("rankedSearchFinished", rankedSearchFinished);
            context.put("unrankedResultUrl", response.encodeURL(((RequestContext) request
                    .getAttribute(RequestContext.REQUEST_PORTALENV)).getRequest().getContextPath()
                    + "/portal/search-result-js.psml"
                    + SearchState.getURLParamsMainSearch(request)
                    + "&js_ranked=false"));
            super.doView(request, response);
            return;
        }
        
        context.put("adminContent", showAdminContent);
        context.put("rankedPageSelector", rankedPageNavigation);
        context.put("unrankedPageSelector", unrankedPageNavigation);
        if(rankedHits != null){
        	if(PortalConfig.getInstance().getBoolean(PortalConfig.PORTAL_ENABLE_SEARCH_FACETE, false)){
                UtilsFacete.checkForExistingFacete((IngridHitsWrapper) rankedHits, request);
	            UtilsFacete.setParamsToContext(request, context, true);
        	}
        }
        context.put("rankedResultList", rankedHits);
        context.put("unrankedResultList", unrankedHits);
        context.put("rankedSearchFinished", rankedSearchFinished);
        context.put("unrankedSearchFinished", unrankedSearchFinished);
        //context.put("providerMap", getProviderMap());

        super.doView(request, response);
    }

    /**
     * Get provider to be able to map them from their abbreviation. 
     * @return a map of short:long values of the provider
     */
    /*private HashMap<String, String> getProviderMap() {
        HashMap<String, String> providerMap = new HashMap<String, String>();
        List<IngridProvider> providers = UtilsDB.getProviders();
        
        for (IngridProvider ingridProvider : providers) {
            providerMap.put(ingridProvider.getIdent(), ingridProvider.getName());
        }
        return providerMap;
    }*/

    public void processAction(ActionRequest request, ActionResponse actionResponse) throws PortletException,
            IOException {
        // check whether page navigation was clicked and send according message (Search state)
    	PortletSession ps = request.getPortletSession();
        
        // NO GROUPING
        String rankedStarthit = request.getParameter(Settings.PARAM_STARTHIT_RANKED);
        if (rankedStarthit != null) {
            SearchState.adaptSearchState(request, Settings.MSG_QUERY_EXECUTION_TYPE, Settings.MSGV_RANKED_QUERY);
            SearchState.adaptSearchState(request, Settings.PARAM_STARTHIT_RANKED, rankedStarthit);
        }
        String unrankedStarthit = request.getParameter(Settings.PARAM_STARTHIT_UNRANKED);
        if (unrankedStarthit != null) {
            SearchState.adaptSearchState(request, Settings.MSG_QUERY_EXECUTION_TYPE, Settings.MSGV_UNRANKED_QUERY);
            SearchState.adaptSearchState(request, Settings.PARAM_STARTHIT_UNRANKED, unrankedStarthit);
        }

        // GROUPING
        // currentSelectorPage is set, send according message (Search state)
        String currentSelectorPage = request.getParameter(Settings.PARAM_CURRENT_SELECTOR_PAGE);
        if (currentSelectorPage != null) {
            SearchState.adaptSearchState(request, Settings.MSG_QUERY_EXECUTION_TYPE, Settings.MSGV_RANKED_QUERY);
            SearchState.adaptSearchState(request, Settings.PARAM_CURRENT_SELECTOR_PAGE, currentSelectorPage);
            ps.setAttribute("isPagingRanked", currentSelectorPage);
        }
        // currentSelectorPageUnranked is set, send according message (Search state)
        String currentSelectorPageUnranked = request.getParameter(Settings.PARAM_CURRENT_SELECTOR_PAGE_UNRANKED);
        if (currentSelectorPageUnranked != null) {
            SearchState.adaptSearchState(request, Settings.MSG_QUERY_EXECUTION_TYPE, Settings.MSGV_UNRANKED_QUERY);
            SearchState.adaptSearchState(request, Settings.PARAM_CURRENT_SELECTOR_PAGE_UNRANKED,
                    currentSelectorPageUnranked);
            ps.setAttribute("isPagingUnranked", currentSelectorPage);
        }

        // adapt filter params, set state only if we do have a subject
        // avoid reset the states while browsing the resultpages
        if (request.getParameter(Settings.PARAM_SUBJECT) != null) {
            SearchState.adaptSearchState(request, Settings.PARAM_SUBJECT, request.getParameter(Settings.PARAM_SUBJECT));
            SearchState.adaptSearchState(request, Settings.PARAM_FILTER, request.getParameter(Settings.PARAM_GROUPING));
        }
        
        String url = "";
        
        if(PortalConfig.getInstance().getBoolean(PortalConfig.PORTAL_ENABLE_SEARCH_FACETE, false)){
            url = UtilsFacete.setFaceteParamsToSessionByAction(request, actionResponse);
        }
        
        boolean doRemoveFilter = Boolean.parseBoolean(request.getParameter("doRemoveFilter")); 
        // redirect to our page wih parameters for bookmarking
        if(doRemoveFilter){
        	// reset filter and grouping and page selector
        	SearchState.adaptSearchState(request, Settings.PARAM_GROUPING, "");
    		SearchState.adaptSearchState(request, Settings.PARAM_SUBJECT, "");
        	SearchState.adaptSearchState(request, Settings.PARAM_FILTER, "");
        	SearchState.adaptSearchState(request, Settings.PARAM_CURRENT_SELECTOR_PAGE, 1);
        	SearchState.adaptSearchState(request, Settings.PARAM_STARTHIT_RANKED, 0);
    		SearchState.adaptSearchState(request, Settings.PARAM_CURRENT_SELECTOR_PAGE_UNRANKED, 1);
    		SearchState.adaptSearchState(request, Settings.PARAM_STARTHIT_UNRANKED, 0);
    		actionResponse.sendRedirect(actionResponse.encodeURL(Settings.PAGE_SEARCH_RESULT + SearchState.getURLParamsMainSearch(request)) + ps.getAttribute("facetsURL"));
        }else{
        	if(!url.equals(ps.getAttribute("facetsURL"))){
        		ps.setAttribute("facetsURL", url);
        		// reset page and page selector by facets activity
        		SearchState.adaptSearchState(request, Settings.PARAM_GROUPING, "");
        		SearchState.adaptSearchState(request, Settings.PARAM_CURRENT_SELECTOR_PAGE, 1);
        		SearchState.adaptSearchState(request, Settings.PARAM_STARTHIT_RANKED, 0);
        		SearchState.adaptSearchState(request, Settings.PARAM_CURRENT_SELECTOR_PAGE_UNRANKED, 1);
        		SearchState.adaptSearchState(request, Settings.PARAM_STARTHIT_UNRANKED, 0);
        	}
        	actionResponse.sendRedirect(actionResponse.encodeURL(Settings.PAGE_SEARCH_RESULT + SearchState.getURLParamsMainSearch(request)) + url);
        }
    }



}
