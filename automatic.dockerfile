FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl git wget \
    python3-pip \
    python3-venv \
    gpg \
    zip \
    && mkdir --parents --mode=0755 /etc/apt/keyrings \
    && wget https://repo.radeon.com/rocm/rocm.gpg.key -O - | \
    gpg --dearmor | tee /etc/apt/keyrings/rocm.gpg > /dev/null \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/6.1.2 jammy main" \
    | tee --append /etc/apt/sources.list.d/rocm.list \
    &&echo 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' \
    | tee /etc/apt/preferences.d/rocm-pin-600 \
    && apt-get update && apt install rocm -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && apt-get clean \
    && mkdir --parents --mode=0755 /app/venv \
    && python3 -m venv /app/venv \
    && chown --recursive 1000:1000 /app \
    && chown --recursive 1000:1000 /app/venv

RUN mkdir /.cache && chmod 777 /.cache && mkdir -p /python && chmod 777 /python
# RUN mkdir -p /app/venv && cd /app/venv && python3 -m venv . && chmod 777 -R /app/venv

RUN groupadd -g 992 render

RUN useradd -m -s /bin/bash alvin
RUN echo "alvin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# RUN mkdir --parents --mode=0755 /etc/apt/keyrings 
# RUN wget https://repo.radeon.com/rocm/rocm.gpg.key -O - | \
#     gpg --dearmor | tee /etc/apt/keyrings/rocm.gpg > /dev/null 

# RUN echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/6.1.2 jammy main" \
#     | tee --append /etc/apt/sources.list.d/rocm.list 
# RUN echo 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' \
#     | tee /etc/apt/preferences.d/rocm-pin-600 
# RUN cat /etc/apt/preferences.d/rocm-pin-600
# RUN apt-get update --allow-insecure-repositories &&  apt install rocm -y \
#     && rm -rf /var/lib/apt/lists/* \
#     && rm -rf /tmp/* \
#     && apt-get clean




WORKDIR /app
