#!/usr/bin/env bash
# Checagem do repositorio da equipe, antes de pedir revisao ou submeter.
#
# POR QUE EXISTE: tres exigencias do Edital nao dependem de talento, dependem de
# alguem conferir. Habito nao confere. Este script confere.
#
# TRES ESTADOS: ok, FALHA e NAO MEDIDO. "Nao medido" nunca e impresso como verde.
set -uo pipefail
cd "$(dirname "$0")/.."
falhas=0

# ⚠️ CONTROLE NEGATIVO. Roda com --auto-teste. Existe porque a primeira versao
# desta varredura passou verde num arquivo com chave de verdade: sem -i, API_KEY
# em caixa alta escapava. Sonda que nao sabe reprovar certifica.
if [ "${1:-}" = "--auto-teste" ]; then
  echo "== auto-teste: a varredura sabe reprovar? =="
  t=$(mktemp); ok=0
  ruins='API_KEY="sk-live-abc123realsecret"
senha: minhaSenhaSuperSecreta123
DATABASE_URL=postgres://user:senha123@host:5432/db
-----BEGIN RSA PRIVATE KEY-----'
  printf '%s\n' "$ruins" > "$t"
  n=$(grep -cEiI -e '(api[_-]?key|secret|passwo?rd|senha|token|bearer)[[:space:]]*[:=][[:space:]]*["'"'"']?[A-Za-z0-9_./+-]{8,}' -e '(postgres|postgresql|mysql|mongodb\+srv|redis)://[^[:space:]"'"'"']+:[^[:space:]"'"'"']+@' -e 'BEGIN [A-Z ]*PRIVATE KEY' "$t" || true)
  [ "$n" -ge 4 ] && echo "  [ok] acusou $n de 4 linhas sabidamente ruins" || { echo "  [CEGA] acusou so $n de 4"; ok=1; }
  bons='chave = os.environ["API_KEY"]
API_KEY=your-key-here
token: <SEU_TOKEN>'
  printf '%s\n' "$bons" > "$t"
  m=$(grep -EiI -e '(api[_-]?key|secret|passwo?rd|senha|token|bearer)[[:space:]]*[:=][[:space:]]*["'"'"']?[A-Za-z0-9_./+-]{8,}' -e '(postgres|postgresql|mysql|mongodb\+srv|redis)://[^[:space:]"'"'"']+:[^[:space:]"'"'"']+@' "$t" 2>/dev/null | grep -vcE '(placeholder|your[_-]|<[^>]*>|os\.environ|process\.env|getenv)' || true)
  [ "$m" -eq 0 ] && echo "  [ok] nao acusou nenhuma das 3 linhas sabidamente boas" || { echo "  [RUIDOSA] acusou $m linha(s) boa(s)"; ok=1; }
  rm -f "$t"; exit "$ok"
fi

echo "== checagem do repositorio =="

# 1. licenca Apache-2.0, exigida desde o primeiro commit
if [ -f LICENSE ] && grep -q "Apache License" LICENSE; then
  echo "[ok]    licenca Apache-2.0 presente"
else
  echo "[FALHA] falta o arquivo LICENSE com a Apache-2.0"; falhas=$((falhas+1))
fi

# 2. segredo versionado. O padrao e amplo de proposito: falso positivo custa 10
#    segundos, falso negativo e irreversivel num repositorio publico.
alvo=$(git ls-files 2>/dev/null | grep -vE '^(LICENSE|\.env\.example|scripts/checar-repo\.sh|AGENTS\.md)$' || true)
if [ -z "$alvo" ]; then
  echo "[NAO MEDIDO] nenhum arquivo versionado ainda"
else
  # ⚠️ DOIS padroes, e nao um. A primeira versao juntava os dois e ficou CEGA:
  #   (a) nome-de-chave SEGUIDO de atribuicao. Precisa de -i, senao API_KEY em
  #       caixa alta escapa, que foi o furo pego pelo controle negativo;
  #   (b) string de conexao, que NAO e seguida de "=" e por isso nao cabe em (a).
  # Provado por controle negativo em --auto-teste: sem os dois, nao acusa.
  sus=$(printf '%s\n' "$alvo" | xargs -r grep -nEiI \
    -e '(api[_-]?key|secret|passwo?rd|senha|token|bearer)[[:space:]]*[:=][[:space:]]*["'"'"']?[A-Za-z0-9_./+-]{8,}' \
    -e '(postgres|postgresql|mysql|mongodb\+srv|redis)://[^[:space:]"'"'"']+:[^[:space:]"'"'"']+@' \
    -e 'BEGIN [A-Z ]*PRIVATE KEY' \
    2>/dev/null | grep -vE '(\.env\.example|EXEMPLO|exemplo|placeholder|your[_-]|xxx+|<[^>]*>|os\.environ|process\.env|getenv)' || true)
  n=$(printf '%s' "$sus" | grep -c . || true)
  if [ "$n" -gt 0 ]; then
    echo "[FALHA] $n linha(s) parecem carregar segredo:"
    printf '%s\n' "$sus" | head -5 | sed 's/^/    /'
    echo "    ⚠️ o repositorio e PUBLICO. Apagar o arquivo NAO apaga o historico."
    falhas=$((falhas+1))
  else
    echo "[ok]    nenhum segredo aparente em $(printf '%s\n' "$alvo" | grep -c .) arquivo(s)"
  fi
fi

# 3-A. ⚠️ O .env.example e EXCLUIDO da varredura acima, de proposito, porque o
#      esperado la e nome de variavel sem valor. Mas isso o torna um ponto cego:
#      segredo colado nele passa invisivel. Entao ele tem checagem PROPRIA, e a
#      regra e inversa: ali NAO pode haver valor nenhum.
#      Achado trazido pela lane laptop-ops em 2026-09-21, ao auditar uma
#      ferramenta de terceiro: a exposicao estava declarada no .env.example, que
#      quase ninguem audita porque "e so exemplo". A pergunta certa nao e "o
#      codigo faz rede?", e "o que ele pede que eu configure?".
if [ -f .env.example ]; then
  val=$(grep -nE '^[A-Za-z_][A-Za-z0-9_]*=[[:space:]]*[^[:space:]#]' .env.example \
        | grep -vE '=[[:space:]]*(your|seu|<|xxx|troque|change)' || true)
  nv=$(printf '%s' "$val" | grep -c . || true)
  if [ "$nv" -gt 0 ]; then
    echo "[FALHA] .env.example tem VALOR preenchido em $nv linha(s). Ali so vao NOMES:"
    printf '%s\n' "$val" | head -3 | sed 's/^/    /'
    falhas=$((falhas+1))
  else
    echo "[ok]    .env.example so tem nomes, sem valor"
  fi
fi

# 4. .env nao pode estar versionado
if git ls-files --error-unmatch .env >/dev/null 2>&1; then
  echo "[FALHA] .env esta versionado. Tire do indice e ponha no .gitignore"; falhas=$((falhas+1))
else
  echo "[ok]    .env nao esta versionado"
fi

# 5. a tabela do charter foi preenchida
if [ ! -f CHARTER.md ]; then
  echo "[FALHA] falta o CHARTER.md"; falhas=$((falhas+1))
elif grep -q '_(ex: formulário de entrada)_' CHARTER.md; then
  echo "[FALHA] a tabela 'Esta funcionando x Ainda nao' ainda esta com o exemplo"; falhas=$((falhas+1))
else
  echo "[ok]    tabela do charter preenchida"
fi

# 6. ferramentas declaradas, exigencia com pena de desclassificacao
if [ -f FERRAMENTAS.md ] && ! grep -q '_(ex: Claude Code)_' FERRAMENTAS.md; then
  echo "[ok]    ferramentas declaradas"
else
  echo "[FALHA] FERRAMENTAS.md nao foi preenchido"; falhas=$((falhas+1))
fi

# 7. link publico do prototipo
if [ -f FERRAMENTAS.md ] && grep -qE 'https?://' FERRAMENTAS.md; then
  echo "[ok]    ha um link publicado declarado"
else
  echo "[NAO MEDIDO] nenhum link publicado ainda. ⚠️ a banca precisa abrir sem instalar"
fi

echo
if [ "$falhas" -eq 0 ]; then
  echo "tudo certo. ⚠️ isto confere FORMA, nao merito: nada aqui avalia o que voce construiu."
else
  echo "$falhas item(ns) a resolver."
fi
exit "$falhas"
