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
public class SearchExtEnvPlaceMapForm extends ActionForm {

    private static final long serialVersionUID = 2308183206172379352L;

    /** attribute name of action form in session */
    public static final String SESSION_KEY = SearchExtEnvPlaceMapForm.class.getName();

    /** field names (name of request parameter) */
    public static final String FIELD_CHK1 = "chk_1";
    public static final String FIELD_CHK2 = "chk_2";
    public static final String FIELD_CHK3 = "chk_3";
    public static final String FIELD_X1 = "x1";
    public static final String FIELD_X2 = "x2";
    public static final String FIELD_Y1 = "y1";
    public static final String FIELD_Y2 = "y2";
    public static final String FIELD_AREAID = "areaid";
    
    /**
     * @see de.ingrid.portal.forms.ActionForm#init()
     */
    public void init() {
        clearInput();
        setInput(FIELD_CHK1, "on");
    }

    /**
     * @see de.ingrid.portal.forms.ActionForm#populate(javax.portlet.PortletRequest)
     */
    public void populate(PortletRequest request) {
        clearInput();
        setInput(FIELD_CHK1, request.getParameter(FIELD_CHK1));
        setInput(FIELD_CHK2, request.getParameter(FIELD_CHK2));
        setInput(FIELD_CHK3, request.getParameter(FIELD_CHK3));
        setInput(FIELD_X1, request.getParameter(FIELD_X1));
        setInput(FIELD_X2, request.getParameter(FIELD_X2));
        setInput(FIELD_Y1, request.getParameter(FIELD_Y1));
        setInput(FIELD_Y2, request.getParameter(FIELD_Y2));
        setInput(FIELD_AREAID, request.getParameter(FIELD_AREAID));
    }

    /**
     * @see de.ingrid.portal.forms.ActionForm#validate()
     */
    public boolean validate() {
        boolean valid = true;
        clearErrors();
        if (!hasInput(FIELD_CHK1) && !hasInput(FIELD_CHK2) && !hasInput(FIELD_CHK3)) {
            setError("constraint", "searchExtEnvPlaceMap.error.no_constraint");
            valid = false;
            
        }
        else if(!hasInput(FIELD_X1) && !hasInput(FIELD_X2) && !hasInput(FIELD_Y1) && !hasInput(FIELD_Y2) && !hasInput(FIELD_AREAID)){
        	setError("", "searchExtEnvPlaceMap.error.no_spacial_constraint");
        	valid = false;
        }
        return valid;
    }

}
