--liquibase formatted sql
--changeset data_script:AST_SERT_HOW_TO_FIX stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from AST_SERT_HOW_TO_FIX;
--precondition-sql-check expectedResult:Y select ast_preferences.get_preference ('AST_SERT_YN') from dual;
--REM INSERTING into AST_SERT_HOW_TO_FIX
--SET DEFINE OFF;
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (14,20,TO_CLOB(q'[The **Deep Linking** attribute determines whether or not bookmarked URLs can be used to access specific pages of an application.  While in some cases this would be convenient for the end user to enable, in others, it could cause issues.  For example, if a user bookmarked page 3 of a 5 step wizard, items that are assumed to be set on the first two pages would never be set, thus causing potential issues.

**Deep Linking** can also be set for an entire application.  Thus, if there are some pages ]')
|| TO_CLOB(q'[that are commonly bookmarked and accessing those pages directly presents no risk to the integrity of the application, then setting the **Deep Linking** attribute for those specific pages to **Enabled** would be acceptable.

Because of this potential risk, it is recommended that Deep Linking be set to **Disabled** at the application level and only enabled on pages where it is required.]'),TO_CLOB(q'[To alter the value of **Deep Linking** for a specific page:

1.  Edit the page attributes for the page in question by clicking on it's name in the Page Rendering tree.
2.  In the Security region, alter the value for the **Deep Linking** select list.
3.  Click **Save**.

Browser Cache has three possible settings:

**\- Application Default** - This will take its value from the current application's Deep Linking attribute.  
**\- Enabled** - Allows this page to be bookmarked  
**\- Disabl]')
|| TO_CLOB(q'[ed** - Prohibits this page from being bookmarked

The page level **Deep Linking** setting, other than Application Default,  will override what is defined at the Application level.]'),'nBXfuftblUyNs5qpeRfDKnBBMTW4Y12wr7jXt9DuFGoJ-rQJUs7LrPMDyBhag1FNNANwPZ94R5jS4DSXmozv7g','SV_PS_DEEP_LINKING',323062163011559267892128049722542396255);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (20,28,TO_CLOB(q'[Often times, developers will use **&ITEM.** syntax in a Display Only item's **PL/SQL Output** attribute to dynamically change the value.  While this is a clever trick that adds a bit of personalization to your application, it may be opening up your application to XSS risk. 

Page Items in APEX are automatically escaped when rendered using the **&ITEM.** syntax, and are generally safe to use.  However, application items are not escaped when rendered using the **&ITEM.** syntax.  Thus, if you ar]')
|| TO_CLOB(q'[e referencing application items via the **&ITEM.** syntax, you need to ensure that there is no way that the application item's value can contain malicious data.]'),'To ensure that **&ITEM.** syntax in a Display Only item''s **PL/SQL Output** poses no risk:

1.  Edit the Display Only page item in your application.
2.  In the Settings region, ensure that the code in PL/SQL Code does not contain any reference to an application item that could potentially contain malicious code.
3.  Click **Save**.','MBNnWFr-wbw21CaW0pRPKdLL9-LaIadBN-vKfXNf0LzQ0MsLxZmw3xnAjqltOCxsW7FjJen4qmcsfK-ofYoFLw','SV_XSS_PLSQL_OUTPUT',323062163011587073185979186193560638303);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (21,29,TO_CLOB(q'[Often times, developers will use **&ITEM.** syntax to dynamically change the value of an attribute.  While this is a clever trick that adds a bit of personalization to your application, it may be opening up your application to XSS risk. 

While page items in APEX are generally safe to use with **&ITEM.** syntax, this is not the case with the **Link Icon**.  Any reference to either page or application items presents an unsafe condition when referenced in the **Link Icon** and should be avoided ]')
|| TO_CLOB(q'[unless that item is secured by session state protection and guaranteed not to have malicious content.]'),'To examine the Interactive Report **Link Icon** attributes:

1.   Edit the corresponding page of your application that contains the report in question.
2.  Edit the **Report Attributes** by selecting the **Attributes** node.
3.  In the Link region, examine the **Link Icon** field for use of **&ITEM.** and make sure any item referenced is being properly escaped.
4.  Click **Save**.','qUSVDy-WwH_xvetyUxJYlDNLcLLwtAeZ-jkbyB1MHOfmMKrxX6bO8XQFik--E_n0AmGYACQ8rTnpLBYL46QI_w','SV_XSS_LINK_ICON',323062163011579819631061498418512401247);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (30,22,TO_CLOB(q'[Some items - specifically **Display Only**, **Checkboxes**, **Radiogroups** and **Textareas with Autocomplete** - can render HTML as part of their item.  In these cases, it is important to ensure that the HTML rendered is properly escaped, so that in the case the HTML contains malicious code, it is rendered harmless.

Each of these items contains a property called **Escape Special Characters**.  When set to **Yes**, any HTML rendered on the page will be properly escaped.  When set to **No**, a]')
|| TO_CLOB(q'[ny HTML will be rendered as-is, introducing the risk of malicious code getting executed.  Thus, it is recommended to set this **Enable Special Characters** to **Yes**.]'),'To change ensure that an item produces escaped HTML:

 1. Edit the corresponding item.  
 2. In the Security region, set the value of Escape HTML to **Yes**.  
 3. Click **Apply Changes**.','9518DsgDYBWfKt8Vm-q6caRdX0Seeu5rX7he81GHjIwmwchvs4Je0JDTwL3Qkx2KNzF_fMZcYDc8r-RKFlxxcw','SV_XSS_UNESCAPED_ITEMS',323062163011595535666716488597783581535);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (75,86,'Often times, developers will use **&ITEM.** syntax in a List Entry to dynamically change the value.  While this is a clever trick that adds a bit of personalization to your application, it may be opening up your application to XSS risk.','Ensure that any **&ITEM.** reference in a List Entry is properly escaped.  APEX page items are automatically escaped when rendered in HTML, but Application Items are not.  Thus, if you are using an Application Item, one technique to ensure that it is properly escaped is to use a page item in its place.  APEX will automatically escape any HTML, rendering any XSS attacks harmless in the process.','kqTbVfOdnNFTMfEjazSA9FWUtftlRF2RELI2SaAu6MqeqsphgZx5buz6rWStQKxlpgvjY2CcKz2ncsRiq4izSw','SV_XSS_LIST_ENTRIES',323062163011582237482700727676861813599);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (76,87,'Often times, developers will use **&ITEM.** syntax in a region title to dynamically change the title.  While this is a clever trick that adds a bit of personalization to your application, it may be opening up your application to XSS risk.','Ensure that any **&ITEM.** reference in a Region Title is properly escaped.  APEX page items are automatically escaped when rendered in HTML, but Application Items are not.  Thus, if you are using an Application Item, one technique to ensure that it is properly escaped is to use a page item in its place.  APEX will automatically escape any HTML, rendering any XSS attacks harmless in the process.','31M3emTsa0kY9j7kECR1lpw55_3w-9xRn9qiPy2M-JebbPmHlGSLmpuhoA12DzmY5-yBMGbU-iyZx_p72IYFow','SV_XSS_REGION_TITLES',323062163011589491037618415451910050655);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (91,82,TO_CLOB(q'[Despite its name, a **Hidden Item** will still have its definition and value rendered in the underlying HTML of a page.  This allows for a malicious user to both view and edit the value and submit it back to APEX for processing, allowing for the update of unintended records.

Fortunately, **Hidden Items** in APEX contain an attribute called **Value Protected**.  When enabled, if the value of a Hidden Item has been manipulated at all, APEX will reject the page submission and generate an error.
]')
|| TO_CLOB(q'[

The **Value Protected** attribute is set to **Yes** by default, and should be left that way.  The only exception to this is when the value of Hidden Item needs to be altered by either JavaScript or a Dynamic Action.  If that is the case, and **Value Protected** is set to No, then additional validations should be made to ensure that the value set was a valid one, not a malicious one.]'),'To ensure that a **Hidden Item** is protected:

1.  Edit a Hidden page item.
2.  In the Settings region, set the value of Value Protected to **Yes**.
3.  Click **Apply Changes**.','w31-Q7zLDrpYZcelB4vY1kDy8SXLKIGSNtKHtHZy6hPY0KnJdGxCU0XTwRkNaTKaDfUNAUZbnANAjySMsWLPSw','SV_XSS_HIDDEN_ITEMS',323062163011574983927783039901813576543);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (123,113,TO_CLOB(q'[When users fill out a form in APEX, the data that is sent back to the server is stored unencrypted in the APEX session table - WWV\_FLOW\_DATA.  While there are adequate precautions taken to ensure that other users can not see this data, there is nothing to stop an APEX workspace administrator or DBA from seeing it.

Thus, you should consider applying Item Level Encryption to any item that could contain sensitive data.  With this feature enabled, the values of items in APEX session state are e]')
|| TO_CLOB(q'[ncrypted before they are stored, preventing APEX workspace administrator and even DBAs from snooping.  

Enabling this feature requires no additional changes to your APEX applications.  You can still refer to encrypted items the same way you would refer to unencrypted ones.  APEX will automatically encrypt and decrypt them for you.

Note: Application Items do not currently support this feature.  Thus, if you need to store data in an encrypted fashion, you should use Page 0 items instead.]'),'To enable **item-level encryption**:

 1. Edit a page item in your application that you wish to enable item-level encryption.  
 2. In the Security region, set the value of Store value encrypted in session state to **Yes**.  
 3. Click **Apply Changes**.','GYp8k7uFvvyjLEcNJ6wNnq4QXtEo1bHR_fh4jLqrCESj4HabWJSzvpJFFISmw6hDPWhppJsDulF39XYtXNP-QQ','SV_URL_ITEM_ENCRYPT',323062163011567730372865352126765339487);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (126,116,TO_CLOB(q'[**Application Items at Risk** are Application Items that have their Session State Protection attribute set to **Unrestricted**.  These application items can be altered by a malicious user via the URL of a page that does not have session state protection enabled, thus potentially changing application functionality.

Since APEX does not escape HTML passed to Application Items, unrestricted application items also susceptible to cross-site scripting attacks, as any malicious Javascript passed to a]')
|| TO_CLOB(q'[n unrestricted application item will not be escaped and could potentially be executed.

There are five different settings:

 **- Unrestricted**  
   Item can be set via the URL or within APEX  
 **- Checksum Required - Application Level**  
   Item can only be set via the URL if the corresponding checksum is also passed via the URL at the application level.  
 **- Checksum Required - User Level**  
   Item can only be set via the URL if the corresponding checksum is also passed via the ]')
|| TO_CLOB(q'[URL at the user level.  
 **- Checksum Required - Session Level**  
   Item can only be set via the URL if the corresponding checksum is also passed via the URL at the session level.  
 **- Restricted - May not be set from browser**  
   Item can not be set via the URL under any circumstances - even if Session State Protection is disabled at the application level.]'),'To change the **Session State Protection** attribute for an **Application Item**:

1.  Edit your application''s **Shared Components**.
2.  In the Application Logic region, click **Application Items**.
3.  Click the application item you wish to modify.
4.  In the Security region, set the Session State Protection attribute to any value other than **Unrestricted**.
5.  Click **Apply Changes**.','JWEY4vWLNkX-j6dbtkVvIY8pIV7v9zYS8zmQieI0JXPVG4UAosm-CWz8OHS9q7LgyV51K5R1SPfgKKqX_YZgaA','SV_XSS_APP_ITEMS',323062163011571357150324196014289458015);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (127,117,'This attribute identifies any **HTML Regions** that contain &ITEM\_NAME. syntax from items that are not properly secured.  While a failure here does not necessarily mean that there is a true risk, it is worth inspecting each item references in a static HTML region to ensure that if a malicious user does end up manipulating it via the URL, the impact would be mitigated.','There are a couple ways to resolve this issue:

 - Ensure that the corresponding item is properly secured so that its value can not be manipulated via the URL.  
 - Change the type of the region from **HTML Text** to **HTML Text (escape special characters)**.

Either of these resolutions will ensure that your HTML regions are safe from Cross Site Scripting attacks.','YUwGtyP1FuQ7s11cVblW_Q8XvDscCD0lK7MJdFCsDpePeurqaKKCu-easVMTpAlrUfwNN-W9VcC0Lc0j-RAuVw','SV_XSS_STATIC_REGION',323062163011594326740896873968608875359);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (134,143,TO_CLOB(q'[While the ability to allow users to download data directly from an APEX report may, in some limited cases, be desirable, on the whole it should be discouraged as it provides end users the ability to take data from an otherwise secure system and move it to insecure areas such as shared drives, USB drives, emails, etc.

Both Interactive and Classic reports provide the ability to allow users to download the report data in various formats.

**Classic Reports**  
\- CSV Format

**Interactive R]')
|| TO_CLOB(q'[eports**  
\- CSV Format  
\- HTML Format  
\- HTML via E-Mail  
\- PDF  
\- XLS  
\- RTF

If it is deemed necessary to allow users to export report data, the developer should examine the individual columns of the report to exclude those columns from the export that may hold sensitive data.]'),TO_CLOB(q'[To **disable** the ability to export data from reports:  
  
**Classic Reports:**  
1) Select the **Attributes** node of the corresponding Classic Report.  
2) In the Download region, set **CSV Export Enabled** to **No**.  
3) Click **Save**.  
  
**Interactive Reports:**  
1) Select the **Attributes** node of the corresponding Interactive Report.  
2) In the Actions Menu region, set the value of **Download** to **No**.  
3) Click **Save**.  
  
To exclude **individual columns** from]')
|| TO_CLOB(q'[ export:

**Classic Reports:**

1.  Expand the **Columns** folder for the corresponding Classic Report.
2.  Select the column or columns that you wish to exclude.
3.  In the Export/Printing region, set Include In Export/Print to **No**.
4.  Click **Save**.

**Interactive Reports:**  
There is no declarative way to limit a column in an Interactive Report from being included within a data export. However, you can set a condition on the column that will prevent it from being exported.

]')
|| TO_CLOB(q'[Set the Condition Type to **Request is Not Contained in Value** and the Value to **CSV:HTMLD:XML:PDF:RTF:XLS** for each column that you want to prevent from being downloaded.]'),'uvOj9uGpxYkR19RysQ-3MMJeuAW32KHmUiRVOymzNG4q5gfDETv8_sfLtggItYi5eXhKD-ejq-fcD6kDjngT5A','SV_PS_RPT_EXP_DATA',323062163011565312521226122868415927135);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (135,144,TO_CLOB(q'[The **Maximum Row Count** of a report dictates the maximum number of rows that will be retrieved from the database. A high **Maximum Row Count** could allow a user to access and export large amounts of data and walk away with it.

During normal system use, most users will be working with the first few hundred rows of data in a report and will never navigate past the first few pages. Therefore it is advantages, not only for security but also for performance reasons to keep the **Maximum Row Cou]')
|| TO_CLOB(q'[nt** as low as possible.]'),'To set the **Maximum Row Count**:  
  
**Classic Reports:**

1.  Select the **Attributes** node of the corresponding Classic Report.
2.  In the Advanced region, set **Maximum Row Count** to the desired value.
3.  Click **Save**.

  
**Interactive Reports:**

1.  Select the **Attributes** node of the corresponding Interactive Report.
2.  In the Advanced region, set the value of **Maximum Row Count** to the desired value.
3.  Click **Save**.','tPP-yEOoClBNVqDeS-WnykHXShhVr1DAwItubOhNdHQ4ZTGdtNYUXjAC_plrB20R_ddSVSZedjHWqre1VFXMVA','SV_PS_RPT_MAX_ROWS',323062163011566521447045737497590633311);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (152,148,TO_CLOB(q'[**Browser Cache** dictates how the user's browser will store a rendered APEX Page in the browser's cache. Normally, browsers save the contents of an application's pages, however if the cache is disabled, the browser will not save the information and will be forced to reload the information from the server.

From a security standpoint, **Browser Cache** should be _**disabled**_ so that no sensitive information will not be kept at the browser level. Setting this to "Disabled" will also help prev]')
|| TO_CLOB(q'[ent subtle back button issues.

**NOTE**: When **Browser Cache** is set to "Disabled", APEX will include the HTTP Header directive _**cache-control: no-store**_ indicating the browser should not store page content in either memory or disk. This feature will only work with browsers which support the _**cache-control**_ directive.]'),TO_CLOB(q'[To alter the value of **Browser Cache** for a specific page:

1.  Edit the page attributes for the page in question by clicking on it's name in the Page Rendering tree.
2.  In the Security region, alter the value for the **Browser Cache** select list.
3.  Click **Save**.

Browser Cache has three possible settings:

**\- Application Default** - This will take its value from the current application's Browser Cache attribute.  
**\- Enabled** - Allows the browser to cache information from ]')
|| TO_CLOB(q'[the page  
**\- Disabled** - Prohibits the browser from caching information for the specific page.

The page level **Browser Cache** setting, other than Application Default,  will override what is defined at the Application level.

**NOTE**: When **Browser Cache** is set to "Disabled", APEX will include the HTTP Header directive _**cache-control: no-store**_ indicating the browser should not store page content in either memory or disk. This feature will only work with browsers which support]')
|| TO_CLOB(q'[ the _**cache-control**_ directive.]'),'QYXTWfC0hZJOblvClV8ImJuBRpMbUMg72SsM79IVSaQzpRTNPrXpPygnjbE_rXQxhxi5V7v09d099NaRrax2ow','SV_PS_BROWSER_CACHE',323062163011561685743767278980891808607);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (156,152,'Often times, developers will use **&ITEM.** syntax in a Tab to dynamically change the value.  While this is a clever trick that adds a bit of personalization to your application, it may be opening up your application to XSS risk.','Ensure that any **&ITEM.** reference in a Tab is properly escaped.  APEX page items are automatically escaped when rendered in HTML, but Application Items are not.  Thus, if you are using an Application Item, one technique to ensure that it is properly escaped is to use a page item in its place.  APEX will automatically escape any HTML, rendering any XSS attacks harmless in the process.','wks0eCFdDJ2eQ-936Sa2lgfmzpEXJfB2r4UoVzAWObb3bnQAxSIo0_IJa5MaBR7Ph0RWtG1gJKO7MnK_SRP68g','SV_XSS_STAB_LABELS',323062163011593117815077259339434169183);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (157,153,'Often times, developers will use **&ITEM.** syntax in a Tab to dynamically change the value.  While this is a clever trick that adds a bit of personalization to your application, it may be opening up your application to XSS risk.','Ensure that any **&ITEM.** reference in a Tab is properly escaped.  APEX page items are automatically escaped when rendered in HTML, but Application Items are not.  Thus, if you are using an Application Item, one technique to ensure that it is properly escaped is to use a page item in its place.  APEX will automatically escape any HTML, rendering any XSS attacks harmless in the process.','wks0eCFdDJ2eQ-936Sa2lgfmzpEXJfB2r4UoVzAWObb3bnQAxSIo0_IJa5MaBR7Ph0RWtG1gJKO7MnK_SRP68g','SV_XSS_PTAB_LABELS',323062163011588282111798800822735344479);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (147,155,TO_CLOB(q'[Each page in an APEX application has an attribute called **Page Access Protection**.  This attribute determines how a page can be accessed, and whether or not you can pass item values to the page.

There are four modes for **Page Access Protection**:

 **- Unrestricted**  
   This page can be accessed via the URL and all URL parameters (request, session state, item values) are allowed  
 **- Arguments Must Have Checksum**  
   URL parameters ( request, session state, item values) can only]')
|| TO_CLOB(q'[ be passed to this page if a corresponding checksum is also present in the URL.  Individual items must also be protected at either the session, user or application level.  
 **- No Arguments Supported**  
   URL parameters (request, session state, item values) for this page are prohibited, but the page can still be accessed via entering its corresponding URL.  
 **- No URL Access**  
   Not only are  URL parameters (request, session state, item values) prohibited, but the only way to access ]')
|| TO_CLOB(q'[this page is the result of an APEX branch.

By default, all APEX pages are created with this attribute set to **Unrestricted**.  That means that users can pass values to any of the URL parameters on any APEX page unless you take time to change this attribute.

If you elect to use **Arguments Must Have Checksum**, then enabling this attribute is only part one of a two step process.  You should take care to enable the corresponding attribute for each item that you wish to protect on this page.]'),TO_CLOB(q'[To change a page's **Page Access Protection** setting:

1.  Edit the page attributes for the page in question by clicking on it's name in the Page Rendering tree.
2.  In the Security region, set the value of **Page Access Protection** to anything except **Arguments Must Have Checksum**, **No Arguments Supported**, or **No URL Access**.
3.  Click **Save**. 

If you elect to use **Arguments Must Have Checksum**, then enabling this attribute is only part one of a two step process.  You should]')
|| TO_CLOB(q'[ take care to enable the corresponding attribute for each item that you wish to protect on this page.]'),'grT6AggJa46W59Jh7KJPxaCzloeINeVPmLyFwVSaZGvwvnES2jh3gZv2V0bt9My-esgve6xw9Du9vs-LNluBkw','SV_URL_PAGE_PROTECT',323062163011570148224504581385114751839);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (148,156,'Report columns with a Display Type of Standard Report Column are susceptible to XSS as the do not escape any of special characters. This means that any JavaScript that might be entered into a form, and which is later displayed using a Standard Report Column, will be executed potentially without the knowledge of the user or system owner.

You should only use Standard Report Columns when you can guarantee that the data being displayed within the report is not being entered by end user.',TO_CLOB(q'[To protect an **Interactive Report Column** from potential XSS attacks:

 1. Navigate to the page containing the **Interactive Report**.  
 2. Edit the Report attributes by right-clicking on the report name in the tree and selecting **Edit Report Attributes**.  
 3. In the Column Attributes region set the **Display Text As** select list to the appropriate display option that _**Escapes Special Characters**_.  
 4. Click **Apply Changes**.

You may also drill down to the column in question]')
|| TO_CLOB(q'[ and in the Column Definition region, set the **Display Type** as mentioned above.

One thing to note: if you have any HTML embedded in your SQL, you will need to move that to the **HTML Expression** attribute, which can be found in the Column Formatting region.  All HTML embedded in SQL will no longer render as HTML, but will rather be escaped.

This, a column that used to look like this:

 **Syracuse, NY**

Will look like this:

  \<b>Syracuse, NY\</b>

Once you change the Display ]')
|| TO_CLOB(q'[As attribute to Display as Text, you should remove all HTML from the SQL and move it to the **HTML Expression** attribute.  Continuing with our example, you would enter the following in the **HTML Expression**, where **#COLUMN\_NAME#** is the name of the corresponding column.

  \<b>#COLUMN\_NAME#\</b>]'),'ncm7sapmE_5xhGnIXCWD9s_vISj8eAqnQ0LLLg9geFvcB7c95QJTU5JEOMP60P-A-e7HR3RoDnX6W2Kyzg_wiw','SV_XSS_IR_RPT_COLS',323062163011577401779422269160162988895);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (149,157,'When a region makes use of the **SYS.HTP** package to emit data into an APEX page, it is possible that the data being emitted is not being properly secured and therefore may pose a XSS risk. 

APEX-SERT looks for and flags uses of the following:

 - HTP.P  
 - HTP.PRN  
 - HTP.PRINT  
 - HTP.PRINTS  
 - HTP.PS  
 - HTP.DIV  
 - HTP.BOLD  
 - HTP.ITALIC  
 - HTP.S  
 - HTP.STRIKE  
 - HTP.STRONG  
 - HTP.EM  
 - HTP.EMPHASIS  
 - HTP.CODE','To protect against possible XSS risks when using **SYS.HTP**, any and all output sent to the **SYS.HTP** package  that could potentially be either entered or manipulated by the user should first be escaped using the **SYS.HTF.ESCAPE\_SC** procedure.

This insures that any special characters are escaped and will not be interpreted by the web browser.','PYW5mxpcmPK3tQIf1b98YKny5k91y21dQjs6hcBMp2ivKA7EIW_LZ_0c-ageioTBQoEfTVwaDSH8TbgySpBVVA','SV_XSS_UNESCAPED_PROCESSES',323062163011596744592536103226958287711);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (171,167,TO_CLOB(q'[Some types of **Interactive Grid** columns allow developers to disable the **Escape Special Characters** attribute.  When this option is set to **No**, then the columns susceptible to XSS attacks. This means that any JavaScript that might be entered into a form, and which is later displayed using an Interactive Grid, will be executed potentially without the knowledge of the user or system owner.

You should only always escape all Interactive Grid columns.  Should you need to augment your resul]')
|| TO_CLOB(q'[ts with HTML, use the **HTML Expression** attribute.]'),TO_CLOB(q'[To protect an **Interactive Grid Columns** from potential XSS attacks:

 1. Navigate to the page containing the **Interactive Grid**.  
 2. Expand the **Columns** node of the report.  
 3. Select the column in question.  
 4. In the Security region set the **Escape Special Characters** item to **No**.  
 5. Click **Apply Changes**.

If the **Escape Special Characters** option is not available, then APEX will automatically always escape the output of this column type.

One thing to note]')
|| TO_CLOB(q'[: if you have any HTML embedded in your SQL, you will need to move that to the **HTML Expression** attribute, which can be found in the Column Formatting region.  All HTML embedded in SQL will no longer render as HTML, but will rather be escaped.

This, a column that used to look like this:

 **Syracuse, NY**

Will look like this:

  \<b>Syracuse, NY\</b>

Once you change the Display As attribute to Display as Text, you should remove all HTML from the SQL and move it to the **HTML Expr]')
|| TO_CLOB(q'[ession** attribute.  Continuing with our example, you would enter the following in the **HTML Expression**, where **#COLUMN\_NAME#** is the name of the corresponding column.

  \<b>#COLUMN\_NAME#\</b>]'),'KR0mNMMaTWXXHO_DN9oREbw3bMgM2RAL4RKVr474NYXQo07eUD6KXPfc11FCE4dj6UOmKzAh9TXMQA5k2-Fgxg','SV_XSS_IG_RPT_COLS',323062163011576192853602654530988282719);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (175,158,'When a region makes use of the **SYS.HTP** package to emit data into an APEX page, it is possible that the data being emitted is not being properly secured and therefore may pose a XSS risk. 

APEX-SERT looks for and flags uses of the following:

 - HTP.P  
 - HTP.PRN  
 - HTP.PRINT  
 - HTP.PRINTS  
 - HTP.PS  
 - HTP.DIV  
 - HTP.BOLD  
 - HTP.ITALIC  
 - HTP.S  
 - HTP.STRIKE  
 - HTP.STRONG  
 - HTP.EM  
 - HTP.EMPHASIS  
 - HTP.CODE','To protect against possible XSS risks when using **SYS.HTP**, any and all output sent to the **SYS.HTP** package  that could potentially be either entered or manipulated by the user should first be escaped using the **SYS.HTF.ESCAPE\_SC** procedure.

This insures that any special characters are escaped and will not be interpreted by the web browser.','JuMP7LNUjF1wlECKtloJXc95Nwr-n6nJfLd3Q5ycCsbcY8quS-AS018U1m5ZKQAk-u1F1JfmVukz6GDcL_5MoQ','SV_XSS_UNESCAPED_REGIONS',323062163011597953518355717856132993887);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (180,163,'The **Rejoin Sessions** attribute will allow users to rejoin a previously established session without providing a Session ID.  APEX will only use the existing cookie to determine whether or not to consider the current session as valid.

Enabling this option does present a security risk, as it would be easier for a hacker to take over an existing APEX session.  Thus, this option should be set to **Disabled**.',TO_CLOB(q'[To alter the value of **Rejoin Sessions** for a specific page:

1.  Edit the page attributes for the page in question by clicking on it's name in the Page Rendering tree.
2.  In the Security region, set the value for Rejoin Sessions to **Disabled**.  Alternatively, if the Application Level setting is set to **Disabled**, then set it to **Application Default**.
3.  Click **Save**.

Rejoin Sessions has four possible settings at the page level:

**\- Application Default** - This will take i]')
|| TO_CLOB(q'[ts value from the current application's Rejoin Sessions attribute.  
**\- Disabled** - Sessions cannot be rejoined at all  
**\- Enabled for Public Sessions** - APEX will attempt to rejoin an existing session only when navigating to a page that is publicly accessible.  
**\- Enabled for All Sessions** - APEX will attempt to rejoin an existing session - so as long as the URL in question does not contain any parameters aside from Application ID and Page ID.]'),'gbTxyls3pZdQXNj8H6IGupypV_RLbcaC1j82ck1DyBCmhHkBebsq3zLuuscN5bIlRp6bEl5a0L_g-xNE7o1zLg','SV_PS_REJOIN_SESSION',323062163011564103595406508239241220959);
Insert into AST_SERT_HOW_TO_FIX (ID,ATTRIBUTE_ID,INFO,FIX,SOURCE_INFO_FIX_MD5,COLLECTION_NAME,TEST_ID) values (102,103,TO_CLOB(q'[This attribute identifies the total number of Items that have their **Session State Protection** attribute set to **Unrestricted** for an application.  These unrestricted items can be manipulated via the URL by a malicious user, causing potentially disastrous results.

There are four possible values for **Session State Protection** at the item level:

 **- Unrestricted**   
   The item may be set via the URL with no restrictions.  
 **- Restricted - may not be set from browser**  
   The ]')
|| TO_CLOB(q'[item can not be set via the URL.  This value only applies to the following item types:  
    - Display as Text (escape special characters, does not save state)  
    - Display as Text (does not save state)  
    - Display as Text (based on LOV, does not save state)  
    - Display as Text (based on PLSQL, does not save state)  
    - Text Field (Disabled, does not save state)  
    - Stop and Start HTML Table (Displays label only)  
 **- Checksum Required - Application Level**  
   The i]')
|| TO_CLOB(q'[tem can be set via the URL provided an application-level checksum is present in the URL.  
 **- Checksum Required - User Level**  
   The item can be set via the URL provided a user-level checksum is present in the URL.  
 **- Checksum Required - Session Level**  
   The item can be set via the URL provided a session-level checksum is present in the URL.

It is broken down by page in the summary report.  To see which items **Session State Protection** is set to **Unrestricted**, click on t]')
|| TO_CLOB(q'[he View link for the corresponding page.

Keep in mind that **Session State Protection** must be enabled at the application level for this attribute to work properly.]'),'To change an item''s **Session State Protection** attribute:

 1. Edit the corresponding page in your application.  
 2. Edit the item you wish to fix.  
 3. In the Security region, set the value of Session State Protection to anything other than **Unrestricted**.  
 4. Click **Apply Changes**.

Note: Setting **Session State Protection** to any of the three Checksum Required values will allow values to be passed to that item, but only if the proper checksum is included in the URL.','N8rIn5s6FF7A-v1JBy094MMlQ0xcs0SoUdcGUWeOCONPWt86K5NDhYU83qN3PF_t98Bv0LBRmENkSJMkfKckRA','SV_URL_ITEM_PROTECT',323062163011568939298684966755940045663);
