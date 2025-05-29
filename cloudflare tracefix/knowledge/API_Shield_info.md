---
title: Web assets · Security dashboard docs
description: Discover web assets such as your API endpoints and instruct Cloudflare how to best protect them.
lastUpdated: 2025-05-14T13:44:15.000Z
source_url:
  html: https://developers.cloudflare.com/security/web-assets/
  md: https://developers.cloudflare.com/security/web-assets/index.md
---

Discover web assets such as your API endpoints and instruct Cloudflare how to best protect them.

## Endpoints

Use the **Endpoints** tab to manage endpoints available on your domain and monitor their health.

You can save endpoints directly from [API Discovery](https://developers.cloudflare.com/api-shield/management-and-monitoring/endpoint-management/#add-endpoints-from-api-discovery), [manually](https://developers.cloudflare.com/api-shield/management-and-monitoring/endpoint-management/#add-endpoints-manually) by method, path, and host, or via [Schema Validation](https://developers.cloudflare.com/api-shield/management-and-monitoring/endpoint-management/#add-endpoints-from-schema-validation).

This will add the specified endpoints to your list of managed endpoints. You can view your list of managed endpoints in the **Endpoints** tab.

For saved endpoints:

* Cloudflare will start collecting [performance data](https://developers.cloudflare.com/api-shield/management-and-monitoring/endpoint-management/#endpoint-analysis) per endpoint.
* You can use the [labeling service](https://developers.cloudflare.com/api-shield/management-and-monitoring/endpoint-labels/) to organize your endpoints by use case.

For more information on how to manage your endpoints, refer to the following resources.

* [Endpoint Management](https://developers.cloudflare.com/api-shield/management-and-monitoring/endpoint-management/)
* [Schema learning](https://developers.cloudflare.com/api-shield/management-and-monitoring/endpoint-management/schema-learning/)
* [Endpoint Analysis](https://developers.cloudflare.com/api-shield/management-and-monitoring/endpoint-management/#endpoint-analysis)

## Discovery

**Discovery** continuously finds your active API endpoints via path normalization.

[Add endpoints](https://developers.cloudflare.com/api-shield/management-and-monitoring/endpoint-management/#add-endpoints-from-api-discovery) to produce recommendations and analytics of your APIs. Your [session identifiers](https://developers.cloudflare.com/api-shield/management-and-monitoring/session-identifiers/) must match your API traffic. Otherwise, API endpoints are also discoverable via [Machine Learning](https://developers.cloudflare.com/api-shield/security/api-discovery/#machine-learning-based-discovery).

Note

**Discovery** is only available for Enterprise customers. If you are an Enterprise customer and interested in this product, contact your account team.

## Sequences

Use **Sequences** to discover how users interact with your API, by tracking the order of API session requests over time. Sequences will group and highlight popular user journeys across your API.

Once you configure [session identifiers](https://developers.cloudflare.com/api-shield/management-and-monitoring/session-identifiers/), the **Sequences** tab will start grouping and highlighting important user journeys (sequences) across your API.

To configure session identifiers, go to **Security** > **Settings** > **All settings** tab and select **Edit** next to **Session identifiers**.

For more information on how Cloudflare identifies API sequences and how you can configure API sequence rules, refer to the following resources:

* [Sequence analytics](https://developers.cloudflare.com/api-shield/security/sequence-analytics/)
* [Sequence mitigation](https://developers.cloudflare.com/api-shield/security/sequence-mitigation/)

Note

The **Sequences** tab includes functionality available in [API Shield](https://developers.cloudflare.com/api-shield/) in the previous dashboard navigation structure.

## Schema validation

Use **Schema validation** to check if your incoming traffic complies with a previously supplied API Schema.

API Schemas are defined by the validity of the API request's properties such as target endpoint, path or query variable format, and HTTP method. A rule is created for incoming traffic and defines which traffic is allowed and which traffic is logged or blocked based on the API schema that you provide or select from the list of learned schemas.

You can add schema validation by:

* [Uploading a schema](https://developers.cloudflare.com/api-shield/security/schema-validation/#add-validation-by-uploading-a-schema)
* [Applying a learned schema to a single endpoint](https://developers.cloudflare.com/api-shield/security/schema-validation/#add-validation-by-applying-a-learned-schema-to-a-single-endpoint)
* [Applying a learned schema to an entire hostname](https://developers.cloudflare.com/api-shield/security/schema-validation/#add-validation-by-applying-a-learned-schema-to-an-entire-hostname)
* [Adding a fallthrough rule](https://developers.cloudflare.com/api-shield/security/schema-validation/#add-validation-by-adding-a-fallthrough-rule)

Note

The **Schema validation** tab includes functionality available in [API Shield](https://developers.cloudflare.com/api-shield/) in the previous dashboard navigation structure.

## Client-side resources

Use **Client-side resources** to [monitor scripts, connections, and cookies](https://developers.cloudflare.com/page-shield/detection/monitor-connections-scripts/) on your domain.

If you notice unexpected scripts or connections on the dashboard, check them for signs of malicious activity. You should also check for any new or unexpected cookies.

Enterprise customers with a paid add-on will have their connections and scripts [classified as potentially malicious](https://developers.cloudflare.com/page-shield/how-it-works/malicious-script-detection/) based on threat feeds.

Note

The **Client-side resources** tab includes functionality available in [Page Shield](https://developers.cloudflare.com/page-shield/) in the previous dashboard navigation structure.

---
title: Endpoint Management · Cloudflare API Shield docs
description: Monitor the health of your API endpoints by saving, updating, and monitoring performance metrics using API Shield’s Endpoint Management.
lastUpdated: 2025-05-02T00:34:08.000Z
source_url:
  html: https://developers.cloudflare.com/api-shield/management-and-monitoring/endpoint-management/
  md: https://developers.cloudflare.com/api-shield/management-and-monitoring/endpoint-management/index.md
---

Available on all plans

Monitor the health of your API endpoints by saving, updating, and monitoring performance metrics using API Shield’s Endpoint Management.

**Add endpoints** allows customers to save endpoints directly from [API Discovery](https://developers.cloudflare.com/api-shield/security/api-discovery/) or manually by method, path, and host.

This will add the specified endpoints to your list of managed endpoints. You can view your list of saved endpoints in the **Endpoint Management** page.

Cloudflare will start collecting [performance data](https://developers.cloudflare.com/api-shield/management-and-monitoring/#endpoint-analysis) on your endpoint when you save an endpoint.

Note

When an endpoint is using [Cloudflare Workers](https://developers.cloudflare.com/workers/), the metrics data will not be populated.

## Access

1. Log in to the [Cloudflare dashboard](https://dash.cloudflare.com/login) and select your account and domain.
2. Select **Security** > **API Shield**.
3. Add your endpoints [manually](#add-endpoints-manually), from [Schema validation](#add-endpoints-from-schema-validation), or from [API Discovery](#add-endpoints-from-api-discovery).

## Add endpoints from API Discovery

There are two ways to add API endpoints from Discovery.

### Add from the Endpoint Management Tab

1. From Endpoint Management, select **Add endpoints** > **Select from Discovery** tab.
2. Select the discovered endpoints you would like to add.
3. Select **Add endpoints**.

### Add from the Discovery Tab

1. From Endpoint Management, select the **Discovery** tab.
2. Select the discovered endpoints you would like to add.
3. Select **Save selected endpoints**.

## Add endpoints from Schema validation

1. Add a schema by [configuring Schema validation](https://developers.cloudflare.com/api-shield/security/schema-validation/).
2. On **Review schema endpoints**, save new endpoints to endpoint management by checking the box.
3. Select **Save as draft** or **Save and Deploy**. Endpoints will be saved regardless of whether the Schema is saved as a draft or published.

API Shield will look for duplicate endpoints that have the same host, method, and path. Duplicate endpoints will not be saved to endpoint management.

Note

If you deselect **Save new endpoints to endpoint management**, the endpoints will not be added.

## Add endpoints manually

1. From Endpoint Management, select **Add endpoints** > **Manually add**.
2. Choose the method from the dropdown menu and add the path and hostname for the endpoint.
3. Select **Add endpoints**.

Note

By selecting multiple checkboxes, you can add several endpoints from Discovery at once instead of individually.

When adding an endpoint manually, you can specify variable fields in the path or host by enclosing them in braces, `/api/user/{var1}/details` or `{hostVar1}.example.com`.

Cloudflare supports hostname variables in the following formats:

```txt
{hostVar1}.example.com


foo.{hostVar1}.example.com


{hostVar2}.{hostVar1}.example.com
```

Hostname variables must comprise the entire domain field and must not be used with other text in the field.

The following format is not supported:

```txt
foo-{hostVar1}.example.com
```

For more information on how Cloudflare uses variables in API Shield, refer to the examples from [API Discovery](https://developers.cloudflare.com/api-shield/security/api-discovery/).

## Delete endpoints manually

You can delete endpoints one at a time or in bulk.

1. From Endpoint Management, select the checkboxes for the endpoints that you want to delete.
2. Select **Delete endpoints**.

## Endpoint Analysis

For each saved endpoint, customers can view:

* **Request count**: The total number of requests to the endpoint over time.
* **Rate limiting recommendation**: per 10 minutes. This is guided by the request count.
* **Latency**: The average origin response time in milliseconds (ms). This metric shows how long it takes from the moment a visitor makes a request to the moment the visitor gets a response back from the origin.
* **Error rate** vs. overall traffic: grouped by 4xx, 5xx, and their sum.
* **Response size**: The average size of the response (in bytes) returned to the request.
* **Labels**: The current [labels](https://developers.cloudflare.com/api-shield/management-and-monitoring/endpoint-labels/) assigned to the endpoint.
* **Authentication status**: The breakdown of which [session identifiers](https://developers.cloudflare.com/api-shield/get-started/#session-identifiers) were seen on successful requests to this endpoint.
* **Sequences**: The number of [Sequence Analytics](https://developers.cloudflare.com/api-shield/security/sequence-analytics/) sequences the endpoint was found in.

Note

Customers viewing analytics have the ability to toggle detailed metrics view between the last 24 hours and 7 days.

## Using the Cloudflare API

You can interact with Endpoint Management through the Cloudflare API. Refer to [Endpoint Management’s API documentation](https://developers.cloudflare.com/api/resources/api_gateway/subresources/discovery/subresources/operations/methods/list/) for more information.

## Sensitive Data Detection

Sensitive data comprises various personally identifiable information and financial data. Cloudflare created this ruleset to address common data loss threats, and the WAF can search for this data in HTTP response bodies from your origin.

API Shield will alert users to the presence of sensitive data in the response body of API endpoints listed in Endpoint Management if the zone is also subscribed to the [Sensitive Data Detection managed ruleset](https://developers.cloudflare.com/waf/managed-rules/reference/sensitive-data-detection/).

Sensitive Data Detection is available to Enterprise customers on our Advanced application security plan.

Once Sensitive Data Detection is enabled for your zone, API Shield queries firewall events from the WAF for the last seven days and places a notification icon on the Endpoint Management table row if there are any matched sensitive responses for your endpoint.

API Shield displays the types of sensitive data found if you expand the Endpoint Management table row to view further details. Select **Explore Events** to view the matched events in Security Events.

After Sensitive Data Detection is enabled for your zone, you can [browse the Sensitive Data Detection ruleset](https://dash.cloudflare.com/?to=/:account/:zone/security/data/ruleset/e22d83c647c64a3eae91b71b499d988e/rules). The link will not work if Sensitive Data Detection is not enabled.

---
title: Endpoint labeling service · Cloudflare API Shield docs
description: API Shield's labeling service will help you organize your endpoints and address vulnerabilities in your API. The labeling service comes with managed and user-defined labels.
lastUpdated: 2025-05-02T00:34:08.000Z
source_url:
  html: https://developers.cloudflare.com/api-shield/management-and-monitoring/endpoint-labels/
  md: https://developers.cloudflare.com/api-shield/management-and-monitoring/endpoint-labels/index.md
---

API Shield's labeling service will help you organize your endpoints and address vulnerabilities in your API. The labeling service comes with managed and user-defined labels.

Today, managed labels are useful for organizing endpoints by use case. In a future release, managed labels will automatically label endpoints by use case and those with informative or security risks, alerting you on endpoints that need attention.

User-defined labels can also be added to endpoints in API Shield by creating a label and adding it to an individual endpoint or multiple endpoints. User-defined labels will be useful for organizing your endpoints by owner, version, or type.

You can filter your endpoints based on the labels.

## Categories

### Managed labels

Use managed labels to identify endpoints by use case. Cloudflare may automatically apply these labels in a future release.

`cf-log-in`: Add this label to endpoints that accept user credentials. You may have multiple endpoints if you accept username, password, and multi-factor authentication (MFA) across multiple endpoints or requests.

`cf-sign-up`: Add this label to endpoints that are the final step in creating user accounts for your site or application.

`cf-content`: Add this label to endpoints that provide unique content, such as product details, user reviews, pricing, or other unique information.

`cf-purchase`: Add this label to endpoints that are the final step in purchasing goods or services online.

`cf-password-reset`: Add this label to endpoints that participate in the user password reset process. This includes initial password reset requests and final password reset submissions.

`cf-add-cart`: Add this label to endpoints that add items to a user's shopping cart or verify item availability.

`cf-add-payment`: Add this label to endpoints that accept credit card or bank account details where fraudsters may iterate through account numbers to guess valid combinations of payment information.

`cf-check-value`: Add this label to endpoints that check the balance of rewards points, in-game currency, or other stored value products that can be earned, transferred, and redeemed for cash or physical goods.

`cf-add-post`: Add this label to endpoints that post messages in a communication forum, or product or merchant reviews.

`cf-account-update`: Add this label to endpoints that participate in user account or profile updates.

`cf-llm`: Services that are (partially) powered by Large Language Model (LLM).

`cf-rss-feed`: Add this label to endpoints that expect traffic from RSS clients.

Note

[Bot Fight Mode](https://developers.cloudflare.com/bots/get-started/bot-fight-mode/) will not block requests to endpoints labeled as `cf-rss-feed`.

[Super Bot Fight Mode rules](https://developers.cloudflare.com/bots/get-started/super-bot-fight-mode/#ruleset-engine) will not match or challenge requests labeled as `cf-rss-feed`.

### Risk labels

Cloudflare automatically runs risk scans every 24 hours on your saved endpoints. API Shield applies these labels when a scan finds security risks on your endpoints. A corresponding Security Center Insight is also raised when risks are found.

`cf-risk-missing-auth`: Automatically added when all successful requests lack a session identifier. Refer to the table below for more information.

`cf-risk-mixed-auth`: Automatically added when some successful requests contain a session identifier and some successful requests lack a session identifier. Refer to the table below for more information.

`cf-risk-sensitive`: Automatically added to endpoints when HTTP responses match the WAF's [Sensitive Data Detection](https://developers.cloudflare.com/api-shield/management-and-monitoring/#sensitive-data-detection) ruleset.

`cf-risk-missing-schema`: Automatically added when a learned schema is available for an endpoint that has no active schema.

`cf-risk-error-anomaly`: Automatically added when an endpoint experiences a recent increase in response errors over the last 24 hours.

`cf-risk-latency-anomaly`: Automatically added when an endpoint experiences a recent increase in response latency over the last 24 hours.

`cf-risk-size-anomaly`: Automatically added when an endpoint experiences a spike in response body size over the last 24 hours.

`cf-risk-bola-enumeration`: Automatically added when an endpoint experiences successful responses with drastic differences in the number of unique elements requested by different user sessions.

`cf-risk-bola-pollution`: Automatically added when an endpoint experiences successful responses where parameters are found in multiple places in the request, as opposed to what is expected from the API's schema.

Note

Cloudflare will only add authentication labels to endpoints with successful response codes. Refer to the below table for more details.

| Description                                                                        | 2xx response codes | 4xx, 5xx response codes                               |
| ---------------------------------------------------------------------------------- | ------------------ | ----------------------------------------------------- |
| If all requests are missing authentication, Cloudflare will apply the label:       | `cf-missing-auth`  | Without successful responses, no label will be added. |
| If only some requests are missing authentication, Cloudflare will apply the label: | `cf-mixed-auth`    | Without successful responses, no label will be added. |

## Create a label

1. Log in to the [Cloudflare dashboard](https://dash.cloudflare.com/) and select your account and domain.
2. Go to **Security** > **Settings** > **Labels**.
3. Under **Security labels**, select **Create label**.
4. Name the label and add an optional label description.
5. Apply the label to your selected endpoints.
6. Select **Create label**.

Alternatively, you can create a user-defined label via Endpoint Management in API Shield.

1. Log in to the [Cloudflare dashboard](https://dash.cloudflare.com/) and select your account and domain.
2. Go to **Security** > **Settings** > **Labels**.
3. Choose the endpoint that you want to label.
4. Select **Edit labels**.
5. Under **User**, select **Create user label**.
6. Enter the label name.
7. Select **Create**.

## Apply a label to an individual endpoint

1. Log in to the [Cloudflare dashboard](https://dash.cloudflare.com/) and select your account and domain.
2. Go to **Security** > **API Shield** > **Endpoint Management**.
3. Choose the endpoint that you want to label.
4. Select **Edit labels**.
5. Add the label(s) that you want to use for the endpoint from the list of managed and user-defined labels.
6. Select **Save labels**.

## Bulk apply labels to multiple endpoints

1. Log in to the [Cloudflare dashboard](https://dash.cloudflare.com/) and select your account and domain.
2. Go to **Security** > **Settings** > **Labels**.
3. On the existing label that you want to apply to multiple endpoints, select **Bulk apply**.
4. Choose the endpoints that you want to label by selecting its checkbox.
5. Select **Save label**.

## Availability

Endpoint Management's labeling service is available to all customers.
