/*
 * Copyright (c) 2006 wemove digital solutions. All rights reserved.
 */
package de.ingrid.portal.portlets.searchext;

import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;

import org.apache.portals.messaging.PortletMessaging;
import org.apache.velocity.context.Context;

import de.ingrid.portal.forms.SearchExtResTopicAttributesForm;
import de.ingrid.portal.forms.SearchExtResTopicAttributesForm;
import de.ingrid.portal.global.Settings;
import de.ingrid.portal.global.Utils;
import de.ingrid.portal.global.UtilsQueryString;

/**
 * This portlet handles the fragment of the attributes input in the extended search
 * for RESEARCH.
 *
 * @author martin@wemove.com
 */
public class SearchExtResTopicAttributesPortlet extends SearchExtResTopic {

    public void doView(javax.portlet.RenderRequest request, javax.portlet.RenderResponse response)
            throws PortletException, IOException {
        Context context = getContext(request);

        SearchExtResTopicAttributesForm f = (SearchExtResTopicAttributesForm) Utils.getActionForm(request, SearchExtResTopicAttributesForm.SESSION_KEY, SearchExtResTopicAttributesForm.class);        

        String cmd = request.getParameter("cmd");
        
        if (cmd == null) {
            f.init();
        }
        context.put("actionForm", f);
        
        // set positions in main and sub tab
        context.put(VAR_MAIN_TAB, PARAMV_TAB_TOPIC);
        context.put(VAR_SUB_TAB, PARAMV_TAB_ATTRIBUTES);

        super.doView(request, response);
    }

    public void processAction(ActionRequest request, ActionResponse actionResponse) throws PortletException,
            IOException {
        String action = request.getParameter(Settings.PARAM_ACTION);
        if (action == null) {
            action = "";
        }
        String submittedAddToQuery = request.getParameter("submitAddToQuery");
        String submittedRemoveFilter = request.getParameter("submitUnfilter");

        if (submittedAddToQuery != null) {

            actionResponse.setRenderParameter("cmd", "form_sent");
            SearchExtResTopicAttributesForm f = (SearchExtResTopicAttributesForm) Utils.getActionForm(request, SearchExtResTopicAttributesForm.SESSION_KEY, SearchExtResTopicAttributesForm.class);        
            f.clearErrors();
            
            f.populate(request);
            if (!f.validate()) {
                return;
            }
            
            String queryStr = (String) PortletMessaging.receive(request, Settings.MSG_TOPIC_SEARCH, Settings.PARAM_QUERY_STRING);
            String subTerm = "";
            if (f.hasInput(SearchExtResTopicAttributesForm.FIELD_DB_INSTITUTE)) {
                if (subTerm.length() > 0) {
                    subTerm = subTerm.concat(" ");
                }
                subTerm = subTerm.concat("institution:").concat(UtilsQueryString.getPhrasedTerm(f.getInput(SearchExtResTopicAttributesForm.FIELD_DB_INSTITUTE)));
            }
            if (f.hasInput(SearchExtResTopicAttributesForm.FIELD_DB_ORG)) {
                if (subTerm.length() > 0) {
                    subTerm = subTerm.concat(" ");
                }
                subTerm = subTerm.concat("sponsor:").concat(UtilsQueryString.getPhrasedTerm(f.getInput(SearchExtResTopicAttributesForm.FIELD_DB_ORG)));
            }
            if (f.hasInput(SearchExtResTopicAttributesForm.FIELD_DB_PM)) {
                if (subTerm.length() > 0) {
                    subTerm = subTerm.concat(" ");
                }
                subTerm = subTerm.concat("supervisor:").concat(UtilsQueryString.getPhrasedTerm(f.getInput(SearchExtResTopicAttributesForm.FIELD_DB_PM)));
            }
            if (f.hasInput(SearchExtResTopicAttributesForm.FIELD_DB_STAFF)) {
                if (subTerm.length() > 0) {
                    subTerm = subTerm.concat(" ");
                }
                subTerm = subTerm.concat("parties:").concat(UtilsQueryString.getPhrasedTerm(f.getInput(SearchExtResTopicAttributesForm.FIELD_DB_STAFF)));
            }
            if (f.hasInput(SearchExtResTopicAttributesForm.FIELD_DB_TITLE)) {
                if (subTerm.length() > 0) {
                    subTerm = subTerm.concat(" ");
                }
                subTerm = subTerm.concat("project:").concat(UtilsQueryString.getPhrasedTerm(f.getInput(SearchExtResTopicAttributesForm.FIELD_DB_TITLE)));
            }
            if (f.hasInput(SearchExtResTopicAttributesForm.FIELD_TERM_FROM)) {
                if (subTerm.length() > 0) {
                    subTerm = subTerm.concat(" ");
                }
                subTerm = subTerm.concat("t1:").concat(UtilsQueryString.getPhrasedTerm(f.getInput(SearchExtResTopicAttributesForm.FIELD_TERM_FROM)));
            }
            if (f.hasInput(SearchExtResTopicAttributesForm.FIELD_TERM_TO)) {
                if (subTerm.length() > 0) {
                    subTerm = subTerm.concat(" ");
                }
                subTerm = subTerm.concat("t2:").concat(UtilsQueryString.getPhrasedTerm(f.getInput(SearchExtResTopicAttributesForm.FIELD_TERM_FROM)));
            }

            if (subTerm.length() > 0) {
                queryStr = UtilsQueryString.addTerm(queryStr, subTerm, UtilsQueryString.OP_AND);
            }
            PortletMessaging.publish(request, Settings.MSG_TOPIC_SEARCH, Settings.PARAM_QUERY_STRING, queryStr);
            f.clear();

        } else if (submittedRemoveFilter != null) {

            String queryStr = (String) PortletMessaging.receive(request, Settings.MSG_TOPIC_SEARCH, Settings.PARAM_QUERY_STRING);
            queryStr = UtilsQueryString.removeField(queryStr, "institution");
            queryStr = UtilsQueryString.removeField(queryStr, "sponsor");
            queryStr = UtilsQueryString.removeField(queryStr, "supervisor");
            queryStr = UtilsQueryString.removeField(queryStr, "parties");
            queryStr = UtilsQueryString.removeField(queryStr, "project");
            queryStr = UtilsQueryString.removeField(queryStr, "t1");
            queryStr = UtilsQueryString.removeField(queryStr, "t2");
            queryStr = UtilsQueryString.stripQueryWhitespace(queryStr);
            PortletMessaging.publish(request, Settings.MSG_TOPIC_SEARCH, Settings.PARAM_QUERY_STRING, queryStr);
            
        } else if (action.equalsIgnoreCase(Settings.PARAMV_ACTION_CHANGE_TAB)) {
            String newTab = request.getParameter(Settings.PARAM_TAB);
            processTab(actionResponse, newTab);
        }
    }
}