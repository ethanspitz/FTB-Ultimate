FROM amazoncorretto:8

LABEL vendor="Ethan Spitz (https://github.com/EthanSpitz)"

WORKDIR /minecraft

# Create user and download files
RUN mkdir -p /minecraft/world && \
    curl -fL https://api.modpacks.ch/public/modpack/93/2114/server/linux -o serverinstall_93_2114 && \
    chmod u+x serverinstall_* && \
    ./serverinstall_* --auto && \
    rm serverinstall_* && \
    echo "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula)." > eula.txt && \
    echo "$(date)" >> eula.txt && \
    echo "eula=true" >> eula.txt && \
    curl -fL https://launcher.mojang.com/v1/objects/02937d122c86ce73319ef9975b58896fc1b491d1/log4j2_112-116.xml -o log4j2_112-116.xml && \
    sed -i 's/-jar/-Dlog4j.configurationFile=log4j2_112-116.xml -jar/g' start.sh && \
	chown -R 1000:1000 /minecraft

# Changing user to minecraft
USER 1000

# Expose port 25565
EXPOSE 25565

# Expose volume
VOLUME ["/minecraft/world"]

# Start server
CMD ["/bin/bash", "/minecraft/start.sh"]