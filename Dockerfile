FROM amazoncorretto:17

COPY install.sh /opt
RUN bash /opt/install.sh && rm -rf /var/lib/apt/lists/* && rm /opt/install.sh

COPY run_pmd.sh /opt
COPY run_cpd.sh /opt
COPY ruleset.xml /opt
COPY run_checkstyle.sh /opt
