FROM amazoncorretto:17

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV UNZIP_VERSION="6.0"
ENV JQ_VERSION="1.5"

ENV PMD_URL="https://api.github.com/repos/pmd/pmd/releases/latest"
ENV CHECKSTYLE_URL="https://api.github.com/repos/checkstyle/checkstyle/releases/latest"

RUN yum install -y unzip-${UNZIP_VERSION} jq-${JQ_VERSION} \
  && yum clean all \
  && rm -rf /var/cache/yum
RUN mkdir -p /opt

WORKDIR /opt

RUN curl -L "$(curl --silent "${PMD_URL}" | jq -r '.assets[] | select(.name | contains("pmd-") and contains("-bin.zip")) | .browser_download_url')" > pmd.zip \
  && unzip pmd.zip \
  && rm pmd.zip \
  && mv pmd-bin* pmd

RUN curl -L "$(curl --silent "${CHECKSTYLE_URL}" | jq -r '.assets[] | select(.name | contains("checkstyle-") and contains(".jar")) | .browser_download_url')" > checkstyle.jar

COPY run_pmd.sh /opt
COPY run_cpd.sh /opt
COPY ruleset.xml /opt
COPY run_checkstyle.sh /opt
