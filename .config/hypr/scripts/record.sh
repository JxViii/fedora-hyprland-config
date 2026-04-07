#!/bin/bash
# ~/.config/hypr/scripts/record.sh

SAVE_DIR="$HOME/Videos/Recordings"
mkdir -p "$SAVE_DIR"

# Pedir nombre con wofi
FILENAME=$(echo "" | wofi --dmenu --prompt "Recording name:")

# Si cancela o deja vacío, salir
[[ -z "$FILENAME" ]] && exit 0

# Sanitizar el nombre (quitar caracteres raros)
FILENAME=$(echo "$FILENAME" | tr -dc 'a-zA-Z0-9_-')

# Añadir timestamp para evitar sobreescribir
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

wf-recorder -g "$(slurp)" --audio -f "$SAVE_DIR/${FILENAME}_${TIMESTAMP}.mp4"