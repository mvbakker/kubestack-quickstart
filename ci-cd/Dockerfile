#
#
# Image versions
ARG BASE_BUILDER=python:3.8
ARG BASE_IMAGE=python:3.8-slim


#
#
# Base builder
FROM ${BASE_BUILDER} AS builder

RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    unzip

RUN mkdir -p /opt/bin


#
#
# Common builder
FROM builder AS common

ARG KUBECTL_VERSION=v1.17.2
ARG KUSTOMIZE_VERSION=v3.5.4
ARG TERRAFORM_VERSION=0.12.20
ARG TERRAFORM_PROVIDER_KUSTOMIZE_VERSION=v0.1.0-beta.3

RUN echo "KUBECTL_VERSION: ${KUBECTL_VERSION}" \
    && curl -Lo /opt/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod +x /opt/bin/kubectl \
    && /opt/bin/kubectl version --client=true

RUN echo "KUSTOMIZE_VERSION: ${KUSTOMIZE_VERSION}" \
    && curl -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz \
    && tar -xf kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz \
    && mv kustomize /opt/bin/kustomize \
    && /opt/bin/kustomize version

RUN echo "TERRAFORM_VERSION: ${TERRAFORM_VERSION}" \
    && curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /opt/bin \
    && chmod +x /opt/bin/terraform \
    && /opt/bin/terraform version

RUN echo "TERRAFORM_PROVIDER_KUSTOMIZE_VERSION: ${TERRAFORM_PROVIDER_KUSTOMIZE_VERSION}" \
    && curl -LO https://github.com/kbst/terraform-provider-kustomize/releases/download/${TERRAFORM_PROVIDER_KUSTOMIZE_VERSION}/terraform-provider-kustomization-${TERRAFORM_PROVIDER_KUSTOMIZE_VERSION}-linux-amd64 \
    && mv terraform-provider-kustomization-${TERRAFORM_PROVIDER_KUSTOMIZE_VERSION}-linux-amd64 /opt/bin/terraform-provider-kustomization \
    && chmod +x /opt/bin/terraform-provider-kustomization

COPY nss-wrapper /opt/bin/nss-wrapper


#
#
# Google builder
FROM builder AS google

ARG GOOGLE_CLOUD_SDK_VERSION=279.0.0

RUN echo "GOOGLE_CLOUD_SDK_VERSION: ${GOOGLE_CLOUD_SDK_VERSION}" \
    && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    && tar zxvf google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz google-cloud-sdk \
    && mv google-cloud-sdk /opt/google \
    && /opt/google/bin/gcloud --version


#
#
# Final
FROM ${BASE_IMAGE} AS final

RUN apt-get update && apt-get install -y \
      ca-certificates \
      git \
      jq \
      wget \
      openssh-client \
      dnsutils \
      libnss-wrapper \
      unzip \
    && rm -rf /var/lib/apt/lists/*

ENV HOME=/infra/.user

# Common
COPY --from=common /opt/bin /opt/bin
ENV PATH=/opt/bin:$PATH

# Google
COPY --from=google /opt/google /opt/google
ENV PATH=$PATH:/opt/google/bin

WORKDIR /infra

ENTRYPOINT ["/opt/bin/nss-wrapper"]
CMD bash
