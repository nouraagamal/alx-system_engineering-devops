Postmortem: Outage in Apache Web Server Due to 500 Internal Server Error
Issue Summary:
On September 9, 2024, an outage occurred that lasted for an hour, from 8:00 AM to 9:00 AM GMT. The Apache web server was returning a "500 Internal Server Error" for all incoming requests. As a result, the web application hosted on the server was completely inaccessible, leading to 100% of users being unable to reach the site during the outage. This affected both web traffic and APIs served by the application. After further research we realised that a misconfigured PHP file within the WordPress installation triggered the Apache server to return 500 errors. The issue was traced to a missing configuration file that led to PHP execution failures.

Timeline:
8:00 AM: The monitoring system sent alerts indicating that the Apache web server was responding with 500 Internal Server Errors for all requests.
8:05 AM: The on-call engineer verified the issue using curl to replicate the error and confirmed that the Apache server was returning HTTP 500 errors across all pages.
8:10 AM: Initial investigation started with Apache logs (/var/log/apache2/error.log) showing generic errors related to PHP execution, but without clear details on the root cause.
8:15 AM: The engineer decided to use strace to trace the system calls of the Apache process to find more detailed information about the cause of the error.
8:25 AM: strace output revealed that the server was failing when trying to read a required configuration file (wp-config.php) for WordPress, which had incorrect file permissions.
8:30 AM: The issue was escalated to the DevOps team to investigate the configuration file issue and suggest a fix.
8:40 AM: The DevOps engineer confirmed the problem: improper file permissions were preventing the Apache user from reading the wp-config.php file. The engineer manually updated the permissions as a temporary fix.
8:50 AM: Apache was restarted, and the 500 errors ceased. The site began responding with HTTP 200 codes again.
9:00 AM: The team created an automation script using Puppet to ensure that this issue would not occur again.

Root Cause and Resolution:
The root cause of the outage was incorrect file permissions on the wp-config.php file used by the WordPress installation. The file had restricted permissions that prevented Apache’s user (www-data) from reading it, leading to the 500 Internal Server Error.
To resolve the issue, the engineer updated the permissions of the file using the chmod command to ensure it was readable by the Apache user. Once the permissions were corrected and Apache was restarted, the service resumed normal operations.
A Puppet script was created to automate this fix and prevent future occurrences of similar issues. The script checks the permissions of wp-config.php during every deployment or system update and adjusts them as necessary.



Corrective and preventative measures:

Corrective Measures:
What Needs Improvement or Fixing?
Plugin Compatibility Testing: Enhance the process to avoid deploying conflicting plugins.
Resource Scaling: Improve infrastructure scalability.
Error Handling and Monitoring: Enhance error handling and monitoring procedures.

Tasks to Address the Issue:
Establish a staging environment for testing all updates.
Create a comprehensive checklist for compatibility testing.
Implement automated testing tools.
Regularly review server resources and scalability.
Implement automatic scaling.
Monitor resource utilisation and adjust resources.
Configure Apache for detailed error logging.
Implement robust monitoring tools and alerts.
Preventative Measures:

What Needs Improvement or Fixing?
Resource Management: Ongoing monitoring and optimization.
Incident Response Planning: Develop and document a comprehensive plan.

Tasks to Address the Issue:
Conduct monthly audits of plugins and themes.
Implement a regular performance review process.
Develop and document an incident response plan.
Organise training sessions for the technical team.

