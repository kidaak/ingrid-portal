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

import javax.portlet.PortletRequest;

/**
 * TODO Describe your created type (class, etc.) here.
 *
 * @author joachim@wemove.com
 */
public class SearchExtEnvTimeConstraintForm extends ActionForm {

    private static final long serialVersionUID = 8809471913897989572L;

    /** attribute name of action form in session */
    public static final String SESSION_KEY = SearchExtEnvTimeConstraintForm.class.getName();

    /** field names (name of request parameter) */
    
    public static final String FIELD_RADIO_TIME_SELECT = "radio_time_select";
    public static final String FIELD_FROM = "from";
    public static final String FIELD_TO = "to";
    public static final String FIELD_AT = "at";
    public static final String FIELD_CHK1 = "chk1";
    public static final String FIELD_CHK2 = "chk2";

    public static final String VALUE_FROM_TO = "1";
    public static final String VALUE_AT = "2";

    
    /**
     * @see de.ingrid.portal.forms.ActionForm#init()
     */
    public void init() {
        clear();
        setInput(FIELD_CHK1, "on");
        setInput(FIELD_CHK2, "on");
        setInput(FIELD_RADIO_TIME_SELECT, VALUE_FROM_TO);
    }

    /**
     * @see de.ingrid.portal.forms.ActionForm#populate(javax.portlet.PortletRequest)
     */
    public void populate(PortletRequest request) {
        clearInput();
        setInput(FIELD_RADIO_TIME_SELECT, request.getParameter(FIELD_RADIO_TIME_SELECT));
        setInput(FIELD_FROM, request.getParameter(FIELD_FROM));
        setInput(FIELD_TO, request.getParameter(FIELD_TO));
        setInput(FIELD_AT, request.getParameter(FIELD_AT));
        setInput(FIELD_CHK1, request.getParameter(FIELD_CHK1));
        setInput(FIELD_CHK2, request.getParameter(FIELD_CHK2));
    }

    /**
     * @see de.ingrid.portal.forms.ActionForm#validate()
     */
    public boolean validate() {
        boolean valid = true;
        clearErrors();
        if (getInput(FIELD_RADIO_TIME_SELECT).equals("1")) {
            if (!hasInput(FIELD_FROM) && !hasInput(FIELD_TO)) {
                setError(FIELD_FROM, "searchExtEnvTimeConstraint.error.no_from_to");
                setError(FIELD_TO, "");
                valid = false;
            } else {
            	if (hasInput(FIELD_FROM)) {
                    if (!getInput(FIELD_FROM).matches("[0-3][0-9]\\.[0-1][0-9]\\.[0-9][0-9][0-9][0-9]")) {
                        setError(FIELD_FROM, "searchExtEnvTimeConstraint.error.invalid_date");
                        valid = false;
                    }
            	}
            	if (hasInput(FIELD_TO)) {
                    if (!getInput(FIELD_TO).matches("[0-3][0-9]\\.[0-1][0-9]\\.[0-9][0-9][0-9][0-9]")) {
                        setError(FIELD_TO, "searchExtEnvTimeConstraint.error.invalid_date");
                        valid = false;
                    }            		
            	}
            }
        } else if(getInput(FIELD_RADIO_TIME_SELECT).equals("2")) {
            if (!hasInput(FIELD_AT)) {
                setError(FIELD_AT, "searchExtEnvTimeConstraint.error.no_at");
                valid = false;
            }
            if (!getInput(FIELD_AT).matches("[0-3][0-9]\\.[0-1][0-9]\\.[0-9][0-9][0-9][0-9]")) {
                setError(FIELD_AT, "searchExtEnvTimeConstraint.error.invalid_date");
                valid = false;
            }
        } else {
            setError("", "searchExtEnvTimeConstraint.error");
            valid = false;
        }
        return valid;
    }

}
