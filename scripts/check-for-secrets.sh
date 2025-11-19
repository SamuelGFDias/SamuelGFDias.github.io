#!/bin/bash

# Script para verificar por informações sensíveis no repositório
# Uso: ./scripts/check-for-secrets.sh

set -e

echo "🔍 Verificando por informações sensíveis no repositório..."
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ISSUES_FOUND=0

# 1. Verificar por arquivos sensíveis que não deveriam estar commitados
echo "📁 Verificando arquivos sensíveis..."
SENSITIVE_FILES=(
    ".env"
    ".env.local"
    ".env.production"
    "serviceAccount.json"
    ".firebaserc"
)

for file in "${SENSITIVE_FILES[@]}"; do
    if git ls-files | grep -q "^${file}$" 2>/dev/null; then
        echo -e "${RED}❌ ENCONTRADO: ${file} está commitado!${NC}"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    else
        echo -e "${GREEN}✅ OK: ${file} não está commitado${NC}"
    fi
done

echo ""

# 2. Verificar por padrões de secrets no código
echo "🔑 Verificando por padrões de secrets..."

# Procurar por possíveis senhas (excluindo arquivos de tradução e labels)
if git grep -i "password.*=.*['\"][^'\"]\{8,\}" -- '*.dart' '*.js' '*.json' 2>/dev/null | grep -v "password.*=.*\[''\]" | grep -v "pt_br_firebase_ui_labels\|translation\|label" | grep -q .; then
    echo -e "${YELLOW}⚠️  AVISO: Possíveis senhas encontradas no código${NC}"
    git grep -i "password.*=.*['\"]" -- '*.dart' '*.js' '*.json' | grep -v "pt_br_firebase_ui_labels\|translation\|label" | head -5
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ OK: Nenhuma senha hardcoded encontrada${NC}"
fi

# Procurar por chaves privadas
if git grep -i "PRIVATE.*KEY\|-----BEGIN" 2>/dev/null | grep -q .; then
    echo -e "${RED}❌ ENCONTRADO: Possível chave privada no código!${NC}"
    git grep -i "PRIVATE.*KEY\|-----BEGIN" | head -5
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ OK: Nenhuma chave privada encontrada${NC}"
fi

# Procurar por tokens de acesso
if git grep -iE "access.*token.*=|bearer.*[a-zA-Z0-9]{20,}|token.*=.*['\"][a-zA-Z0-9]{20,}" -- '*.dart' '*.js' 2>/dev/null | grep -v "access.*token.*=" | grep -q .; then
    echo -e "${YELLOW}⚠️  AVISO: Possíveis tokens de acesso encontrados${NC}"
    git grep -iE "token.*=" -- '*.dart' '*.js' | head -5
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ OK: Nenhum token suspeito encontrado${NC}"
fi

echo ""

# 3. Verificar .gitignore
echo "📋 Verificando .gitignore..."

SHOULD_BE_IGNORED=(
    ".env"
    "scripts/serviceAccount.json"
    ".firebaserc"
)

for pattern in "${SHOULD_BE_IGNORED[@]}"; do
    if git check-ignore -q "$pattern" 2>/dev/null; then
        echo -e "${GREEN}✅ OK: ${pattern} está no .gitignore${NC}"
    else
        echo -e "${YELLOW}⚠️  AVISO: ${pattern} NÃO está explicitamente no .gitignore${NC}"
    fi
done

echo ""

# 4. Verificar histórico git por arquivos sensíveis
echo "🕐 Verificando histórico git..."

if git log --all --pretty=format: --name-only --diff-filter=A | sort -u | grep -qE "\.env$|serviceAccount\.json"; then
    echo -e "${YELLOW}⚠️  AVISO: Arquivos sensíveis encontrados no histórico${NC}"
    echo "Arquivos encontrados:"
    git log --all --pretty=format: --name-only --diff-filter=A | sort -u | grep -E "\.env$|serviceAccount\.json"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ OK: Nenhum arquivo sensível no histórico${NC}"
fi

echo ""

# 5. Informação sobre Firebase API Keys
echo "🔥 Sobre Firebase Web API Keys..."
if git grep -q "apiKey:.*AIza" lib/firebase_options.dart 2>/dev/null; then
    echo -e "${YELLOW}ℹ️  INFO: Firebase Web API Keys encontradas em firebase_options.dart${NC}"
    echo "   Estas chaves são PÚBLICAS por design do Firebase."
    echo "   Veja docs/SECURITY.md para mais informações."
    echo "   Se desejar rotacionar, veja docs/REMOVER_INFORMACOES_SENSIVEIS.md"
else
    echo -e "${GREEN}✅ Nenhuma chave Firebase encontrada${NC}"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Resumo final
if [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${GREEN}✅ SUCESSO: Nenhum problema crítico encontrado!${NC}"
    echo ""
    echo "Recomendações:"
    echo "  - Continue protegendo serviceAccount.json"
    echo "  - Nunca commite arquivos .env"
    echo "  - Revise PRs cuidadosamente"
    exit 0
else
    echo -e "${YELLOW}⚠️  ATENÇÃO: ${ISSUES_FOUND} problema(s) encontrado(s)${NC}"
    echo ""
    echo "Próximos passos:"
    echo "  1. Revise os avisos acima"
    echo "  2. Leia docs/REMOVER_INFORMACOES_SENSIVEIS.md"
    echo "  3. Leia docs/SECURITY.md"
    echo "  4. Tome ação apropriada"
    exit 1
fi
