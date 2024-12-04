
SELECT * FROM website_pageviews;
SELECT * FROM website_sessions;
SELECT * FROM orders;

-- 1. Monthly Trend for gsearch sessions and orders
SELECT 
	MONTH(website_sessions.created_at) AS month,
	COUNT(DISTINCT website_sessions.website_session_id) sessions,
    COUNT(DISTINCT orders.order_id) AS total_orders
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
	AND website_sessions.utm_source = 'gsearch'
GROUP BY month;

-- 2. Monthly Trend for gsearch sessions and orders split by nonbrand and brand campaigns

SELECT 
	MONTH(website_sessions.created_at) AS month,
	-- website_sessions.utm_source,
    COUNT(CASE WHEN website_sessions.utm_campaign ='nonbrand' THEN orders.order_id ELSE NULL END) AS nonbrand_total_order,
    COUNT(CASE WHEN website_sessions.utm_campaign ='brand' THEN orders.order_id ELSE NULL END) AS brand_total_order,
    COUNT(DISTINCT orders.order_id) AS total_orders
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
	AND website_sessions.utm_source = 'gsearch'
GROUP BY month;

-- 3. Monthly Trend for gsearch sessions and orders by nonbrand split by device type

SELECT 
	MONTH(website_sessions.created_at) AS month,
    -- website_sessions.device_type,
    COUNT(CASE WHEN website_sessions.device_type ='desktop' THEN orders.order_id ELSE NULL END) AS desktop_total_order,
    COUNT(CASE WHEN website_sessions.device_type ='mobile' THEN orders.order_id ELSE NULL END) AS mobile_total_order
    -- COUNT(DISTINCT orders.order_id) AS total_orders
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
	AND website_sessions.utm_source = 'gsearch'
	AND website_sessions.utm_campaign ='nonbrand'
GROUP BY month;
	
    
-- 4.
SELECT DISTINCT 
	utm_source
FROM website_sessions
WHERE created_at < '2012-11-27';

SELECT 
	MONTH(website_sessions.created_at) AS month,
    -- website_sessions.utm_source,
	-- COUNT(DISTINCT orders.order_id) AS total_orders
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source ='bsearch' THEN website_sessions.website_session_id ELSE NULL END) AS bsearch_paid_sessions,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source ='gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS gsearch_paid_sessions,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source IS NULL AND http_referer IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END) AS organic_search_sessions,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source IS NULL AND http_referer IS NULL THEN website_sessions.website_session_id ELSE NULL END) AS direct_type_in_sessions
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
GROUP BY month; -- ,  website_sessions.utm_source;

-- 5. Conversion rate from session to orders by month

SELECT
	MONTH(website_sessions.created_at) AS month, 
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS conversion_rate
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
GROUP BY month;


-- 6. gsearch, nonbrand, from 2012-06-19 to 2012-07-28 estimate revenue earned price_usd

-- find the 1st pav
SELECT 
	MIN(website_pageview_id) AS first_test_pv
FROM website_pageviews
WHERE pageview_url = '/lander-1';
-- 23504

CREATE TEMPORARY TABLE first_test_pageviews
SELECT 
	website_pageviews.website_session_id,
	MIN(website_pageviews.website_pageview_id) AS min_pv_id
FROM website_pageviews
	INNER JOIN website_sessions
		ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-07-28'
	AND website_pageviews.website_pageview_id >= 23504
	AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY 1;

SELECT * FROM first_test_pageviews;

-- next, we''ll bring in LP to each session
CREATE TEMPORARY TABLE nonbrand_test_sessions_w_landing_pages
SELECT 
	first_test_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_test_pageviews
	LEFT JOIN website_pageviews
		ON first_test_pageviews.min_pv_id = website_pageviews.website_pageview_id
WHERE website_pageviews.pageview_url IN('/home','/lander-1');

SELECT * FROM nonbrand_test_sessions_w_landing_pages;

-- then we make a table to bring in orders

CREATE TEMPORARY TABLE nonbrand_test_sessions_w_orders
SELECT 
	nonbrand_test_sessions_w_landing_pages.website_session_id, 
    nonbrand_test_sessions_w_landing_pages.landing_page, 
    orders.order_id AS order_id
FROM nonbrand_test_sessions_w_landing_pages
	LEFT JOIN orders
		ON nonbrand_test_sessions_w_landing_pages.website_session_id = orders.website_session_id;

SELECT * FROM nonbrand_test_sessions_w_orders;

-- find the difference between conversion rates
CREATE TEMPORARY TABLE cvr_by_lp
SELECT 
	landing_page,
	COUNT(DISTINCT website_session_id ) AS sessions, 
    COUNT(DISTINCT order_id) AS orders, 
    COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id ) CVR
FROM nonbrand_test_sessions_w_orders
GROUP BY 1;
-- /home 0.0318 , /lander-1 0.046
-- 0.0088 additional orders per session

SELECT * FROM cvr_by_lp;


-- finding the most recent pv for gsearch nonbrand where the traffic was sent to /home

SELECT 
	MAX(website_sessions.website_session_id) AS most_recent_gsearch_nonbrand_home_pv
FROM website_pageviews
	LEFT JOIN website_sessions
		ON website_pageviews.website_session_id = website_sessions.website_session_id
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
        AND pageview_url = '/home'
        AND website_sessions.created_at < '2012-11-27';

SELECT 
	COUNT(website_session_id) AS sessions_since_test
FROM website_sessions
WHERE created_at < '2012-11-27'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
	AND website_session_id > 17145;
-- 22,972 website sessions since the test 
-- x .0087 incremental conversion = 202 incremental orders since 7/29 
		-- roughly 4 months, so roughly 50 extra orders per month. 


-- 7. 
-- STEP 1: select all pageviews for relevant sessions
-- STEP 2: idebtify each relevant pageview as the specific funnel step 
-- STEP 3: create the session-level conversion funnel view
-- STEP 4: aggregate the data assess funnel performance

CREATE TEMPORARY TABLE session_level_made_iy_flagged
SELECT 
	website_session_id,
    MAX(homepage) As saw_homepage,
    MAX(custom_lander) AS saw_custom_lander,
    MAX(products) AS product_made_it,
    MAX(mr_fuzzy) AS mr_fuzzy_made_it,
    MAX(cart) AS cart_made_it,
    MAX(shipping) AS shipping_made_it,
    MAX(billing) AS billing_made_it,
    MAX(thank_you) AS thank_you_made_it
FROM(
SELECT 
	website_sessions.website_session_id, 
    pageview_url, 
    CASE WHEN pageview_url = '/home' THEN 1 ELSE 0 END AS homepage,
    CASE WHEN pageview_url = '/lander-1' THEN 1 ELSE 0 END AS custom_lander,
	CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products, 
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mr_fuzzy,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thank_you
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id	
WHERE utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
    AND website_sessions.created_at BETWEEN '2012-06-19' AND '2012-07-28'
) AS pageview_level
GROUP BY 1;

SELECT * FROM session_level_made_iy_flagged;

SELECT 
	CASE
		WHEN saw_homepage = 1 THEN 'saw_homepage'
		WHEN saw_custom_lander = 1 THEN 'saw_custom_lander'
		ELSE 'uh on .. check logic'
	END AS segment,
    COUNT(distinct website_session_id) AS sessions,
    COUNT( DISTINCT CASE WHEN product_made_it = '1' THEN website_session_id ELSE NULL END ) AS to_products,
    COUNT(CASE WHEN mr_fuzzy_made_it = 1 THEN website_session_id ELSE NULL  END)AS to_mr_fuzzy,
    COUNT(CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL  END) AS to_cart,
    COUNT(CASE WHEN shipping_made_it= 1 THEN website_session_id ELSE NULL  END) AS to_shipping,
    COUNT(CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL  END) AS to_billing,
    COUNT(CASE WHEN thank_you_made_it = 1 THEN website_session_id ELSE NULL  END) AS to_thank_you
FROM session_level_made_iy_flagged
GROUP BY 1;




SELECT 
	CASE
		WHEN saw_homepage = 1 THEN 'saw_homepage'
		WHEN saw_custom_lander = 1 THEN 'saw_custom_lander'
		ELSE 'uh on .. check logic'
	END AS segment,
    COUNT(CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL  END) /COUNT(DISTINCT website_session_id) AS lander_click_rt,
    COUNT(CASE WHEN mr_fuzzy_made_it = 1 THEN website_session_id ELSE NULL  END) /COUNT(CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL  END) AS products_click_rt,
    COUNT(CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL  END)/COUNT(CASE WHEN mr_fuzzy_made_it = 1 THEN website_session_id ELSE NULL  END) AS mrfuzzy_click_rt,
    COUNT(CASE WHEN shipping_made_it= 1 THEN website_session_id ELSE NULL  END)/COUNT(CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL  END) AS cart_click_rt,
    COUNT(CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL  END)/ COUNT(CASE WHEN shipping_made_it= 1 THEN website_session_id ELSE NULL  END)  AS shipping_click_rt,
    COUNT(CASE WHEN thank_you_made_it = 1 THEN website_session_id ELSE NULL  END)/COUNT(CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL  END) AS billing_click_rt
FROM session_level_made_iy_flagged
GROUP BY 1;


-- 8. Quantify the impact of billing test, analyze the lift generated from the test '2012-09-10' AND '2012-11-10' - revenue per billing.

SELECT 
	billing_version_seen, 
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders, 
    COUNT(DISTINCT order_id)/ COUNT(DISTINCT website_session_id) AS billing_to_order_rt,
    SUM(price_usd)/COUNT(DISTINCT website_session_id)  AS revenue_per_billing_page_seen
FROM 
(
SELECT 
	website_pageviews.website_session_id,
    website_pageviews.pageview_url AS billing_version_seen,
    orders.order_id,
    orders.price_usd
FROM website_pageviews
	LEFT JOIN orders
		ON website_pageviews.website_session_id = orders.website_session_id
WHERE website_pageviews.created_at BETWEEN '2012-09-10' AND '2012-11-10'
	AND pageview_url IN ('/billing', '/billing-2')
) AS billing_pv_and_order_data
GROUP BY 1;

-- $22.83 revenue per billing page seen for the old version 
-- $31.34 for the new version 
-- LIFT: $8.51 per billing page view

SELECT 
	COUNT(website_session_id) AS billing_page_sessions
FROM website_pageviews
WHERE pageview_url IN('/billing','/billing-2')
	AND created_at BETWEEN '2012-10-27' AND '2012-11-27';

-- 1,193 billing session past month 
-- LIFT: $8.51 per billing page view 
-- VALUE OF BILLING TEST: $10,160 over the past month










