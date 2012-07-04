/*
 * Copyright (c) 1997-2006 by wemove GmbH
 */
package de.ingrid.portal.scheduler.jobs;

import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.sun.syndication.feed.synd.SyndCategoryImpl;
import com.sun.syndication.feed.synd.SyndEntry;
import com.sun.syndication.feed.synd.SyndFeed;
import com.sun.syndication.feed.synd.SyndPerson;
import com.sun.syndication.feed.synd.SyndPersonImpl;
import com.sun.syndication.io.SyndFeedInput;
import com.sun.syndication.io.XmlReader;

import de.ingrid.portal.config.PortalConfig;
import de.ingrid.portal.global.UtilsString;
import de.ingrid.portal.hibernate.HibernateUtil;
import de.ingrid.portal.om.IngridRSSSource;
import de.ingrid.portal.om.IngridRSSStore;

/**
 * Quartz job for fetching all RSS feeds in database table ingrid_rss_source.
 * All RSS entries not older than one month will be added to the database table
 * ingrid_rss_store. Entries in ingrid_rss_store that are older than one month
 * will be deleted.
 * 
 * 
 * @author joachim@wemove.com
 */
public class RSSFetcherJob extends IngridMonitorAbstractJob {

    protected final static Logger log = LoggerFactory.getLogger(RSSFetcherJob.class);

    /**
     * @see org.quartz.Job#execute(org.quartz.JobExecutionContext)
     */
    public void execute(JobExecutionContext context) throws JobExecutionException {
    	
    	if (log.isDebugEnabled()) {
    		log.debug("RSSFetcherJob is started ...");
    	}

        Session session 	= HibernateUtil.currentSession();
        Transaction tx 		= null;
        JobDataMap dataMap 	= context.getJobDetail().getJobDataMap();

        int status 			= STATUS_OK;
		String statusCode 	= STATUS_CODE_NO_ERROR;
        try {

            SyndFeed feed 			= null;
            URL feedUrl 			= null;
            SyndFeedInput input 	= null;
            Date publishedDate 		= null;
            SyndEntry entry 		= null;
            int cnt 				= 0;
            int feedEntriesCount 	= 0;
            //String errorMsg = "";

            Calendar cal;

            // get rss sources from database
            tx = session.beginTransaction();
            List rssSources = session.createCriteria(IngridRSSSource.class).list();
            tx.commit();
            Iterator it = rssSources.iterator();
            
            // start timer
        	startTimer();
            while (it.hasNext()) {
                IngridRSSSource rssSource = (IngridRSSSource) it.next();
                if (log.isDebugEnabled()) {
                    log.debug("Working on: " + rssSource.getUrl());
                }
                try {
                    feedUrl = new URL(rssSource.getUrl());
                    URLConnection urlCon = feedUrl.openConnection();
                    urlCon.setConnectTimeout(10000);
                    urlCon.setReadTimeout(10000);
                    input 	= new SyndFeedInput();
                    feed 	= input.build(new XmlReader(urlCon));
                    
                    if (log.isDebugEnabled()) {
                        log.debug("Resource fetched.");
                    }
                    
                    if (feed.getLanguage() == null) {
                        feed.setLanguage(rssSource.getLanguage());
                    }
                    if (rssSource.getDescription() != null && rssSource.getDescription().trim().length() > 0) {
                        feed.setAuthor(rssSource.getDescription().trim());
                    }

                    Iterator it2 = feed.getEntries().iterator();
                    // work on all rss items of the feed
                    while (it2.hasNext()) {
                        entry = (SyndEntry) it2.next();
                        if (log.isDebugEnabled()) {
                            log.debug("Working on item: " + entry.getTitle());
                        }
                        boolean includeEntry = true;
                        String categoryFilter = rssSource.getCategories();
                        if (categoryFilter != null && !categoryFilter.equalsIgnoreCase("all")) {
                            includeEntry = false;
                            List categories = entry.getCategories();
                            if (categories != null && categories.size() > 0) {
                                for (int i = 0; i < categories.size(); i++) {
                                    SyndCategoryImpl category = (SyndCategoryImpl) categories.get(i);
                                    String categoryStr = category.getName().toLowerCase();
                                    if (categoryStr != null && categoryStr.length() > 0) {
                                        categoryStr = UtilsString.regExEscape(category.getName().toLowerCase());
                                        if (categoryFilter.toLowerCase().matches("^" + categoryStr + ".*|.*," + categoryStr
                                                + ",.*|.*," + categoryStr + "$")) {
                                            includeEntry = true;
                                            break;
                                        }
                                    }
                                }
                            }
                        }

                        // filter entries with no title
                        if (includeEntry && (entry.getTitle() == null || entry.getTitle().trim().length() == 0)) {
                            includeEntry = false;
                            if (log.isDebugEnabled()) {
                                log.debug("Ignore item, because item has no title: " + entry);
                            }
                        }

                        publishedDate = entry.getPublishedDate();
                        // check for published date in the entry
                        if (publishedDate == null) {
                            includeEntry = false;
                            if (log.isDebugEnabled()) {
                                log.debug("Ignore item, because a publishing date could not be retrieved: " + entry);
                            }
                        }

                        cal = Calendar.getInstance();

                        // filter entries with dates in future
                        if (includeEntry && publishedDate != null && publishedDate.after(cal.getTime())) {
                            includeEntry = false;
                            if (log.isDebugEnabled()) {
                                log.debug("Ignore item, because the publishing date is in the future: " + publishedDate);
                            }
                        }
                        // filter dates before RSS entry window
                        cal.add(Calendar.DATE, -1 * PortalConfig.getInstance().getInt(PortalConfig.RSS_HISTORY_DAYS));
                        if (includeEntry && publishedDate != null && publishedDate.before(cal.getTime())) {
                            includeEntry = false;
                            if (log.isDebugEnabled()) {
                                log.debug("Ignore item, because the publishing date is too far in the past: " + publishedDate);
                            }
                        }

                        if (includeEntry) {
                            // check if this entry already exists
                            tx = session.beginTransaction();
                            List rssEntries = session.createCriteria(IngridRSSStore.class).add(
                                    Restrictions.eq("link", entry.getLink())).add(
                                    Restrictions.eq("language", feed.getLanguage())).list();
                            tx.commit();
                            if (rssEntries.isEmpty()) {
                                List authors = new ArrayList();
                                SyndPerson author = new SyndPersonImpl();
                                authors.add(author);
                                if (feed.getAuthor() == null || feed.getAuthor().length() == 0) {
                                    if (entry.getAuthor() == null || entry.getAuthor().length() == 0) {
                                        if (feed.getTitle() != null && feed.getTitle().length() > 0) {
                                            author.setName(feed.getTitle());
                                        } else {
                                            author.setName("nicht angegeben / not specified");
                                        }
                                    } else {
                                        author.setName(entry.getAuthor());
                                    }
                                } else {
                                    author.setName(feed.getAuthor());
                                }
                                entry.setAuthors(authors);

                                IngridRSSStore rssEntry = new IngridRSSStore();
                                String title = entry.getTitle();
                                title = title.replaceAll("<br.*?>|<p.*?>|</p.*?>", " ");
                                title = title.replaceAll("\\s+", " ");
                                title = UtilsString.stripHTMLTagsAndHTMLEncode(title);
                                if (title.length() > 256)
                                    title = title.substring(0, 255);
                                rssEntry.setTitle(title);
                                String description = entry.getDescription().getValue();
                                description = description.replaceAll("<br.*?>|<p.*?>|</p.*?>", " ");
                                description = description.replaceAll("\\s+", " ");
                                rssEntry.setDescription(UtilsString.stripHTMLTagsAndHTMLEncode(description));
                                rssEntry.setLink(entry.getLink());
                                rssEntry.setLanguage(feed.getLanguage());
                                rssEntry.setPublishedDate(publishedDate);
                                rssEntry.setAuthor(entry.getAuthor());

                                tx = session.beginTransaction();
                                session.save(rssEntry);
                                tx.commit();
                                if (log.isDebugEnabled()) {
                                    log.debug("Item saved to database.");
                                }

                                cnt++;
                                feedEntriesCount++;
                            } else {
                                for (int i = 0; i < rssEntries.size(); i++) {
                                    session.evict(rssEntries.get(i));
                                }
                            }
                            rssEntries = null;
                        }
                    }

                    feed = null;
                } catch (SocketTimeoutException e) {
                    if (log.isInfoEnabled()) {                    	
                        log.info("Error building RSS feed (" + rssSource.getUrl() + "). [" + e.getMessage() + "]");
                    }
                    if (log.isDebugEnabled()) {
                        log.debug("Error building RSS feed (" + rssSource.getUrl() + ").", e);
                    }
                    status 		= STATUS_ERROR;
        			statusCode 	= STATUS_CODE_ERROR_TIMEOUT;
                } catch (Throwable t) {
                	//errorMsg = e.getMessage();
                    if (log.isInfoEnabled()) {                    	
                        log.info("Error building RSS feed (" + rssSource.getUrl() + "). [" + t.getMessage() + "]");
                    }
                    if (log.isDebugEnabled()) {
                        log.debug("Error building RSS feed (" + rssSource.getUrl() + ").", t);
                    }
                    status 		= STATUS_ERROR;
        			statusCode 	= STATUS_CODE_ERROR_UNSPECIFIC;
                } finally {
                	// add information about the fetching of this feed into the RSSSource database
                    tx = session.beginTransaction();
                    
                    if (feedEntriesCount > 0) {
                    	rssSource.setLastUpdate(new Date());
                    	rssSource.setNumLastCount(feedEntriesCount);
                    }
                    
                    //rssSource.setLastMessageUpdate(new Date());
                    
                    //rssSource.setError(errorMsg);
                    
                    session.save(rssSource);
                    tx.commit();
                    
                    session.evict(rssSource);
                    feedEntriesCount = 0;
                    //errorMsg = "";
                }
            }

            if (log.isDebugEnabled()) {
                log.debug("Number of RSS entries added: " + cnt);
            }

            // remove old entries
            cal = Calendar.getInstance();
            cal.add(Calendar.DATE, -1 * PortalConfig.getInstance().getInt(PortalConfig.RSS_HISTORY_DAYS));

            tx = session.beginTransaction();
            List deleteEntries = session.createCriteria(IngridRSSStore.class).add(
                    Restrictions.lt("publishedDate", cal.getTime())).list();
            tx.commit();
            it = deleteEntries.iterator();
            tx = session.beginTransaction();
            while (it.hasNext()) {
                Object obj = it.next();
                session.evict(obj);
                session.delete((IngridRSSStore) obj);
            }
            tx.commit();
            deleteEntries.clear();
        } catch (Exception t) {
            if (tx != null) {
                tx.rollback();
            }
            if (log.isErrorEnabled()) {
                log.error("Error executing quartz job RSSFetcherJob.", t);
            }
            status 		= STATUS_ERROR;
			statusCode 	= STATUS_CODE_ERROR_UNSPECIFIC;
            throw new JobExecutionException("Error executing quartz job RSSFetcherJob.", t, false);
        } finally {
        	computeTime(dataMap, stopTimer());
            if (log.isDebugEnabled()) {
                log.debug("Update quartz job data.");
            }
        	updateJobData(context, status, statusCode);
        	updateJob(context);
            HibernateUtil.closeSession();
            if (log.isDebugEnabled()) {
                log.debug("Hibernate session is closed.");
            }
        }
        if (log.isDebugEnabled()) {
            log.debug("RSSFetcherJob finished.");
        }
    }

}
