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
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletException;
import javax.portlet.PortletRequest;
import javax.portlet.PortletSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.portals.bridges.velocity.AbstractVelocityMessagingPortlet;
import org.apache.velocity.context.Context;

import de.ingrid.portal.config.IngridSessionPreferences;
import de.ingrid.portal.config.PortalConfig;
import de.ingrid.portal.forms.ServiceSearchForm;
import de.ingrid.portal.global.IngridResourceBundle;
import de.ingrid.portal.global.Settings;
import de.ingrid.portal.global.Utils;
import de.ingrid.portal.global.UtilsDB;
import de.ingrid.portal.global.UtilsString;
import de.ingrid.portal.search.QueryPreProcessor;
import de.ingrid.portal.search.SearchState;
import de.ingrid.portal.search.UtilsSearch;
import de.ingrid.utils.query.ClauseQuery;
import de.ingrid.utils.query.FieldQuery;
import de.ingrid.utils.query.IngridQuery;
import de.ingrid.utils.queryparser.QueryStringParser;

public class ServiceSearchPortlet extends AbstractVelocityMessagingPortlet {

    private final static Logger log = LoggerFactory.getLogger(ServiceSearchPortlet.class);

    public void init(PortletConfig config) throws PortletException {
        // set our message "scope" for inter portlet messaging
        setTopic(Settings.MSG_TOPIC_SERVICE);

        super.init(config);
    }

    public void doView(javax.portlet.RenderRequest request, javax.portlet.RenderResponse response)
            throws PortletException, IOException {
        Context context = getContext(request);
        IngridResourceBundle messages = new IngridResourceBundle(getPortletConfig().getResourceBundle(
                request.getLocale()), request.getLocale());
        context.put("MESSAGES", messages);
        
        context.put("UtilsString", new UtilsString());

        // check for enabled search term field
        context.put("enable_searchterm", PortalConfig.getInstance().getBoolean(
                PortalConfig.PORTAL_ENABLE_SEARCH_SERVICES_SEARCHTERM, Boolean.FALSE));
        
        // check for enabled grouping field
        context.put("enable_grouping", PortalConfig.getInstance().getBoolean(
                PortalConfig.PORTAL_ENABLE_SEARCH_SERVICES_GROUPING, Boolean.FALSE));

        // check for enabled provider field
        context.put("enable_provider", PortalConfig.getInstance().getBoolean(
                PortalConfig.PORTAL_ENABLE_SEARCH_SERVICES_PROVIDER, Boolean.FALSE));

        context.put("enable_category", PortalConfig.getInstance().getString(PortalConfig.PORTAL_ENABLE_SEARCH_SERVICES_CATEGORY, "0"));
        
        // ----------------------------------
        // check for passed URL PARAMETERS (for bookmarking)
        // ----------------------------------
        // action indicates what to do !
        String action = request.getParameter(Settings.PARAM_ACTION);
        if (action == null) {
            action = "";
        }
        // indicates whether form parameters were passed -> then we're called from Service page !
        String grouping = request.getParameter(Settings.PARAM_GROUPING);

        // search if
        // - new search submitted
        // - called from teaser
        // - parameters are passed, so maybe we process bookmark !
        boolean doSearch = false;
        if (action.equals(Settings.PARAMV_ACTION_NEW_SEARCH) || action.equals(Settings.PARAMV_ACTION_FROM_TEASER)
                || grouping != null) {
            // remove query message for result portlet -> no results
            cancelRenderMessage(request, Settings.MSG_QUERY);
            doSearch = true;
        }

        // ----------------------------------
        // set data for view template 
        // ----------------------------------

        // get rubrics
        List rubrics = UtilsDB.getServiceRubrics();
        context.put("rubricList", rubrics);

        // check for portal restricted to only one partner
        String partnerRestriction = PortalConfig.getInstance().getString(
                PortalConfig.PORTAL_SEARCH_RESTRICT_PARTNER);
        boolean isPartnerRestrictionEnabled = false;
        if (partnerRestriction != null && partnerRestriction.length() > 0) {
        	isPartnerRestrictionEnabled = true;
        }
        
        if (!isPartnerRestrictionEnabled) {
            // get partners, if not restricted
            context.put("partnerList", UtilsDB.getPartners());
        } else {
            // get providers of the restrected partner if the portal is restricted
            context.put("onePartnerOnly", "true");
            context.put("partnerList", UtilsDB.getProvidersFromPartnerKey(partnerRestriction));
        }

        // update ActionForm !
        ServiceSearchForm af = (ServiceSearchForm) Utils.getActionForm(request, ServiceSearchForm.SESSION_KEY,
                ServiceSearchForm.class, PortletSession.APPLICATION_SCOPE);
        // if no initial rubric selection set, set it and initialize the form (first instantiation)
        if (ServiceSearchForm.getINITIAL_RUBRIC().length() == 0) {
            // compute initial selection string for all rubrics and initialize selection
            ServiceSearchForm.setInitialSelectedRubrics(rubrics);
            af.init();
        }
        
        if (action.equals(Settings.PARAMV_ACTION_NEW_SEARCH)) {
            // empty form on new search
            af.clear();
        } else if (action.equals(Settings.PARAMV_ACTION_FROM_TEASER)) {
            // default values when called from teaser
            af.init();
        } else if (grouping == null) {
            // no URL parameters, we're called from other page -> default values
            af.init();
        }

        // preset the provider selected in the simple search form
        if (isPartnerRestrictionEnabled) {
            // get selected provider
            IngridSessionPreferences sessionPrefs = Utils.getSessionPreferences(request,
                    IngridSessionPreferences.SESSION_KEY, IngridSessionPreferences.class);
            String provider = (String) sessionPrefs.get(IngridSessionPreferences.RESTRICTING_PROVIDER);
            if (provider != null) {
                af.setInput(ServiceSearchForm.FIELD_PARTNER, provider);
            }
        }
        
        // replaces only the ones in request
        af.populate(request);

        // check for "zeige alle Ergebnisse von" and set the form fields accordingly
        String[] subjects = request.getParameterValues(Settings.PARAM_SUBJECT);
        if (subjects != null && subjects.length > 0) {
            if (af.getInput(ServiceSearchForm.FIELD_GROUPING).equals(Settings.PARAMV_GROUPING_PARTNER)) {
                af.setInput(ServiceSearchForm.FIELD_PARTNER, subjects);
            } else if (af.getInput(ServiceSearchForm.FIELD_GROUPING).equals(Settings.PARAMV_GROUPING_PROVIDER)) {
                // NOTICE: "hidden field" in ActionForm encapsulates passed providers (no real field for this one)
                // will only be cleared, if new Action in Form is performed (see processAction() ...
                // in result portlet, the parameters will automatically be generated also for this one (e.g.
                // for page navigation)
                af.setInput(ServiceSearchForm.STORAGE_PROVIDER, subjects);
                /*
                 * If partner restriction is enabled, the partner list box is filled 
                 * with providers. Therefore we set the partner field to the provider
                 * to ensure the selection of the selected provider in the listbox.
                 */
                if (isPartnerRestrictionEnabled) {
                	af.setInput(ServiceSearchForm.FIELD_PARTNER, subjects);
                }
            }
            af.setInput(ServiceSearchForm.FIELD_GROUPING, "none");
        }

        context.put("actionForm", af);

        // validate via ActionForm
        if (!af.validate()) {
            super.doView(request, response);
            return;
        }

        // ----------------------------------
        // prepare Search, Search will be performed in Result portlet 
        // ----------------------------------
        if (doSearch || PortalConfig.getInstance().getBoolean(PortalConfig.PORTAL_ENABLE_SEARCH_SERVICES_DOSEARCH, Boolean.FALSE)) {
            setupQuery(request);
        } else {
            // remove query message for result portlet -> no results
            cancelRenderMessage(request, Settings.MSG_QUERY);
        }

        super.doView(request, response);
    }

    public void processAction(ActionRequest request, ActionResponse actionResponse) throws PortletException,
            IOException {
        // get our ActionForm for generating URL params from current form state
        // we have a new submit, so bring form up to date !
        ServiceSearchForm af = (ServiceSearchForm) Utils.getActionForm(request, ServiceSearchForm.SESSION_KEY,
                ServiceSearchForm.class, PortletSession.APPLICATION_SCOPE);
        af.clear();
        // populate doesn't clear
        af.populate(request);

        // redirect to our page with URL parameters for bookmarking
        actionResponse.sendRedirect(actionResponse.encodeURL(Settings.PAGE_SERVICE + SearchState.getURLParamsCatalogueSearch(request, null)));
    }

    public void setupQuery(PortletRequest request) {
        // remove old query message for result portlet
        cancelRenderMessage(request, Settings.MSG_QUERY);

        ServiceSearchForm af = (ServiceSearchForm) Utils.getActionForm(request, ServiceSearchForm.SESSION_KEY,
                ServiceSearchForm.class, PortletSession.APPLICATION_SCOPE);
        
        String action = request.getParameter(Settings.PARAM_ACTION);
        if(action != null && action.equals(Settings.PARAMV_ACTION_NEW_SEARCH)){
        	af.clear();
            // populate doesn't clear
            af.populate(request);
        } 
        
        IngridQuery query = null;
        try {
        	// create query
            // add search term if exist
            if (af.hasInput(ServiceSearchForm.FIELD_QUERY_STRING)) {
                query = QueryStringParser.parse(af.getInput(ServiceSearchForm.FIELD_QUERY_STRING));
            } else {
                query = new IngridQuery();
            }
            
            query.addField(new FieldQuery(true, false, Settings.QFIELD_DATATYPE,
                            Settings.QVALUE_DATATYPE_AREA_SERVICE));

            // Language
            if(!PortalConfig.getInstance().getBoolean(PortalConfig.PORTAL_SEARCH_LANGUAGE_INDEPENDENT, false)){
               UtilsSearch.processLanguage(query, request.getLocale());
            }

            // RUBRIC
            String queryValue = null;
            ClauseQuery cq = null;
            String[] rubrics;
            String enableCategory = PortalConfig.getInstance().getString(PortalConfig.PORTAL_ENABLE_SEARCH_SERVICES_CATEGORY, "0");
            if(enableCategory.equals("1")){
            	String[] tmp = {"pub"};
            	rubrics = tmp;
            }else if(enableCategory.equals("2")){
            	String[] tmp = {"ver"};
            	rubrics = tmp;
            }else if(enableCategory.equals("3")){
            	String[] tmp = {"pre"};
            	rubrics = tmp;
            }else{
            	String[] tmp = af.getInputAsArray(ServiceSearchForm.FIELD_RUBRIC);
            	rubrics = tmp;
            }
            // don't set anything if "all" is selected
            if (rubrics != null && Utils.getPosInArray(rubrics, Settings.PARAMV_ALL) == -1) {
                cq = new ClauseQuery(true, false);
                for (int i = 0; i < rubrics.length; i++) {
                    if (rubrics[i] != null) {
                        queryValue = UtilsDB.getServiceRubricFromKey(rubrics[i]);
                        cq.addField(new FieldQuery(false, false, Settings.QFIELD_RUBRIC, queryValue));
                    }
                }
                query.addClause(cq);
            }

            // check for portal restricted to only one partner
            String partnerRestriction = PortalConfig.getInstance().getString(
                    PortalConfig.PORTAL_SEARCH_RESTRICT_PARTNER);
            if (partnerRestriction == null || partnerRestriction.length() == 0) {
                // process selected partner, if no partner restriction was set
                UtilsSearch.processPartner(query, af.getInputAsArray(ServiceSearchForm.FIELD_PARTNER));
            } else {
                // we have a restriction to one partner
                // treat Strings in 'partner' property of the form as providers
                // PROVIDER restriction (from hidden Field in ActionForm !)
                UtilsSearch.processProvider(query, af.getInputAsArray(ServiceSearchForm.FIELD_PARTNER));
                // set selected provider so session
                IngridSessionPreferences sessionPrefs = Utils.getSessionPreferences(request,
                        IngridSessionPreferences.SESSION_KEY, IngridSessionPreferences.class);
                sessionPrefs.put(IngridSessionPreferences.RESTRICTING_PROVIDER, af
                        .getInput(ServiceSearchForm.FIELD_PARTNER));
            }

            // PROVIDER restriction (from hidden Field in ActionForm !)
            UtilsSearch.processProvider(query, af.getInputAsArray(ServiceSearchForm.STORAGE_PROVIDER));
            
            // GROUPING
            UtilsSearch.processGrouping(query, af.getInput(ServiceSearchForm.FIELD_GROUPING));

            // RANKING
            query.put(IngridQuery.RANKED, IngridQuery.SCORE_RANKED);
            
            // personalized values
            
            // set partner from personalization
            QueryPreProcessor.processQueryPartner(request, query);

            // set restricting partner from config
            UtilsSearch.processRestrictingPartners(query);
            
        } catch (Throwable t) {
            if (log.isErrorEnabled()) {
                log.error("Problems setting up Query !", t);
            }
        }
        // set query message for result portlet
        publishRenderMessage(request, Settings.MSG_QUERY, query);
    }
}
