# Postmortem: Outage of Web Application Due to Database Connection Pool Exhaustion

## Issue Summary
* **Duration of Outage**: 2023-10-15 14:30 UTC to 2023-10-15 16:00 UTC (1.5 hours)
* **Impact**: The web application became unresponsive for 80% of users. Users experienced slow page loads, timeouts, and errors when trying to access the application. The API response time increased from an average of 200ms to over 10 seconds.
* **Root Cause**: The database connection pool was exhausted due to a sudden spike in traffic and a misconfigured connection pool limit.

## Timeline
* **14:30 UTC**: Issue detected when monitoring alerts flagged a spike in API response times and database connection errors.
* **14:35 UTC**: Engineers noticed the application was unable to establish new database connections.
* **14:40 UTC**: Investigation focused on the database server, assuming it was a performance bottleneck.
* **14:50 UTC**: Misleading path: Engineers checked for high CPU and memory usage on the database server, but both were within normal ranges.
* **15:00 UTC**: Incident escalated to the DevOps and Database teams.
* **15:30 UTC**: Root cause identified as an exhausted database connection pool.
* **15:45 UTC**: Connection pool limit increased, and traffic was temporarily throttled to stabilize the system.
* **16:00 UTC**: Full service restored.

## Root Cause and Resolution
* **Root Cause**: The database connection pool was configured with a maximum of 100 connections. A sudden traffic spike caused the pool to exhaust all available connections, leading to new requests being unable to access the database.
* **Resolution**: The connection pool limit was increased to 500, and a temporary traffic throttle was implemented to prevent further exhaustion. Additionally, connection pooling settings were optimized to release idle connections faster.

## Corrective and Preventative Measures
* **Improvements**:
   1. Review and optimize database connection pooling settings.
   2. Implement auto-scaling for the application to handle traffic spikes.
   3. Add better monitoring and alerting for database connection usage.
   4. Conduct load testing to identify system limits and bottlenecks.
* **TODO List**:
   * Patch the application server to increase the connection pool limit.
   * Add monitoring for database connection pool usage.
   * Implement auto-scaling for the application servers.
   * Conduct regular load testing to simulate traffic spikes.
   * Document the incident and share learnings with the engineering team.

## Attractive Elements
To make this postmortem more engaging, I've included a simple diagram to illustrate the database connection pool exhaustion issue:

```
[Users] --> [Application Server] --> [Database Connection Pool (100/100)] --> [Database]
```

When the connection pool is exhausted:

```
[Users] --> [Application Server] --> [Database Connection Pool (100/100)] --> [ERROR: No connections available]
```

This diagram helps visualize the bottleneck and makes the postmortem more accessible to non-technical stakeholders.
