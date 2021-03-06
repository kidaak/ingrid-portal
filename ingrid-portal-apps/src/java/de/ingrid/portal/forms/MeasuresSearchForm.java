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
package de.ingrid.portal.forms;

import java.util.List;

import javax.portlet.PortletRequest;

import de.ingrid.portal.config.PortalConfig;
import de.ingrid.portal.global.Settings;
import de.ingrid.utils.queryparser.QueryStringParser;

/**
 * Form Handler for Measures Search portlet. Stores and validates form input.
 * 
 * @author Martin Maidhof
 */
public class MeasuresSearchForm extends ActionForm {

    private static final long serialVersionUID = 8882603034022791782L;

    /** attribute name of action form in session */
    public static final String SESSION_KEY = "messearch_form";

    /** field names (name of request parameter) */
    public static final String FIELD_RUBRIC = Settings.PARAM_RUBRIC;

    /** field name of "partner" selection list in form */
    public static final String FIELD_PARTNER = Settings.PARAM_PARTNER;

    /** field name of "grouping" radio group in form */
    public static final String FIELD_GROUPING = Settings.PARAM_GROUPING;

    /** NOTICE: This is for storage of selected Provider ("Zeige Alle Ergebnisse") and
     * is NO FIELD in form */
    public static final String STORAGE_PROVIDER = Settings.PARAM_SUBJECT;

    /** WHEN MULTIPLE VALUES USE "''" TO SEPARATE VALUES !!!!!!!!! */
    protected static String INITIAL_RUBRIC = "";

    public static final String FIELD_QUERY_STRING = Settings.PARAM_QUERY_STRING;
    
    protected static final String INITIAL_PARTNER = Settings.PARAMV_ALL;

    protected static final String INITIAL_GROUPING = "none";

    /**
     * @see de.ingrid.portal.forms.ActionForm#init()
     */
    public void init() {
        clear();
        setInput(FIELD_RUBRIC, INITIAL_RUBRIC);
        setInput(FIELD_PARTNER, INITIAL_PARTNER);
        setInput(FIELD_GROUPING, INITIAL_GROUPING);
        setInput(FIELD_QUERY_STRING, "");
    }

    /**
     * NOTICE: We DON'T CLEAR ANY FIELDS IN THE FORM, just take over the given
     * params into the according field (but that field then ONLY contains the
     * new values). In this way, we can initialize the form with default values
     * and JUST TAKE OVER THE NEW ONES !. Use clearInput() to clear the form
     * before populating !  
     * @see de.ingrid.portal.forms.ActionForm#populate(javax.portlet.PortletRequest)
     */
    public void populate(PortletRequest request) {
        if (request.getParameterValues(FIELD_RUBRIC) != null) {
            setInput(FIELD_RUBRIC, request.getParameterValues(FIELD_RUBRIC));
        }
        if (request.getParameterValues(FIELD_PARTNER) != null) {
            setInput(FIELD_PARTNER, request.getParameterValues(FIELD_PARTNER));
        }
        if (request.getParameterValues(FIELD_GROUPING) != null) {
            setInput(FIELD_GROUPING, request.getParameter(FIELD_GROUPING));
        }
        if (request.getParameterValues(FIELD_QUERY_STRING) != null) {
            setInput(FIELD_QUERY_STRING, request.getParameter(FIELD_QUERY_STRING));
        }
    }

    /**
     * @see de.ingrid.portal.forms.ActionForm#validate()
     */
    public boolean validate() {
        boolean allOk = true;
        clearErrors();

        // check rubric
        if (!hasInput(FIELD_RUBRIC)) {
            setError(FIELD_RUBRIC, "measuresSearch.error.noRubric");
            allOk = false;
        }
        if(PortalConfig.getInstance().getBoolean(
                PortalConfig.PORTAL_ENABLE_SEARCH_MEASURES_PROVIDER, Boolean.FALSE)){
        	if (!hasInput(FIELD_PARTNER)) {
                setError(FIELD_PARTNER, "measuresSearch.error.noPartner");
                allOk = false;
            }	
        }
        if (hasInput(FIELD_QUERY_STRING)) {
            try {
                QueryStringParser.parse(this.getInput(FIELD_QUERY_STRING));
            } catch (Throwable e) {
                setError(FIELD_QUERY_STRING, "measuresSearch.error.invalidSearchTerm");
                allOk = false;
            }
        }
        return allOk;
    }

    /**
     * Set the initially selected rubrics.
     * @param rubrics
     */
    public static void setInitialSelectedRubrics(List rubrics) {
        String allRubric = Settings.PARAMV_ALL.concat(VALUE_SEPARATOR).concat(VALUE_SEPARATOR);
        INITIAL_RUBRIC = allRubric.concat(getInitialSelectString(rubrics));
    }

    /**
     * @return Returns the iNITIAL_RUBRIC.
     */
    public static String getINITIAL_RUBRIC() {
        return INITIAL_RUBRIC;
    }
}
