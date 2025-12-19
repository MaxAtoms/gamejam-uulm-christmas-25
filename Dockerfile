FROM ubuntu:latest

RUN apt-get update && apt-get install -y wget zip unzip git tar

RUN wget "https://downloads.godotengine.org/?version=4.5.1&flavor=stable&slug=linux.x86_64.zip&platform=linux.64" -O godot.zip \
    && unzip godot.zip

RUN wget "https://downloads.godotengine.org/?version=4.5.1&flavor=stable&slug=export_templates.tpz&platform=templates" -O templates.tpz
RUN mkdir -p /root/.local/share/godot/export_templates/4.5.1.stable
RUN unzip -j templates.tpz -d /root/.local/share/godot/export_templates/4.5.1.stable

RUN mkdir mine-defense-release


# RUN ./Godot_v4.5.1-stable_linux.x86_64 --headless --export-release "CI-Web" ./mine-defense/project.godot

# RUN zip -r mine-defense-release.zip mine-defense-release

