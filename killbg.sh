su -c '
FOCUSED=$(dumpsys activity activities | grep -E "topResumedActivity|ResumedActivity" | grep -oE "[a-z][a-z0-9_]*\.[a-zA-Z0-9._]+" | head -1)

if [ -z "$FOCUSED" ]; then
  echo "Nao foi possivel detectar o app em foco. Abortando."
  exit 1
fi

if ! cmd package list packages -3 | grep -q "$FOCUSED"; then
  echo "App em foco parece ser sistema: $FOCUSED. Abortando."
  exit 1
fi

echo "App em foco (excluindo): $FOCUSED"

for a in $(cmd package list packages -3 | cut -f2 -d: | grep -v "$FOCUSED"); do
  echo "Parando: $a"
  am force-stop "$a"
done'
