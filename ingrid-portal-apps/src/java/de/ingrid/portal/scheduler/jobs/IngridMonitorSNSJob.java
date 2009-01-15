/*
 * Copyright (c) 2007 wemove digital solutions. All rights reserved.
 */
package de.ingrid.portal.scheduler.jobs;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.slb.taxi.webservice.xtm.stubs.FieldsType;
import com.slb.taxi.webservice.xtm.stubs.SearchType;
import com.slb.taxi.webservice.xtm.stubs.TopicMapFragment;
import com.slb.taxi.webservice.xtm.stubs.xtm.Topic;

import de.ingrid.iplug.sns.SNSClient;
import de.ingrid.portal.config.PortalConfig;
import de.ingrid.utils.queryparser.ParseException;

/**
 * TODO Describe your created type (class, etc.) here.
 * 
 * @author joachim@wemove.com
 */
public class IngridMonitorSNSJob extends IngridMonitorAbstractJob {

	public static final String STATUS_CODE_ERROR_QUERY_PARSE_EXCEPTION = "component.monitor.iplug.error.query.parse.exception";

	public static final String STATUS_CODE_ERROR_INVALID_SERVICE_URL = "component.monitor.general.error.invalid.service.url";

	public static final String STATUS_CODE_ERROR_INVALID_HTTP_REQUEST = "component.monitor.general.g2k.invalid.http.request";

	public static final String COMPONENT_TYPE = "component.monitor.general.type.sns";

	private final static Log log = LogFactory.getLog(IngridMonitorSNSJob.class);

	/**
	 * @see org.quartz.Job#execute(org.quartz.JobExecutionContext)
	 */
	public void execute(JobExecutionContext context) throws JobExecutionException {

		JobDataMap dataMap = context.getJobDetail().getJobDataMap();
		long startTime = 0;

		boolean isActive = dataMap.getInt(PARAM_ACTIVE) == 1;
		if (!isActive) {
			if (log.isDebugEnabled()) {
				log.debug("Job (" + context.getJobDetail().getName() + ") is inactive. Exiting.");
			}
			return;
		} else {
			if (log.isDebugEnabled()) {
				startTime = System.currentTimeMillis();
				log.debug("Job (" + context.getJobDetail().getName() + ") is executed...");
			}
		}

		String query = dataMap.getString(PARAM_QUERY);

		int timeout;
		try {
			timeout = dataMap.getInt(PARAM_TIMEOUT);
		} catch (Exception e1) {
			timeout = 0;
		}
		if (timeout == 0) {
			timeout = 30000;
			dataMap.put(PARAM_TIMEOUT, timeout);
		}
		String serviceUrl = dataMap.getString(IngridMonitorAbstractJob.PARAM_SERVICE_URL);

		int status = 0;
		String statusCode = null;
		try {
			startTimer();
			SNSClient snsClient;
			if (serviceUrl == null || serviceUrl.length() == 0) {
				snsClient = new SNSClient(PortalConfig.getInstance().getString(
						PortalConfig.COMPONENT_MONITOR_SNS_LOGIN, "ms"), PortalConfig.getInstance().getString(
						PortalConfig.COMPONENT_MONITOR_SNS_PASSWORD, "m3d1asyl3"), "de");
			} else {
				snsClient = new SNSClient("ms", "m3d1asyl3", "de", new URL(serviceUrl));
			}
			snsClient.setTimeout(timeout);
			TopicMapFragment mapFragment = snsClient.findTopics(query, "/thesa/descriptor", SearchType.exact,
					FieldsType.captors, 0, "de", false);
			Topic[] topics = null;
			if (null != mapFragment) {
				topics = mapFragment.getTopicMap().getTopic();
			}
			if (topics == null) {
				status = STATUS_ERROR;
				statusCode = STATUS_CODE_ERROR_NO_HITS;
			} else {
				status = STATUS_OK;
				statusCode = STATUS_CODE_NO_ERROR;
			}
		} catch (ParseException e) {
			status = STATUS_ERROR;
			statusCode = STATUS_CODE_ERROR_QUERY_PARSE_EXCEPTION;
		} catch (MalformedURLException e) {
			status = STATUS_ERROR;
			statusCode = STATUS_CODE_ERROR_INVALID_SERVICE_URL;
			if (log.isDebugEnabled()) {
				log.debug("Error checking SNS Interface.", e);
			}
		} catch (SocketTimeoutException e) {
			status = STATUS_ERROR;
			statusCode = STATUS_CODE_ERROR_TIMEOUT;
			if (log.isDebugEnabled()) {
				log.debug("Error checking SNS Interface.", e);
			}
		} catch (IOException e) {
			status = STATUS_ERROR;
			statusCode = STATUS_CODE_ERROR_TIMEOUT;
			if (log.isDebugEnabled()) {
				log.debug("Error checking SNS Interface.", e);
			}
		} catch (Throwable e) {
			status = STATUS_ERROR;
			statusCode = STATUS_CODE_ERROR_UNSPECIFIC;
			log.error("Error checking SNS Interface.", e);
		}

		computeTime(dataMap, stopTimer());
		
		updateJobData(context, status, statusCode);
		sendAlertMail(context);
		updateJob(context);

		if (log.isDebugEnabled()) {
			log.debug("Job (" + context.getJobDetail().getName() + ") finished in "
					+ (System.currentTimeMillis() - startTime) + " ms.");
		}
	}
}
