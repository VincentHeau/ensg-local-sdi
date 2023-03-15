FROM kartoza/geoserver:2.19.2

#
# Build (1/ ) Enable CORS
RUN sed -i '\:</web-app>:i\
<filter>\n\
    <filter-name>CorsFilter</filter-name>\n\
    <filter-class>org.apache.catalina.filters.CorsFilter</filter-class>\n\
    <init-param>\n\
        <param-name>cors.allowed.origins</param-name>\n\
        <param-value>*</param-value>\n\
    </init-param>\n\
    <init-param>\n\
        <param-name>cors.allowed.methods</param-name>\n\
        <param-value>GET,POST,HEAD,OPTIONS,PUT</param-value>\n\
    </init-param>\n\
</filter>\n\
<filter-mapping>\n\
    <filter-name>CorsFilter</filter-name>\n\
    <url-pattern>/*</url-pattern>\n\
</filter-mapping>' ${CATALINA_HOME}/webapps/geoserver/WEB-INF/web.xml

ENV \
    # CSRF disabled to enable proper AJAX work (https://docs.geoserver.org/stable/en/user/security/webadmin/csrf.html)
    GEOSERVER_CSRF_DISABLED=true    