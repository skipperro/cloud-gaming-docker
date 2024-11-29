#!/bin/sh

docker run -d --rm \
  --name cloud-gaming \
  --network host \
  --env WM_ONLY="false" \
  --env SELKIES_START_AFTER_CONNECT="/apps/garage/Garage42.x86_64" \
  --env SELKIES_START_AFTER_DISCONNECT="killall Garage42.x86_64" \
  --env SELKIES_VIDEO_PACKETLOSS_PERCENT=20 \
  --env SELKIES_AUDIO_PACKETLOSS_PERCENT=20 \
  --env DISPLAY=":20" \
  --env TZ="Europe/Berlin" \
  --env DISPLAY_SIZEW=1920 \
  --env DISPLAY_SIZEH=1080 \
  --env DISPLAY_REFRESH=60 \
  --env DISPLAY_DPI=96 \
  --env DISPLAY_CDEPTH=24 \
  --env SELKIES_ENABLE_BASIC_AUTH=false \
  --env SELKIES_ENCODER=nvh264enc \
  --env SELKIES_VIDEO_BITRATE=8000 \
  --env SELKIES_FRAMERATE=60 \
  --env SELKIES_AUDIO_BITRATE=192000 \
  --env SELKIES_ENABLE_RESIZE=true \
  --env SELKIES_TURN_HOST="relay1.expressturn.com" \
  --env SELKIES_TURN_PORT=3478 \
  --env SELKIES_TURN_USERNAME="efJ7OB93Q8CW0ISQC7" \
  --env SELKIES_TURN_PASSWORD="LXw0ELCJRQekDAU9" \
  --env WINEPREFIX="/wineprefix" \
  --env MANGOHUD=1 \
  --env LANG="de_DE.UTF-8" \
  --env LANGUAGE="de_DE:de" \
  --env LC_ALL="de_DE.UTF-8" \
  --device /dev/dri:/dev/dri \
  --device /dev/snd:/dev/snd \
  --volume /etc/vulkan/icd.d/nvidia_icd.json:/etc/vulkan/icd.d/nvidia_icd.json \
  --volume /etc/vulkan/implicit_layer.d/nvidia_layers.json:/etc/vulkan/implicit_layer.d/nvidia_layers.json \
  --volume /usr/share/glvnd/egl_vendor.d/10_nvidia.json:/usr/share/glvnd/egl_vendor.d/10_nvidia.json \
  --volume ./godot-cache:/home/ubuntu/.local/share/godot \
  --volume ./apps:/apps:ro \
  --volume ./wineprefix:/wineprefix/ \
  --gpus all \
  --security-opt seccomp=unconfined \
  --log-driver=json-file \
  --log-opt max-size=50m \
  cloud-gaming

